Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52CA65B378
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 15:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbjABOpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 09:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjABOpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 09:45:06 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBF763BA
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 06:45:05 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id a184so8011579pfa.9
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 06:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hk4clSxh5lBRO/IXvviKJih8Kg2t0t1kJgW0EQHTX5U=;
        b=ZaFjlBt7ZJPFI3wVxUUCGNG2A96WCXKhhihzCkC8U7sw9/M+jIkSHYVQsVMR9SrR+D
         TgxZ15qANvJ9bSAzWOQZWcHlACzVw8u3qc2y0Ah91hOL18HLN7r30eJoVevHSPvnDH6o
         TZoXpdOHIX5IFcXp9tXQPQ/5bFeqY3KuW53bo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hk4clSxh5lBRO/IXvviKJih8Kg2t0t1kJgW0EQHTX5U=;
        b=O+krILhDBn6EUFzmyNy4zKPGQWPd50kW7CnutyAU/zoLVo3yykTXVjW/y2rFBLMrgX
         nc5marIrtiKf9lyqHAiMTFf+eFd57tQD6WDVtEINQTDiq3Qslk3oSyiG4+8iZLwEcbXf
         lxC6G/yW/OxVUOlWne1VnLsvl0JEX20Ava5g0cxa5BK6XxxhDFX+tbXMFxjSzjHUUrjI
         EtPH5NebLDP8FFNDeXg5RAF0n28Uw/eId3tSugxQRCQigID9+4OP129VMgHYXykV+9Wl
         2o3UMD3QZQw6BL3J1YBkBviRbbNr1KgR8OXC5OkGVuNSyjcJjsMGvjF0mya9A/Ad5Edc
         yiIA==
X-Gm-Message-State: AFqh2koxAs+XM3Rkg+bwhnYc1Nf1RaOB7Vdc7AZEtqrBA5JlkfKz8LSQ
        OkB93JPersrccks1g5oWXkOB3yjEUC8bSnS7g7Y=
X-Google-Smtp-Source: AMrXdXvq8z1bml0ZDBizXcHfWR6z7YuXB6uSagRyKCaqQNlnF8vgKqLDTaBdiEDTcz5FazXsEfO+PQ==
X-Received: by 2002:aa7:9483:0:b0:580:f6ce:5f75 with SMTP id z3-20020aa79483000000b00580f6ce5f75mr27093040pfk.15.1672670705044;
        Mon, 02 Jan 2023 06:45:05 -0800 (PST)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com. [209.85.216.51])
        by smtp.gmail.com with ESMTPSA id z18-20020aa79492000000b0058251a6ea57sm3106380pfk.130.2023.01.02.06.45.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jan 2023 06:45:03 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so28408605pjd.0
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 06:45:03 -0800 (PST)
X-Received: by 2002:a17:902:934b:b0:191:2a9b:ec94 with SMTP id
 g11-20020a170902934b00b001912a9bec94mr2665864plp.8.1672670702971; Mon, 02 Jan
 2023 06:45:02 -0800 (PST)
MIME-Version: 1.0
References: <20221212-uvc-race-v5-0-3db3933d1608@chromium.org> <Y7Lp9hUgF6XItA4q@pendragon.ideasonboard.com>
In-Reply-To: <Y7Lp9hUgF6XItA4q@pendragon.ideasonboard.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 2 Jan 2023 15:44:51 +0100
X-Gmail-Original-Message-ID: <CANiDSCv=X_KHFwKy-hWfVSn=EgmxirQXB3dUmGvYpE7eySL=9g@mail.gmail.com>
Message-ID: <CANiDSCv=X_KHFwKy-hWfVSn=EgmxirQXB3dUmGvYpE7eySL=9g@mail.gmail.com>
Subject: Re: [PATCH v5] media: uvcvideo: Fix race condition with usb_kill_urb
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Staudt <mstaudt@google.com>, linux-media@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yunke Cao <yunkec@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurent

On Mon, 2 Jan 2023 at 15:28, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Ricardo,
>
> Thank you for the patch.
>
> On Mon, Jan 02, 2023 at 01:53:38PM +0100, Ricardo Ribalda wrote:
> > usb_kill_urb warranties that all the handlers are finished when it
> > returns, but does not protect against threads that might be handling
> > asynchronously the urb.
> >
> > For UVC, the function uvc_ctrl_status_event_async() takes care of
> > control changes asynchronously.
> >
> >  If the code is executed in the following order:
> >
> > CPU 0                                 CPU 1
> > =====                                         =====
> > uvc_status_complete()
> >                                       uvc_status_stop()
> > uvc_ctrl_status_event_work()
> >                                       uvc_status_start() -> FAIL
> >
> > Then uvc_status_start will keep failing and this error will be shown:
> >
> > <4>[    5.540139] URB 0000000000000000 submitted while active
> > drivers/usb/core/urb.c:378 usb_submit_urb+0x4c3/0x528
> >
> > Let's improve the current situation, by not re-submiting the urb if
> > we are stopping the status event. Also process the queued work
> > (if any) during stop.
> >
> > CPU 0                                 CPU 1
> > =====                                         =====
> > uvc_status_complete()
> >                                       uvc_status_stop()
> >                                       uvc_status_start()
> > uvc_ctrl_status_event_work() -> FAIL
> >
> > Hopefully, with the usb layer protection this should be enough to cover
> > all the cases.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
> > Reviewed-by: Yunke Cao <yunkec@chromium.org>
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > ---
> > uvc: Fix race condition on uvc
> >
> > Make sure that all the async work is finished when we stop the status urb.
> >
> > To: Yunke Cao <yunkec@chromium.org>
> > To: Sergey Senozhatsky <senozhatsky@chromium.org>
> > To: Max Staudt <mstaudt@google.com>
> > To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > To: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Cc: linux-media@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> > Changes in v5:
> > - atomic_t do not impose barriers, use smp_mb() instead. (Thanks Laurent)
> > - Add an extra cancel_work_sync().
> > - Link to v4: https://lore.kernel.org/r/20221212-uvc-race-v4-0-38d7075b03f5@chromium.org
> >
> > Changes in v4:
> > - Replace bool with atomic_t to avoid compiler reordering.
> > - First complete the async work and then kill the urb to avoid race (Thanks Laurent!)
> > - Link to v3: https://lore.kernel.org/r/20221212-uvc-race-v3-0-954efc752c9a@chromium.org
> >
> > Changes in v3:
> > - Remove the patch for dev->status, makes more sense in another series, and makes
> >   the zero day less nervous.
> > - Update reviewed-by (thanks Yunke!).
> > - Link to v2: https://lore.kernel.org/r/20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org
> >
> > Changes in v2:
> > - Add a patch for not kalloc dev->status
> > - Redo the logic mechanism, so it also works with suspend (Thanks Yunke!)
> > - Link to v1: https://lore.kernel.org/r/20221212-uvc-race-v1-0-c52e1783c31d@chromium.org
> > ---
> >  drivers/media/usb/uvc/uvc_ctrl.c   |  3 +++
> >  drivers/media/usb/uvc/uvc_status.c | 36 ++++++++++++++++++++++++++++++++++++
> >  drivers/media/usb/uvc/uvcvideo.h   |  1 +
> >  3 files changed, 40 insertions(+)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> > index c95a2229f4fa..5160facc8e20 100644
> > --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > @@ -1442,6 +1442,9 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
> >
> >       uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> >
> > +     if (dev->flush_status)
> > +             return;
> > +
> >       /* Resubmit the URB. */
> >       w->urb->interval = dev->int_ep->desc.bInterval;
> >       ret = usb_submit_urb(w->urb, GFP_KERNEL);
> > diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
> > index 7518ffce22ed..5911e63776e1 100644
> > --- a/drivers/media/usb/uvc/uvc_status.c
> > +++ b/drivers/media/usb/uvc/uvc_status.c
> > @@ -6,6 +6,7 @@
> >   *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> >   */
> >
> > +#include <asm/barrier.h>
> >  #include <linux/kernel.h>
> >  #include <linux/input.h>
> >  #include <linux/slab.h>
> > @@ -309,5 +310,40 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
> >
> >  void uvc_status_stop(struct uvc_device *dev)
> >  {
> > +     struct uvc_ctrl_work *w = &dev->async_ctrl;
> > +
> > +     /* From this point, the status urb is not re-queued */
> > +     dev->flush_status = 1;
>
> flush_status is now a bool, set it to true instead of 1. Same below for
> false instead of 0.
>
> > +     /*
> > +      * Make sure that the other CPUs are aware of the new value of
> > +      * flush_status.
> > +      */
> > +     smp_mb();
>
>         /*
>          * Prevent to asynchronous control handler from requeing the URB. The
>          * barrier is needed the flush_status change is visible to other CPUs
>          * running the asynchronous handler before usb_kill_urb() is called
>          * below.
>          */
>         dev->flush_status = true;
>         smp_mb();
>
> > +
> > +     /* If there is any status event on the queue, process it. */
> > +     if (cancel_work_sync(&w->work))
> > +             uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> > +
> > +     /* Kill the urb. */
> >       usb_kill_urb(dev->int_urb);
> > +
> > +     /*
> > +      * If an status event was queued between cancel_work_sync() and
> > +      * usb_kill_urb(), process it.
> > +      */
>
>         /*
>          * The URB completion handler may have queued asynchronous work. This
>          * won't resubmit the URB as flush_status is set, but it needs to be
>          * cancelled before returning or it could then race with a future
>          * uvc_status_start() call.
>          */
>
> > +     if (cancel_work_sync(&w->work))
> > +             uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
>
> I think I'd still prefer checking flush_status in
> uvc_ctrl_status_event_async() and drop the event, as it would be simpler
> here. uvc_status_stop() is called when the last user indicates it's not
> interested in events anymore (by closing the device at the moment,
> possibly by unsubscribing from events in the future), so dropping the
> event isn't a problem as far as I can tell. What do you think ?

Since the user do not have direct control to when uvc_status_stop is
called, I prefer to have the second cancel_work_sync() here. That will
give us more flexibility when we rework the power saving.

Also, uvc_status_stop is done only once and not in IRQ context. the
change you propose will make the irq context bigger.... Yes I know it
is only one if, but I had to say something :P

>
> > +
> > +     /*
> > +      * From this point, there are no events on the queue and the status urb
>
> s/urb/URB/
>
> > +      * is dead, this is, no events will be queued until uvc_status_start()
> > +      * is called.
> > +      */
> > +     dev->flush_status = 0;
> > +     /*
> > +      * Write to memory the value of flush_status before uvc_status_start()
> > +      * is called again,
>
> s/,/./
>
> > +      */
> > +     smp_mb();
>
>         /*
>          * From this point, the status URB is dead, and no asynchronous work is
>          * queued. No event will be processed until uvc_status_start() is
>          * called. Reset flush_status and make it visible to the asynchronous
>          * handler before uvc_status_start() requeues the status URB.
>          */
>         dev->flush_status = 0;
>         smp_mb();
>
> The barrier here is most likely overkill given that I'd be very
> surprised if a URB could be queued, followed by a work item being
> queued, without any memory barrier, but it's good to be explicit I
> suppose :-)
>
> > +
>
> Drop the blank line.
>
> >  }
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> > index df93db259312..6a9b72d6789e 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -560,6 +560,7 @@ struct uvc_device {
> >       struct usb_host_endpoint *int_ep;
> >       struct urb *int_urb;
> >       u8 *status;
> > +     bool flush_status;
> >       struct input_dev *input;
> >       char input_phys[64];
> >
> >
> > ---
> > base-commit: 0ec5a38bf8499f403f81cb81a0e3a60887d1993c
> > change-id: 20221212-uvc-race-09276ea68bf8
>
> --
> Regards,
>
> Laurent Pinchart



-- 
Ricardo Ribalda
