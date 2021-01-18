Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC902F9CD1
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 11:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389144AbhARK0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 05:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389181AbhARJou (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 04:44:50 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFF3C061575;
        Mon, 18 Jan 2021 01:44:07 -0800 (PST)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 3A5D2AF0;
        Mon, 18 Jan 2021 10:44:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1610963046;
        bh=u/RGNnTWYJkbFYhanUxjfVEHJfSz/1T8zo9agvGtStE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XlfpbthhtUr1NTmAtFPFZ/OAla0Ej7qPB5RDBO8m8YRHC873pDiRXuT/Ik0DRHR1a
         I985M5iCiBG+bFLuwNRNOfl8b1m6MJC0HvD+JqoHhxPoNF3ILBwUzOfdg7j06n3w0S
         Z6817DKfi58aoQG1c47KA8EgsIRh5D+qkK2XqLRs=
Date:   Mon, 18 Jan 2021 11:43:50 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Sam Ravnborg <sam@ravnborg.org>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>
Subject: Re: [PATCH 1/3] drm: bridge/panel: Cleanup connector on bridge detach
Message-ID: <YAVYVkb7SPZLAiOZ@pendragon.ideasonboard.com>
References: <20210117112646.98353-1-paul@crapouillou.net>
 <20210117112646.98353-2-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210117112646.98353-2-paul@crapouillou.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

Thank you for the patch.

On Sun, Jan 17, 2021 at 11:26:44AM +0000, Paul Cercueil wrote:
> If we don't call drm_connector_cleanup() manually in
> panel_bridge_detach(), the connector will be cleaned up with the other
> DRM objects in the call to drm_mode_config_cleanup(). However, since our
> drm_connector is devm-allocated, by the time drm_mode_config_cleanup()
> will be called, our connector will be long gone. Therefore, the
> connector must be cleaned up when the bridge is detached to avoid
> use-after-free conditions.
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
>  drivers/gpu/drm/bridge/panel.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/bridge/panel.c b/drivers/gpu/drm/bridge/panel.c
> index 0ddc37551194..975d65c14c9c 100644
> --- a/drivers/gpu/drm/bridge/panel.c
> +++ b/drivers/gpu/drm/bridge/panel.c
> @@ -87,6 +87,10 @@ static int panel_bridge_attach(struct drm_bridge *bridge,
>  
>  static void panel_bridge_detach(struct drm_bridge *bridge)
>  {
> +	struct panel_bridge *panel_bridge = drm_bridge_to_panel_bridge(bridge);
> +	struct drm_connector *connector = &panel_bridge->connector;
> +
> +	drm_connector_cleanup(connector);

The panel bridge driver only creates the connector if the
DRM_BRIDGE_ATTACH_NO_CONNECTOR flag wasn't set in panel_bridge_attach().
We shouldn't clean up the connector unconditionally.

A better fix would be to stop using the devm_* API, but that's more
complicated.

>  }
>  
>  static void panel_bridge_pre_enable(struct drm_bridge *bridge)

-- 
Regards,

Laurent Pinchart
