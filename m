Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E80E265C44
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 11:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgIKJOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 05:14:55 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:33440 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgIKJOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 05:14:55 -0400
Received: by mail-il1-f194.google.com with SMTP id x2so8412946ilm.0;
        Fri, 11 Sep 2020 02:14:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HvBxnxzM9sAOs8HQaj//uyKurEz5VcDAXLMIPy4+cWs=;
        b=fvsZ348Ci1uESLfg/R7Yps3TZajpQwaS+5oZPKf1yGqDDKgO1r9sfXrodKAQ6vp6Vm
         K3iUeCi+420hCWfXpPQ8OSLuw00jG1RwJF0rIdGGLRWHagBchJ6hNWISijQZKstDwEiV
         xxqnM4F9+jerxQzJhTYUkLJD1Cb3aPGumD9yk/8TSBIdo1vQSqfByeXJ5kvfO8ihafJU
         W9GuEmvr5WHAJ6TxQyPof9g+1inV2CyxTbYeox18iFQ2JZ1wNoqV8Ao3M/zwuPsk1d1M
         rFqL6s5IIt6jhBV9VtpZ0h7r+lz9769gZFeWWT6n+1h9XA2TXLeVWx6sl1XuoGGSpygl
         ESAg==
X-Gm-Message-State: AOAM5312aNvTADhLKeihyoCsniEWI/byeaN1we75aXp3jOEsj7adW+o7
        xMkJy6UjQsBElvMFwWhSJ5Z5zaphDMbf1bPyKKQ=
X-Google-Smtp-Source: ABdhPJy18olH7sad1qD70IoFw2yF33yVUU5d5exwA6IUoAUxvQHj3bR0yXN4mCVDB0OdTUKoaNkvXa7mlBpg0ETuo0g=
X-Received: by 2002:a92:c002:: with SMTP id q2mr1030576ild.171.1599815692179;
 Fri, 11 Sep 2020 02:14:52 -0700 (PDT)
MIME-Version: 1.0
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
 <894f35a7883451c4c2bf91b6181376fb@kernel.org> <CAAhV-H401y6_9++CStCH=RrfoRw6-hZBWquEAGtGecbTGbVO1Q@mail.gmail.com>
 <efab39a121918316564168c07cf88539@kernel.org> <CAAhV-H4wHO12HVaA307GJX-WnkddT5w+YWgFMGuk0ov-f7Sm8A@mail.gmail.com>
 <88b8ce9eaf6c866d47685d8608fe5a49@kernel.org>
In-Reply-To: <88b8ce9eaf6c866d47685d8608fe5a49@kernel.org>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 11 Sep 2020 17:14:40 +0800
Message-ID: <CAAhV-H5ZF6=xj9=mP5r6FudFjy9N-TjzZaoVhkuevVKE50LE1A@mail.gmail.com>
Subject: Re: [PATCH 1/3] MIPS: Loongson64: Increase NR_IRQS to 320
To:     Marc Zyngier <maz@kernel.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Marc,

On Fri, Sep 11, 2020 at 5:03 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On 2020-09-11 09:43, Huacai Chen wrote:
> > Hi, Marc,
> >
> > On Fri, Sep 11, 2020 at 3:45 PM Marc Zyngier <maz@kernel.org> wrote:
> >>
> >> On 2020-09-11 04:24, Huacai Chen wrote:
> >> > Hi, Marc,
> >> >
> >> > On Thu, Sep 10, 2020 at 6:10 PM Marc Zyngier <maz@kernel.org> wrote:
> >> >>
> >> >> On 2020-09-09 05:09, Huacai Chen wrote:
> >> >> > Modernized Loongson64 uses a hierarchical organization for interrupt
> >> >> > controllers (INTCs), all INTC nodes (not only leaf nodes) need some IRQ
> >> >> > numbers. This means 280 (i.e., NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
> >> >> > is not enough to represent all interrupts, so let's increase NR_IRQS to
> >> >> > 320.
> >> >> >
> >> >> > Cc: stable@vger.kernel.org
> >> >> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> >> >> > ---
> >> >> >  arch/mips/include/asm/mach-loongson64/irq.h | 2 +-
> >> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >> >
> >> >> > diff --git a/arch/mips/include/asm/mach-loongson64/irq.h
> >> >> > b/arch/mips/include/asm/mach-loongson64/irq.h
> >> >> > index f5e362f7..0da3017 100644
> >> >> > --- a/arch/mips/include/asm/mach-loongson64/irq.h
> >> >> > +++ b/arch/mips/include/asm/mach-loongson64/irq.h
> >> >> > @@ -7,7 +7,7 @@
> >> >> >  /* cpu core interrupt numbers */
> >> >> >  #define NR_IRQS_LEGACY               16
> >> >> >  #define NR_MIPS_CPU_IRQS     8
> >> >> > -#define NR_IRQS                      (NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
> >> >> > +#define NR_IRQS                      320
> >> >> >
> >> >> >  #define MIPS_CPU_IRQ_BASE    NR_IRQS_LEGACY
> >> >>
> >> >> Why are you hardcoding a random value instead of bumping the constant
> >> >> in NR_IRQS?
> >> > Because INTCs can organized in many kinds of hierarchy, we cannot use
> >> > constants to define a accurate value, but 320 is big enough.
> >>
> >> You're not answering my question. You have a parameterized NR_IRQS,
> >> and
> >> you're turning it into an absolute constant. Why? I.e:
> >>
> >> #define NR_IRQS        (NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 296)
> >>
> >> And why 320? Why not 512? or 2^15?
> > OK, I know, I will define a NR_MAX_MIDDLE_IRQS and then define NR_IRQS
> > as  (NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + NR_MAX_MIDDLE_IRQS + 256)
>
> What does MIDDLE_IRQS mean? Please name it to something that actually
> relates to its usage...
INTCs are organized as a tree, MIDDLE_IRQS means those IRQS used by
middle nodes (not leaf nodes and not root node), midde nodes is not
directed by devices, but they consumes irq numbers.

>
> >>
> >> As for a "modernized" setup, the fact that you are not using
> >> SPARSE_IRQ
> >> is pretty backward.
> > I have discussed this with Jiaxun, and he said that there are some
> > difficulties to use SPARSE_IRQ.
>
> It'd be worth considering putting some efforts there...
Yes, but that is another topic.

Huacai
>
>          M.
> --
> Jazz is not dead. It just smells funny...
