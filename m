Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FC03AEA0D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 15:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhFUNbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 09:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhFUNbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 09:31:00 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F1DC061574;
        Mon, 21 Jun 2021 06:28:46 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A918D4C2C;
        Mon, 21 Jun 2021 15:28:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1624282123;
        bh=J4z112JuKdJWKmcJ0RQBiB0ZWAMM+vP5EbTFkOHaTPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SyT4dwT9K/cJKNPWFuY7LwQhhDKtmrFcrMSGeCojfpvI6ndAkwz+rykCZZbJeNyVM
         N9MZ42aFxRTEyo+SJBT1E3EooJvj+a7oMwAaXcObssKulHvXrDJdxQSkrm3yhyNzut
         hi+n3sGUJWO+3eVIbuOO1CfJKRYNdF3XAWOcUZCU=
Date:   Mon, 21 Jun 2021 16:28:17 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] media: uvc: don't do DMA on stack
Message-ID: <YNCT8a8jFYM96p9u@pendragon.ideasonboard.com>
References: <aaa1b65bf2b6c1a2da79b44fe7ada63f697ac32e.1624281807.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaa1b65bf2b6c1a2da79b44fe7ada63f697ac32e.1624281807.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mauro,

Thank you for the patch.

On Mon, Jun 21, 2021 at 03:23:35PM +0200, Mauro Carvalho Chehab wrote:
> As warned by smatch:
> 	drivers/media/usb/uvc/uvc_v4l2.c:911 uvc_ioctl_g_input() error: doing dma on the stack (&i)
> 	drivers/media/usb/uvc/uvc_v4l2.c:943 uvc_ioctl_s_input() error: doing dma on the stack (&i)
> 
> those two functions call uvc_query_ctrl passing a pointer to
> a data at the DMA stack. those are used to send URBs via
> usb_control_msg(). Using DMA stack is not supported and should
> not work anymore on modern Linux versions.
> 
> So, use a temporary buffer, allocated together with
> struct uvc_video_chain.

The second part of the sentence isn't correct anymore.

> Cc: stable@vger.kernel.org	# Kernel 4.9 and upper
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  drivers/media/usb/uvc/uvc_v4l2.c | 26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> index 252136cc885c..d680ae8a5f87 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -899,8 +899,8 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
>  {
>  	struct uvc_fh *handle = fh;
>  	struct uvc_video_chain *chain = handle->chain;
> +	char *buf;

I'd make this

	u8 *buf;

as the selector value is unsigned.

>  	int ret;
> -	u8 i;
>  
>  	if (chain->selector == NULL ||
>  	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
> @@ -908,13 +908,18 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
>  		return 0;
>  	}
>  
> +	buf = kmalloc(1, GFP_KERNEL);

MIssing error check.

> +
>  	ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, chain->selector->id,
>  			     chain->dev->intfnum,  UVC_SU_INPUT_SELECT_CONTROL,
> -			     &i, 1);
> +			     buf, 1);
>  	if (ret < 0)
>  		return ret;
>  
> -	*input = i - 1;
> +	*input = *buf;
> +
> +	kfree(buf);
> +
>  	return 0;
>  }
>  
> @@ -922,8 +927,8 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
>  {
>  	struct uvc_fh *handle = fh;
>  	struct uvc_video_chain *chain = handle->chain;
> +	char *buf;

u8 * here too.

>  	int ret;
> -	u32 i;
>  
>  	ret = uvc_acquire_privileges(handle);
>  	if (ret < 0)
> @@ -939,10 +944,15 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
>  	if (input >= chain->selector->bNrInPins)
>  		return -EINVAL;
>  
> -	i = input + 1;
> -	return uvc_query_ctrl(chain->dev, UVC_SET_CUR, chain->selector->id,
> -			      chain->dev->intfnum, UVC_SU_INPUT_SELECT_CONTROL,
> -			      &i, 1);
> +	buf = kmalloc(1, GFP_KERNEL);

And missing error check.

> +
> +	*buf = input + 1;
> +	ret = uvc_query_ctrl(chain->dev, UVC_SET_CUR, chain->selector->id,
> +			     chain->dev->intfnum, UVC_SU_INPUT_SELECT_CONTROL,
> +			     buf, 1);
> +	kfree(buf);
> +
> +	return ret;
>  }
>  
>  static int uvc_ioctl_queryctrl(struct file *file, void *fh,

-- 
Regards,

Laurent Pinchart
