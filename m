Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3192C71DD
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgK1WDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 17:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbgK1WDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 17:03:50 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FB0C0613D1;
        Sat, 28 Nov 2020 14:03:09 -0800 (PST)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 849E5BAB;
        Sat, 28 Nov 2020 23:03:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1606600986;
        bh=7YBJuQtYHj9dTjRd/vaK8Nvo8/JkMSaK6DjkqheZcDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K+ahAnV2fIg69sbwr1pxAHmGlg3Low8EoyzuO2lb1zd71bLQJmWauXJ0HF1M05duZ
         jR0z7+WiI8QWoswNWIz6v+afNsuyyxS98DYkMYTIa7Geq4af8qOKPINPb96D3rqnua
         e/T6o+aCq+NXbhgiMuXEK1vBAqA3JCyX4lyjHHig=
Date:   Sun, 29 Nov 2020 00:02:57 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     dri-devel@lists.freedesktop.org,
        Nikhil Devshatwar <nikhil.nd@ti.com>,
        linux-omap@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        stable@vger.kernel.org,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: Re: [PATCH] drm/omap: sdi: fix bridge enable/disable
Message-ID: <20201128220257.GB3865@pendragon.ideasonboard.com>
References: <20201127085241.848461-1-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201127085241.848461-1-tomi.valkeinen@ti.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tomi,

Thank you for the patch.

On Fri, Nov 27, 2020 at 10:52:41AM +0200, Tomi Valkeinen wrote:
> When the SDI output was converted to DRM bridge, the atomic versions of
> enable and disable funcs were used. This was not intended, as that would
> require implementing other atomic funcs too. This leads to:
> 
> WARNING: CPU: 0 PID: 18 at drivers/gpu/drm/drm_bridge.c:708 drm_atomic_helper_commit_modeset_enables+0x134/0x268
> 
> and display not working.
> 
> Fix this by using the legacy enable/disable funcs.
> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Fixes: 8bef8a6d5da81b909a190822b96805a47348146f ("drm/omap: sdi: Register a drm_bridge")
> Cc: stable@vger.kernel.org # v5.7+
> Tested-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/gpu/drm/omapdrm/dss/sdi.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/omapdrm/dss/sdi.c b/drivers/gpu/drm/omapdrm/dss/sdi.c
> index 033fd30074b0..282e4c837cd9 100644
> --- a/drivers/gpu/drm/omapdrm/dss/sdi.c
> +++ b/drivers/gpu/drm/omapdrm/dss/sdi.c
> @@ -195,8 +195,7 @@ static void sdi_bridge_mode_set(struct drm_bridge *bridge,
>  	sdi->pixelclock = adjusted_mode->clock * 1000;
>  }
>  
> -static void sdi_bridge_enable(struct drm_bridge *bridge,
> -			      struct drm_bridge_state *bridge_state)
> +static void sdi_bridge_enable(struct drm_bridge *bridge)
>  {
>  	struct sdi_device *sdi = drm_bridge_to_sdi(bridge);
>  	struct dispc_clock_info dispc_cinfo;
> @@ -259,8 +258,7 @@ static void sdi_bridge_enable(struct drm_bridge *bridge,
>  	regulator_disable(sdi->vdds_sdi_reg);
>  }
>  
> -static void sdi_bridge_disable(struct drm_bridge *bridge,
> -			       struct drm_bridge_state *bridge_state)
> +static void sdi_bridge_disable(struct drm_bridge *bridge)
>  {
>  	struct sdi_device *sdi = drm_bridge_to_sdi(bridge);
>  
> @@ -278,8 +276,8 @@ static const struct drm_bridge_funcs sdi_bridge_funcs = {
>  	.mode_valid = sdi_bridge_mode_valid,
>  	.mode_fixup = sdi_bridge_mode_fixup,
>  	.mode_set = sdi_bridge_mode_set,
> -	.atomic_enable = sdi_bridge_enable,
> -	.atomic_disable = sdi_bridge_disable,
> +	.enable = sdi_bridge_enable,
> +	.disable = sdi_bridge_disable,
>  };
>  
>  static void sdi_bridge_init(struct sdi_device *sdi)

-- 
Regards,

Laurent Pinchart
