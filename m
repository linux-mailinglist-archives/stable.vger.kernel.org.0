Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888595EBD5E
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 10:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiI0IeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 04:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbiI0Ids (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 04:33:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDE6B4437;
        Tue, 27 Sep 2022 01:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60AADB819DC;
        Tue, 27 Sep 2022 08:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702C7C433D6;
        Tue, 27 Sep 2022 08:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664267617;
        bh=5GbFuRQK6NuGnXoajaKtdBAUELZ2+XVh6qsDB8ahhwA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r6KoptzrKXBdbpsin9laScLz/M4TNQQdIasAuYQNtK9hzoJ18HLEsYRUlmj3vMeo+
         S3UTBS+i/LybDeSJbsdAUl2QEjAFMyiqazzQwTIxNS8nUDUZ0X2+BAX54d+heh42bx
         7tP/H7YpsdZ2gH7YD+v60Hd8QCCBmPgTptx7cIdY=
Date:   Tue, 27 Sep 2022 10:33:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dan Vacura <w36195@motorola.com>
Cc:     linux-usb@vger.kernel.org,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: fix sg handling in error case
Message-ID: <YzK1Xry5KIrMr18F@kroah.com>
References: <20220926195307.110121-1-w36195@motorola.com>
 <20220926195307.110121-2-w36195@motorola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926195307.110121-2-w36195@motorola.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 02:53:07PM -0500, Dan Vacura wrote:
> If there is a transmission error the buffer will be returned too early,
> causing a memory fault as subsequent requests for that buffer are still
> queued up to be sent. Refactor the error handling to wait for the final
> request to come in before reporting back the buffer to userspace for all
> transfer types (bulk/isoc/isoc_sg) to ensure userspace knows if the
> frame was successfully sent.
> 
> Fixes: e81e7f9a0eb9 ("usb: gadget: uvc: add scatter gather support")
> Cc: <stable@vger.kernel.org> # 859c675d84d4: usb: gadget: uvc: consistently use define for headerlen
> Cc: <stable@vger.kernel.org> # f262ce66d40c: usb: gadget: uvc: use on returned header len in video_encode_isoc_sg
> Cc: <stable@vger.kernel.org> # 61aa709ca58a: usb: gadget: uvc: rework uvcg_queue_next_buffer to uvcg_complete_buffer
> Cc: <stable@vger.kernel.org> # 9b969f93bcef: usb: gadget: uvc: giveback vb2 buffer on req complete
> Cc: <stable@vger.kernel.org> # aef11279888c: usb: gadget: uvc: improve sg exit condition

I don't understand, why we backport all of these commits to 5.15.y if
the original problem isn't in 5.15.y?

Or is it?

I'm confused,

greg k-h


> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Vacura <w36195@motorola.com>
> 
> ---
>  drivers/usb/gadget/function/uvc_queue.c |  8 +++++---
>  drivers/usb/gadget/function/uvc_queue.h |  2 +-
>  drivers/usb/gadget/function/uvc_video.c | 18 ++++++++++++++----
>  3 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
> index ec500ee499ee..72e7ffd9a021 100644
> --- a/drivers/usb/gadget/function/uvc_queue.c
> +++ b/drivers/usb/gadget/function/uvc_queue.c
> @@ -304,6 +304,7 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
>  
>  		queue->sequence = 0;
>  		queue->buf_used = 0;
> +		queue->flags &= ~UVC_QUEUE_MISSED_XFER;
>  	} else {
>  		ret = vb2_streamoff(&queue->queue, queue->queue.type);
>  		if (ret < 0)
> @@ -329,10 +330,11 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
>  void uvcg_complete_buffer(struct uvc_video_queue *queue,
>  					  struct uvc_buffer *buf)
>  {
> -	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
> -	     buf->length != buf->bytesused) {
> -		buf->state = UVC_BUF_STATE_QUEUED;
> +	if ((queue->flags & UVC_QUEUE_MISSED_XFER)) {
> +		queue->flags &= ~UVC_QUEUE_MISSED_XFER;
> +		buf->state = UVC_BUF_STATE_ERROR;
>  		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
> +		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
>  		return;
>  	}
>  
> diff --git a/drivers/usb/gadget/function/uvc_queue.h b/drivers/usb/gadget/function/uvc_queue.h
> index 41f87b917f6b..741ec58ae9bb 100644
> --- a/drivers/usb/gadget/function/uvc_queue.h
> +++ b/drivers/usb/gadget/function/uvc_queue.h
> @@ -42,7 +42,7 @@ struct uvc_buffer {
>  };
>  
>  #define UVC_QUEUE_DISCONNECTED		(1 << 0)
> -#define UVC_QUEUE_DROP_INCOMPLETE	(1 << 1)
> +#define UVC_QUEUE_MISSED_XFER 		(1 << 1)

Why change the name of the error?

>  
>  struct uvc_video_queue {
>  	struct vb2_queue queue;
> diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
> index bb037fcc90e6..e46591b067a8 100644
> --- a/drivers/usb/gadget/function/uvc_video.c
> +++ b/drivers/usb/gadget/function/uvc_video.c
> @@ -88,6 +88,7 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
>  		struct uvc_buffer *buf)
>  {
>  	void *mem = req->buf;
> +	struct uvc_request *ureq = req->context;
>  	int len = video->req_size;
>  	int ret;
>  
> @@ -113,13 +114,14 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
>  		video->queue.buf_used = 0;
>  		buf->state = UVC_BUF_STATE_DONE;
>  		list_del(&buf->queue);
> -		uvcg_complete_buffer(&video->queue, buf);
>  		video->fid ^= UVC_STREAM_FID;
> +		ureq->last_buf = buf;
>  
>  		video->payload_size = 0;
>  	}
>  
>  	if (video->payload_size == video->max_payload_size ||
> +	    video->queue.flags & UVC_QUEUE_MISSED_XFER ||
>  	    buf->bytesused == video->queue.buf_used)
>  		video->payload_size = 0;
>  }
> @@ -180,7 +182,8 @@ uvc_video_encode_isoc_sg(struct usb_request *req, struct uvc_video *video,
>  	req->length -= len;
>  	video->queue.buf_used += req->length - header_len;
>  
> -	if (buf->bytesused == video->queue.buf_used || !buf->sg) {
> +	if (buf->bytesused == video->queue.buf_used || !buf->sg ||
> +			video->queue.flags & UVC_QUEUE_MISSED_XFER) {
>  		video->queue.buf_used = 0;
>  		buf->state = UVC_BUF_STATE_DONE;
>  		buf->offset = 0;
> @@ -195,6 +198,7 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
>  		struct uvc_buffer *buf)
>  {
>  	void *mem = req->buf;
> +	struct uvc_request *ureq = req->context;
>  	int len = video->req_size;
>  	int ret;
>  
> @@ -209,12 +213,13 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
>  
>  	req->length = video->req_size - len;
>  
> -	if (buf->bytesused == video->queue.buf_used) {
> +	if (buf->bytesused == video->queue.buf_used ||
> +			video->queue.flags & UVC_QUEUE_MISSED_XFER) {
>  		video->queue.buf_used = 0;
>  		buf->state = UVC_BUF_STATE_DONE;
>  		list_del(&buf->queue);
> -		uvcg_complete_buffer(&video->queue, buf);
>  		video->fid ^= UVC_STREAM_FID;
> +		ureq->last_buf = buf;
>  	}
>  }
>  
> @@ -255,6 +260,11 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
>  	case 0:
>  		break;
>  
> +	case -EXDEV:
> +		uvcg_info(&video->uvc->func, "VS request missed xfer.\n");

Why are you spamming the kernel logs at the info level for a USB
transmission problem?   That could get very noisy, please change this to
be at the debug level.

thanks,

greg k-h
