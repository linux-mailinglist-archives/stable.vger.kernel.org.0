Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A96345BED
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 13:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfFNL4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 07:56:32 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:39197 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfFNL4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 07:56:32 -0400
Received: by mail-ua1-f66.google.com with SMTP id j8so838861uan.6
        for <stable@vger.kernel.org>; Fri, 14 Jun 2019 04:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QwyZSg6qYvCyeDtTaFz2JZBhYx8SM54kL3EoJWJAemU=;
        b=X58lxYWyhkRVeWQUdA+jz0cFcZ3ryNYJyNfHMyw570sX6G8F+oCR3CRrc3XT4qha8W
         K0EUovEBGpYjK2DOHaKJbiskJ938qdPBWFW8w5kY3Z9klpH+8pztIU0k42YBgRg7done
         SFjRZHr0Kixtrh/xGNckr2r1EhXPNl939fKo/QN9Y2ekGZAps+Jj1ZtPvlkOCgJ8dhkP
         ZqdHYssPRucWN383Vx4noznB0jhqRtyF710yfKcevNjAksdzJgNNXM4JtBfQKsN3GOZ+
         x8aZrL+MWdsuiTiShJ4Jn4xcRyuaQ0HDerb+ETNNOyDBI18pitjqN81qLvVvBuPD62yt
         LUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QwyZSg6qYvCyeDtTaFz2JZBhYx8SM54kL3EoJWJAemU=;
        b=MYLxSoD+bjtxbz9T18V05Im62I5s6rzb0mHFS1rY4E/FmNIbnR020HAn449+ueoILQ
         mdsZVhhSH82WqFzycANRJyTwGiTxdcue62bxZHlI92I9Ytq8rHosgwfNzN469ZPR0BzJ
         ILerNWHIjyWE22wGyQYxAX73J0adE9eATLwwjz/iMwkSXuwshm4AmFS7ULWynllqTu+w
         IIhoXfK6MCC1APH9DQP/24CbqfoTiyKLmei5ciavRqypOWOwGdk7E9EVih2aggap01Ql
         H8Wq9YpSj3/1ofFVtfKUSi2E/9Rjvc3JEc9XEp+aXCtWu0ui4832Nbp4XkCvW+/I7ev2
         6A8A==
X-Gm-Message-State: APjAAAWbzQld3a9DZM5ng/zfJRvFaxVjJBgmc7wVy6zF3u1qoShzDs+Y
        HFYi5i7Gi1h1JcD9mcXfWQylAmjPAOkrNoQwMHFngw==
X-Google-Smtp-Source: APXvYqyOyL2AJ4TST+WfLOMKlCZHEGvw/P/o+IYVMRLbr9MYLxeGoTyNqC6QA2/D0Rwbgd6a1LWd29QlVhZ1T9UACgE=
X-Received: by 2002:a9f:31a2:: with SMTP id v31mr26177035uad.15.1560513390502;
 Fri, 14 Jun 2019 04:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190611123221.11580-1-ulf.hansson@linaro.org>
 <CAD=FV=XBVRsdiOD0vhgTvMXmqm=fzy9Bzd_x=E1TNPBsT_D-tQ@mail.gmail.com>
 <CAPDyKFqR-xSKdYZYBTK5kKOt1dk7dx_BjedHiDOKs7-X4od=dg@mail.gmail.com> <CAD=FV=WODbZa1fBrLbJBsd77xn5ekHWjks-ydxOSzjdBK83Rmg@mail.gmail.com>
In-Reply-To: <CAD=FV=WODbZa1fBrLbJBsd77xn5ekHWjks-ydxOSzjdBK83Rmg@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 14 Jun 2019 13:55:54 +0200
Message-ID: <CAPDyKFpqk4ZcVTqifnbnW1WgNfx9ZNebCttUPcK_e9KWqpDMjQ@mail.gmail.com>
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

On Thu, 13 Jun 2019 at 20:05, Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Thu, Jun 13, 2019 at 2:30 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >
> > > > @@ -937,6 +937,10 @@ static int mmc_sdio_pre_suspend(struct mmc_host *host)
> > > >   */
> > > >  static int mmc_sdio_suspend(struct mmc_host *host)
> > > >  {
> > > > +       /* Prevent processing of SDIO IRQs in suspended state. */
> > > > +       mmc_card_set_suspended(host->card);
> > >
> > > Do you need to claim / release the host around the call to
> > > mmc_card_set_suspended() to avoid races?
> >
> > The intent is that the races should be taken care of like this:
> > 1) In MMC_CAP2_SDIO_IRQ_NOTHREAD case, the call to
> > cancel_delayed_work_sync() below, will make sure that if there are any
> > new work scheduled beyond that point, mmc_card_suspended() will be set
> > and process_sdio_pending_irqs() will bail out.
> >
> > 2. In the non MMC_CAP2_SDIO_IRQ_NOTHREAD case, the call to
> > mmc_claim_host() below will make sure if there is any new attempt to
> > claim the host from the kthread, mmc_card_suspended() will be set and
> > process_sdio_pending_irqs() bails out.
> >
> > Ideally in the long run and want to remove the SDIO kthread, so
> > perhaps this is good enough for now, what do you think?
>
> I was more worried about the safety of mmc_card_set_suspended()
> itself.  That is:
>
> #define mmc_card_set_suspended(c) ((c)->state |= MMC_STATE_SUSPENDED)
>
> ...so it's doing a read-modify-write of "state".  Is that safe to do
> without any type of locking?

In this case, yes I think so.

The point is, it really doesn't matter if the reader (work or thread),
reads a non-updated value, because the synchronization is managed by
the later mmc_claim_host() and the cancel_delayed_work_sync().

>
>
> > BTW, the important point is that the call to
> > cancel_delayed_work_sync(), must not be done while keeping the host
> > claimed, as then it could deadlock.
>
> Definitely.  I was thinking of this sequence:
>
> mmc_claim_host(host);
> mmc_card_set_suspended(host->card);
> mmc_release_host(host);
>

This would work, but claiming/releasing the host is just unnecessary
and "expensive".

> cancel_delayed_work_sync(&host->sdio_irq_work);
>
> mmc_claim_host(host);
>
>
> > > >         if (!err && host->sdio_irqs) {
> > > >                 if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD))
> > > >                         wake_up_process(host->sdio_irq_thread);
> > > > diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
> > > > index 931e6226c0b3..9f54a259a1b3 100644
> > > > --- a/drivers/mmc/core/sdio_irq.c
> > > > +++ b/drivers/mmc/core/sdio_irq.c
> > > > @@ -34,6 +34,10 @@ static int process_sdio_pending_irqs(struct mmc_host *host)
> > > >         unsigned char pending;
> > > >         struct sdio_func *func;
> > > >
> > > > +       /* Don't process SDIO IRQs if the card is suspended. */
> > > > +       if (mmc_card_suspended(card))
> > > > +               return 0;
> > > > +
> > >
> > > Is it really OK to just return like this?  I guess there are two
> > > (somewhat opposite) worries I'd have.  See A) and B) below:
> >
> > Let me comment on A) and B) below, for sure there are more problems to address.
> >
> > The main reason to why I think it's okay to bail out here, is because
> > I think it still improves the current behavior a lot. So, rather than
> > solving all problems at once, I wanted to take a step by step
> > approach.
> >
> > >
> > > A) Do we need to do anything extra to make sure we actually call the
> > > interrupt handler after we've resumed?  I guess we can't actually
> > > "lose" the interrupt since it will be sitting asserted in CCCR_INTx
> > > until we deal with it (right?), but maybe we need to do something to
> > > ensure the handler gets called once we're done resuming?
> >
> > Good point!
> >
> > Although, it also depends on if we are going to power off the SDIO
> > card or not. In other words, if the SDIO IRQ are configured as a
> > system wakeup.
>
> Even if it's not a system wakeup, we still don't want to drop the
> interrupt on the ground though, do we?  For instance, think about a
> level-triggered GPIO interrupt that's _not_ a wakeup interrupt.  If
> that gets asserted in suspend then we won't wakeup the system, but as
> soon as the system gets to a certain point in the resume sequence then
> we should pass the interrupt on to the handler.  If an edge triggered
> (but non-wakeup) interrupt fires when the system is resuming then we
> should similarly not drop it, should we?

GPIOs is clearly different.

When it comes to SDIO cards, re-playing/re-kicking an SDIO IRQ doesn't
make sense in case the SDIO card was powered off during system
suspend. The reason is simply because the internal state inside the
SDIO card gets lost at a power off. For example, the used SDIO func
number, needs to re-enabled before any SDIO IRQs can be delivered for
it.

So yes, I really think we should drop the SDIO IRQ, unless it's
configured as a wakeup. Simply because it's not valid after the system
has resumed.

>
>
> > Moreover there is another related problem, if the SDIO IRQ are
> > configured as a system wakeup, and if there is an IRQ raised during
> > the system suspend process, the system suspend process should be
> > aborted but it may not. This is another issue that currently isn't
> > supported. The PM core helps to deals with this, but to take advantage
> > of that, the host controller device device must be configured via the
> > common wakeup interfaces, such as the device_init_wakeup(), for
> > example.
>
> As per earlier discussions I don't have any good examples of SDIO IRQs
> being able to wakeup the device to poke at.  ...but from GPIO-based
> wakeups I'm used to the suspend code masking the interrupt (so it
> doesn't fire anymore after the suspend call) but leaving it enabled
> and configured as a wakeup.  I guess we'd have to think about how that
> translates.  Your patch seems to be acting as a "mask" of the
> interrupt, at least on my dw_mmc tests where the hardware presents the
> interrupt like it was edge triggered.  ...so it would work OK there
> I'd guess.
>
>
> > > A2): new MMC_CAP2_SDIO_IRQ_NOTHREAD case
> > >
> > > Should we do something to re-kick things?  We could call
> > > sdio_signal_irq() in mmc_sdio_resume() I guess?  I was worried that
> > > might conflict with those that call sdio_run_irqs() directly but it
> > > seems like that's nobody as of commit 89f3c365f3e1 ("mmc: sdhci: Fix
> > > SDIO IRQ thread deadlock").
> >
> > Good point!
> >
> > Again, whether we should re-kick things depends on if the SDIO IRQ is
> > configured as wakeup, but in general using sdio_signal_irq() should
> > work.
> >
> > The other part I am considering is to disable the SDIO irq, in case of
> > "mmc_card_keep_power() && !mmc_card_wake_sdio_irq()".
> >
> > Moreover, if !mmc_card_keep_power(), then there really shouldn't be
> > any IRQs registered so perhaps we should add a special check for that
> > and return an error code.
>
> I haven't looked through all the details here but I can dig if you
> want.  On other drivers it's generally OK to leave your interrupt
> registered (just disabled and/or masked) across suspend/resume, but
> maybe that's not OK for SDIO cards without keep power?

In the end this boils done to dividing the responsibility of whom does
what, at the different layers.

Restoring power to an SDIO card, often ends up with the SDIO func
driver having to re-load a FW and perhaps apply some initial HW
settings for the corresponding chip.

That said, having the mmc core via mmc_sdio_suspend|resume(), to deal
with disable/enable of the SDIO IRQs (and the SDIO func number), seems
like doing things upside-down. It may not even work correctly, until
the chip have been programmed with a new FW.

>
>
> > In regards to other callers of sdio_run_irqs(). I have a patch that
> > makes it this function static, as it really should not need to be used
> > other than from the work queue path. Let me post it asap to cover that
> > gap. Again, thanks for pointing this out!
>
> Yeah, I was thinking of posting that too, but happy to have you do it!  :-)
>
>
> > > ...side note: overall looking at this code path, two additional
> > > questions come up for me.  One is why sdio_run_irqs() hardcodes
> > > "sdio_irq_pending" as true.  That means we won't _ever_ poll CCCR_INTx
> > > in the 1-function case, right?  That seems wrong.  The other is why
> >
> > In the 1-function case, the idea is that we don't have to read the
> > CCCR_INTx to find out what func number the IRQ belongs to.
> >
> > This is the same behavior consistent as with the kthread case, see
> > mmc_signal_sdio_irq(), unless I am mistaken.
>
> I think there's at least the bug that nothing will ever set
> "sdio_irq_pending" to false in the MMC_CAP2_SDIO_IRQ_NOTHREAD case,
> right?  So we'll set it to true the first time and from then on out it
> will never be false again?

Right.

Although, I consider this a different problem (dealing with the things
we have discussed above) and it seems like we should address that as
additional changes on top.

>
>
> > > mmc_sdio_resume() always calls host->ops->enable_sdio_irq(host, 1) at
> > > resume time when nobody ever turned the IRQs off.
> >
> > That's correct and it leads to unbalanced calls of
> > host->ops->enable_sdio_irq(). This needs to be fixed as well.
> >
> > >
> > > ===
> > >
> > > B) Are there any instances where the interrupt will just keep firing
> > > over and over again because we don't handle it?
> > >
> > > As per above, this _isn't_ happening on dw_mmc on my setup because
> > > dw_mmc seems to treat the SDIO interrupt as edge triggered.  ...but is
> > > this true everywhere?  If we were using SDIO in 1-bit mode on dw_mmc,
> > > would the interrupt re-assert right away?  If dw_mmc were configured
> > > to use a dedicated pin would it re-assert right away?  What about
> > > other host controllers?
> > >
> > > If you're sure no host controllers will keep asserting the interrupt
> > > over and over then I guess we don't need to worry about it?
> > > ...otherwise we'd need to find some way to mask the interrupt and we'd
> > > need to make sure whatever we do doesn't interfere with anyone who
> > > supports the SDIO interrupt as a wake source, right?
> >
> > For the MMC_CAP2_SDIO_IRQ_NOTHREAD case, the expected behavior by the
> > host driver is to prior calling sdio_signal_irq(), is should temporary
> > disable the SDIO IRQ. Then, when the host->ops->ack_sdio_irq is called
> > from the work, the IRQ has been processed, which tells the host driver
> > to re-enable the SDIO IRQ.
>
> So what I'm imagining is this:
>
> 1. mmc_sdio_suspend() starts; calls mmc_card_set_suspended() and
> cancel_delayed_work_sync().
>
> 2. SDIO interrupt comes in; host controller calls sdio_signal_irq()
>
> 3. sdio_signal_irq() queues delayed work, which gets scheduled right away.
>
> 4. sdio_run_irqs() calls process_sdio_pending_irqs() which is a no-op
> (because we're suspended)
>
> 5. sdio_run_irqs() calls host->ops->ack_sdio_irq(), which re-enables
> more interrupts.
>
> 6. If SDIO interrupt was truly level triggered, we'll go straight back
> to #2 because we never actually removed the true source of the
> level-triggered interrupt by handling it.
>
>
> We'll run steps #2 - #6 above ad nauseam until we finally manage to
> get to the point in the suspend process where the system actually
> masks/disables all driver interrupts.  This happens sometime _after_
> the host controller's suspend call happens.  Technically this might
> not really hurt anything (other than burning CPU cycles) because the
> system workqueue isn't all that high priority so I think the suspend
> can continue happening while we're looping.  ...but it still doesn't
> seem great.

You are right, thanks for point this out so clearly. I have already
started drafting additional patches on top, but allow me a few more
days before I can post them.

In regards to $subject patch, even if it may introduce the behavior
you described above, I still think it's an improvement comparing to
the existing behavior. Allowing to process the SDIO IRQ is just far
worse.

>
> We don't end up in the above situation in my tests because the SDIO
> interrupt was acting as an edge triggered interrupt.  ...and because,
> as per below, we eventually turn the clock off.
>
>
> > In the kthread case, this is managed by mmc_signal_sdio_irq() and the
> > sdio_irq_thread() that calls host->ops->enable_sdio_irq() both to
> > enable/disable the IRQ (but there are other problems with that).
> >
> > >
> > > ======
> > >
> > > Overall, I can confirm that on my system your patch actually does
> > > work.  ...so if all of the above concerns are moot and won't cause
> > > anyone else problems then I can say that they don't seem to cause any
> > > problems on my system.  On rk3288-veyron-jerry:
> > >
> > > - Before your patch, I got failures at iteration 18, then 32, then 55,
> > > then 7, then 26.
> > >
> > > - After your patch I could do 100 iterations of suspend/resume with no
> > > failures.  I also put printouts to confirm your patch was having an
> > > effect.
> >
> > Great news, thanks a lot for testing and sharing these result.
> >
> > One more thing to consider. After the system suspend callback have
> > been called for the mmc host driver (assuming SDIO IRQ isn't
> > configured as system wakeup), the host driver shouldn't really receive
> > SDIO IRQs and nor should it signal them via sdio_signal_irq(), simply
> > because it has suspended its device/controller and beyond that point,
> > the behavior might be undefined. Can you check to see if this is
> > happening, or possibly you already know that this is the case and that
> > we are "lucky"?
>
> It's happening fine as long as we're loose with the term "after".  :-)
>  Most certainly when we just finished executing the last line of the
> host controller's suspend call then the system can't have done
> anything to prevent interrupts from going off.  Even if the very next
> thing that the core OS did was to disable interrupts there would still
> be at least a few CPU instructions in there where we could have
> finished the suspend call and interrupts were still enabled at the
> system level.
>
> It looks like the actual suspension of interrupts is in
> suspend_device_irqs() which is called right before the "no irq" calls
> are made.  ...so in theory we could still get interrupts for quite a
> while after the host controller's suspend call.

Yes, this is common problem, not specific to this one.

>
> In practice it actually looks to be impossible for dw_mmc, though.
> ...part of dw_mmc's suspend call turns off both the ciu (card clock)
> and biu (bus clock).  I believe this means that the controller is
> fully unclocked and there's no way it could give an interrupt.
>
> In fact, the only time we actually get into trouble in dw_mmc is right
> at the beginning of the resume code where we start re-initting the
> host controller (and turning its clocks on) and then the interrupt
> fires before we're quite ready.

Okay, so that we may need to look into sooner or later. Anyway, let's
see what my following patches can help with in regards to this as
well.

Kind regards
Uffe
