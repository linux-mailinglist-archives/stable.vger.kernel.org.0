Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A153F2C8E
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 14:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240401AbhHTM5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 08:57:45 -0400
Received: from 8bytes.org ([81.169.241.247]:38184 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240375AbhHTM5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 08:57:45 -0400
Received: from cap.home.8bytes.org (p4ff2b1ea.dip0.t-ipconnect.de [79.242.177.234])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 2A46125C;
        Fri, 20 Aug 2021 14:57:06 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-kernel@vger.kernel.org, Fabio Aiuto <fabioaiuto83@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] x86/efi: Restore Firmware IDT before calling ExitBootServices()
Date:   Fri, 20 Aug 2021 14:57:03 +0200
Message-Id: <20210820125703.32410-1-joro@8bytes.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Commit 79419e13e808 ("x86/boot/compressed/64: Setup IDT in startup_32
boot path") introduced an IDT into the 32 bit boot path of the
decompressor stub.  But the IDT is set up before ExitBootServices() is
called and some UEFI firmwares rely on their own IDT.

Save the firmware IDT on boot and restore it before calling into EFI
functions to fix boot failures introduced by above commit.

Reported-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Fixes: 79419e13e808 ("x86/boot/compressed/64: Setup IDT in startup_32 boot path")
Cc: stable@vger.kernel.org # 5.13+
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/efi_thunk_64.S | 30 +++++++++++++++++--------
 arch/x86/boot/compressed/head_64.S      |  3 +++
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/efi_thunk_64.S b/arch/x86/boot/compressed/efi_thunk_64.S
index 95a223b3e56a..8bb92e9f4e97 100644
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
index a2347ded77ea..572c535cf45b 100644
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
-- 
2.32.0

