Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7729623E418
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 00:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHFWjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 18:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHFWjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 18:39:01 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9F4C061574;
        Thu,  6 Aug 2020 15:39:01 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id l204so190990oib.3;
        Thu, 06 Aug 2020 15:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ne1iYZprPZsaiWqWZFllfuyUnxnmRkcPCgewhYs7+po=;
        b=oWwFoqGba2t65iV+0hVJvoo34WVzexMPem5bmNrBL2po0vMgi7NmTYQnYyI/pK9BPL
         JEeCUzLouqqweosS1VJ3yAv/DIUZ58V2TeGJV+2vBVGcGw5DgK0PIliW/SRbGaYI69RM
         aw/fTT5Kwv9QtuMRO1O32xkqGq6citRBosNGQc1Fkf8vgCgxzsXc+iuZfcjFVa+9W9mJ
         P95qUCukRV+2zlroNs8CYWd8S7AuoLWQns9qNS/q4DiPOzzAg9r3uSEah1PBfRMaEVw8
         xHHv0C9s3+5LRHBRnuAQDkWMUPjzLeV5xx9lgb8J1li9YC6gpmudNnGNnS7ByakiCOH6
         MafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ne1iYZprPZsaiWqWZFllfuyUnxnmRkcPCgewhYs7+po=;
        b=qUm2jD7p7OgbeKqYkM8m+uiyc0ASrxRykyyPX4qUfoLaq6ydsHcI8rOpFQxu1xqQgV
         cB8+AUIXWC2gVLHFVuyydBCnPhjxrVKWcjVoomC2jjSHttrxGeWgHHMesjwLNfirMYg+
         2UvlBB7KOiWfAD7bV8HXY8KehYMgKkr+COl47Usqt+rXqzNNmgyASdGbOvAMAwrQPKhD
         htmrpplY4UuJRtWAh1uBvriJVCVGR2lTGLHKOpKN3HK2qWytfmOm5RewCkUZ1LnfVvhM
         Y/ncV+wZIwUqIUPxT8Yl2MuEbtc2OPwUYTNbIie3qno0RKnI2jEhVuNFJIe+Ca64iCge
         vpvg==
X-Gm-Message-State: AOAM533MjdhcnFheyJMQlCuSrFli8N7pevcbgHBgrNzhzloVTQvpN7/V
        lRz2eXgPt6K2Q3cXTPbYVk2tzJ22z/BkGhUxIn0=
X-Google-Smtp-Source: ABdhPJw24FLE0cOWVKOoxoFIzofMAQlqhvnejmnRS9N4YG08WW27U7QHzTUC4wI/BCAaa2dgO3tta2o3+MD5w0Lq8pI=
X-Received: by 2002:aca:2306:: with SMTP id e6mr9080081oie.108.1596753539610;
 Thu, 06 Aug 2020 15:38:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200730205112.2099429-1-ndesaulniers@google.com> <20200730205112.2099429-3-ndesaulniers@google.com>
In-Reply-To: <20200730205112.2099429-3-ndesaulniers@google.com>
From:   Nathan Huckleberry <nhuck15@gmail.com>
Date:   Thu, 6 Aug 2020 17:38:46 -0500
Message-ID: <CAN=-Rxty=Ux5rj-VQSZH-ryj1RiNJvy7mRE7uyx_YAndGtcq7Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: backtrace-clang: add fixup for lr dereference
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        clang-built-linux@googlegroups.com,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Lvqiang Huang <lvqiang.huang@unisoc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Miles Chen <miles.chen@mediatek.com>, stable@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mostly looks good to me. Just a minor nit.

On Thu, Jul 30, 2020 at 3:51 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> If the value of the link register is not correct (tail call from asm
> that didn't set it, stack corruption, memory no longer mapped), then
> using it for an address calculation may trigger an exception.  Without a
> fixup handler, this will lead to a panic, which will unwind, which will
> trigger the fault repeatedly in an infinite loop.
>
> We don't observe such failures currently, but we have. Just to be safe,
> add a fixup handler here so that at least we don't have an infinite
> loop.
>
> Cc: stable@vger.kernel.org
> Fixes: commit 6dc5fd93b2f1 ("ARM: 8900/1: UNWINDER_FRAME_POINTER implementation for Clang")
> Reported-by: Miles Chen <miles.chen@mediatek.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  arch/arm/lib/backtrace-clang.S | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/lib/backtrace-clang.S b/arch/arm/lib/backtrace-clang.S
> index 5388ac664c12..40eb2215eaf4 100644
> --- a/arch/arm/lib/backtrace-clang.S
> +++ b/arch/arm/lib/backtrace-clang.S
> @@ -146,7 +146,7 @@ for_each_frame:     tst     frame, mask             @ Check for address exceptions
>
>                 tst     sv_lr, #0               @ If there's no previous lr,
>                 beq     finished_setup          @ we're done.
> -               ldr     r0, [sv_lr, #-4]        @ get call instruction
> +prev_call:     ldr     r0, [sv_lr, #-4]        @ get call instruction
>                 ldr     r3, .Lopcode+4
>                 and     r2, r3, r0              @ is this a bl call
>                 teq     r2, r3
> @@ -206,6 +206,13 @@ finished_setup:
>                 mov     r2, frame
>                 bl      printk
>  no_frame:      ldmfd   sp!, {r4 - r9, fp, pc}
> +/*
> + * Accessing the address pointed to by the link register triggered an
> + * exception, don't try to unwind through it.
> + */
> +bad_lr:                mov     sv_fp, #0

It might be nice to emit a warning here since we'll
only hit this case if something fishy is going on
with the saved lr.

> +               mov     sv_lr, #0
> +               b       finished_setup
>  ENDPROC(c_backtrace)
>                 .pushsection __ex_table,"a"
>                 .align  3
> @@ -214,6 +221,7 @@ ENDPROC(c_backtrace)
>                 .long   1003b, 1006b
>                 .long   1004b, 1006b
>                 .long   1005b, 1006b
> +               .long   prev_call, bad_lr
>                 .popsection
>
>  .Lbad:         .asciz  "%sBacktrace aborted due to bad frame pointer <%p>\n"
> --
> 2.28.0.163.g6104cc2f0b6-goog
>

Thanks,
Huck
