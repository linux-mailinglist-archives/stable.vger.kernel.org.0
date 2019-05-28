Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D62EF2D1B1
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 00:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfE1Wts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 18:49:48 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:45708 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfE1Wtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 18:49:47 -0400
Received: by mail-yw1-f67.google.com with SMTP id w18so181914ywa.12
        for <stable@vger.kernel.org>; Tue, 28 May 2019 15:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sHhWRG5GPF0tvidqRSCNkdcMvjw5zPCw4zzwfMQUnUU=;
        b=WoM+oqlxfd+/VhoBHQmtOJC1XA63Zq9dmvl9RPpg4ebmrvwPWRdjy26/FxfV8nC/7g
         fhsk0tLyYpKEc6YdYTMWKLurwe4UU1lZ/Fo+HFx8l14uD/UM/ThOMkRZWphu6EBBZy9+
         XR3Wyup9ZfZw1cq9rhcV7HPH/MPFtYKRLg7VA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sHhWRG5GPF0tvidqRSCNkdcMvjw5zPCw4zzwfMQUnUU=;
        b=H/2yVvfASyorb+Ub8DsoStA3evjFXv01YLjbxMx8jABH6s7jTgxwuvSNK7kNpEon7G
         Dwrak0tzzJlLr7f5jOhelvgG4rVJjsyJPMKc7qQ24ING8qXOk+9FOlEhdD8QkaNLBsyZ
         i6cwgjm6lLRIlH1Ker+H+hiAIqhXX0JI/Yc3BXkz1sZglm7Mnh0iopIdGPkAsV75wssr
         QIyG2q/oLk3OptfFXybEb3o02SamJMPr7HPtX+7/o4ZFEOjv3WDXKu3LjMf1BN7cSx+l
         ZP6RPp2IVmv/TjPZGG0JA4ECajSMDN4u4LO8RfikKPhJ03Yy4yNSoqbD3UcStQ5Nwynd
         5Uww==
X-Gm-Message-State: APjAAAVkktnHOcwsaonQ1zUjC8pEcFQOYdm8/5t0hfeW1egVvV5njpqu
        LkO5QNHvFxAJeCa6nX/TzbnIsrDbq1k=
X-Google-Smtp-Source: APXvYqxIn+vx9NiI1Kcn5CK5BzJhOhCq9CpPrjyzfn2BcQjqRRQok4TvAeSKG3uIFBJ7y3GlgIxOJg==
X-Received: by 2002:a81:2506:: with SMTP id l6mr61371295ywl.325.1559083786463;
        Tue, 28 May 2019 15:49:46 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id 205sm2033037ywu.84.2019.05.28.15.49.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 15:49:46 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id a3so52887ybr.6
        for <stable@vger.kernel.org>; Tue, 28 May 2019 15:49:45 -0700 (PDT)
X-Received: by 2002:a25:25c4:: with SMTP id l187mr19641708ybl.345.1559083785254;
 Tue, 28 May 2019 15:49:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190429204040.18725-1-dianders@chromium.org> <CAPDyKFp0fQ+3CS-DadE9rO-9Npzve-nztY9hRaMdX7Pw9sUZMw@mail.gmail.com>
In-Reply-To: <CAPDyKFp0fQ+3CS-DadE9rO-9Npzve-nztY9hRaMdX7Pw9sUZMw@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 28 May 2019 15:49:28 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XMph_CE3pFZGP+5d0K2FgbPbheF1oX72TfZn_dpf8SQA@mail.gmail.com>
Message-ID: <CAD=FV=XMph_CE3pFZGP+5d0K2FgbPbheF1oX72TfZn_dpf8SQA@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: Disable SDIO interrupts while suspended
 to fix suspend/resume
To:     Ulf Hansson <ulf.hansson@linaro.org>
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

Hi,

On Tue, May 28, 2019 at 12:22 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Mon, 29 Apr 2019 at 22:41, Douglas Anderson <dianders@chromium.org> wrote:
> >
> > Processing SDIO interrupts while dw_mmc is suspended (or partly
> > suspended) seems like a bad idea.  We really don't want to be
> > processing them until we've gotten ourselves fully powered up.
>
> I fully agree.
>
> Although, this is important not only from the host driver/controller
> perspective, but also from the SDIO card (managed by mmc core) point
> of view.
>
> In $subject patch you mange the driver/controller issue, but only for
> one specific host driver (dw_mmc). I am thinking that this problem may
> be a rather common problem, so perhaps we should try to address this
> from the core in a way that it affects all host drivers. Did you
> consider that?

I did wonder that.  See below, but in general I don't have massive
experience with all the host controllers out there.  Looking at sdhci
code, though, it might not have the same problems?  At least in some
cases it fully turns off the interrupts.  In other cases it seems like
the controller itself keeps power and so maybe getting the SDIO
interrupts early is OK?


> The other problem I refer to, is in principle a way to prevent
> sdio_run_irqs() from being executed before the SDIO card has been
> resumed, via mmc_sdio_resume(). It's a separate problem, but certainly
> related. This may need some more thinking to address properly, let's
> just keep this in mind and discuss this in a separate thread.

Actually, I think if we could figure out how to do this well it might
solve my particular problem.  Specifically I don't believe that
running dw_mmc's interrupt handler itself is causing the problem
(though it does seem pretty odd to run it while we're in the middle of
initting the host), I think it's the SDIO driver calling back into us
that's causing the problems.


> > You might be wondering how it's even possible to become suspended when
> > an SDIO interrupt is active.  As can be seen in
> > dw_mci_enable_sdio_irq(), we explicitly keep dw_mmc out of runtime
> > suspend when the SDIO interrupt is enabled.  ...but even though we
> > stop normal runtime suspend transitions when SDIO interrupts are
> > enabled, the dw_mci_runtime_suspend() can still get called for a full
> > system suspend.
> >
> > Let's handle all this by explicitly masking SDIO interrupts in the
> > suspend call and unmasking them later in the resume call.  To do this
> > cleanly I'll keep track of whether the client requested that SDIO
> > interrupts be enabled so that we can reliably restore them regardless
> > of whether we're masking them for one reason or another.
> >
> > It should be noted that if dw_mci_enable_sdio_irq() is never called
> > (for instance, if we don't have an SDIO card plugged in) that
> > "client_sdio_enb" will always be false.  In those cases this patch
> > adds a tiny bit of overhead to suspend/resume (a spinlock and a
> > read/write of INTMASK) but other than that is a no-op.  The
> > SDMMC_INT_SDIO bit should always be clear and clearing it again won't
> > hurt.
>
> Thanks for the detailed problem description. In general your approach
> sounds okay to me, but I have a few questions.
>
> 1) As kind of stated above, did you consider a solution where the core
> simply disables the SDIO IRQ in case it isn't enabled for system
> wakeup? In this way all host drivers would benefit.

I can give it a shot if you can give me a bunch of specific advice,
but I only have access to a few devices doing anything with SDIO and
they are all using Marvell or Broadcom on dw_mmc.

In general I have no idea how SDIO wakeup (plumbed through the SD
controller) would work.  As per below the only way I've seen it done
is totally out-of-band.  ...and actually, I'm not sure I've actually
ever seen even the out of band stuff truly work on a system myself.
It's always been one of those "we should support wake on WiFi" but
never made it all the way to implementation.  In any case, if there
are examples of people plumbing wakeup through the SD controller I'd
need to figure out how to not break them.  Just doing a solution for
dw_mmc means I don't have to worry about this since dw_mmc definitely
doesn't support SDIO wakeup.

Maybe one way to get a more generic solution is if you had an idea for
a patch that would work for many host controllers then you could post
it and I could test to confirm that it's happy on dw_mmc?  ...similar
to when you switched dw_mmc away from the old kthread-based SDIO
stuff?


> 2) dw_mmc isn't calling device_init_wakeup() during ->probe(), hence I
> assume it doesn't support the SDIO IRQ being configured as system
> wakeup. Correct? I understand this is platform specific, but still it
> would be good to know your view.

Right, currently dw_mmc doesn't support the SDIO IRQ being configured
as a system wakeup.  I'm kinda curious how this works in general.
Don't you need a clock running to get an SDIO interrupt?  How does
that work for suspend?  ...I do know that I've seen some dw_mmc host
controllers have an "SDIO IRQ" line that could be pinned out and that
line would also assert the same SDIO interrupt, but the mainline
driver has never supported it.  Whenever I asked Marvell about it in
the past they were always confused about what to do with that line and
(if I remember correctly) we never hooked it up.  I always though it
would be super interesting because it seemed like it would let us
disable the card clock when the slot was idle.  ...as far as I was
ever able to discern the pin was officially "non-standard".

As far as I know SDIO cards that want to be able to wakeup the device
end up using some sort of out of band mechanism.  For instance
"marvell,wakeup-pin" or Broadcom's "host-wake" interrupt.  As per
above, I don't have tons of experience here.  I see that
"rk3399-gru-kevin" has "marvell,wakeup-pin" defined, but that's PCIe
not SDIO.  Downstream in our Chrome OS kernel it seems like
"mt8173-oak.dtsi" and "mt8176-rowan.dtsi" have this for SDIO but they
are are devices I didn't work on and don't have much familiarity with.


> 3) Because of 2) The below code in dw_mci_runtime_suspend(), puzzles me:
> "if (host->slot->mmc->pm_flags & MMC_PM_KEEP_POWER)"
>        dw_mci_set_ios(host->slot->mmc, &host->slot->mmc->ios);
>
> Why is 3) needed at all in case system wakeup isn't supported?

That code has been in there for a really long time, dating back to
commit ab269128a2cf ("mmc: dw_mmc: Add sdio power bindings").  ...but,
in general, I know that we always keep power to the SDIO card in
suspend time.  This doesn't take a whole lot of power and speeds up
WiFi acquisition after resume by a whole lot (because otherwise we'd
have to fully re-load the WiFi firmware).  In fact, I believe that the
Marvell WiFi driver requires it.  Ah yes, search for
"MMC_PM_KEEP_POWER" in "marvell/mwifiex/sdio.c" and you'll see that it
gets yells if power isn't kept.

If we are keeping power during suspend/resume then presumably the card
will expect that communication resumes as normal upon resume.  AKA:
the clock should come up at the expected rate / voltage level and we
should resume as normal.


> A note; the current support in the mmc core for the SDIO IRQ being
> used as system wakeup, really needs some re-work. For example, we
> should convert to use common wakeup interfaces, as to allow the PM
> core to behave correctly during system suspend/resume. These are
> changes that have been scheduled on my TODO list since long time ago,
> I hope I can get some time to look into them soon.

Personally my knowledge of SD / SDIO is mostly acquired by trying to
make the dw_mmc driver do what we've needed it to over the years, so I
don't actually have a ton of broad understanding of the SDIO spec and
what is generally done for host controllers / SDIO cards.  If you're
aware of standard ways to get an SDIO IRQ to work in suspend time then
that'd be interesting.


> > Without this fix it can be seen that rk3288-veyron Chromebooks with
> > Marvell WiFi would sometimes fail to resume WiFi even after picking my
> > recent mwifiex patch [1].  Specifically you'd see messages like this:
> >   mwifiex_sdio mmc1:0001:1: Firmware wakeup failed
> >   mwifiex_sdio mmc1:0001:1: PREP_CMD: FW in reset state
> >
> > ...and tracing through the resume code in the failing cases showed
> > that we were processing a SDIO interrupt really early in the resume
> > call.
> >
> > NOTE: downstream in Chrome OS 3.14 and 3.18 kernels (both of which
> > support the Marvell SDIO WiFi card) we had a patch ("CHROMIUM: sdio:
> > Defer SDIO interrupt handling until after resume") [2].  Presumably
> > this is the same problem that was solved by that patch.
>
> Seems reasonable.

Anyway, let me know what you think the next set of steps ought to be.
It would be sorta nice to get suspend/resume working reliably and land
this patch, but if you think that will impede our ability to come up
with a more generic solution then I guess we don't need to land it...


-Doug
