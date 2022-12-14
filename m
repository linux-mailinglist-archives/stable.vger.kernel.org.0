Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82D964CB4E
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 14:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbiLNNaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 08:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiLNNaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 08:30:03 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EA8248CC;
        Wed, 14 Dec 2022 05:30:02 -0800 (PST)
Received: from pendragon.ideasonboard.com (213-243-189-158.bb.dnainternet.fi [213.243.189.158])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 70FBA49C;
        Wed, 14 Dec 2022 14:30:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1671024600;
        bh=hcikIOD0ZaKgGatSHYhaw8DhL+ETjBJe/UhiN4WSVQM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UkFGyfYJe75B9oooVO2PeteA33vUF+MFek+UfvAsvCuFFC2V2xfVtW2rR0+6sL2ln
         pTHAVWtfHZZKzLp21l56eYkXUwMUmSsnnPEcdcb7QtQpxMOAc1MEnLCpYqeOmK6Npq
         rBBNFgf/LfsoV/lRQvuFym90jAhQjUGyUXgMrrsc=
Date:   Wed, 14 Dec 2022 15:29:57 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Max Staudt <mstaudt@google.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yunke Cao <yunkec@chromium.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] media: uvcvideo: Fix race condition with usb_kill_urb
Message-ID: <Y5nP1RXbd7mCkmCD@pendragon.ideasonboard.com>
References: <20221212-uvc-race-v3-0-954efc752c9a@chromium.org>
 <Y5nEgDOXFNDPf8/Y@pendragon.ideasonboard.com>
 <CANiDSCvLjr6NK3pL9NpLap44Zcc22OEbyRANXq90dtG+udro4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANiDSCvLjr6NK3pL9NpLap44Zcc22OEbyRANXq90dtG+udro4Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo,

On Wed, Dec 14, 2022 at 01:44:56PM +0100, Ricardo Ribalda wrote:
> On Wed, 14 Dec 2022 at 13:41, Laurent Pinchart wrote:
> > On Wed, Dec 14, 2022 at 12:18:52PM +0100, Ricardo Ribalda wrote:
> > > usb_kill_urb warranties that all the handlers are finished when it
> > > returns, but does not protect against threads that might be handling
> > > asynchronously the urb.
> > >
> > > For UVC, the function uvc_ctrl_status_event_async() takes care of
> > > control changes asynchronously.
> > >
> > >  If the code is executed in the following order:
> > >
> > > CPU 0                                 CPU 1
> > > =====                                         =====
> > > uvc_status_complete()
> > >                                       uvc_status_stop()
> > > uvc_ctrl_status_event_work()
> > >                                       uvc_status_start() -> FAIL
> > > Then uvc_status_start will keep failing and this error will be shown:
> > >
> > > <4>[    5.540139] URB 0000000000000000 submitted while active
> > > drivers/usb/core/urb.c:378 usb_submit_urb+0x4c3/0x528
> > >
> > > Let's improve the current situation, by not re-submiting the urb if
> > > we are stopping the status event. Also process the queued work
> > > (if any) during stop.
> > >
> > > CPU 0                                 CPU 1
> > > =====                                         =====
> > > uvc_status_complete()
> > >                                       uvc_status_stop()
> > >                                       uvc_status_start()
> > > uvc_ctrl_status_event_work() -> FAIL
> > >
> > > Hopefully, with the usb layer protection this should be enough to cover
> > > all the cases.
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
> > > Reviewed-by: Yunke Cao <yunkec@chromium.org>
> > > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > > ---
> > > uvc: Fix race condition on uvc
> > >
> > > Make sure that all the async work is finished when we stop the status urb.
> > >
> > > To: Yunke Cao <yunkec@chromium.org>
> > > To: Sergey Senozhatsky <senozhatsky@chromium.org>
> > > To: Max Staudt <mstaudt@google.com>
> > > To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > To: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > Cc: linux-media@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > > Changes in v3:
> > > - Remove the patch for dev->status, makes more sense in another series, and makes
> > >   the zero day less nervous.
> > > - Update reviewed-by (thanks Yunke!).
> > > - Link to v2: https://lore.kernel.org/r/20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org
> > >
> > > Changes in v2:
> > > - Add a patch for not kalloc dev->status
> > > - Redo the logic mechanism, so it also works with suspend (Thanks Yunke!)
> > > - Link to v1: https://lore.kernel.org/r/20221212-uvc-race-v1-0-c52e1783c31d@chromium.org
> > > ---
> > >  drivers/media/usb/uvc/uvc_ctrl.c   | 3 +++
> > >  drivers/media/usb/uvc/uvc_status.c | 6 ++++++
> > >  drivers/media/usb/uvc/uvcvideo.h   | 1 +
> > >  3 files changed, 10 insertions(+)
> > >
> > > diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> > > index c95a2229f4fa..5160facc8e20 100644
> > > --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > > +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > > @@ -1442,6 +1442,9 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
> > >
> > >       uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> > >
> > > +     if (dev->flush_status)
> > > +             return;
> > > +
> > >       /* Resubmit the URB. */
> > >       w->urb->interval = dev->int_ep->desc.bInterval;
> > >       ret = usb_submit_urb(w->urb, GFP_KERNEL);
> > > diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
> > > index 7518ffce22ed..09a5802dc974 100644
> > > --- a/drivers/media/usb/uvc/uvc_status.c
> > > +++ b/drivers/media/usb/uvc/uvc_status.c
> > > @@ -304,10 +304,16 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
> > >       if (dev->int_urb == NULL)
> > >               return 0;
> > >
> > > +     dev->flush_status = false;
> > >       return usb_submit_urb(dev->int_urb, flags);
> > >  }
> > >
> > >  void uvc_status_stop(struct uvc_device *dev)
> > >  {
> > > +     struct uvc_ctrl_work *w = &dev->async_ctrl;
> > > +
> > > +     dev->flush_status = true;
> > >       usb_kill_urb(dev->int_urb);
> >
> > Isn't this still racy ?
> 
> Indeed...
> 
> I could add a mutex just for flush_status
> 
> what do you think?

It may be possible to avoid that. I'm giving it a try.

> >
> > CPU0                                    CPU1
> > ====                                    ====
> >
> > uvc_status_stop()                       uvc_ctrl_status_event_work()
> > {                                       {
> >                                                 if (dev->flush_status)
> >                                                         return;
> >
> >         dev->flush_status = true;
> >         usb_kill_urb(dev->int_urb);
> >
> >                                                 /* Resubmit the URB. */
> >                                                 w->urb->interval = dev->int_ep->desc.bInterval;
> >                                                 ret = usb_submit_urb(w->urb, GFP_KERNEL);
> >                                         }
> >
> >         if (cancel_work_sync(&w->work))
> >                 uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> > }
> >
> > uvc_status_start() will then return an error, right ?
> >
> > > +     if (cancel_work_sync(&w->work))
> > > +             uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> > >  }
> > > diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> > > index df93db259312..6a9b72d6789e 100644
> > > --- a/drivers/media/usb/uvc/uvcvideo.h
> > > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > > @@ -560,6 +560,7 @@ struct uvc_device {
> > >       struct usb_host_endpoint *int_ep;
> > >       struct urb *int_urb;
> > >       u8 *status;
> > > +     bool flush_status;
> > >       struct input_dev *input;
> > >       char input_phys[64];
> > >
> > >
> > > ---
> > > base-commit: 0ec5a38bf8499f403f81cb81a0e3a60887d1993c
> > > change-id: 20221212-uvc-race-09276ea68bf8

-- 
Regards,

Laurent Pinchart
