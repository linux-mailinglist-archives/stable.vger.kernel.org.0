Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBD95B1C36
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 14:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiIHMIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 08:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiIHMIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 08:08:34 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56533F5C6F;
        Thu,  8 Sep 2022 05:08:33 -0700 (PDT)
Received: from [192.168.1.111] (91-158-154-79.elisa-laajakaista.fi [91.158.154.79])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 90137888;
        Thu,  8 Sep 2022 14:08:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1662638910;
        bh=CkG/MazVFplR8mYzQrftiKr7OKNvPkPqMPac0VAkq94=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CGVdRO08SxMJyaJrSafYnAPBd6fMzPWt3e8RmFAVovNvy3bPJdtkmMtWaS9k1/MjT
         egVDt55JlacdzaulDZdS6pWpDvWtx4UPEFPb9dsu0+LAa49L+J1kCk8piv9Hg1oXEL
         tyUR45KODpQH9CfRTxOMvELUS90U8SAm3o5QtjLs=
Message-ID: <c0ad65c5-818d-da5c-178a-dfaf685f8d24@ideasonboard.com>
Date:   Thu, 8 Sep 2022 15:08:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ipu3-imgu: Fix NULL pointer dereference in
 imgu_subdev_set_selection()
Content-Language: en-US
To:     Maximilian Luz <luzmaximilian@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Bingbu Cao <bingbu.cao@intel.com>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220907224409.3187482-1-luzmaximilian@gmail.com>
From:   Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
In-Reply-To: <20220907224409.3187482-1-luzmaximilian@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/09/2022 01:44, Maximilian Luz wrote:
> Calling v4l2_subdev_get_try_crop() and v4l2_subdev_get_try_compose()
> with a subdev state of NULL leads to a NULL pointer dereference. This
> can currently happen in imgu_subdev_set_selection() when the state
> passed in is NULL, as this method first gets pointers to both the "try"
> and "active" states and only then decides which to use.
> 
> The same issue has been addressed for imgu_subdev_get_selection() with
> commit 30d03a0de650 ("ipu3-imgu: Fix NULL pointer dereference in active
> selection access"). However the issue still persists in
> imgu_subdev_set_selection().
> 
> Therefore, apply a similar fix as done in the aforementioned commit to
> imgu_subdev_set_selection(). To keep things a bit cleaner, introduce
> helper functions for "crop" and "compose" access and use them in both
> imgu_subdev_set_selection() and imgu_subdev_get_selection().
> 
> Fixes: 0d346d2a6f54 ("media: v4l2-subdev: add subdev-wide state struct")
> Cc: stable@vger.kernel.org # for v5.14 and later
> Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
> ---
>   drivers/staging/media/ipu3/ipu3-v4l2.c | 57 +++++++++++++++-----------
>   1 file changed, 34 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
> index ce13e746c15f..e530767e80a5 100644
> --- a/drivers/staging/media/ipu3/ipu3-v4l2.c
> +++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
> @@ -188,6 +188,28 @@ static int imgu_subdev_set_fmt(struct v4l2_subdev *sd,
>   	return 0;
>   }
>   
> +static struct v4l2_rect *
> +imgu_subdev_get_crop(struct imgu_v4l2_subdev *sd,
> +		     struct v4l2_subdev_state *sd_state, unsigned int pad,
> +		     enum v4l2_subdev_format_whence which)
> +{
> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
> +		return v4l2_subdev_get_try_crop(&sd->subdev, sd_state, pad);
> +	else
> +		return &sd->rect.eff;
> +}
> +
> +static struct v4l2_rect *
> +imgu_subdev_get_compose(struct imgu_v4l2_subdev *sd,
> +			struct v4l2_subdev_state *sd_state, unsigned int pad,
> +			enum v4l2_subdev_format_whence which)
> +{
> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
> +		return v4l2_subdev_get_try_compose(&sd->subdev, sd_state, pad);
> +	else
> +		return &sd->rect.bds;
> +}


If I understand right, these functions are only called with pad 0 
(IMGU_NODE_IN). I would drop the pad argument here and use IMGU_NODE_IN. 
Otherwise it gives a false idea that other pads could be used with these 
functions, and that would fail for the V4L2_SUBDEV_FORMAT_ACTIVE case.

However, that's not a big issue. With or without the change:

Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

  Tomi
