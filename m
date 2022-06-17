Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD67F54F7D8
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 14:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiFQMvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 08:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbiFQMvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 08:51:24 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DC137A84;
        Fri, 17 Jun 2022 05:51:23 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 192342A5;
        Fri, 17 Jun 2022 14:51:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1655470281;
        bh=6044Ae7YHS8XgtS8M1tFoHpK4NiU+wwOXC2x7BQ7Z78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=COaincPjdXKl1B+/5mkNRMn6kFQ0raht3IJWuZ1+RxMFAYBQ1Fpk+blOKhy2VPFIP
         wcMEOHgGxalCoUiO33fS7JrK9xfBVY2VQ2CEnYmVR+kF992v+Me3UWHrEg4f8KQpii
         DMLmJ7laRYi2GnE74q7+Cz+j87s8nCqnvFczrMCE=
Date:   Fri, 17 Jun 2022 15:51:08 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Dan Vacura <w36195@motorola.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: fix list double add in uvcg_video_pump
Message-ID: <Yqx4vPp78Sl2I3nU@pendragon.ideasonboard.com>
References: <20220616030915.149238-1-w36195@motorola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220616030915.149238-1-w36195@motorola.com>
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

On Wed, Jun 15, 2022 at 10:09:15PM -0500, Dan Vacura wrote:
> A panic can occur if the endpoint becomes disabled and the
> uvcg_video_pump adds the request back to the req_free list after it has
> already been queued to the endpoint. The endpoint complete will add the
> request back to the req_free list. Invalidate the local request handle
> once it's been queued.

Good catch !

> <6>[  246.796704][T13726] configfs-gadget gadget: uvc: uvc_function_set_alt(1, 0)
> <3>[  246.797078][   T26] list_add double add: new=ffffff878bee5c40, prev=ffffff878bee5c40, next=ffffff878b0f0a90.
> <6>[  246.797213][   T26] ------------[ cut here ]------------
> <2>[  246.797224][   T26] kernel BUG at lib/list_debug.c:31!
> <6>[  246.807073][   T26] Call trace:
> <6>[  246.807180][   T26]  uvcg_video_pump+0x364/0x38c
> <6>[  246.807366][   T26]  process_one_work+0x2a4/0x544
> <6>[  246.807394][   T26]  worker_thread+0x350/0x784
> <6>[  246.807442][   T26]  kthread+0x2ac/0x320
> 
> Fixes: f9897ec0f6d3 ("usb: gadget: uvc: only pump video data if necessary")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dan Vacura <w36195@motorola.com>
> ---
>  drivers/usb/gadget/function/uvc_video.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
> index 93f42c7f800d..59e2f51b53a5 100644
> --- a/drivers/usb/gadget/function/uvc_video.c
> +++ b/drivers/usb/gadget/function/uvc_video.c
> @@ -427,6 +427,9 @@ static void uvcg_video_pump(struct work_struct *work)
>  		if (ret < 0) {
>  			uvcg_queue_cancel(queue, 0);
>  			break;
> +		} else {
> +			/* Endpoint now owns the request */
> +			req = NULL;
>  		}
>  		video->req_int_count++;

I'd write it as

		if (ret < 0) {
			uvcg_queue_cancel(queue, 0);
			break;
		}

		/* Endpoint now owns the request. */
		req = NULL;
		video->req_int_count++;

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  	}

-- 
Regards,

Laurent Pinchart
