Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5F5409305
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343572AbhIMORG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345298AbhIMOPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:15:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E382161AF0;
        Mon, 13 Sep 2021 13:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540642;
        bh=duFxu1ijeIG/AoV8sk4dQIklpP7RvwQV1HF5aYdCs64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bteof5PfbWVmrRlaVM2BHrwzy8mN23vYsdx5U4+8FkLDTSPmpHaGNGBeYT1wVw20E
         HbqjSuQdGJ/c/YMqpW7mOPBwQLQq6maBLQdIJqQoKAkwRuRbskhff8LCuPNZvTm9xn
         oxhDTDuLhBa9bTcDyWQB9iyTKYPVXndBPa/uljMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Aiuto <fabioaiuto83@gmail.com>,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.13 277/300] x86/efi: Restore Firmware IDT before calling ExitBootServices()
Date:   Mon, 13 Sep 2021 15:15:38 +0200
Message-Id: <20210913131118.697371645@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 22aa45cb465be474e97666b3f7587ccb06ee411b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/efi_thunk_64.S |   30 +++++++++++++++++++++---------
 arch/x86/boot/compressed/head_64.S      |    3 +++
 2 files changed, 24 insertions(+), 9 deletions(-)

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
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -319,6 +319,9 @@ SYM_INNER_LABEL(efi32_pe_stub_entry, SYM
 	movw	%cs, rva(efi32_boot_cs)(%ebp)
 	movw	%ds, rva(efi32_boot_ds)(%ebp)
 
+	/* Store firmware IDT descriptor */
+	sidtl	rva(efi32_boot_idt)(%ebp)
+
 	/* Disable paging */
 	movl	%cr0, %eax
 	btrl	$X86_CR0_PG_BIT, %eax


