Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0B02E3E14
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502781AbgL1OXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:23:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439224AbgL1OXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0E14229C5;
        Mon, 28 Dec 2020 14:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165361;
        bh=TWf9/haxjXMGxCoZSiwcAasoXVdfqAYS/IuwVtlsvMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvjR8XZhRuMqhUbdk7JV2J+03CSGYoaOAZE3JClik7PFvy8MhhxtvYHfjwrqfRajw
         BP36Y+wGLZqIfpi5eKFBYSGGEZT3JfTZH8CJLO0/fZcX6al1EMK/NYjinu3LrMfYQu
         9cvyAmOA6rOypdsdcfJZnDLFrJUBJgMKA9y0ltZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 503/717] ARM: 9044/1: vfp: use undef hook for VFP support detection
Date:   Mon, 28 Dec 2020 13:48:21 +0100
Message-Id: <20201228125045.056652350@linuxfoundation.org>
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

[ Upstream commit 3cce9d44321e460e7c88cdec4e4537a6e9ad7c0d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/vfp/entry.S     | 17 -----------------
 arch/arm/vfp/vfpmodule.c | 25 ++++++++++++++++++++-----
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/arm/vfp/entry.S b/arch/arm/vfp/entry.S
index 0186cf9da890b..27b0a1f27fbdf 100644
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
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index c3b6451c18bda..2cb355c1b5b71 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -32,7 +32,6 @@
 /*
  * Our undef handlers (in entry.S)
  */
-asmlinkage void vfp_testing_entry(void);
 asmlinkage void vfp_support_entry(void);
 asmlinkage void vfp_null_entry(void);
 
@@ -43,7 +42,7 @@ asmlinkage void (*vfp_vector)(void) = vfp_null_entry;
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
@@ -707,7 +706,7 @@ static int __init vfp_kmode_exception_hook_init(void)
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
-- 
2.27.0



