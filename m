Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543BF4E658F
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 15:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbiCXOp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 10:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235849AbiCXOp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 10:45:26 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5606CA42;
        Thu, 24 Mar 2022 07:43:54 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id ECCE41844;
        Thu, 24 Mar 2022 15:43:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1648133033;
        bh=XK0EacdLP60O7zBm098OAPOEWC6AkfCIFJoIv1TcGjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z+qKSpcc0tat79ofIFypLGi2DCcIC4r39TzZ/wuPy4CKI08hw9vrjWTe1YxrcQJD7
         WHbWkhvKrHj0khxGfJPGxC8e9arKQgp27jGKpnsBsgr9t/njQdD5gSoSJkg3EOzCQc
         gyC2TQRQjnJbljHD0EQxO2R+qMCcQK4Ry42ELW6c=
Date:   Thu, 24 Mar 2022 16:43:51 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Dan Vacura <w36195@motorola.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        linux-kernel@vger.kernel.org,
        Paul Elder <paul.elder@ideasonboard.com>
Subject: Re: [PATCH v2] usb: gadget: uvc: Fix crash when encoding data for
 usb request
Message-ID: <YjyDp4l37XimcoZh@pendragon.ideasonboard.com>
References: <20220318164706.22365-1-w36195@motorola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220318164706.22365-1-w36195@motorola.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dan,

(CC'ing Paul Elder)

Thank you for the patch.

On Fri, Mar 18, 2022 at 11:47:06AM -0500, Dan Vacura wrote:
> During the uvcg_video_pump() process, if an error occurs and
> uvcg_queue_cancel() is called, the buffer queue will be cleared out, but
> the current marker (queue->buf_used) of the active buffer (no longer
> active) is not reset. On the next iteration of uvcg_video_pump() the
> stale buf_used count will be used and the logic of min((unsigned
> int)len, buf->bytesused - queue->buf_used) may incorrectly calculate a
> nbytes size, causing an invalid memory access.

When uvcg_queue_cancel() is called, it will empty the queue->irqqueue.
The next uvcg_video_pump() iteration should thus get a NULL buffer when
calling uvcg_queue_head(), and shouldn't proceed to calling
video->encode(). Is the issue that the application queues further
buffers after cancellation, which puts a new buffer in the irqqueue ?

I wonder if we need to expand the discussion here to what should be done
if an error occurs in uvcg_video_pump(). We currently cancel the queue
and drop all queued buffers, but don't prevent more buffers to be
queued. Should we force the application to stop streaming in case of
error, clean up and restart ? Or are usb_ep_queue() errors expected to
happen from time to time, with graceful error recovery a required
feature of the gadget driver ?

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
> Signed-off-by: Dan Vacura <w36195@motorola.com>
> 
> ---
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
> +	queue->buf_used = 0;
> +
>  	/* This must be protected by the irqlock spinlock to avoid race
>  	 * conditions between uvc_queue_buffer and the disconnection event that
>  	 * could result in an interruptible wait in uvc_dequeue_buffer. Do not

-- 
Regards,

Laurent Pinchart
