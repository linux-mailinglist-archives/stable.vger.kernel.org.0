Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAA2346F90
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 03:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhCXCdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 22:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbhCXCcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 22:32:41 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE2DC061763;
        Tue, 23 Mar 2021 19:32:41 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id F0E91883;
        Wed, 24 Mar 2021 03:32:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1616553160;
        bh=l7BD45qd1EreNw2oPGiKvtAPxI7dpJU1XkD1ZqEr9R0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T5q51G7369lgTkBPV6hJMlzYWYozCdmLKtEGYFrjmEFkaBNH9Rnw3Uq0z46NnlOwo
         hcSbaLCVEBIi18wZLAiEm2Ue/JNcTb1Efte23egBegX8BidBati2lzx0BObdcOK+/H
         J/Ipten2UGI3SEPY7sqqHqrt7C1EBSl3h9sXXf/g=
Date:   Wed, 24 Mar 2021 04:31:57 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, od@zcrc.me, stable@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v3 4/4] drm/ingenic: Fix non-OSD mode
Message-ID: <YFqknayQuJQmG7lm@pendragon.ideasonboard.com>
References: <20210124085552.29146-1-paul@crapouillou.net>
 <20210124085552.29146-5-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210124085552.29146-5-paul@crapouillou.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

Thank you for the patch.

On Sun, Jan 24, 2021 at 08:55:52AM +0000, Paul Cercueil wrote:
> Even though the JZ4740 did not have the OSD mode, it had (according to
> the documentation) two DMA channels, but there is absolutely no
> information about how to select the second DMA channel.
> 
> Make the ingenic-drm driver work in non-OSD mode by using the
> foreground0 plane (which is bound to the DMA0 channel) as the primary
> plane, instead of the foreground1 plane, which is the primary plane
> when in OSD mode.
> 
> Fixes: 3c9bea4ef32b ("drm/ingenic: Add support for OSD mode")
> Cc: <stable@vger.kernel.org> # v5.8+
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I don't have much knowledge about this platform, but the change looks
reasonable to me.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> index b23011c1c5d9..59ce43862e16 100644
> --- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> +++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> @@ -554,7 +554,7 @@ static void ingenic_drm_plane_atomic_update(struct drm_plane *plane,
>  		height = state->src_h >> 16;
>  		cpp = state->fb->format->cpp[0];
>  
> -		if (priv->soc_info->has_osd && plane->type == DRM_PLANE_TYPE_OVERLAY)
> +		if (!priv->soc_info->has_osd || plane->type == DRM_PLANE_TYPE_OVERLAY)
>  			hwdesc = &priv->dma_hwdescs->hwdesc_f0;
>  		else
>  			hwdesc = &priv->dma_hwdescs->hwdesc_f1;
> @@ -826,6 +826,7 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
>  	const struct jz_soc_info *soc_info;
>  	struct ingenic_drm *priv;
>  	struct clk *parent_clk;
> +	struct drm_plane *primary;
>  	struct drm_bridge *bridge;
>  	struct drm_panel *panel;
>  	struct drm_encoder *encoder;
> @@ -940,9 +941,11 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
>  	if (soc_info->has_osd)
>  		priv->ipu_plane = drm_plane_from_index(drm, 0);
>  
> -	drm_plane_helper_add(&priv->f1, &ingenic_drm_plane_helper_funcs);
> +	primary = priv->soc_info->has_osd ? &priv->f1 : &priv->f0;
>  
> -	ret = drm_universal_plane_init(drm, &priv->f1, 1,
> +	drm_plane_helper_add(primary, &ingenic_drm_plane_helper_funcs);
> +
> +	ret = drm_universal_plane_init(drm, primary, 1,
>  				       &ingenic_drm_primary_plane_funcs,
>  				       priv->soc_info->formats_f1,
>  				       priv->soc_info->num_formats_f1,
> @@ -954,7 +957,7 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
>  
>  	drm_crtc_helper_add(&priv->crtc, &ingenic_drm_crtc_helper_funcs);
>  
> -	ret = drm_crtc_init_with_planes(drm, &priv->crtc, &priv->f1,
> +	ret = drm_crtc_init_with_planes(drm, &priv->crtc, primary,
>  					NULL, &ingenic_drm_crtc_funcs, NULL);
>  	if (ret) {
>  		dev_err(dev, "Failed to init CRTC: %i\n", ret);

-- 
Regards,

Laurent Pinchart
