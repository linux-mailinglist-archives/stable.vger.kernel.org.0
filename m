Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646B93F3B59
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 18:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhHUQEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Aug 2021 12:04:54 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59250 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhHUQEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Aug 2021 12:04:54 -0400
Date:   Sat, 21 Aug 2021 16:04:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1629561853;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=62aTtqrzgmwTmii6G9WD9NGB+2mGa715lza6oAKvJug=;
        b=BMnjdwJPWHtOTOTwX6sggBxrND7ySX0//0bg8pjeuwelEy+Wo4HRa85TvYZ9cGm2eFJqri
        YS5KPAauiUHk9Kq1fM7MjtymeXUS+HLi0IVq9Ege7Sth6bqVk6ynmpFjbGSFAiV8Zx9AuW
        3Sx4D1GsPT6/DpXf3SDBNkjKngL+b7tUdSzDbp2pAucMIB3HcvFqgA03DR6ym90qzoGwu/
        DRP0R0HfSUZUPEH2NMVOZxWBn2hO7pZPc+1++DnVIjzv3FbfMDyXnROAhfHVitzr1RcjW5
        XPtxd0XETS4WigW0EKAJFg9rU4fF7CTAfB8iYQX81s33fW1HtFHCZMX9L6HvOA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1629561853;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=62aTtqrzgmwTmii6G9WD9NGB+2mGa715lza6oAKvJug=;
        b=lIAc2GJukDzGZi0IEX/zs2NmiKnjQ9WGpySEP/8IVfpgiZuoXAP9dpvTB14GF/CeB0/Hu+
        dvdY7epCxIOqaNDg==
From:   "tip-bot2 for Joerg Roedel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/efi: Restore Firmware IDT before calling
 ExitBootServices()
Cc:     Fabio Aiuto <fabioaiuto83@gmail.com>,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
        #@tip-bot2.tec.linutronix.de, 5.13+@tip-bot2.tec.linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210820125703.32410-1-joro@8bytes.org>
References: <20210820125703.32410-1-joro@8bytes.org>
MIME-Version: 1.0
Message-ID: <162956185258.25758.4225222196830359114.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     22aa45cb465be474e97666b3f7587ccb06ee411b
Gitweb:        https://git.kernel.org/tip/22aa45cb465be474e97666b3f7587ccb06ee411b
Author:        Joerg Roedel <jroedel@suse.de>
AuthorDate:    Fri, 20 Aug 2021 14:57:03 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sat, 21 Aug 2021 17:57:04 +02:00

x86/efi: Restore Firmware IDT before calling ExitBootServices()

Commit

  79419e13e808 ("x86/boot/compressed/64: Setup IDT in startup_32 boot path")

introduced an IDT into the 32-bit boot path of the decompressor stub.
But the IDT is set up before ExitBootServices() is called, and some UEFI
firmwares rely on their own IDT.

Save the firmware IDT on boot and restore it before calling into EFI
functions to fix boot failures introduced by above commit.

Fixes: 79419e13e808 ("x86/boot/compressed/64: Setup IDT in startup_32 boot path")
Reported-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org # 5.13+
Link: https://lkml.kernel.org/r/20210820125703.32410-1-joro@8bytes.org
---
 arch/x86/boot/compressed/efi_thunk_64.S | 30 ++++++++++++++++--------
 arch/x86/boot/compressed/head_64.S      |  3 ++-
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/efi_thunk_64.S b/arch/x86/boot/compressed/efi_thunk_64.S
index 95a223b..8bb92e9 100644
--- a/arch/x86/boot/compressed/efi_thunk_64.S
+++ b/arch/x86/boot/compressed/efi_thunk_64.S
@@ -5,9 +5,8 @@
  * Early support for invoking 32-bit EFI services from a 64-bit kernel.
  *
  * Because this thunking occurs before ExitBootServices() we have to
- * restore the firmware's 32-bit GDT before we make EFI service calls,
- * since the firmware's 32-bit IDT is still currently installed and it
- * needs to be able to service interrupts.
+ * restore the firmware's 32-bit GDT and IDT before we make EFI service
+ * calls.
  *
  * On the plus side, we don't have to worry about mangling 64-bit
  * addresses into 32-bits because we're executing with an identity
@@ -39,7 +38,7 @@ SYM_FUNC_START(__efi64_thunk)
 	/*
 	 * Convert x86-64 ABI params to i386 ABI
 	 */
-	subq	$32, %rsp
+	subq	$64, %rsp
 	movl	%esi, 0x0(%rsp)
 	movl	%edx, 0x4(%rsp)
 	movl	%ecx, 0x8(%rsp)
@@ -49,14 +48,19 @@ SYM_FUNC_START(__efi64_thunk)
 	leaq	0x14(%rsp), %rbx
 	sgdt	(%rbx)
 
+	addq	$16, %rbx
+	sidt	(%rbx)
+
 	/*
-	 * Switch to gdt with 32-bit segments. This is the firmware GDT
-	 * that was installed when the kernel started executing. This
-	 * pointer was saved at the EFI stub entry point in head_64.S.
+	 * Switch to IDT and GDT with 32-bit segments. This is the firmware GDT
+	 * and IDT that was installed when the kernel started executing. The
+	 * pointers were saved at the EFI stub entry point in head_64.S.
 	 *
 	 * Pass the saved DS selector to the 32-bit code, and use far return to
 	 * restore the saved CS selector.
 	 */
+	leaq	efi32_boot_idt(%rip), %rax
+	lidt	(%rax)
 	leaq	efi32_boot_gdt(%rip), %rax
 	lgdt	(%rax)
 
@@ -67,7 +71,7 @@ SYM_FUNC_START(__efi64_thunk)
 	pushq	%rax
 	lretq
 
-1:	addq	$32, %rsp
+1:	addq	$64, %rsp
 	movq	%rdi, %rax
 
 	pop	%rbx
@@ -128,10 +132,13 @@ SYM_FUNC_START_LOCAL(efi_enter32)
 
 	/*
 	 * Some firmware will return with interrupts enabled. Be sure to
-	 * disable them before we switch GDTs.
+	 * disable them before we switch GDTs and IDTs.
 	 */
 	cli
 
+	lidtl	(%ebx)
+	subl	$16, %ebx
+
 	lgdtl	(%ebx)
 
 	movl	%cr4, %eax
@@ -166,6 +173,11 @@ SYM_DATA_START(efi32_boot_gdt)
 	.quad	0
 SYM_DATA_END(efi32_boot_gdt)
 
+SYM_DATA_START(efi32_boot_idt)
+	.word	0
+	.quad	0
+SYM_DATA_END(efi32_boot_idt)
+
 SYM_DATA_START(efi32_boot_cs)
 	.word	0
 SYM_DATA_END(efi32_boot_cs)
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index a2347de..572c535 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -319,6 +319,9 @@ SYM_INNER_LABEL(efi32_pe_stub_entry, SYM_L_LOCAL)
 	movw	%cs, rva(efi32_boot_cs)(%ebp)
 	movw	%ds, rva(efi32_boot_ds)(%ebp)
 
+	/* Store firmware IDT descriptor */
+	sidtl	rva(efi32_boot_idt)(%ebp)
+
 	/* Disable paging */
 	movl	%cr0, %eax
 	btrl	$X86_CR0_PG_BIT, %eax
