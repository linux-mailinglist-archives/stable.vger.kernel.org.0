Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE20C43E18
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732447AbfFMPrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:47:32 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:34515 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731757AbfFMJaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 05:30:09 -0400
Received: by mail-ua1-f66.google.com with SMTP id c4so2580818uad.1
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 02:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dPa72g8ADOpM0ZxpsGvqpjEmyUt4v+QjG+bVcORJbcI=;
        b=qLFx15u1Yty0zsAzoUOq0rf+KbBHb5/in8gyY74bBSaTflA8E1Pusw0msCRxg1f37a
         1QKQMOPIJTKglGICyyELfhUJ/wQ/1Lu8RDKEmjf7UMTZnBsPN1azkFifx1KhWnTIL42M
         cgcLER0GvhMHygbruAWp0GVB+HnFgc8PN2NCjQdMVq69FXuORiXEJfQ6/LhEeUcTS/Gi
         97HqN+ICIwUw12cipzcY25OdemnwpA8w03JFnD8SIfSrLpj0Ak8cqmZHiFLrbqCDU09Z
         Rr1PGAzhqH98ZkTftSwWOUFua3NyrvM/SbTDB14/JxUhCg2GXQlfccA2H0JCfc/v5cEu
         SrWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dPa72g8ADOpM0ZxpsGvqpjEmyUt4v+QjG+bVcORJbcI=;
        b=JumBV+dGvNir2rddTOG9yT+htWlM8eQU444hHYCUoDApEDokvh546dDRrpmM4jy4I7
         BmZ0eH/7SNdEiNrMm0MmbFE3qbdc0RWThzUtR7qzg0gJUTY+YC8XoxtOFA/0ZPHtMtDP
         80ao5bI+8wV2EIXC+kQ4ruXVkBnh4hHBjCg5YRM5511CVy1breHSBKzwU7ZcFtcgHnIC
         nrZv21JYp52KLlXmLS6xopAAWVjvWr2Ovcq4i37Yp6t91/U/CYRt58VMOhRdA8IKE9B8
         4LzI4zn5eLZXpfXlhd/uuZurXBBD8d6I8jSekUjAzo1POaEovMwS/INZU90XkWLRBUAJ
         2Zkw==
X-Gm-Message-State: APjAAAU8smYiCHwkdjv446w5tpGsmpLJ6iR3BCwJWoNAugPxD1G7XiEA
        gdSUua9eem0ZT3+YSkPkG546VJ89FmA+Vp95AzuNdg==
X-Google-Smtp-Source: APXvYqysdwXSOCNEldjb5LKU+pKlg2cmkzbGg45GyytHDdl2rZ+Ospq2CWbdizDeVFbwhe4+AepHFd1wDztUHRyJBtE=
X-Received: by 2002:ab0:1309:: with SMTP id g9mr17640889uae.129.1560418208288;
 Thu, 13 Jun 2019 02:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190611123221.11580-1-ulf.hansson@linaro.org> <CAD=FV=XBVRsdiOD0vhgTvMXmqm=fzy9Bzd_x=E1TNPBsT_D-tQ@mail.gmail.com>
In-Reply-To: <CAD=FV=XBVRsdiOD0vhgTvMXmqm=fzy9Bzd_x=E1TNPBsT_D-tQ@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 13 Jun 2019 11:29:31 +0200
Message-ID: <CAPDyKFqR-xSKdYZYBTK5kKOt1dk7dx_BjedHiDOKs7-X4od=dg@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: Prevent processing SDIO IRQs when the card is suspended
To:     Doug Anderson <dianders@chromium.org>
Cc:     Linux MMC List <linux-mmc@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Brian Norris <briannorris@chromium.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Guenter Roeck <groeck@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 13 Jun 2019 at 00:20, Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Tue, Jun 11, 2019 at 5:32 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >
> > Processing of SDIO IRQs must obviously be prevented while the card is
> > system suspended, otherwise we may end up trying to communicate with an
> > uninitialized SDIO card.
> >
> > Reports throughout the years shows that this is not only a theoretical
> > problem, but a real issue. So, let's finally fix this problem, by keeping
> > track of the state for the card and bail out before processing the SDIO
> > IRQ, in case the card is suspended.
> >
> > Cc: stable@vger.kernel.org
> > Reported-by: Douglas Anderson <dianders@chromium.org>
> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > ---
> >
> > This has only been compile tested so far, any help for real test on HW is
> > greatly appreciated.
>
> Thanks for sending this!

Thanks for you detailed reply - with a hole bunch of good thoughts and results!

>
>
> > Note that, this is only the initial part of what is needed to make power
> > management of SDIO card more robust, but let's start somewhere and continue to
> > improve things.
> >
> > The next step I am looking at right now, is to make sure the SDIO IRQ is turned
> > off during system suspend, unless it's supported as a system wakeup (and enabled
> > to be used).
>
> My gut says that the partway solution is going to be a problem on some
> controllers / systems, even though it seems to work OK on mine.  See
> my thoughts below and let me know what you think.
>
>
> > ---
> >  drivers/mmc/core/sdio.c     | 7 +++++++
> >  drivers/mmc/core/sdio_irq.c | 4 ++++
> >  2 files changed, 11 insertions(+)
> >
> > diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> > index d1aa1c7577bb..9951295d3220 100644
> > --- a/drivers/mmc/core/sdio.c
> > +++ b/drivers/mmc/core/sdio.c
> > @@ -937,6 +937,10 @@ static int mmc_sdio_pre_suspend(struct mmc_host *host)
> >   */
> >  static int mmc_sdio_suspend(struct mmc_host *host)
> >  {
> > +       /* Prevent processing of SDIO IRQs in suspended state. */
> > +       mmc_card_set_suspended(host->card);
>
> Do you need to claim / release the host around the call to
> mmc_card_set_suspended() to avoid races?

The intent is that the races should be taken care of like this:
1) In MMC_CAP2_SDIO_IRQ_NOTHREAD case, the call to
cancel_delayed_work_sync() below, will make sure that if there are any
new work scheduled beyond that point, mmc_card_suspended() will be set
and process_sdio_pending_irqs() will bail out.

2. In the non MMC_CAP2_SDIO_IRQ_NOTHREAD case, the call to
mmc_claim_host() below will make sure if there is any new attempt to
claim the host from the kthread, mmc_card_suspended() will be set and
process_sdio_pending_irqs() bails out.

Ideally in the long run and want to remove the SDIO kthread, so
perhaps this is good enough for now, what do you think?

BTW, the important point is that the call to
cancel_delayed_work_sync(), must not be done while keeping the host
claimed, as then it could deadlock.

>
>
>
> > +       cancel_delayed_work_sync(&host->sdio_irq_work);
> > +
> >         mmc_claim_host(host);
> >
> >         if (mmc_card_keep_power(host) && mmc_card_wake_sdio_irq(host))
> > @@ -985,6 +989,9 @@ static int mmc_sdio_resume(struct mmc_host *host)
> >                 err = sdio_enable_4bit_bus(host->card);
> >         }
> >
> > +       /* Allow SDIO IRQs to be processed again. */
> > +       mmc_card_clr_suspended(host->card);
> > +
>
> Do you need to check for "!err" before calling
> mmc_card_clr_suspended()?  ...or add an "if (err) goto exit" type
> thing and get rid of the "!err" check below?

I was lazy. Good point!

>
>
> >         if (!err && host->sdio_irqs) {
> >                 if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD))
> >                         wake_up_process(host->sdio_irq_thread);
> > diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
> > index 931e6226c0b3..9f54a259a1b3 100644
> > --- a/drivers/mmc/core/sdio_irq.c
> > +++ b/drivers/mmc/core/sdio_irq.c
> > @@ -34,6 +34,10 @@ static int process_sdio_pending_irqs(struct mmc_host *host)
> >         unsigned char pending;
> >         struct sdio_func *func;
> >
> > +       /* Don't process SDIO IRQs if the card is suspended. */
> > +       if (mmc_card_suspended(card))
> > +               return 0;
> > +
>
> Is it really OK to just return like this?  I guess there are two
> (somewhat opposite) worries I'd have.  See A) and B) below:

Let me comment on A) and B) below, for sure there are more problems to address.

The main reason to why I think it's okay to bail out here, is because
I think it still improves the current behavior a lot. So, rather than
solving all problems at once, I wanted to take a step by step
approach.

>
> A) Do we need to do anything extra to make sure we actually call the
> interrupt handler after we've resumed?  I guess we can't actually
> "lose" the interrupt since it will be sitting asserted in CCCR_INTx
> until we deal with it (right?), but maybe we need to do something to
> ensure the handler gets called once we're done resuming?

Good point!

Although, it also depends on if we are going to power off the SDIO
card or not. In other words, if the SDIO IRQ are configured as a
system wakeup.

Moreover there is another related problem, if the SDIO IRQ are
configured as a system wakeup, and if there is an IRQ raised during
the system suspend process, the system suspend process should be
aborted but it may not. This is another issue that currently isn't
supported. The PM core helps to deals with this, but to take advantage
of that, the host controller device device must be configured via the
common wakeup interfaces, such as the device_init_wakeup(), for
example.

>
> A1) old SDIO thread case
>
> I think we'll be OK in the old SDIO thread case.  We'll call
> wake_up_process() after we clear the suspended state and then we'll
> either see "sdio_irq_pending" was set to true or we'll poll CCCR_INTx.

Good point. I keep this observation in mind about the sdio_irq_pending
flag, when going forward.

>
> --
>
> A2): new MMC_CAP2_SDIO_IRQ_NOTHREAD case
>
> Should we do something to re-kick things?  We could call
> sdio_signal_irq() in mmc_sdio_resume() I guess?  I was worried that
> might conflict with those that call sdio_run_irqs() directly but it
> seems like that's nobody as of commit 89f3c365f3e1 ("mmc: sdhci: Fix
> SDIO IRQ thread deadlock").

Good point!

Again, whether we should re-kick things depends on if the SDIO IRQ is
configured as wakeup, but in general using sdio_signal_irq() should
work.

The other part I am considering is to disable the SDIO irq, in case of
"mmc_card_keep_power() && !mmc_card_wake_sdio_irq()".

Moreover, if !mmc_card_keep_power(), then there really shouldn't be
any IRQs registered so perhaps we should add a special check for that
and return an error code.

In regards to other callers of sdio_run_irqs(). I have a patch that
makes it this function static, as it really should not need to be used
other than from the work queue path. Let me post it asap to cover that
gap. Again, thanks for pointing this out!

>
> NOTE: I put a bunch of debug printouts and I'm fairly convinced that
> this is a real problem.  Sort of.  Specifically I confirmed that in
> dw_mmc the SDIO interrupt seems to be treated as an edge-triggered
> interrupt.  AKA: in dw_mci_interrupt() when we write to "RINTSTS" as
> we're handling the interrupt the interrupt immediately stops
> asserting.  It doesn't actually fire again until the Marvell SDIO
> resume functions run.  I didn't dig enough to figure out what
> specifically makes the interrupt fire again in the Marvell resume
> functions, but it seems a little concerning that we're relying on
> something in that driver to re-kick the host controller interrupt.

I fully agree, the re-kick thingy is definitely needed.

>
> ...side note: overall looking at this code path, two additional
> questions come up for me.  One is why sdio_run_irqs() hardcodes
> "sdio_irq_pending" as true.  That means we won't _ever_ poll CCCR_INTx
> in the 1-function case, right?  That seems wrong.  The other is why

In the 1-function case, the idea is that we don't have to read the
CCCR_INTx to find out what func number the IRQ belongs to.

This is the same behavior consistent as with the kthread case, see
mmc_signal_sdio_irq(), unless I am mistaken.

> mmc_sdio_resume() always calls host->ops->enable_sdio_irq(host, 1) at
> resume time when nobody ever turned the IRQs off.

That's correct and it leads to unbalanced calls of
host->ops->enable_sdio_irq(). This needs to be fixed as well.

>
> ===
>
> B) Are there any instances where the interrupt will just keep firing
> over and over again because we don't handle it?
>
> As per above, this _isn't_ happening on dw_mmc on my setup because
> dw_mmc seems to treat the SDIO interrupt as edge triggered.  ...but is
> this true everywhere?  If we were using SDIO in 1-bit mode on dw_mmc,
> would the interrupt re-assert right away?  If dw_mmc were configured
> to use a dedicated pin would it re-assert right away?  What about
> other host controllers?
>
> If you're sure no host controllers will keep asserting the interrupt
> over and over then I guess we don't need to worry about it?
> ...otherwise we'd need to find some way to mask the interrupt and we'd
> need to make sure whatever we do doesn't interfere with anyone who
> supports the SDIO interrupt as a wake source, right?

For the MMC_CAP2_SDIO_IRQ_NOTHREAD case, the expected behavior by the
host driver is to prior calling sdio_signal_irq(), is should temporary
disable the SDIO IRQ. Then, when the host->ops->ack_sdio_irq is called
from the work, the IRQ has been processed, which tells the host driver
to re-enable the SDIO IRQ.

In the kthread case, this is managed by mmc_signal_sdio_irq() and the
sdio_irq_thread() that calls host->ops->enable_sdio_irq() both to
enable/disable the IRQ (but there are other problems with that).

>
> ======
>
> Overall, I can confirm that on my system your patch actually does
> work.  ...so if all of the above concerns are moot and won't cause
> anyone else problems then I can say that they don't seem to cause any
> problems on my system.  On rk3288-veyron-jerry:
>
> - Before your patch, I got failures at iteration 18, then 32, then 55,
> then 7, then 26.
>
> - After your patch I could do 100 iterations of suspend/resume with no
> failures.  I also put printouts to confirm your patch was having an
> effect.

Great news, thanks a lot for testing and sharing these result.

One more thing to consider. After the system suspend callback have
been called for the mmc host driver (assuming SDIO IRQ isn't
configured as system wakeup), the host driver shouldn't really receive
SDIO IRQs and nor should it signal them via sdio_signal_irq(), simply
because it has suspended its device/controller and beyond that point,
the behavior might be undefined. Can you check to see if this is
happening, or possibly you already know that this is the case and that
we are "lucky"?

>
>
> I also confirmed that rk3288-veyron-minnie (which has Broadcom WiFi) I
> could still suspend/resume fine with your patch.

Great news, clearly we are moving forward. :-)

Let me address your comment and post a new version.

Kind regards
Uffe
