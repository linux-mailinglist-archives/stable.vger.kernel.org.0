Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C4D340016
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 08:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhCRHPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 03:15:23 -0400
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:43365 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229540AbhCRHO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 03:14:56 -0400
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud7.xs4all.net with ESMTPA
        id MmrqlHb9oDUxpMmrtlhxEO; Thu, 18 Mar 2021 08:14:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1616051694; bh=AlQSxDB4wmgR+CS/wX1VZjchpLMI9Lhy9x8Te1xxGcE=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=ZGX1b2YKzmP/QtJc7WQXN3Pvdo3p+ZHXMBYG4OV/SY6gYQDH2PVMmyOpGDaD2byGE
         C7oo8X9G0sbHWOnN35rVL4deytgYcERcp0NO1Ab6Lg/hsUk3qIghrtCVqqFPuEFS4f
         4SV5Y40hp85Zmr6RTdl5d+Y0SFKu4LgTkbs6bqGQ583Vz7LfiHQAb7Ke4EZVxqi1wJ
         1CD0dcVDRCPJD94T0R9+NaJroAuLJZYR8tzdEtZE58dQzqjV7s7f2WEEZ6Yp7ORwJe
         cm4m2OzY28+V+hhEd4uQx1N1+PDTP3p+xlvvbUincyZhR5xYmmz8swkj5c+n+nzbEv
         VGLfBdU9xu2IA==
Subject: Re: [PATCH v6 01/17] media: v4l2-ioctl: check_ext_ctrls: Fix
 multiclass V4L2_CTRL_WHICH_DEF_VAL
To:     Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org
Cc:     stable@vger.kernel.org
References: <20210317164511.39967-1-ribalda@chromium.org>
 <20210317164511.39967-2-ribalda@chromium.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <f07a5767-fced-18af-8219-6e54b83a785d@xs4all.nl>
Date:   Thu, 18 Mar 2021 08:14:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210317164511.39967-2-ribalda@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfIAK1Ru+FwUriGLVGEH3AndJIMBqxiQjEmJUzMZ8MNVFI8BNtc63mTCkcH2Dz5gyOkTH4Jgwfa9mYHAG8n3/whcPd9GjjizLalLnv9/XHwvDnu5b6sWP
 xVmXefPXlht1gSSWrRV6jxZaK9Dx0B9djZp1DsmDWlCNK+bOWcEEyKn8H1EmJMBIXR3SO4iN7qI6O8jp9JcQfVV6hAKxYoCqlAwiZDpx79RNQDK0BA+4qGhj
 2uDrYqTg4+rPeXEp550rFCGgKmE18aXSAXKVP2zCErT3JB+SkyT9FNtn7emU5fpwTqmTOucx2VGZx6FA1ayzpdyPmNFqtLSSAIHPVEcbtpJ62jPdm/cF4sqe
 2/WIdJ3ePF7Na/J60Ux+j17C3Gd7kSr/wVlgW8MOYgg4rmzVFjNqomYgmW5GpuCT9eXQLcWBT7ZHUwzF+ZQ3fWdgKQvpiQ0r0ujKl0qtNAOqamNwA0I=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo,

On 17/03/2021 17:44, Ricardo Ribalda wrote:
> Drivers that do not use the ctrl-framework use this function instead.
> 
> - Do not check for multiple classes when getting the DEF_VAL.
> 
> Fixes v4l2-compliance:
> Control ioctls (Input 0):
> 		fail: v4l2-test-controls.cpp(813): doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls)
> 	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL

Can you merge patches 1-4 into a single patch? It's really one big fix since
this code was never updated when new 'which' values were added. So keeping it
together is, for once, actually preferred.

You can add my:

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

after these 4 patches are merged. It looks much nicer now.

Regards,

	Hans

> 
> Cc: stable@vger.kernel.org
> Fixes: 6fa6f831f095 ("media: v4l2-ctrls: add core request support")
> Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 47 ++++++++++++++++------------
>  1 file changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 31d1342e61e8..403f957a1012 100644
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
> @@ -917,23 +917,30 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
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
> +		if (ioctl == VIDIOC_G_CTRL || ioctl == VIDIOC_S_CROP)
> +			return false;
> +		break;
> +	case V4L2_CTRL_WHICH_DEF_VAL:
> +	case V4L2_CTRL_WHICH_CUR_VAL:
> +		return true;
> +	}
> +
>  	/* Check that all controls are from the same control class. */
>  	for (i = 0; i < c->count; i++) {
>  		if (V4L2_CTRL_ID2WHICH(c->controls[i].id) != c->which) {
>  			c->error_idx = i;
> -			return 0;
> +			return false;
>  		}
>  	}
> -	return 1;
> +	return true;
>  }
>  
>  static int check_fmt(struct file *file, enum v4l2_buf_type type)
> @@ -2229,7 +2236,7 @@ static int v4l_g_ctrl(const struct v4l2_ioctl_ops *ops,
>  	ctrls.controls = &ctrl;
>  	ctrl.id = p->id;
>  	ctrl.value = p->value;
> -	if (check_ext_ctrls(&ctrls, 1)) {
> +	if (check_ext_ctrls(&ctrls, VIDIOC_G_CTRL)) {
>  		int ret = ops->vidioc_g_ext_ctrls(file, fh, &ctrls);
>  
>  		if (ret == 0)
> @@ -2263,7 +2270,7 @@ static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
>  	ctrls.controls = &ctrl;
>  	ctrl.id = p->id;
>  	ctrl.value = p->value;
> -	if (check_ext_ctrls(&ctrls, 1))
> +	if (check_ext_ctrls(&ctrls, VIDIOC_S_CTRL))
>  		return ops->vidioc_s_ext_ctrls(file, fh, &ctrls);
>  	return -EINVAL;
>  }
> @@ -2285,8 +2292,8 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
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
> @@ -2306,8 +2313,8 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
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
> @@ -2327,8 +2334,8 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
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
> 

