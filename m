Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D78837BCAC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhELMj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232883AbhELMj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 08:39:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80D82613EB;
        Wed, 12 May 2021 12:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620823130;
        bh=U/gxAeewTiKq3NLv6xkw5kHBZSrDQoOv3EdDAkj+rHw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EhluFSXeRQ9uIMcVhFd03T1Gv/kx0fOmos1rq5xUICKJSfddq5BlQZuDBD2XaVADW
         B6EBJUAI4bnStohdmahmDr+qevSGcmPUExMUZym/lPDzkvnGos0njgBc5hPhTQzbnf
         9du2ZbvQBe6D7KcwSlF6RkRgt6HbRPVVlN8y3zEmAOk9KuRDPskJGwypsJ3oq+mXdK
         7NNNf3wLX5P9hsMHOM3V99u5tW0zCTYn6a8l13BMROphXEn3NM+GPPWraSm/m73W3+
         t2hgMXctRcqQKkvFERIXbPRoBr5LWE5iFs3/HuNlWLWWkZtzxFmt6Wlp5VJZlp1gr9
         qSekJU2sRGkig==
Received: by mail-oi1-f170.google.com with SMTP id j75so22075849oih.10;
        Wed, 12 May 2021 05:38:50 -0700 (PDT)
X-Gm-Message-State: AOAM533p8qT1Gqf2+ZkmACleAjkV+e0hrRQsqnyAWGDTfR02k1g1GYmm
        Ca8FBC62CJcW7tORi3xTELYeGjP9ePy8s/Fu3A0=
X-Google-Smtp-Source: ABdhPJzMV2io1GAvNMIjRvU1yZ0F6O3kx8YhbvxetB/KLUzVK8tlpnTWQDqAPax9fmIxDPCRNFAcnZvAblqchRqWMKk=
X-Received: by 2002:aca:e142:: with SMTP id y63mr26156865oig.33.1620823127705;
 Wed, 12 May 2021 05:38:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210512081211.200025-1-arnd@kernel.org>
In-Reply-To: <20210512081211.200025-1-arnd@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 12 May 2021 14:38:36 +0200
X-Gmail-Original-Message-ID: <CAMj1kXECGjpxx5ouWuvnKUigzMGu=GcE8_ab2rrxt98yU1jUnw@mail.gmail.com>
Message-ID: <CAMj1kXECGjpxx5ouWuvnKUigzMGu=GcE8_ab2rrxt98yU1jUnw@mail.gmail.com>
Subject: Re: [PATCH] ARM: fix gcc-10 thumb2-kernel regression
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mike Rapoport <rppt@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 May 2021 at 10:13, Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> When building the kernel wtih gcc-10 or higher using the
> CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y flag, the compiler picks a slightly
> different set of registers for the inline assembly in cpu_init() that
> subsequently results in a corrupt kernel stack as well as remaining in
> FIQ mode. If a banked register is used for the last argument, the wrong
> version of that register gets loaded into CPSR_c.  When building in Arm
> mode, the arguments are passed as immediate values and the bug cannot
> happen.
>
> This got introduced when Daniel reworked the FIQ handling and was
> technically always broken, but happened to work with both clang and gcc
> before gcc-10 as long as they picked one of the lower registers.
> This is probably an indication that still very few people build the
> kernel in Thumb2 mode.
>
> Marek pointed out the problem on IRC, Arnd narrowed it down to this
> inline assembly and Russell pinpointed the exact bug.
>
> Change the constraints to force the final mode switch to use a non-banked
> register for the argument to ensure that the correct constant gets loaded.
> Another alternative would be to always use registers for the constant
> arguments to avoid the #ifdef that has now become more complex.
>
> Cc: <stable@vger.kernel.org> # v3.18+
> Cc: Daniel Thompson <daniel.thompson@linaro.org>
> Reported-by: Marek Vasut <marek.vasut@gmail.com>
> Fixes: c0e7f7ee717e ("ARM: 8150/3: fiq: Replace default FIQ handler")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Nice bug!

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm/kernel/setup.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 1a5edf562e85..73ca7797b92f 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -545,9 +545,11 @@ void notrace cpu_init(void)
>          * In Thumb-2, msr with an immediate value is not allowed.
>          */
>  #ifdef CONFIG_THUMB2_KERNEL
> -#define PLC    "r"
> +#define PLC_l  "l"
> +#define PLC_r  "r"
>  #else
> -#define PLC    "I"
> +#define PLC_l  "I"
> +#define PLC_r  "I"
>  #endif
>
>         /*
> @@ -569,15 +571,15 @@ void notrace cpu_init(void)
>         "msr    cpsr_c, %9"
>             :
>             : "r" (stk),
> -             PLC (PSR_F_BIT | PSR_I_BIT | IRQ_MODE),
> +             PLC_r (PSR_F_BIT | PSR_I_BIT | IRQ_MODE),
>               "I" (offsetof(struct stack, irq[0])),
> -             PLC (PSR_F_BIT | PSR_I_BIT | ABT_MODE),
> +             PLC_r (PSR_F_BIT | PSR_I_BIT | ABT_MODE),
>               "I" (offsetof(struct stack, abt[0])),
> -             PLC (PSR_F_BIT | PSR_I_BIT | UND_MODE),
> +             PLC_r (PSR_F_BIT | PSR_I_BIT | UND_MODE),
>               "I" (offsetof(struct stack, und[0])),
> -             PLC (PSR_F_BIT | PSR_I_BIT | FIQ_MODE),
> +             PLC_r (PSR_F_BIT | PSR_I_BIT | FIQ_MODE),
>               "I" (offsetof(struct stack, fiq[0])),
> -             PLC (PSR_F_BIT | PSR_I_BIT | SVC_MODE)
> +             PLC_l (PSR_F_BIT | PSR_I_BIT | SVC_MODE)
>             : "r14");
>  #endif
>  }
> --
> 2.29.2
>
