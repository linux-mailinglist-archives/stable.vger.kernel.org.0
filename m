Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2994472FC
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 14:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbhKGNMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 08:12:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231136AbhKGNMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Nov 2021 08:12:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D547561465;
        Sun,  7 Nov 2021 13:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636290589;
        bh=KTTVrTd2ihbh9KwJ9n54z88VqLiq1cWDd/itc0fUwkk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HgozeBh6rpCvMRtgrEjwmZOdYtMdw3efdzXV7iQfL89J7mW3eajDkFlapmkE61671
         9xKV9bDQ12adyUe1cwcZoZfk9tMCULRM6YlfMG+jgnSGuxJi4hhCjrAxHb1fcrYTN2
         eZqbdJY+BE3TWELfEvMp5Z/FGtlIUrNYkFUjsVtCQSLSjbyISLiBNICZkZvHTaQLtI
         ZIA9iOwM+/iYTbSAuaTzTpCqslKyy9WmwLSPhkTpkmXkFQ8ZZddP7vKFnvX+9VPyKj
         ArNuyyW44uo7AxQZTL8cl+ExGU3acsIGXOhDwz02Wbuk+nAExX31UkdmG6pKre88fI
         YF75MxMUnPqqg==
Received: by mail-ua1-f45.google.com with SMTP id i6so26287153uae.6;
        Sun, 07 Nov 2021 05:09:49 -0800 (PST)
X-Gm-Message-State: AOAM531CrKtV92rAGOCEDbFyfmA8LrbwR/1yGcbu3rqkeq0ZgiJGgCVV
        FdCN3i2dR1AG4XiduUp8+fUYa6oxNF9ConAZtQQ=
X-Google-Smtp-Source: ABdhPJy6SHuBT9ZKBzGHzAGDfkrU4I/o9sw4qE3Sm+bDD3q17LwpNd6AfgdHtPrDO+s36w7HEzo9u4jnAZ9X0MyzPg0=
X-Received: by 2002:a67:fa93:: with SMTP id f19mr92381967vsq.43.1636290588838;
 Sun, 07 Nov 2021 05:09:48 -0800 (PST)
MIME-Version: 1.0
References: <20211105094748.3894453-1-guoren@kernel.org> <CAAhSdy1vyCQdv_gNaNSzU79PC4giCAig6hzgD9JXSXs6+gfFPA@mail.gmail.com>
In-Reply-To: <CAAhSdy1vyCQdv_gNaNSzU79PC4giCAig6hzgD9JXSXs6+gfFPA@mail.gmail.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Sun, 7 Nov 2021 21:09:38 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTcx0GWQ6CY0VJtzAi8TqvOKK00py4f-d_1iHhi1XAXmw@mail.gmail.com>
Message-ID: <CAJF2gTTcx0GWQ6CY0VJtzAi8TqvOKK00py4f-d_1iHhi1XAXmw@mail.gmail.com>
Subject: Re: [PATCH V7] irqchip/sifive-plic: Fixup EOI failed when masked
To:     Anup Patel <anup@brainfault.org>, Marc Zyngier <maz@kernel.org>
Cc:     Atish Patra <atish.patra@wdc.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Guo Ren <guoren@linux.alibaba.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 6, 2021 at 9:45 PM Anup Patel <anup@brainfault.org> wrote:
>
> On Fri, Nov 5, 2021 at 3:18 PM <guoren@kernel.org> wrote:
> >
> > From: Guo Ren <guoren@linux.alibaba.com>
> >
> > When using "devm_request_threaded_irq(,,,,IRQF_ONESHOT,,)" in the driver,
> > only the first interrupt could be handled, and continue irq is blocked by
> > hw. Because the riscv plic couldn't complete masked irq source which has
> > been disabled in enable register. The bug was firstly reported in [1].
> >
> > Here is the description of Interrupt Completion in PLIC spec [2]:
> >
> > The PLIC signals it has completed executing an interrupt handler by
> > writing the interrupt ID it received from the claim to the claim/complete
> > register. The PLIC does not check whether the completion ID is the same
> > as the last claim ID for that target. If the completion ID does not match
> > an interrupt source that is currently enabled for the target, the
> >                          ^^ ^^^^^^^^^ ^^^^^^^
> > completion is silently ignored.
> >
> > [1] http://lists.infradead.org/pipermail/linux-riscv/2021-July/007441.html
> > [2] https://github.com/riscv/riscv-plic-spec/blob/8bc15a35d07c9edf7b5d23fec9728302595ffc4d/riscv-plic.adoc
> >
> > Fixes: bb0fed1c60cc ("irqchip/sifive-plic: Switch to fasteoi flow")
> > Reported-by: Vincent Pelletier <plr.vincent@gmail.com>
> > Tested-by: Nikita Shubin <nikita.shubin@maquefel.me>
> > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
>
> Looks good to me.
>
> Reviewed-by: Anup Patel <anup@brainfault.org>
Thx

@Marc Zyngier
Could you help to take the patch into your tree include "Anup's
Reviewed-by"? Or Let me update a new version of the patch.

>
> Regards,
> Anup
>
> > Cc: stable@vger.kernel.org
> > Cc: Anup Patel <anup@brainfault.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Palmer Dabbelt <palmer@dabbelt.com>
> > Cc: Atish Patra <atish.patra@wdc.com>
> > Cc: Nikita Shubin <nikita.shubin@maquefel.me>
> > Cc: incent Pelletier <plr.vincent@gmail.com>
> >
> > ---
> >
> > Changes since V7:
> >  - Add Fixes tag
> >  - Add Tested-by
> >  - Add Cc stable
> >
> > Changes since V6:
> >  - Propagate to plic_irq_eoi for all riscv,plic by Nikita Shubin
> >  - Remove thead related codes
> >
> > Changes since V5:
> >  - Move back to mask/unmask
> >  - Fixup the problem in eoi callback
> >  - Remove allwinner,sun20i-d1 IRQCHIP_DECLARE
> >  - Rewrite comment log
> >
> > Changes since V4:
> >  - Update comment by Anup
> >
> > Changes since V3:
> >  - Rename "c9xx" to "c900"
> >  - Add sifive_plic_chip and thead_plic_chip for difference
> >
> > Changes since V2:
> >  - Add a separate compatible string "thead,c9xx-plic"
> >  - set irq_mask/unmask of "plic_chip" to NULL and point
> >    irq_enable/disable of "plic_chip" to plic_irq_mask/unmask
> >  - Add a detailed comment block in plic_init() about the
> >    differences in Claim/Completion process of RISC-V PLIC and C9xx
> >    PLIC.
> > ---
> >  drivers/irqchip/irq-sifive-plic.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
> > index cf74cfa82045..259065d271ef 100644
> > --- a/drivers/irqchip/irq-sifive-plic.c
> > +++ b/drivers/irqchip/irq-sifive-plic.c
> > @@ -163,7 +163,13 @@ static void plic_irq_eoi(struct irq_data *d)
> >  {
> >         struct plic_handler *handler = this_cpu_ptr(&plic_handlers);
> >
> > -       writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
> > +       if (irqd_irq_masked(d)) {
> > +               plic_irq_unmask(d);
> > +               writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
> > +               plic_irq_mask(d);
> > +       } else {
> > +               writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
> > +       }
> >  }
> >
> >  static struct irq_chip plic_chip = {
> > --
> > 2.25.1
> >



-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
