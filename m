Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA8DFAE3
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 15:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfD3N6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 09:58:20 -0400
Received: from retiisi.org.uk ([95.216.213.190]:43680 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726105AbfD3N6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 09:58:20 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2a01:4f9:c010:4572::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 3787D634C7B;
        Tue, 30 Apr 2019 16:58:10 +0300 (EEST)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1hLTGr-0000hd-Rk; Tue, 30 Apr 2019 16:58:09 +0300
Date:   Tue, 30 Apr 2019 16:58:09 +0300
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 03/14] media: ov6650: Fix unverified arguments used in
 .set_fmt()
Message-ID: <20190430135809.5mgf4govbqj3cxph@valkosipuli.retiisi.org.uk>
References: <20190408214242.9603-1-jmkrzyszt@gmail.com>
 <20190408214242.9603-4-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408214242.9603-4-jmkrzyszt@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Janusz,

On Mon, Apr 08, 2019 at 11:42:31PM +0200, Janusz Krzysztofik wrote:
> Commit 717fd5b4907ad ("[media] v4l2: replace try_mbus_fmt by set_fmt")
> converted a former ov6650_try_fmt() video operation callback to an
> ov6650_set_fmt() pad operation callback.  However, the function does not
> verify correctness of user provided format->which flag and pad config
> pointer arguments.  Fix it.
> 
> Fixes: 717fd5b4907ad ("[media] v4l2: replace try_mbus_fmt by set_fmt")
> Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/media/i2c/ov6650.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
> index 007f0ca24913..3062c9a6c57b 100644
> --- a/drivers/media/i2c/ov6650.c
> +++ b/drivers/media/i2c/ov6650.c
> @@ -679,6 +679,17 @@ static int ov6650_set_fmt(struct v4l2_subdev *sd,
>  	if (format->pad)
>  		return -EINVAL;
>  
> +	switch (format->which) {
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		break;
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		if (cfg)
> +			break;
> +		/* fall through */
> +	default:
> +		return -EINVAL;
> +	}

For this to return an error, there would need to be a problem on the
caller's side. In other words, this isn't supposed to happen.

Instead of adding such checks to all drivers, I think they instead should
be added to the caller's side. The checks already exist for uAPI, but not
for other drivers.

The same applies to patches until 7th (including).

> +
>  	if (is_unscaled_ok(mf->width, mf->height, &priv->rect))
>  		v4l_bound_align_image(&mf->width, 2, W_CIF, 1,
>  				&mf->height, 2, H_CIF, 1, 0);

-- 
Kind regards,

Sakari Ailus
