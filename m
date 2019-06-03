Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C7A33328
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 17:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbfFCPKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 11:10:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:18899 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729145AbfFCPKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 11:10:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 08:10:20 -0700
X-ExtLoop1: 1
Received: from wuerth-mobl3.ger.corp.intel.com (HELO [10.252.33.134]) ([10.252.33.134])
  by orsmga007.jf.intel.com with ESMTP; 03 Jun 2019 08:10:19 -0700
Subject: Re: [PATCH] drm/i915: Fix per-pixel alpha with CCS
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Matt Roper <matthew.d.roper@intel.com>,
        Heinrich Fink <heinrich.fink@daqri.com>
References: <20190603142500.25680-1-ville.syrjala@linux.intel.com>
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <4ee3ffa8-4048-d92d-4493-ea5ed1dfb23e@linux.intel.com>
Date:   Mon, 3 Jun 2019 17:10:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603142500.25680-1-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Op 03-06-2019 om 16:25 schreef Ville Syrjala:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>
> We forgot to set .has_alpha=true for the A+CCS formats when the code
> started to consult .has_alpha. This manifests as A+CCS being treated
> as X+CCS which means no per-pixel alpha blending. Fix the format
> list appropriately.
>
> Cc: stable@vger.kernel.org
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Matt Roper <matthew.d.roper@intel.com>
> Cc: Heinrich Fink <heinrich.fink@daqri.com>
> Reported-by: Heinrich Fink <heinrich.fink@daqri.com>
> Fixes: b20815255693 ("drm/i915: Add plane alpha blending support, v2.")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/intel_display.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index c3e2b1178d55..67d796f4747e 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -2463,10 +2463,14 @@ static unsigned int intel_fb_modifier_to_tiling(u64 fb_modifier)
>   * main surface.
>   */
>  static const struct drm_format_info ccs_formats[] = {
> -	{ .format = DRM_FORMAT_XRGB8888, .depth = 24, .num_planes = 2, .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
> -	{ .format = DRM_FORMAT_XBGR8888, .depth = 24, .num_planes = 2, .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
> -	{ .format = DRM_FORMAT_ARGB8888, .depth = 32, .num_planes = 2, .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
> -	{ .format = DRM_FORMAT_ABGR8888, .depth = 32, .num_planes = 2, .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
> +	{ .format = DRM_FORMAT_XRGB8888, .depth = 24, .num_planes = 2,
> +	  .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
> +	{ .format = DRM_FORMAT_XBGR8888, .depth = 24, .num_planes = 2,
> +	  .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
> +	{ .format = DRM_FORMAT_ARGB8888, .depth = 32, .num_planes = 2,
> +	  .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, .has_alpha = true, },
> +	{ .format = DRM_FORMAT_ABGR8888, .depth = 32, .num_planes = 2,
> +	  .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, .has_alpha = true, },
>  };
>  
>  static const struct drm_format_info *

Makes sense..

Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

