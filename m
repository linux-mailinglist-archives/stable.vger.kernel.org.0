Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848E336C8D2
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 17:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbhD0Ply (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 11:41:54 -0400
Received: from foss.arm.com ([217.140.110.172]:54310 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhD0Ply (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 11:41:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8B1C31B;
        Tue, 27 Apr 2021 08:41:10 -0700 (PDT)
Received: from e110455-lin.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 86C0C3F73B;
        Tue, 27 Apr 2021 08:41:10 -0700 (PDT)
Received: by e110455-lin.cambridge.arm.com (Postfix, from userid 1000)
        id 19D3068393E; Tue, 27 Apr 2021 16:41:09 +0100 (BST)
Date:   Tue, 27 Apr 2021 16:41:09 +0100
From:   Liviu Dudau <liviu.dudau@arm.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH 2/8] drm/arm/malidp: Always list modifiers
Message-ID: <YIgwlRnguY+K3gJV@e110455-lin.cambridge.arm.com>
References: <20210427092018.832258-1-daniel.vetter@ffwll.ch>
 <20210427092018.832258-2-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210427092018.832258-2-daniel.vetter@ffwll.ch>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 27, 2021 at 11:20:12AM +0200, Daniel Vetter wrote:
> Even when all we support is linear, make that explicit. Otherwise the
> uapi is rather confusing.

:)

> 
> Cc: stable@vger.kernel.org
> Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
> Cc: Liviu Dudau <liviu.dudau@arm.com>
> Cc: Brian Starkey <brian.starkey@arm.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>

Acked-by: Liviu Dudau <liviu.dudau@arm.com>

Best regards,
Liviu

> ---
>  drivers/gpu/drm/arm/malidp_planes.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/arm/malidp_planes.c b/drivers/gpu/drm/arm/malidp_planes.c
> index ddbba67f0283..8c2ab3d653b7 100644
> --- a/drivers/gpu/drm/arm/malidp_planes.c
> +++ b/drivers/gpu/drm/arm/malidp_planes.c
> @@ -927,6 +927,11 @@ static const struct drm_plane_helper_funcs malidp_de_plane_helper_funcs = {
>  	.atomic_disable = malidp_de_plane_disable,
>  };
>  
> +static const uint64_t linear_only_modifiers[] = {
> +	DRM_FORMAT_MOD_LINEAR,
> +	DRM_FORMAT_MOD_INVALID
> +};
> +
>  int malidp_de_planes_init(struct drm_device *drm)
>  {
>  	struct malidp_drm *malidp = drm->dev_private;
> @@ -990,8 +995,8 @@ int malidp_de_planes_init(struct drm_device *drm)
>  		 */
>  		ret = drm_universal_plane_init(drm, &plane->base, crtcs,
>  				&malidp_de_plane_funcs, formats, n,
> -				(id == DE_SMART) ? NULL : modifiers, plane_type,
> -				NULL);
> +				(id == DE_SMART) ? linear_only_modifiers : modifiers,
> +				plane_type, NULL);
>  
>  		if (ret < 0)
>  			goto cleanup;
> -- 
> 2.31.0
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯
