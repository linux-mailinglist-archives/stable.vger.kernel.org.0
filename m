Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFF833EE88
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 11:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhCQKn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 06:43:59 -0400
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:44837 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230034AbhCQKnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 06:43:42 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2021 06:43:42 EDT
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud9.xs4all.net with ESMTPA
        id MTXTlA9fKGEYcMTXXlN8Xa; Wed, 17 Mar 2021 11:36:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1615977395; bh=VZVA94vcZQUs1b/HuXvvarXkTuyIvnAiDo9ccC8Gd5k=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=gurBdK5D9nc6kyHcfcLa6CgHJQaMOxWoNBRHVxUpatdSk0LiDo+Rrz7R98owJPb53
         GsddQbOHdGgcPClJdcoN/xVwS1GejgdLA4U6Jipn/tjkaflozy+k6RfF/iiwHjlqHv
         a1apqp31AYJGjSeySCvl/DTKj53TynAm00fd1hv+6yzSAEA4tKSWdryn8LsQdgEyoF
         /W91JgqzQge4rzktUpnv6uGhw+2C4B0p4fgxd0qUzFygwHrABGDh8f2XC05oYL7M+P
         M50qlYAcF/LIsuSbPmDdqAI1Lk2JPYreQYyfy6e5XTsoBFY+P2zdIur4BTK1Z6laPB
         ewt6p3SIKut/g==
Subject: Re: [PATCH v5 01/13] media: v4l2-ioctl: Fix check_ext_ctrls
To:     Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org
Cc:     stable@vger.kernel.org
References: <20210316180004.1605727-1-ribalda@chromium.org>
 <20210316180004.1605727-2-ribalda@chromium.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <176411ad-97de-ab83-d5f3-1977cadcbcfa@xs4all.nl>
Date:   Wed, 17 Mar 2021 11:36:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210316180004.1605727-2-ribalda@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfK76AdYDNN2b+tZ16LYeoFrztOE8V/7HovzaQZN6RGV8i33rmJ3aKorCgC5A4D75f7CfQo2dZqy9dC1Q7ZEpqkuthtVQVErxf9iW5cDuty8AKrP7czVy
 XyXIWs10qD/s2qQH6V9jHC78oqEWxCSOO8cBmO1KE/xfSQcaXFE4jgzH3g7Rg1itcdPXHDCXfXg1Xt/X7zcWGQT8FD4sU9e9YoY+Zbisydj7uVYLHZCn7jdx
 geY4ZqLQQa0kP4Clvn2nWpt+kgLBZE5Zat+D2K02y7HuWmfLWAxToLGSZB78AmzaMXbsvWWPHsNy/iu+z+p3C+yqB1+o55baNzROqrEl733H8haFwvUyqh/i
 glbp1BVtcIO7PC9D6tEUyL57qmtxbh2Nd5TCDBcvVg8K0qAoB+D3c8LJ3v4edcnZM59c3fi1SpHMfUQ0Nl9crh0BBkwckgvHMzMuhj50F4FEOU/Z78c=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16/03/2021 18:59, Ricardo Ribalda wrote:
> Drivers that do not use the ctrl-framework use this function instead.
> 
> - Return error when handling of REQUEST_VAL.
> - Do not check for multiple classes when getting the DEF_VAL.
> 
> Fixes v4l2-compliance:
> Control ioctls (Input 0):
> 		fail: v4l2-test-controls.cpp(813): doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls)
> 	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
> 
> Cc: stable@vger.kernel.org
> Fixes: 6fa6f831f095 ("media: v4l2-ctrls: add core request support")
> Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 31d1342e61e8..9406e90ff805 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -917,15 +917,24 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)

allow_priv really should be a bool.

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
> +	switch (c->which) {
> +	case V4L2_CID_PRIVATE_BASE:
> +		/*
> +		 * V4L2_CID_PRIVATE_BASE cannot be used as control class
> +		 * when using extended controls.
> +		 * Only when passed in through VIDIOC_G_CTRL and VIDIOC_S_CTRL
> +		 * is it allowed for backwards compatibility.
> +		*/
> +		if (!allow_priv)
> +			return 0;
> +		break;
> +	case V4L2_CTRL_WHICH_DEF_VAL:

I think it would be better if a second bool 'is_get' argument is added that is true
for g_ctrl and g_ext_ctrls: then you can do a 'return is_get;' here. That way drivers
do not need to take care of V4L2_CTRL_WHICH_DEF_VAL for set/try.

Regards,

	Hans

> +	case V4L2_CTRL_WHICH_CUR_VAL:
>  		return 1;
> +	case V4L2_CTRL_WHICH_REQUEST_VAL:
> +		return 0;
> +	}
> +
>  	/* Check that all controls are from the same control class. */
>  	for (i = 0; i < c->count; i++) {
>  		if (V4L2_CTRL_ID2WHICH(c->controls[i].id) != c->which) {
> 

