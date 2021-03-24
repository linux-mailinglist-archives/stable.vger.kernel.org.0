Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2401B346F5A
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 03:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhCXCR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 22:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbhCXCR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 22:17:28 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2056EC061763;
        Tue, 23 Mar 2021 19:17:28 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5A638580;
        Wed, 24 Mar 2021 03:17:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1616552245;
        bh=qmQLAPlk4G6/WYtsOH5D1LVgkD6Jy8yQNYSAiaOxFOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hjiGesnakNcI11YiR1n37fS+ZicFYib3eqRR5Y7wvWep3+rnjl0gVNb9/y/w0mWFK
         cn3qV2pdgV9GiX9wF7zX9O3cV9Ut8MMpyy+iHoUY2x6iU9bHMmtUbnMuyfXjmbOBIh
         C8mLVldMPkFMu9fJNqiEmRkziuUZO/F5ClsnnvgA=
Date:   Wed, 24 Mar 2021 04:16:43 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jonas Karlman <jonas@kwiboo.se>, linux-mips@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>, od@zcrc.me,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v3 1/4] drm: bridge/panel: Cleanup connector on bridge
 detach
Message-ID: <YFqhC6e/Gb2JrKyC@pendragon.ideasonboard.com>
References: <20210124085552.29146-1-paul@crapouillou.net>
 <20210124085552.29146-2-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210124085552.29146-2-paul@crapouillou.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

Thank you for the patch.

On Sun, Jan 24, 2021 at 08:55:49AM +0000, Paul Cercueil wrote:
> If we don't call drm_connector_cleanup() manually in
> panel_bridge_detach(), the connector will be cleaned up with the other
> DRM objects in the call to drm_mode_config_cleanup(). However, since our
> drm_connector is devm-allocated, by the time drm_mode_config_cleanup()
> will be called, our connector will be long gone. Therefore, the
> connector must be cleaned up when the bridge is detached to avoid
> use-after-free conditions.
> 
> v2: Cleanup connector only if it was created
> 
> v3: Add FIXME
> 
> Fixes: 13dfc0540a57 ("drm/bridge: Refactor out the panel wrapper from the lvds-encoder bridge.")
> Cc: <stable@vger.kernel.org> # 4.12+
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: Neil Armstrong <narmstrong@baylibre.com>
> Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
> Cc: Jonas Karlman <jonas@kwiboo.se>
> Cc: Jernej Skrabec <jernej.skrabec@siol.net>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  drivers/gpu/drm/bridge/panel.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/gpu/drm/bridge/panel.c b/drivers/gpu/drm/bridge/panel.c
> index 0ddc37551194..5959e8183cd0 100644
> --- a/drivers/gpu/drm/bridge/panel.c
> +++ b/drivers/gpu/drm/bridge/panel.c
> @@ -87,6 +87,18 @@ static int panel_bridge_attach(struct drm_bridge *bridge,
>  
>  static void panel_bridge_detach(struct drm_bridge *bridge)
>  {
> +	struct panel_bridge *panel_bridge = drm_bridge_to_panel_bridge(bridge);
> +	struct drm_connector *connector = &panel_bridge->connector;
> +
> +	/*
> +	 * Cleanup the connector if we know it was initialized.
> +	 *
> +	 * FIXME: This wouldn't be needed if the panel_bridge structure was
> +	 * allocated with drmm_kzalloc(). This might be tricky since the
> +	 * drm_device pointer can only be retrieved when the bridge is attached.
> +	 */
> +	if (!!panel_bridge->connector.dev)

How about simply

	if (connector->dev)

? With this change,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +		drm_connector_cleanup(connector);
>  }
>  
>  static void panel_bridge_pre_enable(struct drm_bridge *bridge)

-- 
Regards,

Laurent Pinchart
