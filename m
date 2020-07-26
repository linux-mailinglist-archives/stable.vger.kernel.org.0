Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B6222E197
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 19:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgGZRKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 13:10:24 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:52678 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgGZRKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 13:10:23 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id 679BA804D8;
        Sun, 26 Jul 2020 19:10:20 +0200 (CEST)
Date:   Sun, 26 Jul 2020 19:10:18 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        dri-devel@lists.freedesktop.org,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm: of: Fix double-free bug
Message-ID: <20200726171018.GF3275923@ravnborg.org>
References: <1595502654-40595-1-git-send-email-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595502654-40595-1-git-send-email-biju.das.jz@bp.renesas.com>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=aP3eV41m c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=kj9zAlcOel0A:10 a=yC-0_ovQAAAA:8 a=VwQbUJbxAAAA:8 a=e5mUnYsNAAAA:8
        a=NBDvnfKliWK8pw6bCscA:9 a=CjuIK1q_8ugA:10 a=QsnFDINu91a9xkgZirup:22
        a=AjGcO6oz07-iQ99wixmX:22 a=Vxmtnl_E_bksehYqCbjh:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Biju

On Thu, Jul 23, 2020 at 12:10:54PM +0100, Biju Das wrote:
> Fix double-free bug in the error path.
> 
> Fixes: 6529007522de ("drm: of: Add drm_of_lvds_get_dual_link_pixel_order")
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Cc: stable@vger.kernel.org

Thanks, applied to drm-misc-fixes.

	Sam

> ---
> This patch is tested against drm-fixes and drm-next.
> ---
>  drivers/gpu/drm/drm_of.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_of.c b/drivers/gpu/drm/drm_of.c
> index fdb05fb..ca04c34 100644
> --- a/drivers/gpu/drm/drm_of.c
> +++ b/drivers/gpu/drm/drm_of.c
> @@ -331,10 +331,8 @@ static int drm_of_lvds_get_remote_pixels_type(
>  		 * configurations by passing the endpoints explicitly to
>  		 * drm_of_lvds_get_dual_link_pixel_order().
>  		 */
> -		if (!current_pt || pixels_type != current_pt) {
> -			of_node_put(remote_port);
> +		if (!current_pt || pixels_type != current_pt)
>  			return -EINVAL;
> -		}
>  	}
>  
>  	return pixels_type;
> -- 
> 2.7.4
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
