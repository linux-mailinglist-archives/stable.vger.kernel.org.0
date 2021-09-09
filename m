Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CEA405A22
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 17:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhIIPXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 11:23:24 -0400
Received: from mail-vk1-f178.google.com ([209.85.221.178]:38849 "EHLO
        mail-vk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbhIIPXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 11:23:23 -0400
Received: by mail-vk1-f178.google.com with SMTP id k124so845408vke.5;
        Thu, 09 Sep 2021 08:22:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jMdZxCtACotNgu9fcSUDCRRpS8pLXrlQN9yO6urHYyg=;
        b=w7+QDR7LdJfgxtECbMMqXzBUcJvueG743R0dwLScZiGXnLbTN869yZ2jpkbMC06QaK
         ZiBbp/7NOeWhMxa69+xRohQQMdfm1E/QCjXLdxUhlyIJw28LNV4bwPvoH27tH7Hpb4xp
         y04i9sHX8aNBzyIKx4HrnpHY6W52eQ+ZwjVbwruCukUgXJd9wtwscQCbRPnjoHZrMGW5
         kevtVsWMd0f/AjBLo4w5gC93siiPVIIjZLdG3G+0H1/vUClhawh7D1XBlacCPHiEx3QX
         fNkdzeeqkka/W7cFMR8mYIDIDKqsAO0n/LLoMQH24OfTxPzjV9VAZ8X+ya8fHS47XgTR
         ZZ8w==
X-Gm-Message-State: AOAM530ygaFR/a1e1XurGzFMapemUopC/+xVpjjKbTocvbZ8cj3j6/p7
        5K5X8tPg1DnUE6FgyZuVZaMDfsyDXYhxY0FieDY=
X-Google-Smtp-Source: ABdhPJy4AEeHXVpZsVsOzXcULq6QeeWxboOzc3kpSRyQieHqZC+uyu5zFuVnW1w0ubYQbeCDPw1BGP5cIZOPos8YxVI=
X-Received: by 2002:a1f:2055:: with SMTP id g82mr1978381vkg.11.1631200933555;
 Thu, 09 Sep 2021 08:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200624195811.435857-1-maz@kernel.org> <20200624195811.435857-8-maz@kernel.org>
In-Reply-To: <20200624195811.435857-8-maz@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 9 Sep 2021 17:22:01 +0200
Message-ID: <CAMuHMdV+Ev47K5NO8XHsanSq5YRMCHn2gWAQyV-q2LpJVy9HiQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/17] irqchip/gic: Atomically update affinity
To:     Marc Zyngier <maz@kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
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

Hi Marc, Russell,

On Wed, Jun 24, 2020 at 9:59 PM Marc Zyngier <maz@kernel.org> wrote:
> The GIC driver uses a RMW sequence to update the affinity, and
> relies on the gic_lock_irqsave/gic_unlock_irqrestore sequences
> to update it atomically.
>
> But these sequences only expend into anything meaningful if
> the BL_SWITCHER option is selected, which almost never happens.
>
> It also turns out that using a RMW and locks is just as silly,
> as the GIC distributor supports byte accesses for the GICD_TARGETRn
> registers, which when used make the update atomic by definition.
>
> Drop the terminally broken code and replace it by a byte write.
>
> Fixes: 04c8b0f82c7d ("irqchip/gic: Make locking a BL_SWITCHER only feature")
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Thanks for your patch, which is now commit 005c34ae4b44f085
("irqchip/gic: Atomically update affinity"), to which I bisected a hard
lock-up during boot on the Renesas EMMA Mobile EV2-based KZM-A9-Dual
board, which has a dual Cortex-A9 with PL390.

Despite the ARM Generic Interrupt Controller Architecture Specification
(both version 1.0 and 2.0) stating that the Interrupt Processor Targets
Registers are byte-accessible, the EMMA Mobile EV2 User's Manual
states that the interrupt registers can be accessed via the APB bus,
in 32-bit units.  Using byte accesses locks up the system.

Unfortunately I only have remote access to the board showing the
issue.  I did check that adding the writeb_relaxed() before the
writel_relaxed() that was used before also causes a lock-up, so the
issue is not an endian mismatch.
Looking at the driver history, these registers have always been
accessed using 32-bit accesses before.  As byte accesses lead
indeed to simpler code, I'm wondering if they had been tried before,
and caused issues before?

Since you said the locking was bogus before, due to the reliance on
the BL_SWITCHER option, I'm not suggesting a plain revert, but I'm
wondering what kind of locking you suggest to use instead?

Thanks for your comments!

> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -329,10 +329,8 @@ static int gic_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
>  static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
>                             bool force)
>  {
> -       void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
> -       unsigned int cpu, shift = (gic_irq(d) % 4) * 8;
> -       u32 val, mask, bit;
> -       unsigned long flags;
> +       void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + gic_irq(d);
> +       unsigned int cpu;
>
>         if (!force)
>                 cpu = cpumask_any_and(mask_val, cpu_online_mask);
> @@ -342,13 +340,7 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
>         if (cpu >= NR_GIC_CPU_IF || cpu >= nr_cpu_ids)
>                 return -EINVAL;
>
> -       gic_lock_irqsave(flags);
> -       mask = 0xff << shift;
> -       bit = gic_cpu_map[cpu] << shift;
> -       val = readl_relaxed(reg) & ~mask;
> -       writel_relaxed(val | bit, reg);
> -       gic_unlock_irqrestore(flags);
> -
> +       writeb_relaxed(gic_cpu_map[cpu], reg);
>         irq_data_update_effective_affinity(d, cpumask_of(cpu));
>
>         return IRQ_SET_MASK_OK_DONE;

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
