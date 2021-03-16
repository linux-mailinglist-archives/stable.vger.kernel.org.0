Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC9633D9FC
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 18:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhCPQ7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 12:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbhCPQ7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 12:59:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7583C06174A
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 09:59:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y7so42242418ybh.20
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 09:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qFPd4GCvjOnAI114zyj55KKPv7/vXpPXUVChFNLgXOc=;
        b=Sqg90j2zbK9L8TDJRd61CYbqP1Rb8bHaf9f3ko5TKMzispMXJKrLskJZs3+fwo9vP2
         cKgp/Isc8wZNZEfTciPBPuSn2xmgxbQmrCMYwYbCwP/JWu0eobVnvmlOeiI1EO3fBYYI
         OaUxYvKHpyaY3HTxHvldYCmdNcedgQTG+XEdC0gDBmKxqRLNbqUAIrpjBriwdDo9L+B3
         1LeXbS0A7cn19h7TEaUKBgBLHgi4t++X9L4w8n+XiBWqjtRvtRrEejdKnVA8tCBjGhXl
         7EbwAuvBJDGsTblOdosobtcYmDqdTdctMHIMEMMsxFG9oZUx+hGgKwDylqMokYWV08zI
         ao4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qFPd4GCvjOnAI114zyj55KKPv7/vXpPXUVChFNLgXOc=;
        b=XFz3odHEGYb2yj1i1/pOSq+IiOh2w3vZbbHQ6xMv0DSWglrw8v1KaGQd5klVBmTASG
         xaVvEACcWw/onpZpUw4LULV9Xany9YyyQ9cXEiTnhbswxtyBYN0K9recDBb3/zTO1TCr
         QbB6HH40W5VHYQHCxpd4E12kX2e62OjBlG1cTmfRs1l675srDshRUxqwaKGaNzyvhppQ
         YnxXS50LNuMmCiA/o2jiIAzDRGaE3abqfoVgrgFHvnQGSXw230hpdPOc5cegoglxwwby
         mbUmVy1KiOEa+F4DIO0/007KN6H8ANWOn/yfLDzaSZqky8HRBg48dt0edRZNass8U5k9
         LNWQ==
X-Gm-Message-State: AOAM533EMgSUeDZov1z1eWTl3ifyQxXntKTQcqMZ4mriITZ8wkuya9XI
        UtVnhHy8GG9HsCA78m69eJdTF2yOmJKFjf40gco=
X-Google-Smtp-Source: ABdhPJwBww2xQrf/YPdlquWtETmwqCdJB0uKJKFqwU8pNqm4ZJfwuP8U20arvdC31cpIFWTg4z2MSoyln54SSkYbdHU=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:b408:7c5f:edf4:6c69])
 (user=ndesaulniers job=sendgmr) by 2002:a25:1008:: with SMTP id
 8mr8392167ybq.21.1615913961773; Tue, 16 Mar 2021 09:59:21 -0700 (PDT)
Date:   Tue, 16 Mar 2021 09:59:18 -0700
In-Reply-To: <CAMj1kXGT8Zgz3Pn+DDJnY6HRz3ugbkFozJycGBW+Cm6RvyYBHA@mail.gmail.com>
Message-Id: <20210316165918.1794549-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <CAMj1kXGT8Zgz3Pn+DDJnY6HRz3ugbkFozJycGBW+Cm6RvyYBHA@mail.gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 5.4 2/2] ARM: 9044/1: vfp: use undef hook for VFP support detection
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     ardb@kernel.org, candle.sun@unisoc.com, catalin.marinas@arm.com,
        clang-built-linux@googlegroups.com, digetx@gmail.com,
        jiancai@google.com, keescook@chromium.org,
        linus.walleij@linaro.org, llozano@google.com, maz@kernel.org,
        miles.chen@mediatek.com, ndesaulniers@google.com,
        rmk+kernel@armlinux.org.uk, samitolvanen@google.com,
        srhines@google.com, sspatil@google.com, stable@vger.kernel.org,
        stefan@agner.ch, "kernelci.org bot" <bot@kernelci.org>
Content-Type: text/plain; charset="UTF-8"
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
---
This is meant to be applied on top of
https://lore.kernel.org/stable/20210315231952.1482097-1-ndesaulniers@google.com/.
If it's preferrable to send an .mbox file or a series with cover letter,
I'm happy to resend it as such, just let me know.

 arch/arm/vfp/entry.S     | 17 -----------------
 arch/arm/vfp/vfpmodule.c | 25 ++++++++++++++++++++-----
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/arm/vfp/entry.S b/arch/arm/vfp/entry.S
index 0186cf9da890..27b0a1f27fbd 100644
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
index c3b6451c18bd..2cb355c1b5b7 100644
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
2.31.0.rc2.261.g7f71774620-goog

