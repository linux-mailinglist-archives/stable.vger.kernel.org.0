Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304B438A8B4
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239236AbhETKwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239020AbhETKur (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:50:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69EDE61CD6;
        Thu, 20 May 2021 09:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621504792;
        bh=8XaTgPGPzMKrVYB55TT07RWpor7EE721k5DsUaOSml0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ie2tMfGK1o1rBRZPngS1gPkvaHRuwU8AFvP3QMJTaXoVaAyU/50RYhn/lE+JEyyjn
         h1ytCatz8wmyed76m6nh8RoGWn1iMadS2DmKEJ1YCtuEK7xTl8IXp5cPuyHd6ZuJ4w
         /q/IYW0HmDEV52+1+QJiq6OcUshgX6W1YfUOVbQTCk2ZD7vr0RMuXvkUcBaDU4vdco
         e2pVyvrcI6ilp/F1lXNqbCsP9YQsI3IVxefLPge6P3sosgonkmNt4rerqcl0aqxXW5
         8RnohRlffqkKSnr3D9zLc/LLXApCGpYTQ/Qk9ahQf4Xiqe6Ee6RQ/f0FyZLurCNOtW
         0UJhM0g9KxItA==
Received: by mail-oi1-f178.google.com with SMTP id s19so15864342oic.7;
        Thu, 20 May 2021 02:59:52 -0700 (PDT)
X-Gm-Message-State: AOAM531iF1VeMbr8mvDPap9p5qugLWT/colddp3bwjqTYiz4V3vp4P86
        bccgv6Sj0nNV/6flU5pEuAscLok32pblwxR20hU=
X-Google-Smtp-Source: ABdhPJxFl7ZFAJvxWiszmikWzGkP+5QaUAR2Rrt8rhTxIOrBEaQH8G7l6XiBT1Y+lrgctnhdZU+kC/ywCYsIxk4dEpY=
X-Received: by 2002:aca:4343:: with SMTP id q64mr2653931oia.33.1621504791801;
 Thu, 20 May 2021 02:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210520092053.516042993@linuxfoundation.org> <20210520092053.731407333@linuxfoundation.org>
In-Reply-To: <20210520092053.731407333@linuxfoundation.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 20 May 2021 11:59:40 +0200
X-Gmail-Original-Message-ID: <CAMj1kXECeTz5T+0Pi77POE-uo65D_+gXFHZh=wi6EDVBDK2Rsg@mail.gmail.com>
Message-ID: <CAMj1kXECeTz5T+0Pi77POE-uo65D_+gXFHZh=wi6EDVBDK2Rsg@mail.gmail.com>
Subject: Re: [PATCH 5.12 06/45] ARM: 9058/1: cache-v7: refactor
 v7_invalidate_l1 to avoid clobbering r5/r6
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 May 2021 at 11:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> [ Upstream commit f9e7a99fb6b86aa6a00e53b34ee6973840e005aa ]
>
> The cache invalidation code in v7_invalidate_l1 can be tweaked to
> re-read the associativity from CCSIDR, and keep the way identifier
> component in a single register that is assigned in the outer loop. This
> way, we need 2 registers less.
>
> Given that the number of sets is typically much larger than the
> associativity, rearrange the code so that the outer loop has the fewer
> number of iterations, ensuring that the re-read of CCSIDR only occurs a
> handful of times in practice.
>
> Fix the whitespace while at it, and update the comment to indicate that
> this code is no longer a clone of anything else.
>
> Acked-by: Nicolas Pitre <nico@fluxnic.net>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please do NOT backport this to any stable trees.

It has no cc:stable tag
It has no fixes: tag
It was part of a 3 part series, but only the middle patch was selected.
It touches ARM assembly that may assemble without problems but be
completely broken at runtime when used out of the original intended
context.

Tip: disregard patches touching .S files entirely unless they have a
cc:stable or fixes: tag. Or teach the bot never to AUTOSEL anything
authored by me: if it needs to go to -stable, I will ask you myself.

--
Ard.



> ---
>  arch/arm/mm/cache-v7.S | 51 +++++++++++++++++++++---------------------
>  1 file changed, 25 insertions(+), 26 deletions(-)
>
> diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
> index dc8f152f3556..e3bc1d6e13d0 100644
> --- a/arch/arm/mm/cache-v7.S
> +++ b/arch/arm/mm/cache-v7.S
> @@ -33,41 +33,40 @@ icache_size:
>   * processor.  We fix this by performing an invalidate, rather than a
>   * clean + invalidate, before jumping into the kernel.
>   *
> - * This function is cloned from arch/arm/mach-tegra/headsmp.S, and needs
> - * to be called for both secondary cores startup and primary core resume
> - * procedures.
> + * This function needs to be called for both secondary cores startup and
> + * primary core resume procedures.
>   */
>  ENTRY(v7_invalidate_l1)
>         mov     r0, #0
>         mcr     p15, 2, r0, c0, c0, 0
>         mrc     p15, 1, r0, c0, c0, 0
>
> -       movw    r1, #0x7fff
> -       and     r2, r1, r0, lsr #13
> +       movw    r3, #0x3ff
> +       and     r3, r3, r0, lsr #3      @ 'Associativity' in CCSIDR[12:3]
> +       clz     r1, r3                  @ WayShift
> +       mov     r2, #1
> +       mov     r3, r3, lsl r1          @ NumWays-1 shifted into bits [31:...]
> +       movs    r1, r2, lsl r1          @ #1 shifted left by same amount
> +       moveq   r1, #1                  @ r1 needs value > 0 even if only 1 way
>
> -       movw    r1, #0x3ff
> +       and     r2, r0, #0x7
> +       add     r2, r2, #4              @ SetShift
>
> -       and     r3, r1, r0, lsr #3      @ NumWays - 1
> -       add     r2, r2, #1              @ NumSets
> +1:     movw    r4, #0x7fff
> +       and     r0, r4, r0, lsr #13     @ 'NumSets' in CCSIDR[27:13]
>
> -       and     r0, r0, #0x7
> -       add     r0, r0, #4      @ SetShift
> -
> -       clz     r1, r3          @ WayShift
> -       add     r4, r3, #1      @ NumWays
> -1:     sub     r2, r2, #1      @ NumSets--
> -       mov     r3, r4          @ Temp = NumWays
> -2:     subs    r3, r3, #1      @ Temp--
> -       mov     r5, r3, lsl r1
> -       mov     r6, r2, lsl r0
> -       orr     r5, r5, r6      @ Reg = (Temp<<WayShift)|(NumSets<<SetShift)
> -       mcr     p15, 0, r5, c7, c6, 2
> -       bgt     2b
> -       cmp     r2, #0
> -       bgt     1b
> -       dsb     st
> -       isb
> -       ret     lr
> +2:     mov     r4, r0, lsl r2          @ NumSet << SetShift
> +       orr     r4, r4, r3              @ Reg = (Temp<<WayShift)|(NumSets<<SetShift)
> +       mcr     p15, 0, r4, c7, c6, 2
> +       subs    r0, r0, #1              @ Set--
> +       bpl     2b
> +       subs    r3, r3, r1              @ Way--
> +       bcc     3f
> +       mrc     p15, 1, r0, c0, c0, 0   @ re-read cache geometry from CCSIDR
> +       b       1b
> +3:     dsb     st
> +       isb
> +       ret     lr
>  ENDPROC(v7_invalidate_l1)
>
>  /*
> --
> 2.30.2
>
>
>
