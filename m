Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE9338A0E8
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhETJ0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:26:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231751AbhETJ0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12E796135B;
        Thu, 20 May 2021 09:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502713;
        bh=XjNwv2Xw4I05Tn+u7g5M5/v9oyFzRCtsszzdvESb0/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yYkwJdV1WoUCGxntliULb8YkB2bOi7nIm4uOczMrgwqsLMVSL8LGMj8805LXa1P0Y
         ZNSt2WsHhr//AbjmmVmIsxFLEVdxQ1lMHwWTZ+IVuSZkBFc+9C+98ho1+sH+N1MY0y
         cN0pLrxCWo/b47mSrUsvw2SewCG5Tf2AIGqSZJJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 25/45] riscv: Workaround mcount name prior to clang-13
Date:   Thu, 20 May 2021 11:22:13 +0200
Message-Id: <20210520092054.334013268@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 7ce04771503074a7de7f539cc43f5e1b385cb99b ]

Prior to clang 13.0.0, the RISC-V name for the mcount symbol was
"mcount", which differs from the GCC version of "_mcount", which results
in the following errors:

riscv64-linux-gnu-ld: init/main.o: in function `__traceiter_initcall_level':
main.c:(.text+0xe): undefined reference to `mcount'
riscv64-linux-gnu-ld: init/main.o: in function `__traceiter_initcall_start':
main.c:(.text+0x4e): undefined reference to `mcount'
riscv64-linux-gnu-ld: init/main.o: in function `__traceiter_initcall_finish':
main.c:(.text+0x92): undefined reference to `mcount'
riscv64-linux-gnu-ld: init/main.o: in function `.LBB32_28':
main.c:(.text+0x30c): undefined reference to `mcount'
riscv64-linux-gnu-ld: init/main.o: in function `free_initmem':
main.c:(.text+0x54c): undefined reference to `mcount'

This has been corrected in https://reviews.llvm.org/D98881 but the
minimum supported clang version is 10.0.1. To avoid build errors and to
gain a working function tracer, adjust the name of the mcount symbol for
older versions of clang in mount.S and recordmcount.pl.

Link: https://github.com/ClangBuiltLinux/linux/issues/1331
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/ftrace.h | 14 ++++++++++++--
 arch/riscv/kernel/mcount.S      | 10 +++++-----
 scripts/recordmcount.pl         |  2 +-
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/ftrace.h b/arch/riscv/include/asm/ftrace.h
index 845002cc2e57..04dad3380041 100644
--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -13,9 +13,19 @@
 #endif
 #define HAVE_FUNCTION_GRAPH_RET_ADDR_PTR
 
+/*
+ * Clang prior to 13 had "mcount" instead of "_mcount":
+ * https://reviews.llvm.org/D98881
+ */
+#if defined(CONFIG_CC_IS_GCC) || CONFIG_CLANG_VERSION >= 130000
+#define MCOUNT_NAME _mcount
+#else
+#define MCOUNT_NAME mcount
+#endif
+
 #define ARCH_SUPPORTS_FTRACE_OPS 1
 #ifndef __ASSEMBLY__
-void _mcount(void);
+void MCOUNT_NAME(void);
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
 	return addr;
@@ -36,7 +46,7 @@ struct dyn_arch_ftrace {
  * both auipc and jalr at the same time.
  */
 
-#define MCOUNT_ADDR		((unsigned long)_mcount)
+#define MCOUNT_ADDR		((unsigned long)MCOUNT_NAME)
 #define JALR_SIGN_MASK		(0x00000800)
 #define JALR_OFFSET_MASK	(0x00000fff)
 #define AUIPC_OFFSET_MASK	(0xfffff000)
diff --git a/arch/riscv/kernel/mcount.S b/arch/riscv/kernel/mcount.S
index 8a5593ff9ff3..6d462681c9c0 100644
--- a/arch/riscv/kernel/mcount.S
+++ b/arch/riscv/kernel/mcount.S
@@ -47,8 +47,8 @@
 
 ENTRY(ftrace_stub)
 #ifdef CONFIG_DYNAMIC_FTRACE
-       .global _mcount
-       .set    _mcount, ftrace_stub
+       .global MCOUNT_NAME
+       .set    MCOUNT_NAME, ftrace_stub
 #endif
 	ret
 ENDPROC(ftrace_stub)
@@ -78,7 +78,7 @@ ENDPROC(return_to_handler)
 #endif
 
 #ifndef CONFIG_DYNAMIC_FTRACE
-ENTRY(_mcount)
+ENTRY(MCOUNT_NAME)
 	la	t4, ftrace_stub
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	la	t0, ftrace_graph_return
@@ -124,6 +124,6 @@ do_trace:
 	jalr	t5
 	RESTORE_ABI_STATE
 	ret
-ENDPROC(_mcount)
+ENDPROC(MCOUNT_NAME)
 #endif
-EXPORT_SYMBOL(_mcount)
+EXPORT_SYMBOL(MCOUNT_NAME)
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a36df04cfa09..7b83a1aaec98 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -392,7 +392,7 @@ if ($arch eq "x86_64") {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
 } elsif ($arch eq "riscv") {
     $function_regex = "^([0-9a-fA-F]+)\\s+<([^.0-9][0-9a-zA-Z_\\.]+)>:";
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\sR_RISCV_CALL(_PLT)?\\s_mcount\$";
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\sR_RISCV_CALL(_PLT)?\\s_?mcount\$";
     $type = ".quad";
     $alignment = 2;
 } elsif ($arch eq "nds32") {
-- 
2.30.2



