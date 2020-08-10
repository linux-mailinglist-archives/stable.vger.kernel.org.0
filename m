Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39C9241342
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 00:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgHJWdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 18:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgHJWde (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 18:33:34 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F301C061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 15:33:34 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 17so6517275pfw.9
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 15:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i7ZfdynehOdybqijT/Iim3hOWf1+yvwIpK/H7v550UQ=;
        b=mhtQBufTPANHwJt2YnyJ/vLi8+sR6/jg0gf8krTkW7x+L/KIh2eF3Y25ypKQKj9eWQ
         tgbLDbBM6IE0m6FyEMSx9Lf8gKi71rjxKVxlh3QgXE0PD70t5TUELjSWWcr5FzHWft0p
         fWjKTYUFd1tCnYomCDpU5Yqyob35Egp5DlfkjDxCOKcqU60ZTJ0HqbJ5sfR2yQtWnyHy
         jKM+WiclhG925nM7/r3iiPEa8WPWjOP4ajTCyse9YDiMGVgHVi3YwcBU4yyPWBXUtBV6
         aC2kcORjgG0XDv3MmSZfNNvxhdZO+QvJ9aeXFO4p1uX7Dl+iIDUCvT1cLvyyyZdT/8IK
         KfcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i7ZfdynehOdybqijT/Iim3hOWf1+yvwIpK/H7v550UQ=;
        b=jtiuaOjGcBT6ylnYoAkOQAE9AnMdjkLJv9Au8llzf5fdtU12wGOW63jLZd74h6Duw7
         Xxc8EqLUmc47xXG2q53f9SSFbabEm7LeReTZRs1b764MS+pIb8wesZwK+fqNEWi592X+
         /Am0CVoHDUGeWGK+AOOQf7aH319GShOIHLsK9nr4pvMWX+PkMOWGQ9Qb+bcH4w1g4sFy
         qvtqFtV89lraskeQXOIMI51ZSISuYM+kPUPxj1MgDTFYm5ACV5Yn5tG3TT48HIBnPeoO
         l0brw91zaeOaKUCWbETjbLxvvFMJ9mELW6Ahr2FsRcxxvhNzcAWAwpXZp6sW6zFIt/ec
         oBPQ==
X-Gm-Message-State: AOAM5324kzhb25k7zGDcVCl3gnEIR8by91RccCL6J24Hbj2X9NLchjlB
        ByMdznS/JSqgU+wf1sd6pZf3h+fc8Xw3QJBeX1gY7A==
X-Google-Smtp-Source: ABdhPJzXTvIZAHfH9jpUrtK3vUE/qI8VWhuaoQktb5lbMLN9zEI8agpeALqtVf0qPpZVQ0WKCLyimURi+ymlHxcwJLA=
X-Received: by 2002:a63:4e56:: with SMTP id o22mr8537935pgl.381.1597098813343;
 Mon, 10 Aug 2020 15:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200730205112.2099429-1-ndesaulniers@google.com>
 <20200730205112.2099429-3-ndesaulniers@google.com> <CAN=-Rxty=Ux5rj-VQSZH-ryj1RiNJvy7mRE7uyx_YAndGtcq7Q@mail.gmail.com>
In-Reply-To: <CAN=-Rxty=Ux5rj-VQSZH-ryj1RiNJvy7mRE7uyx_YAndGtcq7Q@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 10 Aug 2020 15:33:22 -0700
Message-ID: <CAKwvOdkNLK2cRfY+DA0u3KuY5PuEss5Qox6X3zzpL053pARfrA@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: backtrace-clang: add fixup for lr dereference
To:     Nathan Huckleberry <nhuck15@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Lvqiang Huang <lvqiang.huang@unisoc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Miles Chen <miles.chen@mediatek.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 6, 2020 at 3:39 PM Nathan Huckleberry <nhuck15@gmail.com> wrote:
>
> Mostly looks good to me. Just a minor nit.
>
> On Thu, Jul 30, 2020 at 3:51 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > If the value of the link register is not correct (tail call from asm
> > that didn't set it, stack corruption, memory no longer mapped), then
> > using it for an address calculation may trigger an exception.  Without a
> > fixup handler, this will lead to a panic, which will unwind, which will
> > trigger the fault repeatedly in an infinite loop.
> >
> > We don't observe such failures currently, but we have. Just to be safe,
> > add a fixup handler here so that at least we don't have an infinite
> > loop.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: commit 6dc5fd93b2f1 ("ARM: 8900/1: UNWINDER_FRAME_POINTER implementation for Clang")
> > Reported-by: Miles Chen <miles.chen@mediatek.com>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > ---
> >  arch/arm/lib/backtrace-clang.S | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/lib/backtrace-clang.S b/arch/arm/lib/backtrace-clang.S
> > index 5388ac664c12..40eb2215eaf4 100644
> > --- a/arch/arm/lib/backtrace-clang.S
> > +++ b/arch/arm/lib/backtrace-clang.S
> > @@ -146,7 +146,7 @@ for_each_frame:     tst     frame, mask             @ Check for address exceptions
> >
> >                 tst     sv_lr, #0               @ If there's no previous lr,
> >                 beq     finished_setup          @ we're done.
> > -               ldr     r0, [sv_lr, #-4]        @ get call instruction
> > +prev_call:     ldr     r0, [sv_lr, #-4]        @ get call instruction
> >                 ldr     r3, .Lopcode+4
> >                 and     r2, r3, r0              @ is this a bl call
> >                 teq     r2, r3
> > @@ -206,6 +206,13 @@ finished_setup:
> >                 mov     r2, frame
> >                 bl      printk
> >  no_frame:      ldmfd   sp!, {r4 - r9, fp, pc}
> > +/*
> > + * Accessing the address pointed to by the link register triggered an
> > + * exception, don't try to unwind through it.
> > + */
> > +bad_lr:                mov     sv_fp, #0
>
> It might be nice to emit a warning here since we'll
> only hit this case if something fishy is going on
> with the saved lr.

Yeah, something fishy is going on if that ever happens.  Let me create
a V2 with an additional print.

>
> > +               mov     sv_lr, #0
> > +               b       finished_setup
> >  ENDPROC(c_backtrace)
> >                 .pushsection __ex_table,"a"
> >                 .align  3
> > @@ -214,6 +221,7 @@ ENDPROC(c_backtrace)
> >                 .long   1003b, 1006b
> >                 .long   1004b, 1006b
> >                 .long   1005b, 1006b
> > +               .long   prev_call, bad_lr
> >                 .popsection
> >
> >  .Lbad:         .asciz  "%sBacktrace aborted due to bad frame pointer <%p>\n"
> > --
> > 2.28.0.163.g6104cc2f0b6-goog
> >
>
> Thanks,
> Huck



-- 
Thanks,
~Nick Desaulniers
