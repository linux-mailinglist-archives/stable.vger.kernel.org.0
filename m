Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F96133CDEA
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 07:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhCPGU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 02:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCPGU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 02:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EABFC65160
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 06:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615875626;
        bh=X1CQqU5gDmL78HARSPWbt87J401h29s0Cud1t9RuCFk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Hc3dZ27W6RywxTrn0Tb4k1L8jIHq04XDaYfNT0S4MMyketcG78AElWIxYAFh0k1qA
         Yb8W90MREDODgT0EKxMil8IpMKXk8h87QHRCkwHO5MO25xbbwXLu197li/Tes9rRws
         awxIVMcOJNLZXcXT2HslZpbnJ/iNecA5/SGFWTRnJn8pxs3bDWxTK7pXaY95kKuGj3
         L5cj6Kl7JgGtU4r8TZSXXM9legXX4ZV7skyvEMW9TqGjivCze94Bvt9DUIi/zzIv9+
         relTapbX9/GqsYxJIBUQAFmO0Ro/kwLX7z/PtDZE4axRNK7xeHZJkq9YUIJ2ultsrX
         UOlU1bqeonDWQ==
Received: by mail-oo1-f53.google.com with SMTP id w1-20020a4adec10000b02901bc77feac3eso728441oou.3
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 23:20:25 -0700 (PDT)
X-Gm-Message-State: AOAM532qouoYbCw8TlJ1PRPN+md6dXIJXlTReKEfxMJvgoUu8j6pk/je
        7QZzeCQvonfx3UiWOT5cgNZH7Czw1UPfz8O72Ts=
X-Google-Smtp-Source: ABdhPJz1GhynHT8GiNtX9PajrVuyk00G5vIrIfuu+WBsB99tv0Sg3bcyBsPaDBcgmVToz8B3c7EWNf72DCc1T1wzyqM=
X-Received: by 2002:a4a:395d:: with SMTP id x29mr2346878oog.41.1615875625011;
 Mon, 15 Mar 2021 23:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdm6FXWVu-9YkQNNyoYmw+hkj1a7MQrRbWyUxsO2vDcnQA@mail.gmail.com>
 <20210315231952.1482097-1-ndesaulniers@google.com>
In-Reply-To: <20210315231952.1482097-1-ndesaulniers@google.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 16 Mar 2021 07:20:13 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGT8Zgz3Pn+DDJnY6HRz3ugbkFozJycGBW+Cm6RvyYBHA@mail.gmail.com>
Message-ID: <CAMj1kXGT8Zgz3Pn+DDJnY6HRz3ugbkFozJycGBW+Cm6RvyYBHA@mail.gmail.com>
Subject: Re: [PATCH 5.4.y] ARM: 9030/1: entry: omit FP emulation for UND
 exceptions taken in kernel mode
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        candle.sun@unisoc.com, Catalin Marinas <catalin.marinas@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Luis Lozano <llozano@google.com>,
        Marc Zyngier <maz@kernel.org>,
        =?UTF-8?B?TWlsZXMgQ2hlbiAo6Zmz5rCR5qi6KQ==?= 
        <miles.chen@mediatek.com>, Sami Tolvanen <samitolvanen@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Stephen Hines <srhines@google.com>,
        Sandeep Patil <sspatil@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>, Stefan Agner <stefan@agner.ch>,
        Dmitry Osipenko <digetx@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Mar 2021 at 00:19, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> commit f77ac2e378be9dd61eb88728f0840642f045d9d1 upstream.
>
> There are a couple of problems with the exception entry code that deals
> with FP exceptions (which are reported as UND exceptions) when building
> the kernel in Thumb2 mode:
> - the conditional branch to vfp_kmode_exception in vfp_support_entry()
>   may be out of range for its target, depending on how the linker decides
>   to arrange the sections;
> - when the UND exception is taken in kernel mode, the emulation handling
>   logic is entered via the 'call_fpe' label, which means we end up using
>   the wrong value/mask pairs to match and detect the NEON opcodes.
>
> Since UND exceptions in kernel mode are unlikely to occur on a hot path
> (as opposed to the user mode version which is invoked for VFP support
> code and lazy restore), we can use the existing undef hook machinery for
> any kernel mode instruction emulation that is needed, including calling
> the existing vfp_kmode_exception() routine for unexpected cases. So drop
> the call to call_fpe, and instead, install an undef hook that will get
> called for NEON and VFP instructions that trigger an UND exception in
> kernel mode.
>
> While at it, make sure that the PC correction is accurate for the
> execution mode where the exception was taken, by checking the PSR
> Thumb bit.
>
> Cc: Dmitry Osipenko <digetx@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>
> Fixes: eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input sections")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> [nd: fix conflict in arch/arm/vfp/vfphw.S due to missing
>      commit 2cbd1cc3dcd3 ("ARM: 8991/1: use VFP assembler mnemonics if
>      available")]
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
> This should have been sent along with
> https://lore.kernel.org/stable/20210113185758.GA571703@ubuntu-m3-large-x86/
> it's my fault I missed it.
>

This breaks the boot on non-VFP capable hardware unless commit
3cce9d44321e460e7c88

ARM: 9044/1: vfp: use undef hook for VFP support detection

is applied as well, so please treat these as a pair for the purpose of
backporting.


>  arch/arm/kernel/entry-armv.S | 25 ++----------------
>  arch/arm/vfp/vfphw.S         |  5 ----
>  arch/arm/vfp/vfpmodule.c     | 49 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 49 insertions(+), 30 deletions(-)
>
> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> index a874b753397e..b62d74a2c73a 100644
> --- a/arch/arm/kernel/entry-armv.S
> +++ b/arch/arm/kernel/entry-armv.S
> @@ -252,31 +252,10 @@ __und_svc:
>  #else
>         svc_entry
>  #endif
> -       @
> -       @ call emulation code, which returns using r9 if it has emulated
> -       @ the instruction, or the more conventional lr if we are to treat
> -       @ this as a real undefined instruction
> -       @
> -       @  r0 - instruction
> -       @
> -#ifndef CONFIG_THUMB2_KERNEL
> -       ldr     r0, [r4, #-4]
> -#else
> -       mov     r1, #2
> -       ldrh    r0, [r4, #-2]                   @ Thumb instruction at LR - 2
> -       cmp     r0, #0xe800                     @ 32-bit instruction if xx >= 0
> -       blo     __und_svc_fault
> -       ldrh    r9, [r4]                        @ bottom 16 bits
> -       add     r4, r4, #2
> -       str     r4, [sp, #S_PC]
> -       orr     r0, r9, r0, lsl #16
> -#endif
> -       badr    r9, __und_svc_finish
> -       mov     r2, r4
> -       bl      call_fpe
>
>         mov     r1, #4                          @ PC correction to apply
> -__und_svc_fault:
> + THUMB(        tst     r5, #PSR_T_BIT          )       @ exception taken in Thumb mode?
> + THUMB(        movne   r1, #2                  )       @ if so, fix up PC correction
>         mov     r0, sp                          @ struct pt_regs *regs
>         bl      __und_fault
>
> diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
> index b2e560290860..b530db8f2c6c 100644
> --- a/arch/arm/vfp/vfphw.S
> +++ b/arch/arm/vfp/vfphw.S
> @@ -78,11 +78,6 @@
>  ENTRY(vfp_support_entry)
>         DBGSTR3 "instr %08x pc %08x state %p", r0, r2, r10
>
> -       ldr     r3, [sp, #S_PSR]        @ Neither lazy restore nor FP exceptions
> -       and     r3, r3, #MODE_MASK      @ are supported in kernel mode
> -       teq     r3, #USR_MODE
> -       bne     vfp_kmode_exception     @ Returns through lr
> -
>         VFPFMRX r1, FPEXC               @ Is the VFP enabled?
>         DBGSTR1 "fpexc %08x", r1
>         tst     r1, #FPEXC_EN
> diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
> index 8c9e7f9f0277..c3b6451c18bd 100644
> --- a/arch/arm/vfp/vfpmodule.c
> +++ b/arch/arm/vfp/vfpmodule.c
> @@ -23,6 +23,7 @@
>  #include <asm/cputype.h>
>  #include <asm/system_info.h>
>  #include <asm/thread_notify.h>
> +#include <asm/traps.h>
>  #include <asm/vfp.h>
>
>  #include "vfpinstr.h"
> @@ -642,7 +643,9 @@ static int vfp_starting_cpu(unsigned int unused)
>         return 0;
>  }
>
> -void vfp_kmode_exception(void)
> +#ifdef CONFIG_KERNEL_MODE_NEON
> +
> +static int vfp_kmode_exception(struct pt_regs *regs, unsigned int instr)
>  {
>         /*
>          * If we reach this point, a floating point exception has been raised
> @@ -660,9 +663,51 @@ void vfp_kmode_exception(void)
>                 pr_crit("BUG: unsupported FP instruction in kernel mode\n");
>         else
>                 pr_crit("BUG: FP instruction issued in kernel mode with FP unit disabled\n");
> +       pr_crit("FPEXC == 0x%08x\n", fmrx(FPEXC));
> +       return 1;
>  }
>
> -#ifdef CONFIG_KERNEL_MODE_NEON
> +static struct undef_hook vfp_kmode_exception_hook[] = {{
> +       .instr_mask     = 0xfe000000,
> +       .instr_val      = 0xf2000000,
> +       .cpsr_mask      = MODE_MASK | PSR_T_BIT,
> +       .cpsr_val       = SVC_MODE,
> +       .fn             = vfp_kmode_exception,
> +}, {
> +       .instr_mask     = 0xff100000,
> +       .instr_val      = 0xf4000000,
> +       .cpsr_mask      = MODE_MASK | PSR_T_BIT,
> +       .cpsr_val       = SVC_MODE,
> +       .fn             = vfp_kmode_exception,
> +}, {
> +       .instr_mask     = 0xef000000,
> +       .instr_val      = 0xef000000,
> +       .cpsr_mask      = MODE_MASK | PSR_T_BIT,
> +       .cpsr_val       = SVC_MODE | PSR_T_BIT,
> +       .fn             = vfp_kmode_exception,
> +}, {
> +       .instr_mask     = 0xff100000,
> +       .instr_val      = 0xf9000000,
> +       .cpsr_mask      = MODE_MASK | PSR_T_BIT,
> +       .cpsr_val       = SVC_MODE | PSR_T_BIT,
> +       .fn             = vfp_kmode_exception,
> +}, {
> +       .instr_mask     = 0x0c000e00,
> +       .instr_val      = 0x0c000a00,
> +       .cpsr_mask      = MODE_MASK,
> +       .cpsr_val       = SVC_MODE,
> +       .fn             = vfp_kmode_exception,
> +}};
> +
> +static int __init vfp_kmode_exception_hook_init(void)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(vfp_kmode_exception_hook); i++)
> +               register_undef_hook(&vfp_kmode_exception_hook[i]);
> +       return 0;
> +}
> +core_initcall(vfp_kmode_exception_hook_init);
>
>  /*
>   * Kernel-side NEON support functions
> --
> 2.31.0.rc2.261.g7f71774620-goog
>
