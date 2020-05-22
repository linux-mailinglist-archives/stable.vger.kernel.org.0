Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2A11DE018
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 08:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgEVGqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 02:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgEVGqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 May 2020 02:46:38 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05C5C05BD43
        for <stable@vger.kernel.org>; Thu, 21 May 2020 23:46:37 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id n5so8767740wmd.0
        for <stable@vger.kernel.org>; Thu, 21 May 2020 23:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BdlhqyJ951xgsvD5BLBHy8K0oY2CiBKgpcw7Bfgw0og=;
        b=MMALL3hdVhUKe9RSDOjWQFf8Rj16jm9NnaDZwZSTAIl5sqs1rfb8ZlWZc+mksI4LjS
         YbK0eqASO6GJdnMPtQ5kw5DxjfG1V8V6misIPJraMRq6XAak7Sp7PpOXLmnLQX3YpalD
         /n7t3ILmEcLLWGr5ub+o8UpM85BjaDmcBby+A0LnpXJy96kcsLIG9Vu5AGZAAgOagoih
         LsVmGmmxp3vWCshshBJJBO209oiWdvVCaR9QMuFLeXs01cISosV176UzwqN8Rt6QYJ4o
         lB7KQbGW4yDAXO/d3jT+3nquplZ+z0UZY3ixTLgWO8wjJs0k1wVyEb9PBGgA1ZXR1YYq
         WBqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BdlhqyJ951xgsvD5BLBHy8K0oY2CiBKgpcw7Bfgw0og=;
        b=gyZG6o7MX2WGr38R/VRayRXxa4y0n+Tj4LPmo+8t8q8CpjiQPwgtVzyrnHUmz9HY6O
         ru8lm1LYQyVQnSpHKkmXpV2hkGOIsmIYH09jN0MJLHCjLlz70XeZv4P4uvgbJ5kCZ0d3
         k4lg93o1mkNbmkJ5AOj4lWy8c9ACL8DOccRCrGS1n8Hcd8UywV9SHICxczHUchnVSGTv
         UA4OrDi0Gy7UnDKkcgOWh2azFmQDx6QbU9OXeRuiut84Mc5qR3pAzZXcGF0UobEqQsTw
         lGeMfbI+t0zkO4FjP1i9dRrbdkytSFZfdotPWYkffAeSIH5UADtEmdCQnp70hMM9a1m7
         Uncw==
X-Gm-Message-State: AOAM530adUoVu+hPzw0ZHLIL9Iv+0ckhWezneMlwA/fI7yTr2VXhTxnf
        gIkOEB8GauEzD5WpMvHxOrbjuMm3Lde9dm/GJ5zC1A==
X-Google-Smtp-Source: ABdhPJxKUECvmXh3jDWmvCzFehb3e/WIuTSnRSQEBDoErxJ4L97sPaekwvTZTGb89pkgft+zbMU7QBtOLH7SUqOkdB8=
X-Received: by 2002:a7b:c0d1:: with SMTP id s17mr11498344wmh.157.1590129996226;
 Thu, 21 May 2020 23:46:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200518091441.94843-3-anup.patel@wdc.com> <mhng-06a48d36-b37c-481f-97aa-8fc0b1f9795e@palmerdabbelt-glaptop1>
In-Reply-To: <mhng-06a48d36-b37c-481f-97aa-8fc0b1f9795e@palmerdabbelt-glaptop1>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 22 May 2020 12:16:24 +0530
Message-ID: <CAAhSdy1NmtRW+LGJ013xAe9AwroUPcujqC2yLcNY+5ZtvGpCUQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] irqchip/sifive-plic: Setup cpuhp once after boot
 CPU handler is present
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <maz@kernel.org>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 22, 2020 at 3:36 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
> On Mon, 18 May 2020 02:14:40 PDT (-0700), Anup Patel wrote:
> > For multiple PLIC instances, the plic_init() is called once for each
> > PLIC instance. Due to this we have two issues:
> > 1. cpuhp_setup_state() is called multiple times
> > 2. plic_starting_cpu() can crash for boot CPU if cpuhp_setup_state()
> >    is called before boot CPU PLIC handler is available.
> >
> > This patch fixes both above issues.
> >
> > Fixes: f1ad1133b18f ("irqchip/sifive-plic: Add support for multiple PLICs")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > ---
> >  drivers/irqchip/irq-sifive-plic.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
> > index 9f7f8ce88c00..6c54abf5cc5e 100644
> > --- a/drivers/irqchip/irq-sifive-plic.c
> > +++ b/drivers/irqchip/irq-sifive-plic.c
> > @@ -76,6 +76,7 @@ struct plic_handler {
> >       void __iomem            *enable_base;
> >       struct plic_priv        *priv;
> >  };
> > +static bool plic_cpuhp_setup_done;
> >  static DEFINE_PER_CPU(struct plic_handler, plic_handlers);
> >
> >  static inline void plic_toggle(struct plic_handler *handler,
> > @@ -285,6 +286,7 @@ static int __init plic_init(struct device_node *node,
> >       int error = 0, nr_contexts, nr_handlers = 0, i;
> >       u32 nr_irqs;
> >       struct plic_priv *priv;
> > +     struct plic_handler *handler;
> >
> >       priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> >       if (!priv)
> > @@ -313,7 +315,6 @@ static int __init plic_init(struct device_node *node,
> >
> >       for (i = 0; i < nr_contexts; i++) {
> >               struct of_phandle_args parent;
> > -             struct plic_handler *handler;
> >               irq_hw_number_t hwirq;
> >               int cpu, hartid;
> >
> > @@ -367,9 +368,18 @@ static int __init plic_init(struct device_node *node,
> >               nr_handlers++;
> >       }
> >
> > -     cpuhp_setup_state(CPUHP_AP_IRQ_SIFIVE_PLIC_STARTING,
> > +     /*
> > +      * We can have multiple PLIC instances so setup cpuhp state only
> > +      * when context handler for current/boot CPU is present.
> > +      */
> > +     handler = this_cpu_ptr(&plic_handlers);
> > +     if (handler->present && !plic_cpuhp_setup_done) {
> > +             cpuhp_setup_state(CPUHP_AP_IRQ_SIFIVE_PLIC_STARTING,
> >                                 "irqchip/sifive/plic:starting",
> >                                 plic_starting_cpu, plic_dying_cpu);
> > +             plic_cpuhp_setup_done = true;
>
> So presumably something else is preventing multiple plic_init() calls from
> executing at the same time?  Assuming that's the case

AFAIK, interrupt controller and timer probing happens sequentially on
boot CPU before all secondary CPUs are brought-up.

>
> Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
> Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
>
> > +     }
> > +
> >       pr_info("mapped %d interrupts with %d handlers for %d contexts.\n",
> >               nr_irqs, nr_handlers, nr_contexts);
> >       set_handle_irq(plic_handle_irq);

Thanks,
Anup
