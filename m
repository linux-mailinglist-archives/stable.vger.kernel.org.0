Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FFB3F290F
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 11:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhHTJ0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 05:26:06 -0400
Received: from mail.skyhub.de ([5.9.137.197]:32956 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232991AbhHTJ0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 05:26:06 -0400
Received: from zn.tnic (p200300ec2f107b00c7422970522e0abe.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:7b00:c742:2970:522e:abe])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 755551EC047D;
        Fri, 20 Aug 2021 11:25:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1629451523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=CLw1R2E8tRT9zZxScyNNPpxGm1yDL2InY9dHbzY51fU=;
        b=DtkfIwZqVj7StAX8FsC0CFsqYI8v3d/RdofKs4XYIlVVAVWh4sXDgHicAIPykMWOhaZOw9
        vbi2vVsTs/fbacZR6D0M+pPbKq8/Q+XjRnR/9cNKUCNrJZIa9C7Y7v8kMmsLt9ioYwOPwe
        koK8dC8igpnT2BL6Pqf1nJqqCYXI10M=
Date:   Fri, 20 Aug 2021 11:26:00 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
        Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Fabio Aiuto <fabioaiuto83@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/efi: Restore Firmware IDT in before
 ExitBootServices()
Message-ID: <YR91KKJ1Bq/KNBnY@zn.tnic>
References: <20210820073429.19457-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210820073429.19457-1-joro@8bytes.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 09:34:29AM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Commit 79419e13e808 ("x86/boot/compressed/64: Setup IDT in startup_32
> boot path") introduced an IDT into the 32 bit boot path of the
> decompressor stub.  But the IDT is set up before ExitBootServices() is
> called and some UEFI firmwares rely on their own IDT.
> 
> Save the firmware IDT on boot and restore it before calling into EFI
> functions to fix boot failures introduced by above commit.
> 
> Reported-by: Fabio Aiuto <fabioaiuto83@gmail.com>
> Fixes: 79419e13e808 ("x86/boot/compressed/64: Setup IDT in startup_32 boot path")
> Cc: stable@vger.kernel.org # 5.13+
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/boot/compressed/efi_thunk_64.S | 23 ++++++++++++++++++-----
>  arch/x86/boot/compressed/head_64.S      |  3 +++
>  2 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/efi_thunk_64.S b/arch/x86/boot/compressed/efi_thunk_64.S
> index 95a223b3e56a..99cfd5dea23c 100644
> --- a/arch/x86/boot/compressed/efi_thunk_64.S
> +++ b/arch/x86/boot/compressed/efi_thunk_64.S
> @@ -39,7 +39,7 @@ SYM_FUNC_START(__efi64_thunk)
>  	/*
>  	 * Convert x86-64 ABI params to i386 ABI
>  	 */
> -	subq	$32, %rsp
> +	subq	$64, %rsp
>  	movl	%esi, 0x0(%rsp)
>  	movl	%edx, 0x4(%rsp)
>  	movl	%ecx, 0x8(%rsp)
> @@ -49,14 +49,19 @@ SYM_FUNC_START(__efi64_thunk)
>  	leaq	0x14(%rsp), %rbx
>  	sgdt	(%rbx)
>  
> +	addq	$16, %rbx
> +	sidt	(%rbx)
> +
>  	/*
> -	 * Switch to gdt with 32-bit segments. This is the firmware GDT
> -	 * that was installed when the kernel started executing. This
> -	 * pointer was saved at the EFI stub entry point in head_64.S.
> +	 * Switch to idt and gdt with 32-bit segments. This is the firmware GDT

IDT and GDT, both capitalized pls. Also, the comment at the top of the
file needs adjusting.

> +	 * and IDT that was installed when the kernel started executing. The
> +	 * pointers were saved at the EFI stub entry point in head_64.S.
>  	 *
>  	 * Pass the saved DS selector to the 32-bit code, and use far return to
>  	 * restore the saved CS selector.
>  	 */
> +	leaq	efi32_boot_idt(%rip), %rax
> +	lidt	(%rax)
>  	leaq	efi32_boot_gdt(%rip), %rax
>  	lgdt	(%rax)
>  
> @@ -67,7 +72,7 @@ SYM_FUNC_START(__efi64_thunk)
>  	pushq	%rax
>  	lretq
>  
> -1:	addq	$32, %rsp
> +1:	addq	$64, %rsp
>  	movq	%rdi, %rax
>  
>  	pop	%rbx
> @@ -132,6 +137,9 @@ SYM_FUNC_START_LOCAL(efi_enter32)
>  	 */

Can you pls also extend this comment here to say "IDT" for faster
pinpointing when someone like me is looking for the place where the
kernel IDT/GDT get restored again.

In any case, those are all minor nitpicks, other than that LGTM.

Lemme go test it on whatever I can - if others wanna run this, it would
be very much appreciated!

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
