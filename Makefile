# 定义编译器
CC = /Users/chenshipeng/Documents/project/llvm/llvm-src/build/Release/bin/clang
LD = /Users/chenshipeng/Documents/project/llvm/llvm-src/build/Release/bin/clang++

LLVM_CONFIG = /Users/chenshipeng/Documents/project/llvm/llvm-src/build/Release/bin/llvm-config

# 定义编译选项
CFLAGS=-g -Wall

CFLAGS += -I/Users/chenshipeng/Documents/project/llvm/llvm-src/build/Release/include
LDFLAGS = -L/Users/chenshipeng/Documents/project/llvm/llvm-src/build/Release/lib -Wl,-search_paths_first -Wl,-headerpad_max_install_names -lLLVMX86TargetMCA -lLLVMMCA -lLLVMX86Disassembler -lLLVMX86AsmParser -lLLVMX86CodeGen -lLLVMCFGuard -lLLVMGlobalISel -lLLVMX86Desc -lLLVMX86Info -lLLVMMCDisassembler -lLLVMSelectionDAG -lLLVMInstrumentation -lLLVMAsmPrinter -lLLVMInterpreter -lLLVMCodeGen -lLLVMScalarOpts -lLLVMInstCombine -lLLVMAggressiveInstCombine -lLLVMObjCARCOpts -lLLVMTransformUtils -lLLVMBitWriter -lLLVMExecutionEngine -lLLVMTarget -lLLVMRuntimeDyld -lLLVMOrcTargetProcess -lLLVMOrcShared -lLLVMAnalysis -lLLVMProfileData -lLLVMSymbolize -lLLVMDebugInfoPDB -lLLVMDebugInfoMSF -lLLVMDebugInfoDWARF -lLLVMObject -lLLVMTextAPI -lLLVMMCParser -lLLVMIRReader -lLLVMAsmParser -lLLVMMC -lLLVMDebugInfoCodeView -lLLVMBitReader -lLLVMCore -lLLVMRemarks -lLLVMBitstreamReader -lLLVMBinaryFormat -lLLVMTargetParser -lLLVMSupport -lLLVMDemangle -lc++ -lncurses -lz -Wl,-rpath,/Users/chenshipeng/Documents/project/llvm/llvm-src/build/Release/lib

# 定义输出目录
BUILD_DIR=build

# 主程序目标可执行文件
MAIN_TARGET=$(BUILD_DIR)/main

# 测试程序目标可执行文件
TEST_TARGET=$(BUILD_DIR)/test

# 主程序源文件
MAIN_SRCS_DIRS = src src/front src/back src/utils
MAIN_SRCS = $(wildcard $(addsuffix /*.c,$(MAIN_SRCS_DIRS)))

# 测试程序源文件
TEST_SRCS_DIRS = tests src/define src/front
TEST_SRCS = $(wildcard $(addsuffix /*.c,$(TEST_SRCS_DIRS)))

# 定义头文件目录
INCLUDES += -I.

# 编译后的可执行文件
PROGRAM = build/main

# 默认目标构建主程序
all: $(MAIN_TARGET)

# 主程序构建规则
$(MAIN_TARGET): $(MAIN_SRCS)
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $@ $^

# 测试目标构建测试程序
$(TEST_TARGET): $(TEST_SRCS)
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $@ $^

# 清理规则
clean:
	rm -rf $(BUILD_DIR)/*

# 测试目录
TEST_DIR = tests

# 查找所有测试文件
TESTS = $(wildcard $(TEST_DIR)/*.fn)

# # 测试程序的兼容性
# test: $(MAIN_TARGET)
# 	@for testfile in $(TESTS); do \
#         echo "运行 $$testfile..."; \
#         output_file=$$(echo $$testfile | sed 's/.fn/.output/'); \
#         expected_output_file=$$(echo $$testfile | sed 's/.fn/.expected/'); \
#         $(PROGRAM) $$testfile > $$output_file; \
#         if [ -f $$expected_output_file ]; then \
#             if diff $$output_file $$expected_output_file > /dev/null; then \
#                 echo "Test $$testfile passed!"; \
#             else \
#                 echo "Test $$testfile failed!"; \
#                 echo "Expected output:"; \
#                 cat $$expected_output_file; \
#                 echo "Actual output:"; \
#                 cat $$output_file; \
#                 exit 1; \
#             fi \
#         else \
#             echo "没有预期的输出文件： $$testfile"; \
#         fi; \
#     done

test: $(MAIN_TARGET)
	@for testfile in $(TESTS); do \
        echo "运行 $$testfile..."; \
        $(PROGRAM) $$testfile; \
    done

# 伪目标声明
.PHONY: all test clean
