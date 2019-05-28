Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAED2CF57
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 21:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfE1TWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 15:22:06 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:40803 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbfE1TWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 15:22:05 -0400
Received: by mail-ua1-f68.google.com with SMTP id d4so8450612uaj.7
        for <stable@vger.kernel.org>; Tue, 28 May 2019 12:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o51SeYBfVRyasaL8DkaZePzzAuT4juHYF4hX6xOnKiM=;
        b=Gx+5MLP2FDWOPXWy6czETvegxYXSZwbIucUqOc1Qf8P2FO3umVCVFVhoqkZSx7MT3o
         3ZTGMaIsnzBfkyIVjkiDXwAvuS0DGzp/lIz/e0mfQjdtXUCwCjnRRerWoOPdNC2F9lru
         VeAMhWhHympLCCUHsNWHw8z5EB/X9l93i9mElATUKTrib+XZvaGvGGSW3GqN7GjVUJpa
         SgX5Uwsc8SCY4dBErVxgV6V2v0lg0LFZ8R88NBC61ilOYoaEL/ZccrAoYt/yGjHgjTO3
         8CBZAu3GE3m1Yt93tZWfOTH+kXNTnaXu/nJdgzih09h9ovzcBfr9XPRXLIhwW/SwGVl8
         eGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o51SeYBfVRyasaL8DkaZePzzAuT4juHYF4hX6xOnKiM=;
        b=rTeFTlsGv8c7egawzRdVYcn0PJiolQ7EFRRUbf1ff7wW+vxTf5kKl94eM8ZQI431cP
         4f0guXU9B/g4yzYnqJdeAXSDh/AkjFPGP6n+OutR6LygJGMWHbhS658eObKpsZutrfPe
         Jf3Y649oE7CXy54ZU0kU1lkH4h0kRlUxQQvhXl+QeoWPPo7z88IYL+XUM6DkrijFfexx
         K+AHD755CwdX6yJpgsAvYxWYDnJh+SpvqIkrUbLZTkhpzSXhE6+PiSTlR8M433nqlFAl
         luBgurE4Qr5ItPJOoTvuiEQKtykeHOgljXtyThwT70+8Z0IB1nIbT+sdyqpe5xovj7Pb
         dMvw==
X-Gm-Message-State: APjAAAXs33zOFEKw/Ktwhytt1ESNlvxwbajN0vsDpHw6LL9dewtnFkEO
        tyes8afoWRMIQ5a2w7UD0XsnMzf/FHcYIjoISR/pOw==
X-Google-Smtp-Source: APXvYqxq83kXFEOLbADw2n/1zs0kcaN0zXUr1gStJ+CzcAafZwaxBuMfO06ZSd63b61fxvj11okHHU6DG92954qEiBw=
X-Received: by 2002:a9f:2103:: with SMTP id 3mr57230678uab.100.1559071323390;
 Tue, 28 May 2019 12:22:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190429204040.18725-1-dianders@chromium.org>
In-Reply-To: <20190429204040.18725-1-dianders@chromium.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 28 May 2019 21:21:25 +0200
Message-ID: <CAPDyKFp0fQ+3CS-DadE9rO-9Npzve-nztY9hRaMdX7Pw9sUZMw@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: Disable SDIO interrupts while suspended
 to fix suspend/resume
To:     Douglas Anderson <dianders@chromium.org>
Cc:     Jaehoon Chung <jh80.chung@samsung.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Guenter Roeck <groeck@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Emil Renner Berthing <emil.renner.berthing@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Ryan Case <ryandcase@chromium.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Apr 2019 at 22:41, Douglas Anderson <dianders@chromium.org> wrote:
>
> Processing SDIO interrupts while dw_mmc is suspended (or partly
> suspended) seems like a bad idea.  We really don't want to be
> processing them until we've gotten ourselves fully powered up.

I fully agree.

Although, this is important not only from the host driver/controller
perspective, but also from the SDIO card (managed by mmc core) point
of view.

In $subject patch you mange the driver/controller issue, but only for
one specific host driver (dw_mmc). I am thinking that this problem may
be a rather common problem, so perhaps we should try to address this
from the core in a way that it affects all host drivers. Did you
consider that?

The other problem I refer to, is in principle a way to prevent
sdio_run_irqs() from being executed before the SDIO card has been
resumed, via mmc_sdio_resume(). It's a separate problem, but certainly
related. This may need some more thinking to address properly, let's
just keep this in mind and discuss this in a separate thread.

>
> You might be wondering how it's even possible to become suspended when
> an SDIO interrupt is active.  As can be seen in
> dw_mci_enable_sdio_irq(), we explicitly keep dw_mmc out of runtime
> suspend when the SDIO interrupt is enabled.  ...but even though we
> stop normal runtime suspend transitions when SDIO interrupts are
> enabled, the dw_mci_runtime_suspend() can still get called for a full
> system suspend.
>
> Let's handle all this by explicitly masking SDIO interrupts in the
> suspend call and unmasking them later in the resume call.  To do this
> cleanly I'll keep track of whether the client requested that SDIO
> interrupts be enabled so that we can reliably restore them regardless
> of whether we're masking them for one reason or another.
>
> It should be noted that if dw_mci_enable_sdio_irq() is never called
> (for instance, if we don't have an SDIO card plugged in) that
> "client_sdio_enb" will always be false.  In those cases this patch
> adds a tiny bit of overhead to suspend/resume (a spinlock and a
> read/write of INTMASK) but other than that is a no-op.  The
> SDMMC_INT_SDIO bit should always be clear and clearing it again won't
> hurt.

Thanks for the detailed problem description. In general your approach
sounds okay to me, but I have a few questions.

1) As kind of stated above, did you consider a solution where the core
simply disables the SDIO IRQ in case it isn't enabled for system
wakeup? In this way all host drivers would benefit.

2) dw_mmc isn't calling device_init_wakeup() during ->probe(), hence I
assume it doesn't support the SDIO IRQ being configured as system
wakeup. Correct? I understand this is platform specific, but still it
would be good to know your view.

3) Because of 2) The below code in dw_mci_runtime_suspend(), puzzles me:
"if (host->slot->mmc->pm_flags & MMC_PM_KEEP_POWER)"
       dw_mci_set_ios(host->slot->mmc, &host->slot->mmc->ios);

Why is 3) needed at all in case system wakeup isn't supported?

A note; the current support in the mmc core for the SDIO IRQ being
used as system wakeup, really needs some re-work. For example, we
should convert to use common wakeup interfaces, as to allow the PM
core to behave correctly during system suspend/resume. These are
changes that have been scheduled on my TODO list since long time ago,
I hope I can get some time to look into them soon.

>
> Without this fix it can be seen that rk3288-veyron Chromebooks with
> Marvell WiFi would sometimes fail to resume WiFi even after picking my
> recent mwifiex patch [1].  Specifically you'd see messages like this:
>   mwifiex_sdio mmc1:0001:1: Firmware wakeup failed
>   mwifiex_sdio mmc1:0001:1: PREP_CMD: FW in reset state
>
> ...and tracing through the resume code in the failing cases showed
> that we were processing a SDIO interrupt really early in the resume
> call.
>
> NOTE: downstream in Chrome OS 3.14 and 3.18 kernels (both of which
> support the Marvell SDIO WiFi card) we had a patch ("CHROMIUM: sdio:
> Defer SDIO interrupt handling until after resume") [2].  Presumably
> this is the same problem that was solved by that patch.

Seems reasonable.

>
> [1] https://lkml.kernel.org/r/20190404040106.40519-1-dianders@chromium.org
> [2] https://crrev.com/c/230765
>
> Cc: <stable@vger.kernel.org> # 4.14.x
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
> I didn't put any "Fixes" tag here, but presumably this could be
> backported to whichever kernels folks found it useful for.  I have at
> least confirmed that kernels v4.14 and v4.19 (as well as v5.1-rc2)
> show the problem.  It is very easy to pick this to v4.19 and it
> definitely fixes the problem there.
>
> I haven't spent the time to pick this to 4.14 myself, but presumably
> it wouldn't be too hard to backport this as far as v4.13 since that
> contains commit 32dba73772f8 ("mmc: dw_mmc: Convert to use
> MMC_CAP2_SDIO_IRQ_NOTHREAD for SDIO IRQs").  Prior to that it might
> make sense for anyone experiencing this problem to just pick the old
> CHROMIUM patch to fix them.
>
> Changes in v2:
> - Suggested 4.14+ in the stable tag (Sasha-bot)
> - Extra note that this is a noop on non-SDIO (Shawn / Emil)
> - Make boolean logic cleaner as per https://crrev.com/c/1586207/1
> - Hopefully clear comments as per https://crrev.com/c/1586207/1
>
>  drivers/mmc/host/dw_mmc.c | 27 +++++++++++++++++++++++----
>  drivers/mmc/host/dw_mmc.h |  3 +++
>  2 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 80dc2fd6576c..480067b87a94 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1664,7 +1664,8 @@ static void dw_mci_init_card(struct mmc_host *mmc, struct mmc_card *card)
>         }
>  }
>
> -static void __dw_mci_enable_sdio_irq(struct dw_mci_slot *slot, int enb)
> +static void __dw_mci_enable_sdio_irq(struct dw_mci_slot *slot, bool enb,
> +                                    bool client_requested)
>  {
>         struct dw_mci *host = slot->host;
>         unsigned long irqflags;
> @@ -1672,6 +1673,20 @@ static void __dw_mci_enable_sdio_irq(struct dw_mci_slot *slot, int enb)
>
>         spin_lock_irqsave(&host->irq_lock, irqflags);
>
> +       /*
> +        * If we're being called directly from dw_mci_enable_sdio_irq()
> +        * (which means that the client driver actually wants to enable or
> +        * disable interrupts) then save the request.  Otherwise this
> +        * wasn't directly requested by the client and we should logically
> +        * AND it with the client request since we want to disable if
> +        * _either_ the client disabled OR we have some other reason to
> +        * disable temporarily.
> +        */
> +       if (client_requested)
> +               host->client_sdio_enb = enb;
> +       else
> +               enb &= host->client_sdio_enb;
> +
>         /* Enable/disable Slot Specific SDIO interrupt */
>         int_mask = mci_readl(host, INTMASK);
>         if (enb)
> @@ -1688,7 +1703,7 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>         struct dw_mci_slot *slot = mmc_priv(mmc);
>         struct dw_mci *host = slot->host;
>
> -       __dw_mci_enable_sdio_irq(slot, enb);
> +       __dw_mci_enable_sdio_irq(slot, enb, true);
>
>         /* Avoid runtime suspending the device when SDIO IRQ is enabled */
>         if (enb)
> @@ -1701,7 +1716,7 @@ static void dw_mci_ack_sdio_irq(struct mmc_host *mmc)
>  {
>         struct dw_mci_slot *slot = mmc_priv(mmc);
>
> -       __dw_mci_enable_sdio_irq(slot, 1);
> +       __dw_mci_enable_sdio_irq(slot, true, false);
>  }
>
>  static int dw_mci_execute_tuning(struct mmc_host *mmc, u32 opcode)
> @@ -2734,7 +2749,7 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>                 if (pending & SDMMC_INT_SDIO(slot->sdio_id)) {
>                         mci_writel(host, RINTSTS,
>                                    SDMMC_INT_SDIO(slot->sdio_id));
> -                       __dw_mci_enable_sdio_irq(slot, 0);
> +                       __dw_mci_enable_sdio_irq(slot, false, false);
>                         sdio_signal_irq(slot->mmc);
>                 }
>
> @@ -3424,6 +3439,8 @@ int dw_mci_runtime_suspend(struct device *dev)
>  {
>         struct dw_mci *host = dev_get_drvdata(dev);
>
> +       __dw_mci_enable_sdio_irq(host->slot, false, false);
> +
>         if (host->use_dma && host->dma_ops->exit)
>                 host->dma_ops->exit(host);
>
> @@ -3490,6 +3507,8 @@ int dw_mci_runtime_resume(struct device *dev)
>         /* Now that slots are all setup, we can enable card detect */
>         dw_mci_enable_cd(host);
>
> +       __dw_mci_enable_sdio_irq(host->slot, true, false);
> +
>         return 0;
>
>  err:
> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
> index 46e9f8ec5398..dfbace0f5043 100644
> --- a/drivers/mmc/host/dw_mmc.h
> +++ b/drivers/mmc/host/dw_mmc.h
> @@ -127,6 +127,7 @@ struct dw_mci_dma_slave {
>   * @cmd11_timer: Timer for SD3.0 voltage switch over scheme.
>   * @cto_timer: Timer for broken command transfer over scheme.
>   * @dto_timer: Timer for broken data transfer over scheme.
> + * @client_sdio_enb: The value last passed to enable_sdio_irq.
>   *
>   * Locking
>   * =======
> @@ -234,6 +235,8 @@ struct dw_mci {
>         struct timer_list       cmd11_timer;
>         struct timer_list       cto_timer;
>         struct timer_list       dto_timer;
> +
> +       bool                    client_sdio_enb;
>  };
>
>  /* DMA ops for Internal/External DMAC interface */
> --
> 2.21.0.593.g511ec345e18-goog
>

Kind regards
Uffe
