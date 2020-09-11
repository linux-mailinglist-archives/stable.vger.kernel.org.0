Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DAB265D76
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 12:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgIKKNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 06:13:15 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:35363 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgIKKNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 06:13:13 -0400
Received: by mail-il1-f193.google.com with SMTP id y9so703570ilq.2;
        Fri, 11 Sep 2020 03:13:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hNAgDJmssVpw4aMJ18Kb1if3usn2Q1OLYU7PwTagydI=;
        b=XasShgc6jkunjr2FzZ2Zg/+2Uhkko/zR/kargiaqWBq9SC1RxEJ0HJVB7X5kmS/xGe
         Z0AjLhyZ3NeOrAvxlSTt5kCJV++AymMQObb07iSMLUL7VlyhZrAk1b59sCyDOXPHzEGd
         x/DdwSvl6bb+F462eDWi1KlvtZ58lp1EkUHajWY/g5zsaGbvU7qYHCifUvBb8NiYeVWA
         xe+yFpCyjTLgFIW/Ul/rZhz2yvNxMM2DWEfMkU3Midc0LzQSscHG0JZwnqGRZSZqgvi0
         B6FLiu/QSYfASdsnc4W/b6V7qTMcKX+LWHyBLAS4adT0UcI+uDA5/Hphc/xjZYz1GXVj
         gYwg==
X-Gm-Message-State: AOAM533vaImYiSvsm9uYTTrIDCADG42k/dnhYW272C3zyraoslkPyTPb
        PjnO3tMvXgD0mbL/QpL8fQxoSTJ+fTh+oprcJVs=
X-Google-Smtp-Source: ABdhPJwUVdyO+k4KE34x6ppO9BMm8P/K08kHVYCJa1Rk6zmWOIv8EG/Kfr5AxqsGi6/kDCieNbG0G7aV+4cuRnsSBhs=
X-Received: by 2002:a92:2806:: with SMTP id l6mr1095325ilf.147.1599819188684;
 Fri, 11 Sep 2020 03:13:08 -0700 (PDT)
MIME-Version: 1.0
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
 <1599624552-17523-3-git-send-email-chenhc@lemote.com> <613dd7bc4d7eeec1a5fd30f679fc83eb@kernel.org>
 <CAAhV-H5Rs-PHV6Sy=1tbhsF-nj5MOYgvNie_5g7+8yFYT_2Anw@mail.gmail.com> <6af66ab3dbf81cc1d0cf4c204ebac2b8@kernel.org>
In-Reply-To: <6af66ab3dbf81cc1d0cf4c204ebac2b8@kernel.org>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 11 Sep 2020 18:12:55 +0800
Message-ID: <CAAhV-H5-2SZOaGny68-PBP3_+afHk5XMuQRYgCQS50b_3fMj4A@mail.gmail.com>
Subject: Re: [PATCH 3/3] irqchip/loongson-pch-pic: Reserve legacy LPC irqs
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

On Fri, Sep 11, 2020 at 3:50 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On 2020-09-11 05:13, Huacai Chen wrote:
> > Hi, Marc,
> >
> > On Thu, Sep 10, 2020 at 6:08 PM Marc Zyngier <maz@kernel.org> wrote:
> >>
> >> On 2020-09-09 05:09, Huacai Chen wrote:
> >> > Reserve legacy LPC irqs (0~15) to avoid spurious interrupts.
> >>
> >> How can they be spurious? Why are they enabled the first place?
> >>
> >> This looks like you are papering over a much bigger issue.
> > The spurious interrupts are probably occurred after kdump and the irq
> > number is in legacy LPC ranges. I think this is because the old kernel
> > doesn't (and it can't) disable devices properly so there are stale
> > interrupts in the kdump case.
>
> I don't really understand why the old kernel can't turn the interrupts
> off. Most architectures are able t, why not yours?
>
> Finally, why don't you just shut these interrupts off the first place
> in the interrupt controller init? Adding a whole lot of kernel
> data structures as a band-aid doesn't strike me as the best possible
> idea. Not to mention that if they keep firing, all you are doing
> is adding extra overhead.
After tests, I found that the previous patch (patch 2 in this series)
can avoid most spurious interrupts and kdump can work, so I will send
V2 to drop this patch.

Huacai
>
>          M.
> --
> Jazz is not dead. It just smells funny...
