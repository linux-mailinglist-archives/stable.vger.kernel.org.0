Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6851D6651
	for <lists+stable@lfdr.de>; Sun, 17 May 2020 08:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgEQGRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 May 2020 02:17:42 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:51790 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgEQGRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 May 2020 02:17:42 -0400
Received: from ravnborg.org (unknown [158.248.194.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id C667780533;
        Sun, 17 May 2020 08:17:38 +0200 (CEST)
Date:   Sun, 17 May 2020 08:17:37 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, od@zcrc.me, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 04/12] gpu/drm: ingenic: Fix bogus crtc_atomic_check
 callback
Message-ID: <20200517061737.GC609600@ravnborg.org>
References: <20200516215057.392609-1-paul@crapouillou.net>
 <20200516215057.392609-4-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516215057.392609-4-paul@crapouillou.net>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=MOBOZvRl c=1 sm=1 tr=0
        a=UWs3HLbX/2nnQ3s7vZ42gw==:117 a=UWs3HLbX/2nnQ3s7vZ42gw==:17
        a=kj9zAlcOel0A:10 a=VwQbUJbxAAAA:8 a=ER_8r6IbAAAA:8 a=7gkXJVJtAAAA:8
        a=e5mUnYsNAAAA:8 a=q0884fTdi5gFdvFPT1AA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=9LHmKk7ezEChjTCyhBa9:22
        a=E9Po1WZjFZOl8hwRPBS3:22 a=Vxmtnl_E_bksehYqCbjh:22
        a=pHzHmUro8NiASowvMSCR:22 a=nt3jZW36AmriUCFCBwmW:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 16, 2020 at 11:50:49PM +0200, Paul Cercueil wrote:
> The code was comparing the SoC's maximum height with the mode's width,
> and vice-versa. D'oh.
> 
> Cc: stable@vger.kernel.org # v5.6
> Fixes: a7c909b7c037 ("gpu/drm: ingenic: Check for display size in CRTC atomic check")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Looks correct.
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> 
> Notes:
>     This patch was previously sent standalone.
>     I marked it as superseded in patchwork.
>     Nothing has been changed here.
> 
>  drivers/gpu/drm/ingenic/ingenic-drm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ingenic/ingenic-drm.c b/drivers/gpu/drm/ingenic/ingenic-drm.c
> index 632d72177123..0c472382a08b 100644
> --- a/drivers/gpu/drm/ingenic/ingenic-drm.c
> +++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
> @@ -330,8 +330,8 @@ static int ingenic_drm_crtc_atomic_check(struct drm_crtc *crtc,
>  	if (!drm_atomic_crtc_needs_modeset(state))
>  		return 0;
>  
> -	if (state->mode.hdisplay > priv->soc_info->max_height ||
> -	    state->mode.vdisplay > priv->soc_info->max_width)
> +	if (state->mode.hdisplay > priv->soc_info->max_width ||
> +	    state->mode.vdisplay > priv->soc_info->max_height)
>  		return -EINVAL;
>  
>  	rate = clk_round_rate(priv->pix_clk,
> -- 
> 2.26.2
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
