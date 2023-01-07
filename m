Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E03B660AF3
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 01:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjAGAiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 19:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236149AbjAGAif (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 19:38:35 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1275284BD9;
        Fri,  6 Jan 2023 16:37:24 -0800 (PST)
Received: from pendragon.ideasonboard.com (213-243-189-158.bb.dnainternet.fi [213.243.189.158])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 604C34AE;
        Sat,  7 Jan 2023 01:37:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1673051842;
        bh=1yPY6zLuxUhJr2heWCr2QRw7KxBcGsyvQJyxUF//dK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tm5IE0cu4JhHxJgBiNmyRkVcmrGXqERTccrZp9tCQ7BbzFlQyjImdQpQRjfcM30Al
         wg5O0Td2bTY0rNWgUpbBE80Bc95eFY2YoXxGOLp4n96omMBiL29auLkEILNXLJ+ffx
         i0QMT0KJa3ZVYXBWH0n0254hoQGFNBDGeC72BFGs=
Date:   Sat, 7 Jan 2023 02:37:17 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hillf Danton <hdanton@sina.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Staudt <mstaudt@google.com>,
        Yunke Cao <yunkec@chromium.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v7] media: uvcvideo: Fix race condition with usb_kill_urb
Message-ID: <Y7i+vfJxtcxZFgf/@pendragon.ideasonboard.com>
References: <20221212-uvc-race-v7-0-e2517c66a55a@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221212-uvc-race-v7-0-e2517c66a55a@chromium.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo,

Thank you for the patch.

On Thu, Jan 05, 2023 at 03:31:29PM +0100, Ricardo Ribalda wrote:
> usb_kill_urb warranties that all the handlers are finished when it
> returns, but does not protect against threads that might be handling
> asynchronously the urb.
> 
> For UVC, the function uvc_ctrl_status_event_async() takes care of
> control changes asynchronously.
> 
>  If the code is executed in the following order:
> 
> CPU 0					CPU 1
> ===== 					=====
> uvc_status_complete()
> 					uvc_status_stop()
> uvc_ctrl_status_event_work()
> 					uvc_status_start() -> FAIL
> 
> Then uvc_status_start will keep failing and this error will be shown:
> 
> <4>[    5.540139] URB 0000000000000000 submitted while active
> drivers/usb/core/urb.c:378 usb_submit_urb+0x4c3/0x528
> 
> Let's improve the current situation, by not re-submiting the urb if
> we are stopping the status event. Also process the queued work
> (if any) during stop.
> 
> CPU 0					CPU 1
> ===== 					=====
> uvc_status_complete()
> 					uvc_status_stop()
> 					uvc_status_start()
> uvc_ctrl_status_event_work() -> FAIL
> 
> Hopefully, with the usb layer protection this should be enough to cover
> all the cases.

For some reason the word "hopefully" in a bug fix doesn't make me very
hopeful ;-)

> Cc: stable@vger.kernel.org
> Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
> Reviewed-by: Yunke Cao <yunkec@chromium.org>
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> ---
> uvc: Fix race condition on uvc
> 
> Make sure that all the async work is finished when we stop the status urb.
> 
> To: Hillf Danton <hdanton@sina.com>
> To: Yunke Cao <yunkec@chromium.org>
> To: Sergey Senozhatsky <senozhatsky@chromium.org>
> To: Max Staudt <mstaudt@google.com>
> To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> To: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> Changes in v7:
> - Use smp_store_release. (Thanks Hilf!)
> - Rebase on top of uvc/next.
> - Link to v6: https://lore.kernel.org/r/20221212-uvc-race-v6-0-2a662f8de011@chromium.org
> 
> Changes in v6:
> - Improve comments. (Thanks Laurent).
> - Use true/false instead of 1/0 (Thanks Laurent).
> - Link to v5: https://lore.kernel.org/r/20221212-uvc-race-v5-0-3db3933d1608@chromium.org
> 
> Changes in v5:
> - atomic_t do not impose barriers, use smp_mb() instead. (Thanks Laurent)
> - Add an extra cancel_work_sync().
> - Link to v4: https://lore.kernel.org/r/20221212-uvc-race-v4-0-38d7075b03f5@chromium.org
> 
> Changes in v4:
> - Replace bool with atomic_t to avoid compiler reordering.
> - First complete the async work and then kill the urb to avoid race (Thanks Laurent!)
> - Link to v3: https://lore.kernel.org/r/20221212-uvc-race-v3-0-954efc752c9a@chromium.org
> 
> Changes in v3:
> - Remove the patch for dev->status, makes more sense in another series, and makes
>   the zero day less nervous.
> - Update reviewed-by (thanks Yunke!).
> - Link to v2: https://lore.kernel.org/r/20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org
> 
> Changes in v2:
> - Add a patch for not kalloc dev->status
> - Redo the logic mechanism, so it also works with suspend (Thanks Yunke!)
> - Link to v1: https://lore.kernel.org/r/20221212-uvc-race-v1-0-c52e1783c31d@chromium.org
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c   |  5 +++++
>  drivers/media/usb/uvc/uvc_status.c | 33 +++++++++++++++++++++++++++++++++
>  drivers/media/usb/uvc/uvcvideo.h   |  1 +
>  3 files changed, 39 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> index e07b56bbf853..30c417768376 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -6,6 +6,7 @@
>   *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
>   */
>  
> +#include <asm/barrier.h>
>  #include <linux/bitops.h>
>  #include <linux/kernel.h>
>  #include <linux/list.h>
> @@ -1509,6 +1510,10 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
>  
>  	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
>  
> +	/* The barrier is needed to synchronize with uvc_status_stop(). */
> +	if (smp_load_acquire(&dev->flush_status))
> +		return;
> +
>  	/* Resubmit the URB. */
>  	w->urb->interval = dev->int_ep->desc.bInterval;
>  	ret = usb_submit_urb(w->urb, GFP_KERNEL);
> diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
> index 602830a8023e..21e13b8441da 100644
> --- a/drivers/media/usb/uvc/uvc_status.c
> +++ b/drivers/media/usb/uvc/uvc_status.c
> @@ -6,6 +6,7 @@
>   *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
>   */
>  
> +#include <asm/barrier.h>
>  #include <linux/kernel.h>
>  #include <linux/input.h>
>  #include <linux/slab.h>
> @@ -311,5 +312,37 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
>  
>  void uvc_status_stop(struct uvc_device *dev)
>  {
> +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> +
> +	/*
> +	 * Prevent the asynchronous control handler from requeing the URB. The
> +	 * barrier is needed so the flush_status change is visible to other
> +	 * CPUs running the asynchronous handler before usb_kill_urb() is
> +	 * called below.
> +	 */
> +	smp_store_release(&dev->flush_status, true);
> +
> +	/* If there is any status event on the queue, process it. */

	/*
	 * Cancel any pending asynchronous work. If any status event was queued,
	 * process it synchronously.
	 */

> +	if (cancel_work_sync(&w->work))
> +		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> +
> +	/* Kill the urb. */
>  	usb_kill_urb(dev->int_urb);
> +
> +	/*
> +	 * The URB completion handler may have queued asynchronous work. This
> +	 * won't resubmit the URB as flush_status is set, but it needs to be
> +	 * cancelled before returning or it could then race with a future
> +	 * uvc_status_start() call.
> +	 */
> +	if (cancel_work_sync(&w->work))
> +		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> +
> +	/*
> +	 * From this point, there are no events on the queue and the status URB
> +	 * is dead, this is, no events will be queued until uvc_status_start()
> +	 * is called. The barrier is needed to make sure that it is written to
> +	 * memory before uvc_status_start() is called again.

With data races, the concept of "written to memory" doesn't make much
sense anymore.

	* From this point, there are no events on the queue and the status URB
	* is dead. No events will be queued until uvc_status_start() is called.
	* The barrier is needed to make sure that flush_status is visible to
	* uvc_ctrl_status_event_work() when uvc_status_start() will be called
	* again.

I'll update the comments locally.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +	 */
> +	smp_store_release(&dev->flush_status, false);
>  }
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> index ae0066eceffd..b2b277cccbdb 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -578,6 +578,7 @@ struct uvc_device {
>  	struct usb_host_endpoint *int_ep;
>  	struct urb *int_urb;
>  	struct uvc_status *status;
> +	bool flush_status;
>  
>  	struct input_dev *input;
>  	char input_phys[64];
> 
> ---
> base-commit: fb1316b0ff3fc3cd98637040ee17ab7be753aac7
> change-id: 20221212-uvc-race-09276ea68bf8

-- 
Regards,

Laurent Pinchart
