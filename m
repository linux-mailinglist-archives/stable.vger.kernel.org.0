Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF266C4D32
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 15:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjCVONE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 10:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjCVONB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 10:13:01 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249906485D;
        Wed, 22 Mar 2023 07:12:51 -0700 (PDT)
Received: from pendragon.ideasonboard.com (213-243-189-158.bb.dnainternet.fi [213.243.189.158])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8F367118E;
        Wed, 22 Mar 2023 15:12:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1679494368;
        bh=88STxbmTABTxETL9/vEcf/srguNOQ0Th+PpdA0xD54k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sZVpqef+IbPAIAKXsdkPd+cVkRgxGqQOONeMCCUkwdqDkGDAneQQvteaNh5QA5Lfc
         jemAJwxcR6m/AcrbjS03z+HG35s0Yj9v7tLqTt00cIFteE/E3NvanIyBIfcYVDS6ni
         5diBzhbCRYPfYI5RDikWHOga0mY5JWTdrqlkCFno=
Date:   Wed, 22 Mar 2023 16:12:55 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     Adrien Grassein <adrien.grassein@gmail.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Matheus Castello <matheus.castello@toradex.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH v1] drm/bridge: lt8912b: return EPROBE_DEFER if bridge is
 not found
Message-ID: <20230322141255.GN20234@pendragon.ideasonboard.com>
References: <20230322140309.95936-1-francesco@dolcini.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230322140309.95936-1-francesco@dolcini.it>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Francesco,

Thank you for the patch.

On Wed, Mar 22, 2023 at 03:03:09PM +0100, Francesco Dolcini wrote:
> From: Matheus Castello <matheus.castello@toradex.com>
> 
> Returns EPROBE_DEFER when of_drm_find_bridge() fails, this is consistent
> with what all the other DRM bridge drivers are doing and this is
> required since the bridge might not be there when the driver is probed
> and this should not be a fatal failure.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
> Signed-off-by: Matheus Castello <matheus.castello@toradex.com>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
>  drivers/gpu/drm/bridge/lontium-lt8912b.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
> index 2019a8167d69..fec02e47cfdb 100644
> --- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
> +++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
> @@ -676,8 +676,8 @@ static int lt8912_parse_dt(struct lt8912 *lt)
>  
>  	lt->hdmi_port = of_drm_find_bridge(port_node);
>  	if (!lt->hdmi_port) {
> -		dev_err(lt->dev, "%s: Failed to get hdmi port\n", __func__);
> -		ret = -ENODEV;
> +		dev_dbg(lt->dev, "%s: Failed to get hdmi port\n", __func__);

Please use dev_err_probe(). Apart from that, the patch looks fine to me.

> +		ret = -EPROBE_DEFER;
>  		goto err_free_host_node;
>  	}
>  

-- 
Regards,

Laurent Pinchart
