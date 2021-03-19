Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C293417E5
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 10:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCSJC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 05:02:28 -0400
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:33681 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229769AbhCSJCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 05:02:10 -0400
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud9.xs4all.net with ESMTPA
        id NB1BlKyCEGEYcNB1ElR6w0; Fri, 19 Mar 2021 10:02:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1616144528; bh=v+kMtDv2szbKV/KSjKOL3Mzf9CQd1p6KDStDP9SmKi4=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=OLeHK1hgcxvaUWo7FTFu0+fJr3mP11WDDX1IvhlXd1kM1tuXGH95LDbtPmtLtro1v
         Dt1yCEfp6A9BlcZ15eqT8OChU8kBORe25ZL7sPxmABxTpJOQ+CCcmpXDSkveUx2K66
         DRPki6z+D35ZHc19hSJ5vXJL1CKwh7OfQ8luVq7hI70/bldx6AoRe13WrEHxsI0uol
         wKF4dht5R181yJyB9Q5jBelLIakzu/CmJXSbVwa8ywCvSBcD73t8rgBCTr9HMiwaWv
         KdL9njkZvLXo76kxMZdeNYZOrNUtfIIJHJnjldVnuNW4q2OlFaFQ/oW9zBepENQSic
         vQo1jZJOgq0bw==
Subject: Re: [PATCH v7 01/17] media: v4l2-ioctl: Fix check_ext_ctrls
To:     Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org
Cc:     stable@vger.kernel.org
References: <20210318202928.166955-1-ribalda@chromium.org>
 <20210318202928.166955-2-ribalda@chromium.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <8b3305d2-ec9c-2fcd-e21c-af11c28ead86@xs4all.nl>
Date:   Fri, 19 Mar 2021 10:02:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210318202928.166955-2-ribalda@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfDdekmBROP3njrA+7a5rf05vsEaw5hswsEbm5PXHgoJShDMpy4iRl3QiyI9V6rwSlNFvIzE5o7qnAf4qaPfA+Z0OuThOe7eOa1NWvGlYLVB/LMuMalpS
 NyJ9h0bSaJigUqo1ud+V3sTa5rkQFpSUU8qjRmEkBVtWl4u1fVYHT4Fby+RdNFq8x3ZKgpq2IP8Wi9pT/LWBnvsAYHk/IC7pqJnOA6dYmzIG4bOcnUC1BNXo
 SqqtVDBwGUD1LyOH7+D4w+TqlnHkxX7csTC7hEvjXPwSi29wpXabEhpK8HfaXCDyyEzb+fyRFN6ZPF1bMwVkEG2T/tyVGeRykmljba2Z27p86ClOQnKOmgJT
 DrXt0++G+DO92P093hGTv3MWliVLZtb5djjzpoKfF1FhtioVDnPTnbChhQ1GkkRNWfBYh+mWhOLoHb2Z2tCQNmAdnXzjahGp6eBUCVIT6ddoH03NmiA=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/03/2021 21:29, Ricardo Ribalda wrote:
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
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 59 ++++++++++++++++++----------
>  1 file changed, 38 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 31d1342e61e8..ccd21b4d9c72 100644
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
> @@ -917,23 +917,40 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
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

S_CROP -> S_CTRL :-)

Regards,

	Hans

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
> +			c->error_idx = ioctl == VIDIOC_TRY_EXT_CTRLS ? i : c->count;
> +			return false;
>  		}
>  	}
> -	return 1;
> +	return true;
>  }
>  
>  static int check_fmt(struct file *file, enum v4l2_buf_type type)
> @@ -2229,7 +2246,7 @@ static int v4l_g_ctrl(const struct v4l2_ioctl_ops *ops,
>  	ctrls.controls = &ctrl;
>  	ctrl.id = p->id;
>  	ctrl.value = p->value;
> -	if (check_ext_ctrls(&ctrls, 1)) {
> +	if (check_ext_ctrls(&ctrls, VIDIOC_G_CTRL)) {
>  		int ret = ops->vidioc_g_ext_ctrls(file, fh, &ctrls);
>  
>  		if (ret == 0)
> @@ -2263,7 +2280,7 @@ static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
>  	ctrls.controls = &ctrl;
>  	ctrl.id = p->id;
>  	ctrl.value = p->value;
> -	if (check_ext_ctrls(&ctrls, 1))
> +	if (check_ext_ctrls(&ctrls, VIDIOC_S_CTRL))
>  		return ops->vidioc_s_ext_ctrls(file, fh, &ctrls);
>  	return -EINVAL;
>  }
> @@ -2285,8 +2302,8 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
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
> @@ -2306,8 +2323,8 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
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
> @@ -2327,8 +2344,8 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
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

