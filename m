Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69F5265BD6
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 10:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbgIKInn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 04:43:43 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:35610 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgIKInk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 04:43:40 -0400
Received: by mail-il1-f193.google.com with SMTP id y9so514838ilq.2;
        Fri, 11 Sep 2020 01:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z8esEQlzABnB5T5ebZQWpJdrFqv+XSgKnrvncW5myDw=;
        b=eG9mnL8E9x7s7VG561eFNEpD1cnqj9TGiyxs8h3FAUR46hKJDD+7kGvL0+Dlp1Ds80
         U7QXVjxQAxLeUvJSpyn5SOU18Xu7p9UDZnczBCvOma4OpK9qrGgXuizM42YpI4k+pbrO
         tz0aall0iq7EwnQVflGqnPI+7TFXZgApEn+PyswCJsoLF0b8+pQ2BYEasf9fB8xTrvgm
         UMRjfAuopzJloV69DWp7BWuJdXtL19HsKJx5YjOqsjDQHhpPItfKOAbG3lDfNxvAxz25
         kG+zkyzOggvbR2FF1R0zGoO+5Zv+w/pA8FDa2SM4DOohGr5a/iMQ/BWbpWjI63H9CEGC
         7EzA==
X-Gm-Message-State: AOAM533bHl4vg5LUVUnevyIG6VnECmWZ4fxoRnUBjVBDqiaAv1S/j5AY
        PARGX1K2Avt/HZAeWJOy+h1lXoKrtbObooLPO2I=
X-Google-Smtp-Source: ABdhPJza9sfvEj1TOyvr+9fxJTL4Nn7z0oUNNVCUjpO7fQYjLtAAArZby6Gg/WCn0x71+m/oc5p1GISpVbWCcRtW2aQ=
X-Received: by 2002:a92:2806:: with SMTP id l6mr876377ilf.147.1599813819654;
 Fri, 11 Sep 2020 01:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
 <894f35a7883451c4c2bf91b6181376fb@kernel.org> <CAAhV-H401y6_9++CStCH=RrfoRw6-hZBWquEAGtGecbTGbVO1Q@mail.gmail.com>
 <efab39a121918316564168c07cf88539@kernel.org>
In-Reply-To: <efab39a121918316564168c07cf88539@kernel.org>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 11 Sep 2020 16:43:28 +0800
Message-ID: <CAAhV-H4wHO12HVaA307GJX-WnkddT5w+YWgFMGuk0ov-f7Sm8A@mail.gmail.com>
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

On Fri, Sep 11, 2020 at 3:45 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On 2020-09-11 04:24, Huacai Chen wrote:
> > Hi, Marc,
> >
> > On Thu, Sep 10, 2020 at 6:10 PM Marc Zyngier <maz@kernel.org> wrote:
> >>
> >> On 2020-09-09 05:09, Huacai Chen wrote:
> >> > Modernized Loongson64 uses a hierarchical organization for interrupt
> >> > controllers (INTCs), all INTC nodes (not only leaf nodes) need some IRQ
> >> > numbers. This means 280 (i.e., NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
> >> > is not enough to represent all interrupts, so let's increase NR_IRQS to
> >> > 320.
> >> >
> >> > Cc: stable@vger.kernel.org
> >> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> >> > ---
> >> >  arch/mips/include/asm/mach-loongson64/irq.h | 2 +-
> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >
> >> > diff --git a/arch/mips/include/asm/mach-loongson64/irq.h
> >> > b/arch/mips/include/asm/mach-loongson64/irq.h
> >> > index f5e362f7..0da3017 100644
> >> > --- a/arch/mips/include/asm/mach-loongson64/irq.h
> >> > +++ b/arch/mips/include/asm/mach-loongson64/irq.h
> >> > @@ -7,7 +7,7 @@
> >> >  /* cpu core interrupt numbers */
> >> >  #define NR_IRQS_LEGACY               16
> >> >  #define NR_MIPS_CPU_IRQS     8
> >> > -#define NR_IRQS                      (NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
> >> > +#define NR_IRQS                      320
> >> >
> >> >  #define MIPS_CPU_IRQ_BASE    NR_IRQS_LEGACY
> >>
> >> Why are you hardcoding a random value instead of bumping the constant
> >> in NR_IRQS?
> > Because INTCs can organized in many kinds of hierarchy, we cannot use
> > constants to define a accurate value, but 320 is big enough.
>
> You're not answering my question. You have a parameterized NR_IRQS, and
> you're turning it into an absolute constant. Why? I.e:
>
> #define NR_IRQS        (NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 296)
>
> And why 320? Why not 512? or 2^15?
OK, I know, I will define a NR_MAX_MIDDLE_IRQS and then define NR_IRQS
as  (NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + NR_MAX_MIDDLE_IRQS + 256)

>
> As for a "modernized" setup, the fact that you are not using SPARSE_IRQ
> is pretty backward.
I have discussed this with Jiaxun, and he said that there are some
difficulties to use SPARSE_IRQ.

Huacai
>
>          M.
> --
> Jazz is not dead. It just smells funny...
