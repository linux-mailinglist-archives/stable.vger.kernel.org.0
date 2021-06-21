Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9250C3AEADE
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 16:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhFUOOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 10:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhFUOOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 10:14:31 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B195C061756;
        Mon, 21 Jun 2021 07:12:14 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 02DAC5C75;
        Mon, 21 Jun 2021 16:12:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1624284733;
        bh=aRDvLGDHkllkAXYqx0yCOiC9NL5De0JywflMx1qqRCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ai5eTMDukpcInGM+jSkdvRqZVlC9MmtY+ZldIvkPk4B1/Nlm7GKDLnzQc4jCQ40oV
         O1DsiQ8FT8UNHKsHp2GT4KBLo2itsU2s20bmSM9LuEhIrzkELB7l8roILCWfd8CkNh
         a1ntv6PxYGesokKvaMEHXDDWNjRekkFXv8z7dqS8=
Date:   Mon, 21 Jun 2021 17:11:46 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] media: uvc: don't do DMA on stack
Message-ID: <YNCeIvQJIOCm8g+P@pendragon.ideasonboard.com>
References: <6832dffafd54a6a95b287c4a1ef30250d6b9237a.1624282817.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6832dffafd54a6a95b287c4a1ef30250d6b9237a.1624282817.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mauro,

Thank you for the patch.

On Mon, Jun 21, 2021 at 03:40:19PM +0200, Mauro Carvalho Chehab wrote:
> As warned by smatch:
> 	drivers/media/usb/uvc/uvc_v4l2.c:911 uvc_ioctl_g_input() error: doing dma on the stack (&i)
> 	drivers/media/usb/uvc/uvc_v4l2.c:943 uvc_ioctl_s_input() error: doing dma on the stack (&i)
> 
> those two functions call uvc_query_ctrl passing a pointer to
> a data at the DMA stack. those are used to send URBs via
> usb_control_msg(). Using DMA stack is not supported and should
> not work anymore on modern Linux versions.
> 
> So, use a kmalloc'ed buffer.
> 
> Cc: stable@vger.kernel.org	# Kernel 4.9 and upper
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  drivers/media/usb/uvc/uvc_v4l2.c | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> index 252136cc885c..a95bf7318848 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -899,8 +899,8 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
>  {
>  	struct uvc_fh *handle = fh;
>  	struct uvc_video_chain *chain = handle->chain;
> +	u8 *buf;
>  	int ret;
> -	u8 i;
>  
>  	if (chain->selector == NULL ||
>  	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
> @@ -908,13 +908,20 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
>  		return 0;
>  	}
>  
> +	buf = kmalloc(1, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
>  	ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, chain->selector->id,
>  			     chain->dev->intfnum,  UVC_SU_INPUT_SELECT_CONTROL,
> -			     &i, 1);
> +			     buf, 1);
>  	if (ret < 0)
>  		return ret;

Memory leak :-)

	if (!ret)
		*input = *buf - 1;

	kfree(buf);

	return ret;

>  
> -	*input = i - 1;
> +	*input = *buf - 1;
> +
> +	kfree(buf);
> +
>  	return 0;
>  }
>  
> @@ -922,8 +929,8 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
>  {
>  	struct uvc_fh *handle = fh;
>  	struct uvc_video_chain *chain = handle->chain;
> +	char *buf;

	u8 *buf;

With these two changes,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Do I need to take the patch in my tree ?

>  	int ret;
> -	u32 i;
>  
>  	ret = uvc_acquire_privileges(handle);
>  	if (ret < 0)
> @@ -939,10 +946,17 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
>  	if (input >= chain->selector->bNrInPins)
>  		return -EINVAL;
>  
> -	i = input + 1;
> -	return uvc_query_ctrl(chain->dev, UVC_SET_CUR, chain->selector->id,
> -			      chain->dev->intfnum, UVC_SU_INPUT_SELECT_CONTROL,
> -			      &i, 1);
> +	buf = kmalloc(1, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
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
