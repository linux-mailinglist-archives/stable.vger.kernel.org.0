Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DF42F9CD0
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 11:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389127AbhARK0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 05:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389177AbhARJop (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 04:44:45 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F8FC061573;
        Mon, 18 Jan 2021 01:44:05 -0800 (PST)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6DB092BB;
        Mon, 18 Jan 2021 10:44:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1610963043;
        bh=xxk+lHswU9GlVNAzi20vlKRav8h21hAOnc3sgblTiI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GfDVi4uOmKDP4tvYUwfaXmm9qFwbo13a2g19YNpayVOme+gSnX1h+XsReQbiQkAIZ
         /ybBeCnZDJMG2EIL4aM8+v7jxOkw9cTc3nqeS+0tRvYNLF9fWqUK3bAdnwx5Q8US7E
         hCRN4K0l/UvsWd8MdYfweJqCJLUttELffGps90J8=
Date:   Mon, 18 Jan 2021 11:43:47 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org, od@zcrc.me,
        dri-devel@lists.freedesktop.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 2/3] drm/ingenic: Register devm action to cleanup encoders
Message-ID: <YAVYUzR9+ic5lEjE@pendragon.ideasonboard.com>
References: <20210117112646.98353-1-paul@crapouillou.net>
 <20210117112646.98353-3-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210117112646.98353-3-paul@crapouillou.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

Thank you for the patch.

On Sun, Jan 17, 2021 at 11:26:45AM +0000, Paul Cercueil wrote:
> Since the encoders have been devm-allocated, they will be freed way
> before drm_mode_config_cleanup() is called. To avoid use-after-free
> conditions, we then must ensure that drm_encoder_cleanup() is called
> before the encoders are freed.

How about allocating the encoder with drmm_encoder_alloc() instead ?

> Fixes: c369cb27c267 ("drm/ingenic: Support multiple panels/bridges")
> Cc: <stable@vger.kernel.org> # 5.8+
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> index 368bfef8b340..d23a3292a0e0 100644
> --- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> +++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> @@ -803,6 +803,11 @@ static void __maybe_unused ingenic_drm_release_rmem(void *d)
>  	of_reserved_mem_device_release(d);
>  }
>  
> +static void ingenic_drm_encoder_cleanup(void *encoder)
> +{
> +	drm_encoder_cleanup(encoder);
> +}
> +
>  static int ingenic_drm_bind(struct device *dev, bool has_components)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
> @@ -1011,6 +1016,11 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
>  			return ret;
>  		}
>  
> +		ret = devm_add_action_or_reset(dev, ingenic_drm_encoder_cleanup,
> +					       encoder);
> +		if (ret)
> +			return ret;
> +
>  		ret = drm_bridge_attach(encoder, bridge, NULL, 0);
>  		if (ret) {
>  			dev_err(dev, "Unable to attach bridge\n");

-- 
Regards,

Laurent Pinchart
