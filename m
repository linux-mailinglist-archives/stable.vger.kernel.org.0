Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBF13381A6
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 00:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhCKXn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 18:43:59 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:43348 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhCKXn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 18:43:56 -0500
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1397F88F;
        Fri, 12 Mar 2021 00:43:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1615506235;
        bh=ozdy96rbUlmL2Ihxn0PG6hwkkYtEpwgXYdHM9705AMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kVQLcod2wwgzihfDu3o5vUGu6gn0/3sCSaNcyAcCmgmfFY0+rouz6/G7HTqWOYIr0
         VmA9lwbqzET6HfcT2riGjIS00piDzthtvdNtVC0IcSn4oaJmiSomz8+wSi6+oLaq0L
         M+lgzsaleod/Bo+cVELPh3XptqDJT89ecKYuncBo=
Date:   Fri, 12 Mar 2021 01:43:21 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, senozhatsky@chromium.org,
        Hans Verkuil <hverkuil@xs4all.nl>, stable@vger.kernel.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: Re: [PATCH v2 1/6] media: v4l2-ioctl: Fix check_ext_ctrls
Message-ID: <YEqrGQXEARuyUBUI@pendragon.ideasonboard.com>
References: <20210311221946.1319924-1-ribalda@chromium.org>
 <20210311221946.1319924-2-ribalda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210311221946.1319924-2-ribalda@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo,

Thank you for the patch.

On Thu, Mar 11, 2021 at 11:19:41PM +0100, Ricardo Ribalda wrote:
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
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 31d1342e61e8..6f6b310e2802 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -924,8 +924,10 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
>  	 */
>  	if (!allow_priv && c->which == V4L2_CID_PRIVATE_BASE)
>  		return 0;
> -	if (!c->which)
> +	if (!c->which || c->which == V4L2_CTRL_WHICH_DEF_VAL)

How about

	if (c->which == V4L2_CTRL_WHICH_CUR_VAL ||
	    c->which == V4L2_CTRL_WHICH_DEF_VAL)

>  		return 1;
> +	if (c->which == V4L2_CTRL_WHICH_REQUEST_VAL)
> +		return 0;

Or possibly

	switch (c->which) {
	case V4L2_CTRL_WHICH_CUR_VAL:
	case V4L2_CTRL_WHICH_DEF_VAL:
		return 1;
	case V4L2_CTRL_WHICH_REQUEST_VAL:
		return 0;
	}

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  	/* Check that all controls are from the same control class. */
>  	for (i = 0; i < c->count; i++) {
>  		if (V4L2_CTRL_ID2WHICH(c->controls[i].id) != c->which) {

-- 
Regards,

Laurent Pinchart
