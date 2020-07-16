Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAD3222A35
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 19:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgGPRnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 13:43:39 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:43398 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgGPRnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 13:43:39 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id B649920024;
        Thu, 16 Jul 2020 19:43:36 +0200 (CEST)
Date:   Thu, 16 Jul 2020 19:43:35 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        od@zcrc.me, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 01/12] drm/ingenic: Fix incorrect assumption about
 plane->index
Message-ID: <20200716174335.GC2235355@ravnborg.org>
References: <20200716163846.174790-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716163846.174790-1-paul@crapouillou.net>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=f+hm+t6M c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=kj9zAlcOel0A:10 a=VwQbUJbxAAAA:8 a=ER_8r6IbAAAA:8 a=7gkXJVJtAAAA:8
        a=4WA-eTY_EG-Q7__DAOgA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=9LHmKk7ezEChjTCyhBa9:22 a=E9Po1WZjFZOl8hwRPBS3:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul.

On Thu, Jul 16, 2020 at 06:38:35PM +0200, Paul Cercueil wrote:
> plane->index is NOT the index of the color plane in a YUV frame.
> Actually, a YUV frame is represented by a single drm_plane, even though
> it contains three Y, U, V planes.
> 
> v2-v3: No change
> 
> Cc: stable@vger.kernel.org # v5.3
> Fixes: 90b86fcc47b4 ("DRM: Add KMS driver for the Ingenic JZ47xx SoCs")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

A cover letter would have been useful. Please consider that in the
future.
All patches in this set are:
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>

A few requires some trivial issues fixed. They can be fixed while
applying.

I consider the patch-set ready to go in and I expect you to commit them.

	Sam

> ---
>  drivers/gpu/drm/ingenic/ingenic-drm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/ingenic/ingenic-drm.c b/drivers/gpu/drm/ingenic/ingenic-drm.c
> index deb37b4a8e91..606d8acb0954 100644
> --- a/drivers/gpu/drm/ingenic/ingenic-drm.c
> +++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
> @@ -386,7 +386,7 @@ static void ingenic_drm_plane_atomic_update(struct drm_plane *plane,
>  		addr = drm_fb_cma_get_gem_addr(state->fb, state, 0);
>  		width = state->src_w >> 16;
>  		height = state->src_h >> 16;
> -		cpp = state->fb->format->cpp[plane->index];
> +		cpp = state->fb->format->cpp[0];
>  
>  		priv->dma_hwdesc->addr = addr;
>  		priv->dma_hwdesc->cmd = width * height * cpp / 4;
> -- 
> 2.27.0
