Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADBB213BC7
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgGCO0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 10:26:12 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:59340 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgGCO0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 10:26:12 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id C9D08804EB;
        Fri,  3 Jul 2020 16:26:08 +0200 (CEST)
Date:   Fri, 3 Jul 2020 16:26:07 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/dbi: Fix SPI Type 1 (9-bit) transfer
Message-ID: <20200703142607.GB25632@ravnborg.org>
References: <20200703141341.1266263-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200703141341.1266263-1-paul@crapouillou.net>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=aP3eV41m c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=8nJEP1OIZ-IA:10 a=VwQbUJbxAAAA:8 a=SJz97ENfAAAA:8 a=Ikd4Dj_1AAAA:8
        a=QyXUC8HyAAAA:8 a=7gkXJVJtAAAA:8 a=WZHNqt2aAAAA:8 a=20KFwNOVAAAA:8
        a=-VAfIpHNAAAA:8 a=e5mUnYsNAAAA:8 a=ER_8r6IbAAAA:8 a=UplYCoFZqbpoQR9uMNUA:9
        a=wPNLvfGTeEIA:10 a=AjGcO6oz07-iQ99wixmX:22 a=vFet0B0WnEQeilDPIY6i:22
        a=E9Po1WZjFZOl8hwRPBS3:22 a=PrHl9onO2p7xFKlKy1af:22
        a=srlwD-8ojaedGGhPAyx8:22 a=Vxmtnl_E_bksehYqCbjh:22
        a=9LHmKk7ezEChjTCyhBa9:22 a=pHzHmUro8NiASowvMSCR:22
        a=nt3jZW36AmriUCFCBwmW:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 03, 2020 at 04:13:41PM +0200, Paul Cercueil wrote:
> The function mipi_dbi_spi1_transfer() will transfer its payload as 9-bit
> data, the 9th (MSB) bit being the data/command bit. In order to do that,
> it unpacks the 8-bit values into 16-bit values, then sets the 9th bit if
> the byte corresponds to data, clears it otherwise. The 7 MSB are
> padding. The array of now 16-bit values is then passed to the SPI core
> for transfer.
> 
> This function was broken since its introduction, as the length of the
> SPI transfer was set to the payload size before its conversion, but the
> payload doubled in size due to the 8-bit -> 16-bit conversion.
> 
> Fixes: 02dd95fe3169 ("drm/tinydrm: Add MIPI DBI support")
> Cc: <stable@vger.kernel.org> # 4.10
"dim fixes 02dd95fe3169" provides the following output:
Fixes: 02dd95fe3169 ("drm/tinydrm: Add MIPI DBI support")
Cc: Noralf Trønnes <noralf@tronnes.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: "Noralf Trønnes" <noralf@tronnes.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Lechner <david@lechnology.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Eric Anholt <eric@anholt.net>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.11+

I assume the "Cc: <stable@vger.kernel.org> # 4.11+" is more correct?

	Sam


> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  drivers/gpu/drm/drm_mipi_dbi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_mipi_dbi.c b/drivers/gpu/drm/drm_mipi_dbi.c
> index bb27c82757f1..bf7888ad9ad4 100644
> --- a/drivers/gpu/drm/drm_mipi_dbi.c
> +++ b/drivers/gpu/drm/drm_mipi_dbi.c
> @@ -923,7 +923,7 @@ static int mipi_dbi_spi1_transfer(struct mipi_dbi *dbi, int dc,
>  			}
>  		}
>  
> -		tr.len = chunk;
> +		tr.len = chunk * 2;
>  		len -= chunk;
>  
>  		ret = spi_sync(spi, &m);
> -- 
> 2.27.0
