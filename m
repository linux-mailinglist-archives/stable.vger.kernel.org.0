Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC27406CCD
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 15:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbhIJNUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 09:20:49 -0400
Received: from mail-vk1-f179.google.com ([209.85.221.179]:37613 "EHLO
        mail-vk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbhIJNU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 09:20:28 -0400
Received: by mail-vk1-f179.google.com with SMTP id t13so618936vkm.4;
        Fri, 10 Sep 2021 06:19:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f/lYWG5la+6tQ91oKqvQyuhgFB1Puxb3SoIztDp/wYM=;
        b=XeYCWlBl2zkHk3HrNgetX4kln2blgYan4Ny5p1VxwsDPb5Xd+7zdSOAnNP+2ZJCUeh
         l1EE68HlSHZrId2Kvw3+u4gxJn3Fnuicaf40BkDG4Czey3UV2mfGTw8KDC6Q5HPLrWkJ
         +hOxmDZ4pEXp81hF0rtCUdNQoFVn5ncwWchw41G2TlgJozArsqI5OyYaPzBrgVk0TvGv
         /zdKCNk3gVhXCNexXhIAd6kL//NMnIukDDsCnezTB4KcVNBTuE4feEThFBTeFv9uf23v
         /cH2qKDOsZ8fK+lKvR6xo0rVJzlLFV6gJ4SvBNQwiS+oSKiVgRuoO9Su/T1MRiDKkFqe
         nOFA==
X-Gm-Message-State: AOAM532Uz+Z5KPjTZ91wcnL1EcvHX5cQcUEMZgZYNb8TqEzUoc5RFjYj
        aECHSeDbMIT/E9fDM11C/dB73RWK4VgYBzfTLW4=
X-Google-Smtp-Source: ABdhPJxpZ7rRIa9VoKLgdHVemmGp99DCb2df29r+j5E8CLoCYnJGH7WeBUqZDrBYNhmDe6/TPxFBoqp5Zz30qIGkEzg=
X-Received: by 2002:ac5:c144:: with SMTP id e4mr5192018vkk.7.1631279957049;
 Fri, 10 Sep 2021 06:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200624195811.435857-1-maz@kernel.org> <20200624195811.435857-8-maz@kernel.org>
 <CAMuHMdV+Ev47K5NO8XHsanSq5YRMCHn2gWAQyV-q2LpJVy9HiQ@mail.gmail.com> <875yv8d91b.wl-maz@kernel.org>
In-Reply-To: <875yv8d91b.wl-maz@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 10 Sep 2021 15:19:05 +0200
Message-ID: <CAMuHMdV+ydPaXbGf1_O0S-juaPWk1gwBUOK+GeLZukZeoqtMGQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/17] irqchip/gic: Atomically update affinity
To:     Marc Zyngier <maz@kernel.org>
Cc:     Russell King <linux@arm.linux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Android Kernel Team <kernel-team@android.com>,
        stable <stable@vger.kernel.org>,
        Magnus Damm <damm+renesas@opensource.se>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On Fri, Sep 10, 2021 at 12:23 PM Marc Zyngier <maz@kernel.org> wrote:
> On Thu, 09 Sep 2021 16:22:01 +0100,
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, Jun 24, 2020 at 9:59 PM Marc Zyngier <maz@kernel.org> wrote:
> > > The GIC driver uses a RMW sequence to update the affinity, and
> > > relies on the gic_lock_irqsave/gic_unlock_irqrestore sequences
> > > to update it atomically.
> > >
> > > But these sequences only expend into anything meaningful if
> > > the BL_SWITCHER option is selected, which almost never happens.
> > >
> > > It also turns out that using a RMW and locks is just as silly,
> > > as the GIC distributor supports byte accesses for the GICD_TARGETRn
> > > registers, which when used make the update atomic by definition.
> > >
> > > Drop the terminally broken code and replace it by a byte write.
> > >
> > > Fixes: 04c8b0f82c7d ("irqchip/gic: Make locking a BL_SWITCHER only feature")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> >
> > Thanks for your patch, which is now commit 005c34ae4b44f085
> > ("irqchip/gic: Atomically update affinity"), to which I bisected a hard
> > lock-up during boot on the Renesas EMMA Mobile EV2-based KZM-A9-Dual
> > board, which has a dual Cortex-A9 with PL390.
> >
> > Despite the ARM Generic Interrupt Controller Architecture Specification
> > (both version 1.0 and 2.0) stating that the Interrupt Processor Targets
> > Registers are byte-accessible, the EMMA Mobile EV2 User's Manual
> > states that the interrupt registers can be accessed via the APB bus,
> > in 32-bit units.  Using byte accesses locks up the system.
>
> Urgh. That is definitely a pretty poor integration. How about the
> priority registers? I guess they suffer from the same issue...

Yes, they do.

> > Unfortunately I only have remote access to the board showing the
> > issue.  I did check that adding the writeb_relaxed() before the
> > writel_relaxed() that was used before also causes a lock-up, so the
> > issue is not an endian mismatch.
> > Looking at the driver history, these registers have always been
> > accessed using 32-bit accesses before.  As byte accesses lead
> > indeed to simpler code, I'm wondering if they had been tried before,
> > and caused issues before?
>
> Not that I know. A lock was probably fine on a two CPU system. Less so
> on a busy 8 CPU machine where interrupts are often migrated. The GIC
> architecture makes a point in not requiring locking for most of the
> registers that can be accessed concurrently.
>
> > Since you said the locking was bogus before, due to the reliance on
> > the BL_SWITCHER option, I'm not suggesting a plain revert, but I'm
> > wondering what kind of locking you suggest to use instead?
>
> There isn't much we can do aside from reintroducing the RMW+spinlock
> approach, and for real this time. It would have to be handled as a
> quirk though, as I'm not keen on reintroducing this for all systems.
>
> I wrote the patchlet below, which is totally untested. Please give it
> a go and let me know if it helps.

Thanks for your quick response!
Your solution works, after making a few small modifications.

> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -774,6 +776,25 @@ static int gic_pm_init(struct gic_chip_data *gic)
>  #endif
>
>  #ifdef CONFIG_SMP
> +static void rmw_writeb(u8 bval, void __iomem *addr)
> +{
> +       static DEFINE_RAW_SPINLOCK(rmw_lock);
> +       unsigned long offset = (unsigned long)addr & ~3UL;

Please drop the tilde.

> +       unsigned long shift = offset * 8;

"unsigned int" is sufficient for offset and size.

> +       unsigned long flags;
> +       u32 val;
> +
> +       raw_spin_lock_irqsave(&rmw_lock, flags);
> +
> +       addr -= offset;
> +       val = readl_relaxed(addr);
> +       val &= ~(0xffUL << shift);

No need for the UL suffix.

> +       val |= (u32)bval << shift;

No need for the cast.

> +       writel_relaxed(val, addr);
> +
> +       raw_spin_unlock_irqrestore(&rmw_lock, flags);
> +}
> +
>  static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
>                             bool force)
>  {

> @@ -1375,6 +1399,29 @@ static bool gic_check_eoimode(struct device_node *node, void __iomem **base)
>         return true;
>  }
>
> +static bool gic_enable_rmw_access(void *data)
> +{
> +       /*
> +        * The EMEV2 class of machines has a broken interconnect, and
> +        * locks up on accesses that are less than 32bit. So far, only
> +        * the affinity setting requires it.
> +        */
> +       if (of_machine_is_compatible("renesas,emev2")) {
> +               static_branch_enable(&needs_rmw_access);
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
> +static const struct gic_quirk gic_quirks[] = {
> +       {
> +               .desc           = "Implementation with broken byte access",

The output would look better without capitalizing the first word.
I think you can drop the first two words, saving some space:

    GIC: enabling workaround for broken byte access

> +               .compatible     = "arm,pl390",
> +               .init           = gic_enable_rmw_access,
> +       },

Missing "{ /* sentinel */ }".

> +};
> +
>  static int gic_of_setup(struct gic_chip_data *gic, struct device_node *node)
>  {
>         if (!gic || !node)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
