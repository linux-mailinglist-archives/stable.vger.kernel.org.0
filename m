Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB28E656BF7
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 15:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiL0Ohf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 09:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiL0Ohe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 09:37:34 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41309114F;
        Tue, 27 Dec 2022 06:37:33 -0800 (PST)
Received: from pendragon.ideasonboard.com (213-243-189-158.bb.dnainternet.fi [213.243.189.158])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8FE65514;
        Tue, 27 Dec 2022 15:37:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1672151851;
        bh=uIFy53dh+MOyb7n6C3/FdgAjbfgf004pHkGiHJYvU/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R/hLKQD9nCHkTAa326H7uhQJKPGYwiPArCSGdjkvWTPM/phl982cT2IYpHd1QtSz1
         j8ngAMrX8qxsbfsySvHaop1SNxHPy2wrMliTrB2FxAzZgj/nQbwtxM5/0+BRVEkD46
         ekgJZ4VyqPKKv0nHzvFxHbpf8jvr4d6/l3Tx8Y8w=
Date:   Tue, 27 Dec 2022 16:37:28 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Staudt <mstaudt@google.com>, linux-media@vger.kernel.org,
        stable@vger.kernel.org, Yunke Cao <yunkec@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: uvcvideo: Fix race condition with usb_kill_urb
Message-ID: <Y6sDKPD8L47ce35u@pendragon.ideasonboard.com>
References: <20221212-uvc-race-v4-0-38d7075b03f5@chromium.org>
 <Y6sAO7URJpSIulye@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y6sAO7URJpSIulye@pendragon.ideasonboard.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 27, 2022 at 04:25:01PM +0200, Laurent Pinchart wrote:
> Hi Ricardo,
> 
> Thank you for the patch.
> 
> On Wed, Dec 14, 2022 at 05:31:55PM +0100, Ricardo Ribalda wrote:
> > usb_kill_urb warranties that all the handlers are finished when it
> > returns, but does not protect against threads that might be handling
> > asynchronously the urb.
> > 
> > For UVC, the function uvc_ctrl_status_event_async() takes care of
> > control changes asynchronously.
> > 
> >  If the code is executed in the following order:
> > 
> > CPU 0					CPU 1
> > ===== 					=====
> > uvc_status_complete()
> > 					uvc_status_stop()
> > uvc_ctrl_status_event_work()
> > 					uvc_status_start() -> FAIL
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
> > CPU 0					CPU 1
> > ===== 					=====
> > uvc_status_complete()
> > 					uvc_status_stop()
> > 					uvc_status_start()
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
> > Changes in v4:
> > - Replace bool with atomic_t to avoid compiler reordering
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
> >  drivers/media/usb/uvc/uvc_ctrl.c   | 3 +++
> >  drivers/media/usb/uvc/uvc_status.c | 6 ++++++
> >  drivers/media/usb/uvc/uvcvideo.h   | 1 +
> >  3 files changed, 10 insertions(+)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> > index c95a2229f4fa..1be6897a7d6d 100644
> > --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > @@ -1442,6 +1442,9 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
> >  
> >  	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> >  
> > +	if (atomic_read(&dev->flush_status))
> > +		return;
> > +
> >  	/* Resubmit the URB. */
> >  	w->urb->interval = dev->int_ep->desc.bInterval;
> >  	ret = usb_submit_urb(w->urb, GFP_KERNEL);
> > diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
> > index 7518ffce22ed..4a95850cdc1b 100644
> > --- a/drivers/media/usb/uvc/uvc_status.c
> > +++ b/drivers/media/usb/uvc/uvc_status.c
> > @@ -304,10 +304,16 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
> >  	if (dev->int_urb == NULL)
> >  		return 0;
> >  
> > +	atomic_set(&dev->flush_status, 0);
> >  	return usb_submit_urb(dev->int_urb, flags);
> >  }
> >  
> >  void uvc_status_stop(struct uvc_device *dev)
> >  {
> > +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> > +
> > +	atomic_set(&dev->flush_status, 1);
> 
> Note that atomic_read() and atomic_set() do no imply any memory barrier
> on most architectures, as far as I can tell. They essentially become
> READ_ONCE() and WRITE_ONCE() calls, which guarantee that the compiler
> will not merge or split loads or stores, or reorder them with respect to
> load and stores to the *same* memory location, but nothing else. I think
> you need to add proper barriers, and you can then probably also drop
> usage of atomic_t.
> 
> > +	if (cancel_work_sync(&w->work))
> > +		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> >  	usb_kill_urb(dev->int_urb);
> 
> This should get rid of the main race (possibly save the barrier issue),
> but it's not the most efficient option, and can still be problematic.
> Consider the following case:
> 
> CPU0							CPU1
> ----							----
> 
> void uvc_status_stop(struct uvc_device *dev)		uvc_ctrl_status_event_async()
> {							{
> 	...
> 	atomic_set(&dev->flush_status, 1);			...
> 	if (cancel_work_sync())
> 		...
> 								schedule_work();
> 	usb_kill_urb();					}
> }
> 
> The usb_kill_urb() call ensures that uvc_ctrl_status_event_async()
> completes before uvc_status_stop() returns, but there will still be work
> scheduled in that case. uvc_ctrl_status_event_work() will be run later,
> and as flush_status is set to 1, the function will not resubmit the URB.
> That fixes the main race, but leaves the asynchronous control status
> event handling for after uvc_status_stop() returns, which isn't great.
> 
> Now, if we consider that uvc_status_start() could be called shortly
> after uvc_status_stop(), we may get in a situation where
> uvc_status_start() will reset flush_status to 0 before
> uvc_ctrl_status_event_async() runs. Both uvc_ctrl_status_event_async()
> and uvc_status_start() will thus submit the same URB.
> 
> You can't fix this by first killing the URB and then cancelling the
> work, as there would then be a risk that uvc_ctrl_status_event_work()
> would be running in parallel, going past the flush_status check before
> flush_status gets set to 1 in uvc_status_stop(), and submitting the URB
> after usb_kill_urb() is called.
> 
> I think a good fix would be to check flush_status in
> uvc_ctrl_status_event_async() and avoid the schedule_work() call in that
> case. You could then also move the atomic_set(..., 0) call from
> uvc_status_start() to the end of uvc_status_stop() (again with proper
> barriers).

Also, as all of this is tricky, comments in appropriate places in the
code would be very helpful to avoid breaking things later.

> Could you please check the memory barriers and test the above proposal
> (after double-checking it of course, I may have missed something) ?
> 
> >  }
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> > index df93db259312..1274691f157f 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -560,6 +560,7 @@ struct uvc_device {
> >  	struct usb_host_endpoint *int_ep;
> >  	struct urb *int_urb;
> >  	u8 *status;
> > +	atomic_t flush_status;
> >  	struct input_dev *input;
> >  	char input_phys[64];
> >  

-- 
Regards,

Laurent Pinchart
