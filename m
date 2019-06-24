Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E7450830
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbfFXKNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbfFXKNc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:13:32 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42C69205C9;
        Mon, 24 Jun 2019 10:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371210;
        bh=gR8feKZ1mWK2vQqDrDx+RFTKVwDxC0dzrUJRAOxra1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWzAA9hFzeX9X4SP1L2wZGbF7omytz9ZkJlBakJBwoCieWwdjMN7SUmyOFCrBFWQo
         RTMidRxc7ub9Jq4ifmf7+6naj+RSXHPJWDktVicSKsC9YTQHui8ARHAvLJ7PrssbPj
         a8K/eGwdZMFAAy4oY7S7oMCl17QsKfcqq5p81s+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Chen <vincentc@andestech.com>,
        Greentime Hu <greentime@andestech.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 062/121] nds32: Avoid IEX status being incorrectly modified
Date:   Mon, 24 Jun 2019 17:56:34 +0800
Message-Id: <20190624092323.933449635@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ed32949e0acb73e7bc054bb02e0453d4d561ceda ]

In order for kernel to capture each denormalized output, the UDF
trapping enable bit is always raised in $fpcsr. Because underflow case will
issue not an underflow exception but also an inexact exception, it causes
that the IEX, IEX cumulative exception, flag in $fpcsr to be raised in each
denormalized output handling. To make the emulation transparent to the
user, the emulator needs to clear the IEX flag in $fpcsr if the result is a
denormalized number. However, if the IEX flag has been raised before this
floating point emulation, this cleanup may be incorrect. To avoid the IEX
flags in $fpcsr be raised in each denormalized output handling, the IEX
trap shall be always enabled.

Signed-off-by: Vincent Chen <vincentc@andestech.com>
Acked-by: Greentime Hu <greentime@andestech.com>
Signed-off-by: Greentime Hu <greentime@andestech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nds32/include/asm/bitfield.h            |  2 +-
 arch/nds32/include/asm/fpu.h                 |  2 +-
 arch/nds32/include/asm/syscalls.h            |  2 +-
 arch/nds32/include/uapi/asm/fp_udfiex_crtl.h | 16 ++++++++++++
 arch/nds32/include/uapi/asm/sigcontext.h     | 24 ++++++++++++------
 arch/nds32/include/uapi/asm/udftrap.h        | 13 ----------
 arch/nds32/include/uapi/asm/unistd.h         |  4 +--
 arch/nds32/kernel/fpu.c                      | 15 +++++------
 arch/nds32/kernel/sys_nds32.c                | 26 +++++++++++---------
 9 files changed, 58 insertions(+), 46 deletions(-)
 create mode 100644 arch/nds32/include/uapi/asm/fp_udfiex_crtl.h
 delete mode 100644 arch/nds32/include/uapi/asm/udftrap.h

diff --git a/arch/nds32/include/asm/bitfield.h b/arch/nds32/include/asm/bitfield.h
index 7414fcbbab4e..03bbb6d27828 100644
--- a/arch/nds32/include/asm/bitfield.h
+++ b/arch/nds32/include/asm/bitfield.h
@@ -937,7 +937,7 @@
 #define FPCSR_mskDNIT           ( 0x1  << FPCSR_offDNIT )
 #define FPCSR_mskRIT		( 0x1  << FPCSR_offRIT )
 #define FPCSR_mskALL		(FPCSR_mskIVO | FPCSR_mskDBZ | FPCSR_mskOVF | FPCSR_mskUDF | FPCSR_mskIEX)
-#define FPCSR_mskALLE_NO_UDFE	(FPCSR_mskIVOE | FPCSR_mskDBZE | FPCSR_mskOVFE | FPCSR_mskIEXE)
+#define FPCSR_mskALLE_NO_UDF_IEXE (FPCSR_mskIVOE | FPCSR_mskDBZE | FPCSR_mskOVFE)
 #define FPCSR_mskALLE		(FPCSR_mskIVOE | FPCSR_mskDBZE | FPCSR_mskOVFE | FPCSR_mskUDFE | FPCSR_mskIEXE)
 #define FPCSR_mskALLT           (FPCSR_mskIVOT | FPCSR_mskDBZT | FPCSR_mskOVFT | FPCSR_mskUDFT | FPCSR_mskIEXT |FPCSR_mskDNIT | FPCSR_mskRIT)
 
diff --git a/arch/nds32/include/asm/fpu.h b/arch/nds32/include/asm/fpu.h
index 019f1bcfc5ee..8294ed4aaa2c 100644
--- a/arch/nds32/include/asm/fpu.h
+++ b/arch/nds32/include/asm/fpu.h
@@ -36,7 +36,7 @@ extern int do_fpuemu(struct pt_regs *regs, struct fpu_struct *fpu);
  * enabled by default and kerenl will re-execute it by fpu emulator
  * when getting underflow exception.
  */
-#define FPCSR_INIT  FPCSR_mskUDFE
+#define FPCSR_INIT  (FPCSR_mskUDFE | FPCSR_mskIEXE)
 #else
 #define FPCSR_INIT  0x0UL
 #endif
diff --git a/arch/nds32/include/asm/syscalls.h b/arch/nds32/include/asm/syscalls.h
index da32101b455d..b9c9becce5d6 100644
--- a/arch/nds32/include/asm/syscalls.h
+++ b/arch/nds32/include/asm/syscalls.h
@@ -7,7 +7,7 @@
 asmlinkage long sys_cacheflush(unsigned long addr, unsigned long len, unsigned int op);
 asmlinkage long sys_fadvise64_64_wrapper(int fd, int advice, loff_t offset, loff_t len);
 asmlinkage long sys_rt_sigreturn_wrapper(void);
-asmlinkage long sys_udftrap(int option);
+asmlinkage long sys_fp_udfiex_crtl(int cmd, int act);
 
 #include <asm-generic/syscalls.h>
 
diff --git a/arch/nds32/include/uapi/asm/fp_udfiex_crtl.h b/arch/nds32/include/uapi/asm/fp_udfiex_crtl.h
new file mode 100644
index 000000000000..d54a5d6c6538
--- /dev/null
+++ b/arch/nds32/include/uapi/asm/fp_udfiex_crtl.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2005-2019 Andes Technology Corporation */
+#ifndef	_FP_UDF_IEX_CRTL_H
+#define	_FP_UDF_IEX_CRTL_H
+
+/*
+ * The cmd list of sys_fp_udfiex_crtl()
+ */
+/* Disable UDF or IEX trap based on the content of parameter act */
+#define DISABLE_UDF_IEX_TRAP	0
+/* Enable UDF or IEX trap based on the content of parameter act */
+#define ENABLE_UDF_IEX_TRAP	1
+/* Get current status of UDF and IEX trap */
+#define GET_UDF_IEX_TRAP	2
+
+#endif /* _FP_UDF_IEX_CRTL_H */
diff --git a/arch/nds32/include/uapi/asm/sigcontext.h b/arch/nds32/include/uapi/asm/sigcontext.h
index 58afc416473e..b53634033e32 100644
--- a/arch/nds32/include/uapi/asm/sigcontext.h
+++ b/arch/nds32/include/uapi/asm/sigcontext.h
@@ -13,14 +13,24 @@ struct fpu_struct {
 	unsigned long long fd_regs[32];
 	unsigned long fpcsr;
 	/*
-	 * UDF_trap is used to recognize whether underflow trap is enabled
-	 * or not. When UDF_trap == 1, this process will be traped and then
-	 * get a SIGFPE signal when encountering an underflow exception.
-	 * UDF_trap is only modified through setfputrap syscall. Therefore,
-	 * UDF_trap needn't be saved or loaded to context in each context
-	 * switch.
+	 * When CONFIG_SUPPORT_DENORMAL_ARITHMETIC is defined, kernel prevents
+	 * hardware from treating the denormalized output as an underflow case
+	 * and rounding it to a normal number. Hence kernel enables the UDF and
+	 * IEX trap in the fpcsr register to step in the calculation.
+	 * However, the UDF and IEX trap enable bit in $fpcsr also lose
+	 * their use.
+	 *
+	 * UDF_IEX_trap replaces the feature of UDF and IEX trap enable bit in
+	 * $fpcsr to control the trap of underflow and inexact. The bit filed
+	 * of UDF_IEX_trap is the same as $fpcsr, 10th bit is used to enable UDF
+	 * exception trapping and 11th bit is used to enable IEX exception
+	 * trapping.
+	 *
+	 * UDF_IEX_trap is only modified through fp_udfiex_crtl syscall.
+	 * Therefore, UDF_IEX_trap needn't be saved and restored in each
+	 * context switch.
 	 */
-	unsigned long UDF_trap;
+	unsigned long UDF_IEX_trap;
 };
 
 struct zol_struct {
diff --git a/arch/nds32/include/uapi/asm/udftrap.h b/arch/nds32/include/uapi/asm/udftrap.h
deleted file mode 100644
index 433f79d679c0..000000000000
--- a/arch/nds32/include/uapi/asm/udftrap.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2005-2018 Andes Technology Corporation */
-#ifndef	_ASM_SETFPUTRAP
-#define	_ASM_SETFPUTRAP
-
-/*
- * Options for setfputrap system call
- */
-#define	DISABLE_UDFTRAP	0	/* disable underflow exception trap */
-#define	ENABLE_UDFTRAP	1	/* enable undeflos exception trap */
-#define	GET_UDFTRAP	2	/* only get undeflos exception trap status */
-
-#endif /* _ASM_CACHECTL */
diff --git a/arch/nds32/include/uapi/asm/unistd.h b/arch/nds32/include/uapi/asm/unistd.h
index 4ec8f543103f..6b9ff90e3ae5 100644
--- a/arch/nds32/include/uapi/asm/unistd.h
+++ b/arch/nds32/include/uapi/asm/unistd.h
@@ -11,6 +11,6 @@
 
 /* Additional NDS32 specific syscalls. */
 #define __NR_cacheflush		(__NR_arch_specific_syscall)
-#define __NR_udftrap		(__NR_arch_specific_syscall + 1)
+#define __NR_fp_udfiex_crtl	(__NR_arch_specific_syscall + 1)
 __SYSCALL(__NR_cacheflush, sys_cacheflush)
-__SYSCALL(__NR_udftrap, sys_udftrap)
+__SYSCALL(__NR_fp_udfiex_crtl, sys_fp_udfiex_crtl)
diff --git a/arch/nds32/kernel/fpu.c b/arch/nds32/kernel/fpu.c
index fddd40c7a16f..cf0b8760f261 100644
--- a/arch/nds32/kernel/fpu.c
+++ b/arch/nds32/kernel/fpu.c
@@ -14,7 +14,7 @@ const struct fpu_struct init_fpuregs = {
 	.fd_regs = {[0 ... 31] = sNAN64},
 	.fpcsr = FPCSR_INIT,
 #if IS_ENABLED(CONFIG_SUPPORT_DENORMAL_ARITHMETIC)
-	.UDF_trap = 0
+	.UDF_IEX_trap = 0
 #endif
 };
 
@@ -178,7 +178,7 @@ inline void do_fpu_context_switch(struct pt_regs *regs)
 		/* First time FPU user.  */
 		load_fpu(&init_fpuregs);
 #if IS_ENABLED(CONFIG_SUPPORT_DENORMAL_ARITHMETIC)
-		current->thread.fpu.UDF_trap = init_fpuregs.UDF_trap;
+		current->thread.fpu.UDF_IEX_trap = init_fpuregs.UDF_IEX_trap;
 #endif
 		set_used_math();
 	}
@@ -206,7 +206,7 @@ inline void handle_fpu_exception(struct pt_regs *regs)
 	unsigned int fpcsr;
 	int si_code = 0, si_signo = SIGFPE;
 #if IS_ENABLED(CONFIG_SUPPORT_DENORMAL_ARITHMETIC)
-	unsigned long redo_except = FPCSR_mskDNIT|FPCSR_mskUDFT;
+	unsigned long redo_except = FPCSR_mskDNIT|FPCSR_mskUDFT|FPCSR_mskIEXT;
 #else
 	unsigned long redo_except = FPCSR_mskDNIT;
 #endif
@@ -215,21 +215,18 @@ inline void handle_fpu_exception(struct pt_regs *regs)
 	fpcsr = current->thread.fpu.fpcsr;
 
 	if (fpcsr & redo_except) {
-#if IS_ENABLED(CONFIG_SUPPORT_DENORMAL_ARITHMETIC)
-		if (fpcsr & FPCSR_mskUDFT)
-			current->thread.fpu.fpcsr &= ~FPCSR_mskIEX;
-#endif
 		si_signo = do_fpuemu(regs, &current->thread.fpu);
 		fpcsr = current->thread.fpu.fpcsr;
-		if (!si_signo)
+		if (!si_signo) {
+			current->thread.fpu.fpcsr &= ~(redo_except);
 			goto done;
+		}
 	} else if (fpcsr & FPCSR_mskRIT) {
 		if (!user_mode(regs))
 			do_exit(SIGILL);
 		si_signo = SIGILL;
 	}
 
-
 	switch (si_signo) {
 	case SIGFPE:
 		fill_sigfpe_signo(fpcsr, &si_code);
diff --git a/arch/nds32/kernel/sys_nds32.c b/arch/nds32/kernel/sys_nds32.c
index 0835277636ce..cb2d1e219bb3 100644
--- a/arch/nds32/kernel/sys_nds32.c
+++ b/arch/nds32/kernel/sys_nds32.c
@@ -6,8 +6,8 @@
 
 #include <asm/cachectl.h>
 #include <asm/proc-fns.h>
-#include <asm/udftrap.h>
 #include <asm/fpu.h>
+#include <asm/fp_udfiex_crtl.h>
 
 SYSCALL_DEFINE6(mmap2, unsigned long, addr, unsigned long, len,
 	       unsigned long, prot, unsigned long, flags,
@@ -51,31 +51,33 @@ SYSCALL_DEFINE3(cacheflush, unsigned int, start, unsigned int, end, int, cache)
 	return 0;
 }
 
-SYSCALL_DEFINE1(udftrap, int, option)
+SYSCALL_DEFINE2(fp_udfiex_crtl, unsigned int, cmd, unsigned int, act)
 {
 #if IS_ENABLED(CONFIG_SUPPORT_DENORMAL_ARITHMETIC)
-	int old_udftrap;
+	int old_udf_iex;
 
 	if (!used_math()) {
 		load_fpu(&init_fpuregs);
-		current->thread.fpu.UDF_trap = init_fpuregs.UDF_trap;
+		current->thread.fpu.UDF_IEX_trap = init_fpuregs.UDF_IEX_trap;
 		set_used_math();
 	}
 
-	old_udftrap = current->thread.fpu.UDF_trap;
-	switch (option) {
-	case DISABLE_UDFTRAP:
-		current->thread.fpu.UDF_trap = 0;
+	old_udf_iex = current->thread.fpu.UDF_IEX_trap;
+	act &= (FPCSR_mskUDFE | FPCSR_mskIEXE);
+
+	switch (cmd) {
+	case DISABLE_UDF_IEX_TRAP:
+		current->thread.fpu.UDF_IEX_trap &= ~act;
 		break;
-	case ENABLE_UDFTRAP:
-		current->thread.fpu.UDF_trap = FPCSR_mskUDFE;
+	case ENABLE_UDF_IEX_TRAP:
+		current->thread.fpu.UDF_IEX_trap |= act;
 		break;
-	case GET_UDFTRAP:
+	case GET_UDF_IEX_TRAP:
 		break;
 	default:
 		return -EINVAL;
 	}
-	return old_udftrap;
+	return old_udf_iex;
 #else
 	return -ENOTSUPP;
 #endif
-- 
2.20.1



