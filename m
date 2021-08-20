Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D133F27C2
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 09:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbhHTHmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 03:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233162AbhHTHmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 03:42:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24D57610A0;
        Fri, 20 Aug 2021 07:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629445284;
        bh=yDK/gS6z3i4jokxoXmZH4an8BkHs/VnNnpppenG9co4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rFcdetDfJMXCDhC6RJyTgit7JNoGVr15tpvYtar2wzeNjma41qW5b1HGx6+Xbh6jz
         OAKiLri6rHaqeOUUZ9INbVAlSg8a7ZR5ariCLqLVfoHwK5GB4BFSLr/A+c7MrRT9Qf
         TQzgYmk6Sjm94yRB43lFSQBKBy4ii3YmFE7hY1vg+3YKUCcet+Rp2LTZForC2l0/Ss
         bJ5KODQS2G4qzZFdoAarTZHUl64O2bhx7/ffh5QdB2/Fw+zhsbLRWeBME2iM6b7pIk
         SzKmUWCBe0+oRQqEkNJ0HTgbYx3L+eabtB/sNf0116Yw0C11NQO54rmYV5Bv/RDOt9
         c8TU3cprERWJA==
Received: by mail-oi1-f178.google.com with SMTP id r26so12138228oij.2;
        Fri, 20 Aug 2021 00:41:24 -0700 (PDT)
X-Gm-Message-State: AOAM530Ii0JXOw8hvr+JM6LJA515cO+pMopXUX/KGCwkCX2CkUeQZtPx
        6+gKzTPMTUabXwAKR0gEqiuhH5KUoo12cdtYWrY=
X-Google-Smtp-Source: ABdhPJxh6GottlM2I2mt5hSD2zw5zPhPLO0A4grv+8ugA8cO8XOfTmPuRoVjTQQ5WvcwGWqts1xtRfekiutRTN/m/aI=
X-Received: by 2002:a05:6808:2219:: with SMTP id bd25mr2028724oib.33.1629445283401;
 Fri, 20 Aug 2021 00:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210820073429.19457-1-joro@8bytes.org>
In-Reply-To: <20210820073429.19457-1-joro@8bytes.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 20 Aug 2021 09:41:12 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGTxt8Ln58F9dNb-Jkzhvj-RRXrPZmoeNZ4dguhvrx=iQ@mail.gmail.com>
Message-ID: <CAMj1kXGTxt8Ln58F9dNb-Jkzhvj-RRXrPZmoeNZ4dguhvrx=iQ@mail.gmail.com>
Subject: Re: [PATCH] x86/efi: Restore Firmware IDT in before ExitBootServices()
To:     Joerg Roedel <joro@8bytes.org>
Cc:     X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Aug 2021 at 09:34, Joerg Roedel <joro@8bytes.org> wrote:
>
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

Acked by: Ard Biesheuvel <ardb@kernel.org>

One nit below

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
>         /*
>          * Convert x86-64 ABI params to i386 ABI
>          */
> -       subq    $32, %rsp
> +       subq    $64, %rsp

Any reason in particular for the increase by 32?

>         movl    %esi, 0x0(%rsp)
>         movl    %edx, 0x4(%rsp)
>         movl    %ecx, 0x8(%rsp)
> @@ -49,14 +49,19 @@ SYM_FUNC_START(__efi64_thunk)
>         leaq    0x14(%rsp), %rbx
>         sgdt    (%rbx)
>
> +       addq    $16, %rbx
> +       sidt    (%rbx)
> +
>         /*
> -        * Switch to gdt with 32-bit segments. This is the firmware GDT
> -        * that was installed when the kernel started executing. This
> -        * pointer was saved at the EFI stub entry point in head_64.S.
> +        * Switch to idt and gdt with 32-bit segments. This is the firmware GDT
> +        * and IDT that was installed when the kernel started executing. The
> +        * pointers were saved at the EFI stub entry point in head_64.S.
>          *
>          * Pass the saved DS selector to the 32-bit code, and use far return to
>          * restore the saved CS selector.
>          */
> +       leaq    efi32_boot_idt(%rip), %rax
> +       lidt    (%rax)
>         leaq    efi32_boot_gdt(%rip), %rax
>         lgdt    (%rax)
>
> @@ -67,7 +72,7 @@ SYM_FUNC_START(__efi64_thunk)
>         pushq   %rax
>         lretq
>
> -1:     addq    $32, %rsp
> +1:     addq    $64, %rsp
>         movq    %rdi, %rax
>
>         pop     %rbx
> @@ -132,6 +137,9 @@ SYM_FUNC_START_LOCAL(efi_enter32)
>          */
>         cli
>
> +       lidtl   (%ebx)
> +       subl    $16, %ebx
> +
>         lgdtl   (%ebx)
>
>         movl    %cr4, %eax
> @@ -166,6 +174,11 @@ SYM_DATA_START(efi32_boot_gdt)
>         .quad   0
>  SYM_DATA_END(efi32_boot_gdt)
>
> +SYM_DATA_START(efi32_boot_idt)
> +       .word   0
> +       .quad   0
> +SYM_DATA_END(efi32_boot_idt)
> +
>  SYM_DATA_START(efi32_boot_cs)
>         .word   0
>  SYM_DATA_END(efi32_boot_cs)
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index a2347ded77ea..572c535cf45b 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -319,6 +319,9 @@ SYM_INNER_LABEL(efi32_pe_stub_entry, SYM_L_LOCAL)
>         movw    %cs, rva(efi32_boot_cs)(%ebp)
>         movw    %ds, rva(efi32_boot_ds)(%ebp)
>
> +       /* Store firmware IDT descriptor */
> +       sidtl   rva(efi32_boot_idt)(%ebp)
> +
>         /* Disable paging */
>         movl    %cr0, %eax
>         btrl    $X86_CR0_PG_BIT, %eax
> --
> 2.32.0
>
