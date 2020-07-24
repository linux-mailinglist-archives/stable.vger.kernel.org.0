Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F50522BB91
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 03:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGXBeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 21:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgGXBeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 21:34:06 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B963C0619D3;
        Thu, 23 Jul 2020 18:34:06 -0700 (PDT)
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 156FB279;
        Fri, 24 Jul 2020 03:34:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1595554444;
        bh=bCDL+N0xmJi7u1Mqf0NQTk956HaMBsNCR+6/+d1EzGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oop5JKeXsXOOGdhHGzswQrxOrDD1QLbqGxixXuCZXJ9hQoBXKK+6jpim5N7ZhtZpF
         2+4sibsjhUVNawQezmWA8pQwoZ6gv6vDP7EGT1iGjyZFWvbASoR7IefyE3u5+oW4X1
         eCQEGzQanMmcoVw8YpZcLXpyaW6IYOOQ8uXedS/k=
Date:   Fri, 24 Jul 2020 04:33:57 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        dri-devel@lists.freedesktop.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm: of: Fix double-free bug
Message-ID: <20200724013357.GM21353@pendragon.ideasonboard.com>
References: <1595502654-40595-1-git-send-email-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1595502654-40595-1-git-send-email-biju.das.jz@bp.renesas.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Biju,

Thank you for the patch.

On Thu, Jul 23, 2020 at 12:10:54PM +0100, Biju Das wrote:
> Fix double-free bug in the error path.
> 
> Fixes: 6529007522de ("drm: of: Add drm_of_lvds_get_dual_link_pixel_order")
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

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

-- 
Regards,

Laurent Pinchart
