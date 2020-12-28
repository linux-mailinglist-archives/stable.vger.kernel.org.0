Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A780A2E40C2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbgL1O4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:56:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391777AbgL1OQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A56F20791;
        Mon, 28 Dec 2020 14:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164969;
        bh=y5hcqTNguQgkMmbJ3S3HwvxW8sVdhmMIV1ne0Sa5PiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcY6O+dqxPxCSDfhskefTQ1TVcnuNAHIQwWDOIHq2wYv49p8Odt3VQ7PyjZEi7Wum
         jZWqODLISDVd0xiZ0vQdTSrpXym8gzmI+whgfqVYtsONzcyD/sUrNIzvxntKItVcAG
         /gTL4XV+cwpx8k7IRw+8Tqun5I+7Sy+Mec/Yk670=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 363/717] ARM: 9030/1: entry: omit FP emulation for UND exceptions taken in kernel mode
Date:   Mon, 28 Dec 2020 13:46:01 +0100
Message-Id: <20201228125038.405690346@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit f77ac2e378be9dd61eb88728f0840642f045d9d1 ]

There are a couple of problems with the exception entry code that deals
with FP exceptions (which are reported as UND exceptions) when building
the kernel in Thumb2 mode:
- the conditional branch to vfp_kmode_exception in vfp_support_entry()
  may be out of range for its target, depending on how the linker decides
  to arrange the sections;
- when the UND exception is taken in kernel mode, the emulation handling
  logic is entered via the 'call_fpe' label, which means we end up using
  the wrong value/mask pairs to match and detect the NEON opcodes.

Since UND exceptions in kernel mode are unlikely to occur on a hot path
(as opposed to the user mode version which is invoked for VFP support
code and lazy restore), we can use the existing undef hook machinery for
any kernel mode instruction emulation that is needed, including calling
the existing vfp_kmode_exception() routine for unexpected cases. So drop
the call to call_fpe, and instead, install an undef hook that will get
called for NEON and VFP instructions that trigger an UND exception in
kernel mode.

While at it, make sure that the PC correction is accurate for the
execution mode where the exception was taken, by checking the PSR
Thumb bit.

Cc: Dmitry Osipenko <digetx@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Fixes: eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input sections")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/entry-armv.S | 25 ++----------------
 arch/arm/vfp/vfphw.S         |  5 ----
 arch/arm/vfp/vfpmodule.c     | 49 ++++++++++++++++++++++++++++++++++--
 3 files changed, 49 insertions(+), 30 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 55a47df047738..1c9e6d1452c5b 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -252,31 +252,10 @@ __und_svc:
 #else
 	svc_entry
 #endif
-	@
-	@ call emulation code, which returns using r9 if it has emulated
-	@ the instruction, or the more conventional lr if we are to treat
-	@ this as a real undefined instruction
-	@
-	@  r0 - instruction
-	@
-#ifndef CONFIG_THUMB2_KERNEL
-	ldr	r0, [r4, #-4]
-#else
-	mov	r1, #2
-	ldrh	r0, [r4, #-2]			@ Thumb instruction at LR - 2
-	cmp	r0, #0xe800			@ 32-bit instruction if xx >= 0
-	blo	__und_svc_fault
-	ldrh	r9, [r4]			@ bottom 16 bits
-	add	r4, r4, #2
-	str	r4, [sp, #S_PC]
-	orr	r0, r9, r0, lsl #16
-#endif
-	badr	r9, __und_svc_finish
-	mov	r2, r4
-	bl	call_fpe
 
 	mov	r1, #4				@ PC correction to apply
-__und_svc_fault:
+ THUMB(	tst	r5, #PSR_T_BIT		)	@ exception taken in Thumb mode?
+ THUMB(	movne	r1, #2			)	@ if so, fix up PC correction
 	mov	r0, sp				@ struct pt_regs *regs
 	bl	__und_fault
 
diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index 4fcff9f59947d..d5837bf05a9a5 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -79,11 +79,6 @@ ENTRY(vfp_support_entry)
 	DBGSTR3	"instr %08x pc %08x state %p", r0, r2, r10
 
 	.fpu	vfpv2
-	ldr	r3, [sp, #S_PSR]	@ Neither lazy restore nor FP exceptions
-	and	r3, r3, #MODE_MASK	@ are supported in kernel mode
-	teq	r3, #USR_MODE
-	bne	vfp_kmode_exception	@ Returns through lr
-
 	VFPFMRX	r1, FPEXC		@ Is the VFP enabled?
 	DBGSTR1	"fpexc %08x", r1
 	tst	r1, #FPEXC_EN
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 8c9e7f9f0277d..c3b6451c18bda 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -23,6 +23,7 @@
 #include <asm/cputype.h>
 #include <asm/system_info.h>
 #include <asm/thread_notify.h>
+#include <asm/traps.h>
 #include <asm/vfp.h>
 
 #include "vfpinstr.h"
@@ -642,7 +643,9 @@ static int vfp_starting_cpu(unsigned int unused)
 	return 0;
 }
 
-void vfp_kmode_exception(void)
+#ifdef CONFIG_KERNEL_MODE_NEON
+
+static int vfp_kmode_exception(struct pt_regs *regs, unsigned int instr)
 {
 	/*
 	 * If we reach this point, a floating point exception has been raised
@@ -660,9 +663,51 @@ void vfp_kmode_exception(void)
 		pr_crit("BUG: unsupported FP instruction in kernel mode\n");
 	else
 		pr_crit("BUG: FP instruction issued in kernel mode with FP unit disabled\n");
+	pr_crit("FPEXC == 0x%08x\n", fmrx(FPEXC));
+	return 1;
 }
 
-#ifdef CONFIG_KERNEL_MODE_NEON
+static struct undef_hook vfp_kmode_exception_hook[] = {{
+	.instr_mask	= 0xfe000000,
+	.instr_val	= 0xf2000000,
+	.cpsr_mask	= MODE_MASK | PSR_T_BIT,
+	.cpsr_val	= SVC_MODE,
+	.fn		= vfp_kmode_exception,
+}, {
+	.instr_mask	= 0xff100000,
+	.instr_val	= 0xf4000000,
+	.cpsr_mask	= MODE_MASK | PSR_T_BIT,
+	.cpsr_val	= SVC_MODE,
+	.fn		= vfp_kmode_exception,
+}, {
+	.instr_mask	= 0xef000000,
+	.instr_val	= 0xef000000,
+	.cpsr_mask	= MODE_MASK | PSR_T_BIT,
+	.cpsr_val	= SVC_MODE | PSR_T_BIT,
+	.fn		= vfp_kmode_exception,
+}, {
+	.instr_mask	= 0xff100000,
+	.instr_val	= 0xf9000000,
+	.cpsr_mask	= MODE_MASK | PSR_T_BIT,
+	.cpsr_val	= SVC_MODE | PSR_T_BIT,
+	.fn		= vfp_kmode_exception,
+}, {
+	.instr_mask	= 0x0c000e00,
+	.instr_val	= 0x0c000a00,
+	.cpsr_mask	= MODE_MASK,
+	.cpsr_val	= SVC_MODE,
+	.fn		= vfp_kmode_exception,
+}};
+
+static int __init vfp_kmode_exception_hook_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(vfp_kmode_exception_hook); i++)
+		register_undef_hook(&vfp_kmode_exception_hook[i]);
+	return 0;
+}
+core_initcall(vfp_kmode_exception_hook_init);
 
 /*
  * Kernel-side NEON support functions
-- 
2.27.0



