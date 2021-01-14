Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13B42F65FF
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 17:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbhANQcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 11:32:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbhANQcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 11:32:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FFFB23B44
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 16:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610641903;
        bh=wb1kG1KOAEcolwpdR+/yk6//aiweBGIjXCPqYQo31CI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=L1hQdNive443MYwW0uH9ce6vVzRF6OcQFXFGgQJZyN785v0EYJfgUqfJCLGT5FgcJ
         r2ccGbv8njQ6XjKSKynPJOsUkYSKjLIS1pns303WPc5AMfP3OV9Sg5Q1BHYJ84Chgz
         G9EhsI7y4R23G0Bk+DEkn4eVGRtA9lKuggAMduWRCvC51gH7Bay4GHJ63xRhk5M0I7
         sWGL5Hs1s0TuvEkJORPBmNr5IytdAgZFkiLQElg1ub3dOkev/pqAJNYbRPipuiDj+o
         zgvjGVRyzDesWaJ7E5GBbcVpO9yd0OHEdkhzCPYAawYL0RKgObq25ouEscQwYjIxhg
         BqeayE1Puo3qw==
Received: by mail-ed1-f53.google.com with SMTP id i24so6348106edj.8
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 08:31:43 -0800 (PST)
X-Gm-Message-State: AOAM532XIUVPNUc/mxhlllrjZ8EKKAdV4nkXRxkscOy4A+xq3d5Xbd3+
        0Rhi640It5bdV2y1k/gcF5vpDW2WRj0yDnJSi5m1WA==
X-Google-Smtp-Source: ABdhPJyx/R15Nrp9ik8k+VF0kZbQIYD07LEtRzB/beQh3xE1BViQZKJp/EwJywNd4A/+zd6SqmGh5VY8CCo+iPX+tOs=
X-Received: by 2002:aa7:ca55:: with SMTP id j21mr6223884edt.172.1610641901633;
 Thu, 14 Jan 2021 08:31:41 -0800 (PST)
MIME-Version: 1.0
References: <20201228160631.32732-1-krzysiek@podlesie.net> <20210112000923.GK25645@zn.tnic>
 <20210114092218.GA26786@shrek.podlesie.net> <20210114094425.GA12284@zn.tnic>
 <20210114123657.GA6358@shrek.podlesie.net> <20210114140737.GD12284@zn.tnic> <20210114145105.GA17363@shrek.podlesie.net>
In-Reply-To: <20210114145105.GA17363@shrek.podlesie.net>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 14 Jan 2021 08:31:30 -0800
X-Gmail-Original-Message-ID: <CALCETrU0Y_Cg--Vs-88Hu9vTR-QynC0AQOpYehE86MYow5u3RQ@mail.gmail.com>
Message-ID: <CALCETrU0Y_Cg--Vs-88Hu9vTR-QynC0AQOpYehE86MYow5u3RQ@mail.gmail.com>
Subject: Re: [PATCH] x86/lib: don't use MMX before FPU initialization
To:     Krzysztof Mazur <krzysiek@podlesie.net>,
        "Jason A. Donenfeld" <zx2c4@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 6:51 AM Krzysztof Mazur <krzysiek@podlesie.net> wrote:
>
> On Thu, Jan 14, 2021 at 03:07:37PM +0100, Borislav Petkov wrote:
> > On Thu, Jan 14, 2021 at 01:36:57PM +0100, Krzysztof Mazur wrote:
> > > The OSFXSR must be set only on CPUs with SSE. There
> > > are some CPUs with 3DNow!, but without SSE and FXSR (like AMD
> > > Geode LX, which is still used in many embedded systems).
> > > So, I've changed that to:
> > >
> > > if (unlikely(in_interrupt()) || (boot_cpu_has(X86_FEATURE_XMM) &&
> > >             unlikely(!(cr4_read_shadow() & X86_CR4_OSFXSR))))
> >
> > Why?
> >
> > X86_CR4_OSFXSR won't ever be set on those CPUs but the test will be
> > performed anyway. So there's no need for boot_cpu_has().
>
> Because the MMX version should be always used on those CPUs, even without
> OSFXSR set. If the CPU does not support SSE, it is safe to
> call kernel_fpu_begin() without OSFXSR set.
> "!(cr4_read_shadow() & X86_CR4_OSFXSR)" will be always true on
> those CPUs, and without boot_cpu_has() MMX version will be never used.
>
> There are two cases:
>
> 3DNow! without SSE              always use MMX version
> 3DNow! + SSE (K7)               use MMX version only if FXSR is enabled
>
> Thanks.
>
> Best regards,
> Krzysiek
> -- >8 --
> Subject: [PATCH] x86/lib: don't use mmx_memcpy() too early
>
> The MMX 3DNow! optimized memcpy() is used very early,
> even before FPU is initialized in the kernel. It worked fine, but commit
> 7ad816762f9bf89e940e618ea40c43138b479e10 ("x86/fpu: Reset MXCSR
> to default in kernel_fpu_begin()") broke that. After that
> commit the kernel_fpu_begin() assumes that FXSR is enabled in
> the CR4 register on all processors with SSE. Because memcpy() is used
> before FXSR is enabled, the kernel crashes just after "Booting the kernel."
> message. It affects all kernels with CONFIG_X86_USE_3DNOW (enabled when
> some AMD/Cyrix processors are selected) on processors with SSE
> (like AMD K7, which supports both MMX 3DNow! and SSE).
>
> Fixes: 7ad816762f9b ("x86/fpu: Reset MXCSR to default in kernel_fpu_begin()")
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: <stable@vger.kernel.org> # 5.8+
> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> ---
>  arch/x86/lib/mmx_32.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/lib/mmx_32.c b/arch/x86/lib/mmx_32.c
> index 4321fa02e18d..70aa769570e6 100644
> --- a/arch/x86/lib/mmx_32.c
> +++ b/arch/x86/lib/mmx_32.c
> @@ -25,13 +25,20 @@
>
>  #include <asm/fpu/api.h>
>  #include <asm/asm.h>
> +#include <asm/tlbflush.h>
>
>  void *_mmx_memcpy(void *to, const void *from, size_t len)
>  {
>         void *p;
>         int i;
>
> -       if (unlikely(in_interrupt()))
> +       /*
> +        * kernel_fpu_begin() assumes that FXSR is enabled on all processors
> +        * with SSE. Thus, MMX-optimized version can't be used
> +        * before the kernel enables FXSR (OSFXSR bit in the CR4 register).
> +        */
> +       if (unlikely(in_interrupt()) || (boot_cpu_has(X86_FEATURE_XMM) &&
> +                       unlikely(!(cr4_read_shadow() & X86_CR4_OSFXSR))))

This is gross.  I realize this is only used for old CPUs that we don't
care about perf-wise, but this code is nonsense -- it makes absolutely
to sense to put this absurd condition here to work around
kernel_fpu_begin() bugs.  If we want to use MMX, we should check MMX.
And we should also check the correct condition re: irqs.  So this code
should be:

if (boot_cpu_has(X86_FEATURE_XMM) && irq_fpu_usable()) {
  kernel_fpu_begin_mask(FPU_MASK_XMM);
  ...

or we could improve code gen by adding a try_kernel_fpu_begin_mask()
so we can do a single call instead of two.

This also mostly fixes our little performance regression -- we'd make
kernel_fpu_begin() be an inline wrapper around
kernel_fpu_begin_mask(FPU_MASK_DEFAULTFP), and *that* would be
FPU_MASK_XYZMM on 64-bit and FPU_MASK_387 on 32-bit.  (Okay, XYZMM
isn't a great name, but whatever.)  And the EFI code can become
completely explicit: kernel_fpu_begin(FPU_MASK_ALL).

What do you all think?  If you're generally in favor, I can write the
code and do a quick audit for other weird cases in the kernel.

Or we could flip the OSFSXR bit very early, I suppose.

--Andy
