Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2646C1B63ED
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 20:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgDWSnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 14:43:51 -0400
Received: from mga04.intel.com ([192.55.52.120]:2270 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbgDWSnu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 14:43:50 -0400
IronPort-SDR: ICXgK6m0N0Pp55a+pTwUxWHNOocaYrDSgDVy3anIzoNCJs9es+X+6imu3Uc/+eKr5uVSwpjndW
 W1gvRg1DUCVg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 11:43:50 -0700
IronPort-SDR: r3VcBlY1YZ6yROw9g3qjdqBgL4ReksCCyx/SDb2A9lP/FAOUo0Dasvh52GBfXqwgRhMf0eTuy4
 Sbi6dqqlV0ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="457013796"
Received: from unknown (HELO intel.com) ([10.165.21.211])
  by fmsmga005.fm.intel.com with ESMTP; 23 Apr 2020 11:43:50 -0700
Date:   Thu, 23 Apr 2020 11:45:11 -0700
From:   Manasi Navare <manasi.d.navare@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/edid: Fix off-by-one in DispID DTD pixel
 clock
Message-ID: <20200423184510.GA12177@intel.com>
References: <20200423151743.18767-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200423151743.18767-1-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 06:17:43PM +0300, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> The DispID DTD pixel clock is documented as:
> "00 00 00 h → FF FF FF h | Pixel clock ÷ 10,000 0.01 → 167,772.16 Mega Pixels per Sec"
> Which seems to imply that we to add one to the raw value.
> 
> Reality seems to agree as there are tiled displays in the wild
> which currently show a 10kHz difference in the pixel clock
> between the tiles (one tile gets its mode from the base EDID,
> the other from the DispID block).
> 
> Cc: stable@vger.kernel.org
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/27
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Makes total sense,

Reviewed-by: Manasi Navare <manasi.d.navare@intel.com>

Manasi

> ---
>  drivers/gpu/drm/drm_edid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 43b6ca364daa..544d2603f5fc 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -5120,7 +5120,7 @@ static struct drm_display_mode *drm_mode_displayid_detailed(struct drm_device *d
>  	struct drm_display_mode *mode;
>  	unsigned pixel_clock = (timings->pixel_clock[0] |
>  				(timings->pixel_clock[1] << 8) |
> -				(timings->pixel_clock[2] << 16));
> +				(timings->pixel_clock[2] << 16)) + 1;
>  	unsigned hactive = (timings->hactive[0] | timings->hactive[1] << 8) + 1;
>  	unsigned hblank = (timings->hblank[0] | timings->hblank[1] << 8) + 1;
>  	unsigned hsync = (timings->hsync[0] | (timings->hsync[1] & 0x7f) << 8) + 1;
> -- 
> 2.24.1
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
