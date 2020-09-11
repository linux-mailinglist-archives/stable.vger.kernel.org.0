Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467B52657E3
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 06:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725320AbgIKENa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 00:13:30 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39164 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgIKENZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 00:13:25 -0400
Received: by mail-io1-f68.google.com with SMTP id b6so9623931iof.6;
        Thu, 10 Sep 2020 21:13:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0B9EnzCWMEUSzb0RmQZw8R4A4nFSLvij84dGvYd9u4Y=;
        b=KtPez1fbEmebKtwCQ1A+88dzsmhyQegjMaQv7nq2R49EcAmR8Xj8Ps41+goOrZhWg/
         rIomTl6jpK0GMzpSwHAFRBCb+aHUDlBbaaTrxjfajmys+2K97PdxqyPtG6VL6AXQHUbR
         63PDwjmE369/cigXveH2FO4Eq6IoubIZCARaNZwJmbfdW0yJS7LLzbnnkUIrqOznVeeQ
         EaowRt+s9jg0UTwoLVVMJxviZGOj4bbTY1xQ9NZEvTNBBF3IXHFM6qdWyw6Cyo65f8wz
         OzYvGLV8SYFgQdAxbLxDoWog6Er94N/35/vFa+P9N3KVn/P6J6PnRQMJ8JJyHiMvwnfU
         8Xzg==
X-Gm-Message-State: AOAM531a2leC8gFhbELcG6hWXE2wsB71V6IPsLcFchcb7t413x6GZS7r
        rRnoEvVXoGNlnyQhh837aoPR21n6thjVUMBUx1k=
X-Google-Smtp-Source: ABdhPJwHLdMYRawQ21HS1ogeOhr9D2dx+jXKFVZxUZl3dEZ3VvXm2UFQvx0g6azWe3oI+FEdboZxQIgQMiYxHf1ruKY=
X-Received: by 2002:a02:a498:: with SMTP id d24mr191429jam.137.1599797604700;
 Thu, 10 Sep 2020 21:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
 <1599624552-17523-3-git-send-email-chenhc@lemote.com> <613dd7bc4d7eeec1a5fd30f679fc83eb@kernel.org>
In-Reply-To: <613dd7bc4d7eeec1a5fd30f679fc83eb@kernel.org>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 11 Sep 2020 12:13:13 +0800
Message-ID: <CAAhV-H5Rs-PHV6Sy=1tbhsF-nj5MOYgvNie_5g7+8yFYT_2Anw@mail.gmail.com>
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

On Thu, Sep 10, 2020 at 6:08 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On 2020-09-09 05:09, Huacai Chen wrote:
> > Reserve legacy LPC irqs (0~15) to avoid spurious interrupts.
>
> How can they be spurious? Why are they enabled the first place?
>
> This looks like you are papering over a much bigger issue.
The spurious interrupts are probably occurred after kdump and the irq
number is in legacy LPC ranges. I think this is because the old kernel
doesn't (and it can't) disable devices properly so there are stale
interrupts in the kdump case.

Huacai
>
>          M.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > ---
> >  drivers/irqchip/irq-loongson-pch-pic.c | 19 ++++++++++++++++++-
> >  1 file changed, 18 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/irqchip/irq-loongson-pch-pic.c
> > b/drivers/irqchip/irq-loongson-pch-pic.c
> > index 9bf6b9a..9f6719c 100644
> > --- a/drivers/irqchip/irq-loongson-pch-pic.c
> > +++ b/drivers/irqchip/irq-loongson-pch-pic.c
> > @@ -35,6 +35,7 @@
> >
> >  struct pch_pic {
> >       void __iomem            *base;
> > +     struct irq_domain       *lpc_domain;
> >       struct irq_domain       *pic_domain;
> >       u32                     ht_vec_base;
> >       raw_spinlock_t          pic_lock;
> > @@ -184,9 +185,9 @@ static void pch_pic_reset(struct pch_pic *priv)
> >  static int pch_pic_of_init(struct device_node *node,
> >                               struct device_node *parent)
> >  {
> > +     int i, base, err;
> >       struct pch_pic *priv;
> >       struct irq_domain *parent_domain;
> > -     int err;
> >
> >       priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> >       if (!priv)
> > @@ -213,6 +214,22 @@ static int pch_pic_of_init(struct device_node
> > *node,
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
>
> --
> Jazz is not dead. It just smells funny...
