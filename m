Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7F82639B3
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 04:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbgIJCAa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 9 Sep 2020 22:00:30 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:45956 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729525AbgIJBlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 21:41:10 -0400
Received: by mail-il1-f195.google.com with SMTP id q6so4174545ild.12;
        Wed, 09 Sep 2020 18:41:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gbx95JmWRu+tNJB//sm1NIc5T2Lh4ktsJ6AdK4Wo+2k=;
        b=I7n7xk6HEaxXkY9OFiEigSMUaq4r4XfDslLGR+M00gkjwGMjF2ThteBATNsQ2jK0mE
         nB6f6Yyev/kbIk8AwE5s9p84UcStPwbkzuLk8fCD+jNl4qVSUeE5dxUpRxZ/XUaD5ONf
         3D+qR+T1wmiC3/LSfAV6vLfRCPETmcJbygkx+vZELSoSA2BLEId3dkcMgtQACeWhNWco
         mVJOn6jCuX5V070vrtcgE2H1qkbC6ViUVfWnxOUwFhsHYwZQQegdng5EtVhelx90qVN1
         IiRZs11CW3YpdgjdwrHhn4cJyQGePoh+Ub1k4qzVepBtBlC3uFZ6Z5O3EFKBpynn9aEe
         5gUw==
X-Gm-Message-State: AOAM533a5RVjYKErr5UWHUiSf8i4W/YO6dfsjh9z428ooWivxU+Q4Hkv
        g8nxs8CwvbwsOYPLVZH55SRXeqW2gvlKzzgtUUk=
X-Google-Smtp-Source: ABdhPJyhQEsv8PLqHzxt4OxUqUlMDPjolx0tmd3Db+rB0RyPwwLjDBu8hpoTpGqhURnX8Dzpkh1wqqx5bStMowo31NA=
X-Received: by 2002:a92:c8c4:: with SMTP id c4mr3878144ilq.287.1599702069954;
 Wed, 09 Sep 2020 18:41:09 -0700 (PDT)
MIME-Version: 1.0
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
 <1599624552-17523-3-git-send-email-chenhc@lemote.com> <be0840ac-ecb4-1c93-828f-0773f348f4b0@flygoat.com>
In-Reply-To: <be0840ac-ecb4-1c93-828f-0773f348f4b0@flygoat.com>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Thu, 10 Sep 2020 09:40:58 +0800
Message-ID: <CAAhV-H5vigV8jfrOK3uciRjkwE_c1Or+YpmzDb0CSfraNLtc3g@mail.gmail.com>
Subject: Re: [PATCH 3/3] irqchip/loongson-pch-pic: Reserve legacy LPC irqs
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <maz@kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Jiaxun,

On Thu, Sep 10, 2020 at 8:52 AM Jiaxun Yang <jiaxun.yang@flygoat.com> wrote:
>
>
>
> 在 2020/9/9 12:09, Huacai Chen 写道:
> > Reserve legacy LPC irqs (0~15) to avoid spurious interrupts.
>
> It doesn't make sense at all.
>
> How can you allocate IRQ without irqchip backing it?
>
> - Jiaxun
As you know, this patch resolves the kdump problem, and 0~15 is really
needed to reserve for LPC, right?

Huacai
>
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > ---
> >   drivers/irqchip/irq-loongson-pch-pic.c | 19 ++++++++++++++++++-
> >   1 file changed, 18 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
> > index 9bf6b9a..9f6719c 100644
> > --- a/drivers/irqchip/irq-loongson-pch-pic.c
> > +++ b/drivers/irqchip/irq-loongson-pch-pic.c
> > @@ -35,6 +35,7 @@
> >
> >   struct pch_pic {
> >       void __iomem            *base;
> > +     struct irq_domain       *lpc_domain;
> >       struct irq_domain       *pic_domain;
> >       u32                     ht_vec_base;
> >       raw_spinlock_t          pic_lock;
> > @@ -184,9 +185,9 @@ static void pch_pic_reset(struct pch_pic *priv)
> >   static int pch_pic_of_init(struct device_node *node,
> >                               struct device_node *parent)
> >   {
> > +     int i, base, err;
> >       struct pch_pic *priv;
> >       struct irq_domain *parent_domain;
> > -     int err;
> >
> >       priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> >       if (!priv)
> > @@ -213,6 +214,22 @@ static int pch_pic_of_init(struct device_node *node,
> >               goto iounmap_base;
> >       }
> >
> > +     base = irq_alloc_descs(-1, 0, NR_IRQS_LEGACY, 0);
> > +     if (base < 0) {
> > +             pr_err("Failed to allocate LPC IRQ numbers\n");
> > +             goto iounmap_base;
> > +     }
> > +
> > +     priv->lpc_domain = irq_domain_add_legacy(node, NR_IRQS_LEGACY, 0, 0,
> > +                                              &irq_domain_simple_ops, NULL);
> > +     if (!priv->lpc_domain) {
> > +             pr_err("Failed to add irqdomain for LPC controller");
> > +             goto iounmap_base;
> > +     }
> > +
> > +     for (i = 0; i < NR_IRQS_LEGACY; i++)
> > +             irq_set_chip_and_handler(i, &dummy_irq_chip, handle_simple_irq);
> > +
> >       priv->pic_domain = irq_domain_create_hierarchy(parent_domain, 0,
> >                                                      PIC_COUNT,
> >                                                      of_node_to_fwnode(node),
