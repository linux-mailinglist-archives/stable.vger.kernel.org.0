Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3EB507B2A
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 22:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353044AbiDSUtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 16:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346528AbiDSUtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 16:49:22 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A61D40E7F;
        Tue, 19 Apr 2022 13:46:39 -0700 (PDT)
Received: from pendragon.ideasonboard.com (85-76-5-145-nat.elisa-mobile.fi [85.76.5.145])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6080525B;
        Tue, 19 Apr 2022 22:46:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1650401197;
        bh=rwfL+M0TxWM76tUhVeJH7ficDjSMRpORDcGVV4xgDOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bl/4nH37/PNu+89JvZmpj4TNQWr2NUJd0MfOJEOBuo7dikyoWwPBpoKbS0zbu8ZWO
         r0Fq9xjQsQExCXCFwDTK78Gsyw32IpCrOR4D6neDnY91bK1+kPF3OA9x2DShl1FVVv
         s1WkbQU2uCnR8nuuwmrBzNgXzK1xtL0HGmkZN2b4=
Date:   Tue, 19 Apr 2022 23:46:37 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Dan Vacura <w36195@motorola.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] usb: gadget: uvc: Fix crash when encoding data for
 usb request
Message-ID: <Yl8frWT5VYRdt5zA@pendragon.ideasonboard.com>
References: <20220331184024.23918-1-w36195@motorola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220331184024.23918-1-w36195@motorola.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dan,

Thank you for the patch.

On Thu, Mar 31, 2022 at 01:40:23PM -0500, Dan Vacura wrote:
> During the uvcg_video_pump() process, if an error occurs and
> uvcg_queue_cancel() is called, the buffer queue will be cleared out, but
> the current marker (queue->buf_used) of the active buffer (no longer
> active) is not reset. On the next iteration of uvcg_video_pump() the
> stale buf_used count will be used and the logic of min((unsigned
> int)len, buf->bytesused - queue->buf_used) may incorrectly calculate a
> nbytes size, causing an invalid memory access.
> 
> [80802.185460][  T315] configfs-gadget gadget: uvc: VS request completed
> with status -18.
> [80802.185519][  T315] configfs-gadget gadget: uvc: VS request completed
> with status -18.
> ...
> uvcg_queue_cancel() is called and the queue is cleared out, but the
> marker queue->buf_used is not reset.
> ...
> [80802.262328][ T8682] Unable to handle kernel paging request at virtual
> address ffffffc03af9f000
> ...
> ...
> [80802.263138][ T8682] Call trace:
> [80802.263146][ T8682]  __memcpy+0x12c/0x180
> [80802.263155][ T8682]  uvcg_video_pump+0xcc/0x1e0
> [80802.263165][ T8682]  process_one_work+0x2cc/0x568
> [80802.263173][ T8682]  worker_thread+0x28c/0x518
> [80802.263181][ T8682]  kthread+0x160/0x170
> [80802.263188][ T8682]  ret_from_fork+0x10/0x18
> [80802.263198][ T8682] Code: a8c12829 a88130cb a8c130
> 
> Fixes: d692522577c0 ("usb: gadget/uvc: Port UVC webcam gadget to use videobuf2 framework")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Vacura <w36195@motorola.com>

This indeed fixes an issue, so I think we can merge the patch, but I
also believe we need further improvements on top (of course if you would
like to improve the implementation in a v4, I won't complain :-))

As replied in v2 (sorry for the late reply), it seems that this error
can occur under normal conditions. This means we shouldn't cancel the
queue, at least when the error is intermitent (if all URBs fail that's
another story).

> ---
> Changes in v3:
> - Cc stable
> Changes in v2:
> - Add Fixes tag
> 
>  drivers/usb/gadget/function/uvc_queue.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
> index d852ac9e47e7..2cda982f3765 100644
> --- a/drivers/usb/gadget/function/uvc_queue.c
> +++ b/drivers/usb/gadget/function/uvc_queue.c
> @@ -264,6 +264,8 @@ void uvcg_queue_cancel(struct uvc_video_queue *queue, int disconnect)
>  		buf->state = UVC_BUF_STATE_ERROR;
>  		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
>  	}

A blank line would be nice here, and I would also like a comment to
state that further improvements are required:

	/*
	 * When the queue is cancelled due to an error (either when queuing a
	 * USB request, or in the request completion handler), the we empty the
	 * irqqueue but userspace may queue futher buffers. We need to reset
	 * buf_used to 0 or uvcg_video_pump() will use an incorrect stale value.
	 *
	 * TODO: It seems that a -EXDEV error can occur in the request
	 * completion handler under normal circumstances. Don't cancel the queue
	 * in that case but recover gracefully (likely with rate-limiting, to
	 * still cancel the queue if errors occur too often).
	 */

We likely need to differentiate between -EXDEV and other errors in
uvc_video_complete(), as I'd like to be conservative and cancel the
queue for unknown errors. We also need to improve the queue cancellation
implementation so that userspace gets an error when queuing further
buffers.

> +	queue->buf_used = 0;
> +
>  	/* This must be protected by the irqlock spinlock to avoid race
>  	 * conditions between uvc_queue_buffer and the disconnection event that
>  	 * could result in an interruptible wait in uvc_dequeue_buffer. Do not

-- 
Regards,

Laurent Pinchart
