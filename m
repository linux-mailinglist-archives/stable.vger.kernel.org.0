Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E7A3442EC
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhCVMqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231932AbhCVMoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EE59619DD;
        Mon, 22 Mar 2021 12:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416902;
        bh=FKNLXU5pRzOqwUIWr0COcTuD4QX8+TGWGncYtbQu4n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ioVFmHzFwKGd289AvA/Xnp3lUvyHzkGN5Vte/+bR3hd9R6Ket/GzhHjqSvYCxgInd
         SwkSmkUzloD/kSkTlD8CAlSTzTsPFmE12lhxcHo5aA7DfC2hEE5OtYWjrwv026as/o
         p/sOGkjppclx04s47YYzMAvuIGa3YgphHHSDiAXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.4 10/60] ARM: 9044/1: vfp: use undef hook for VFP support detection
Date:   Mon, 22 Mar 2021 13:27:58 +0100
Message-Id: <20210322121922.712835534@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 3cce9d44321e460e7c88cdec4e4537a6e9ad7c0d upstream.

Commit f77ac2e378be9dd6 ("ARM: 9030/1: entry: omit FP emulation for UND
exceptions taken in kernel mode") failed to take into account that there
is in fact a case where we relied on this code path: during boot, the
VFP detection code issues a read of FPSID, which will trigger an undef
exception on cores that lack VFP support.

So let's reinstate this logic using an undef hook which is registered
only for the duration of the initcall to vpf_init(), and which sets
VFP_arch to a non-zero value - as before - if no VFP support is present.

Fixes: f77ac2e378be9dd6 ("ARM: 9030/1: entry: omit FP emulation for UND ...")
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/vfp/entry.S     |   17 -----------------
 arch/arm/vfp/vfpmodule.c |   25 ++++++++++++++++++++-----
 2 files changed, 20 insertions(+), 22 deletions(-)

--- a/arch/arm/vfp/entry.S
+++ b/arch/arm/vfp/entry.S
@@ -37,20 +37,3 @@ ENDPROC(vfp_null_entry)
 	.align	2
 .LCvfp:
 	.word	vfp_vector
-
-@ This code is called if the VFP does not exist. It needs to flag the
-@ failure to the VFP initialisation code.
-
-	__INIT
-ENTRY(vfp_testing_entry)
-	dec_preempt_count_ti r10, r4
-	ldr	r0, VFP_arch_address
-	str	r0, [r0]		@ set to non-zero value
-	ret	r9			@ we have handled the fault
-ENDPROC(vfp_testing_entry)
-
-	.align	2
-VFP_arch_address:
-	.word	VFP_arch
-
-	__FINIT
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -32,7 +32,6 @@
 /*
  * Our undef handlers (in entry.S)
  */
-asmlinkage void vfp_testing_entry(void);
 asmlinkage void vfp_support_entry(void);
 asmlinkage void vfp_null_entry(void);
 
@@ -43,7 +42,7 @@ asmlinkage void (*vfp_vector)(void) = vf
  * Used in startup: set to non-zero if VFP checks fail
  * After startup, holds VFP architecture
  */
-unsigned int VFP_arch;
+static unsigned int __initdata VFP_arch;
 
 /*
  * The pointer to the vfpstate structure of the thread which currently
@@ -437,7 +436,7 @@ static void vfp_enable(void *unused)
  * present on all CPUs within a SMP complex. Needs to be called prior to
  * vfp_init().
  */
-void vfp_disable(void)
+void __init vfp_disable(void)
 {
 	if (VFP_arch) {
 		pr_debug("%s: should be called prior to vfp_init\n", __func__);
@@ -707,7 +706,7 @@ static int __init vfp_kmode_exception_ho
 		register_undef_hook(&vfp_kmode_exception_hook[i]);
 	return 0;
 }
-core_initcall(vfp_kmode_exception_hook_init);
+subsys_initcall(vfp_kmode_exception_hook_init);
 
 /*
  * Kernel-side NEON support functions
@@ -753,6 +752,21 @@ EXPORT_SYMBOL(kernel_neon_end);
 
 #endif /* CONFIG_KERNEL_MODE_NEON */
 
+static int __init vfp_detect(struct pt_regs *regs, unsigned int instr)
+{
+	VFP_arch = UINT_MAX;	/* mark as not present */
+	regs->ARM_pc += 4;
+	return 0;
+}
+
+static struct undef_hook vfp_detect_hook __initdata = {
+	.instr_mask	= 0x0c000e00,
+	.instr_val	= 0x0c000a00,
+	.cpsr_mask	= MODE_MASK,
+	.cpsr_val	= SVC_MODE,
+	.fn		= vfp_detect,
+};
+
 /*
  * VFP support code initialisation.
  */
@@ -773,10 +787,11 @@ static int __init vfp_init(void)
 	 * The handler is already setup to just log calls, so
 	 * we just need to read the VFPSID register.
 	 */
-	vfp_vector = vfp_testing_entry;
+	register_undef_hook(&vfp_detect_hook);
 	barrier();
 	vfpsid = fmrx(FPSID);
 	barrier();
+	unregister_undef_hook(&vfp_detect_hook);
 	vfp_vector = vfp_null_entry;
 
 	pr_info("VFP support v0.3: ");


