Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6473D3A3064
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 18:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhFJQWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 12:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhFJQWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 12:22:00 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AA7C061574;
        Thu, 10 Jun 2021 09:20:04 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0F3458D4;
        Thu, 10 Jun 2021 18:20:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1623342002;
        bh=BzGXdhhvS+7/Ft9bTCTS7hlMOBX5DbO4oiIXKPVtD1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rWg9gd1eDQexldBezKEvnFl1SjTqIBRPl9L6hrk2f0RO4o07jl1bxVLKd6jzfQaod
         3VEWNbOuX9eHYgB3dAagwCpqpIOHgjbA2V8nSV6kx/pThDxaVmD+YL+t46wYzKZ8fv
         1Ys5sKmiTSd2vcmylwwuflEVCaJ396CFuD0YBJEA=
Date:   Thu, 10 Jun 2021 19:19:43 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org, stable@vger.kernel.org
Subject: Re: [PATCH v9 01/22] media: v4l2-ioctl: Fix check_ext_ctrls
Message-ID: <YMI7n11nRO/tcP1j@pendragon.ideasonboard.com>
References: <20210326095840.364424-1-ribalda@chromium.org>
 <20210326095840.364424-2-ribalda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210326095840.364424-2-ribalda@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo,

Thank you for the patch.

On Fri, Mar 26, 2021 at 10:58:19AM +0100, Ricardo Ribalda wrote:
> Drivers that do not use the ctrl-framework use this function instead.
> 
> Fix the following issues:
> 
> - Do not check for multiple classes when getting the DEF_VAL.
> - Return -EINVAL for request_api calls
> - Default value cannot be changed, return EINVAL as soon as possible.
> - Return the right error_idx
> [If an error is found when validating the list of controls passed with
> VIDIOC_G_EXT_CTRLS, then error_idx shall be set to ctrls->count to
> indicate to userspace that no actual hardware was touched.
> It would have been much nicer of course if error_idx could point to the
> control index that failed the validation, but sadly that's not how the
> API was designed.]
> 
> Fixes v4l2-compliance:
> Control ioctls (Input 0):
>         warn: v4l2-test-controls.cpp(834): error_idx should be equal to count
>         warn: v4l2-test-controls.cpp(855): error_idx should be equal to count
> 		fail: v4l2-test-controls.cpp(813): doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls)
> 	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
> Buffer ioctls (Input 0):
> 		fail: v4l2-test-buffers.cpp(1994): ret != EINVAL && ret != EBADR && ret != ENOTTY
> 	test Requests: FAIL
> 
> Cc: stable@vger.kernel.org
> Fixes: 6fa6f831f095 ("media: v4l2-ctrls: add core request support")
> Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 60 ++++++++++++++++++----------
>  1 file changed, 39 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 31d1342e61e8..7b5ebdd329e8 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -908,7 +908,7 @@ static void v4l_print_default(const void *arg, bool write_only)
>  	pr_cont("driver-specific ioctl\n");
>  }
>  
> -static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
> +static bool check_ext_ctrls(struct v4l2_ext_controls *c, unsigned long ioctl)
>  {
>  	__u32 i;
>  
> @@ -917,23 +917,41 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
>  	for (i = 0; i < c->count; i++)
>  		c->controls[i].reserved2[0] = 0;
>  
> -	/* V4L2_CID_PRIVATE_BASE cannot be used as control class
> -	   when using extended controls.
> -	   Only when passed in through VIDIOC_G_CTRL and VIDIOC_S_CTRL
> -	   is it allowed for backwards compatibility.
> -	 */
> -	if (!allow_priv && c->which == V4L2_CID_PRIVATE_BASE)
> -		return 0;
> -	if (!c->which)
> -		return 1;
> +	switch (c->which) {
> +	case V4L2_CID_PRIVATE_BASE:
> +		/*
> +		 * V4L2_CID_PRIVATE_BASE cannot be used as control class
> +		 * when using extended controls.
> +		 * Only when passed in through VIDIOC_G_CTRL and VIDIOC_S_CTRL
> +		 * is it allowed for backwards compatibility.
> +		 */
> +		if (ioctl == VIDIOC_G_CTRL || ioctl == VIDIOC_S_CTRL)
> +			return false;
> +		break;
> +	case V4L2_CTRL_WHICH_DEF_VAL:
> +		/* Default value cannot be changed */
> +		if (ioctl == VIDIOC_S_EXT_CTRLS ||
> +		    ioctl == VIDIOC_TRY_EXT_CTRLS) {
> +			c->error_idx = c->count;
> +			return false;
> +		}
> +		return true;
> +	case V4L2_CTRL_WHICH_CUR_VAL:
> +		return true;
> +	case V4L2_CTRL_WHICH_REQUEST_VAL:
> +		c->error_idx = c->count;
> +		return false;
> +	}
> +
>  	/* Check that all controls are from the same control class. */
>  	for (i = 0; i < c->count; i++) {
>  		if (V4L2_CTRL_ID2WHICH(c->controls[i].id) != c->which) {
> -			c->error_idx = i;
> -			return 0;
> +			c->error_idx = ioctl == VIDIOC_TRY_EXT_CTRLS ? i :
> +								      c->count;
> +			return false;
>  		}
>  	}
> -	return 1;
> +	return true;
>  }
>  
>  static int check_fmt(struct file *file, enum v4l2_buf_type type)
> @@ -2229,7 +2247,7 @@ static int v4l_g_ctrl(const struct v4l2_ioctl_ops *ops,
>  	ctrls.controls = &ctrl;
>  	ctrl.id = p->id;
>  	ctrl.value = p->value;
> -	if (check_ext_ctrls(&ctrls, 1)) {
> +	if (check_ext_ctrls(&ctrls, VIDIOC_G_CTRL)) {
>  		int ret = ops->vidioc_g_ext_ctrls(file, fh, &ctrls);
>  
>  		if (ret == 0)
> @@ -2263,7 +2281,7 @@ static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
>  	ctrls.controls = &ctrl;
>  	ctrl.id = p->id;
>  	ctrl.value = p->value;
> -	if (check_ext_ctrls(&ctrls, 1))
> +	if (check_ext_ctrls(&ctrls, VIDIOC_S_CTRL))
>  		return ops->vidioc_s_ext_ctrls(file, fh, &ctrls);
>  	return -EINVAL;
>  }
> @@ -2285,8 +2303,8 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  					vfd, vfd->v4l2_dev->mdev, p);
>  	if (ops->vidioc_g_ext_ctrls == NULL)
>  		return -ENOTTY;
> -	return check_ext_ctrls(p, 0) ? ops->vidioc_g_ext_ctrls(file, fh, p) :
> -					-EINVAL;
> +	return check_ext_ctrls(p, VIDIOC_G_EXT_CTRLS) ?
> +				ops->vidioc_g_ext_ctrls(file, fh, p) : -EINVAL;
>  }
>  
>  static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
> @@ -2306,8 +2324,8 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  					vfd, vfd->v4l2_dev->mdev, p);
>  	if (ops->vidioc_s_ext_ctrls == NULL)
>  		return -ENOTTY;
> -	return check_ext_ctrls(p, 0) ? ops->vidioc_s_ext_ctrls(file, fh, p) :
> -					-EINVAL;
> +	return check_ext_ctrls(p, VIDIOC_S_EXT_CTRLS) ?
> +				ops->vidioc_s_ext_ctrls(file, fh, p) : -EINVAL;
>  }
>  
>  static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
> @@ -2327,8 +2345,8 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  					  vfd, vfd->v4l2_dev->mdev, p);
>  	if (ops->vidioc_try_ext_ctrls == NULL)
>  		return -ENOTTY;
> -	return check_ext_ctrls(p, 0) ? ops->vidioc_try_ext_ctrls(file, fh, p) :
> -					-EINVAL;
> +	return check_ext_ctrls(p, VIDIOC_TRY_EXT_CTRLS) ?
> +			ops->vidioc_try_ext_ctrls(file, fh, p) : -EINVAL;
>  }
>  
>  /*

-- 
Regards,

Laurent Pinchart
