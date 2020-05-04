Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7D91C3F7B
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 18:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgEDQMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 12:12:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:42892 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729207AbgEDQMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 12:12:18 -0400
IronPort-SDR: GaO8djqiS2pGiJ4VEzK21OfRR+p9GR/H1OOoiF1LyDWwe8m9F4UWF+CgXZu/iEGTLYCSBEzCzW
 f95LkA7L/isQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 09:12:18 -0700
IronPort-SDR: NjIs5eVckiefVYzs1nbR8TZZP08x1SCNuBp/AYXeYKVd5KTbFssOqilwxELtBYPR4imLSjI+d2
 TGTnF4ViDebw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,352,1583222400"; 
   d="scan'208";a="262866242"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga006.jf.intel.com with SMTP; 04 May 2020 09:12:14 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 04 May 2020 19:12:13 +0300
Date:   Mon, 4 May 2020 19:12:13 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Don't enable WaIncreaseLatencyIPCEnabled when
 IPC is disabled
Message-ID: <20200504161213.GD6112@intel.com>
References: <20200430214654.51314-1-sultan@kerneltoast.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200430214654.51314-1-sultan@kerneltoast.com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 02:46:54PM -0700, Sultan Alsawaf wrote:
> From: Sultan Alsawaf <sultan@kerneltoast.com>
> 
> In commit 5a7d202b1574, a logical AND was erroneously changed to an OR,
> causing WaIncreaseLatencyIPCEnabled to be enabled unconditionally for
> kabylake and coffeelake, even when IPC is disabled. Fix the logic so
> that WaIncreaseLatencyIPCEnabled is only used when IPC is enabled.
> 
> Fixes: 5a7d202b1574 ("drm/i915: Drop WaIncreaseLatencyIPCEnabled/1140 for cnl")
> Cc: stable@vger.kernel.org # 5.3.x+
> Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> ---
>  drivers/gpu/drm/i915/intel_pm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
> index 8375054ba27d..a52986a9e7a6 100644
> --- a/drivers/gpu/drm/i915/intel_pm.c
> +++ b/drivers/gpu/drm/i915/intel_pm.c
> @@ -4992,7 +4992,7 @@ static void skl_compute_plane_wm(const struct intel_crtc_state *crtc_state,
>  	 * WaIncreaseLatencyIPCEnabled: kbl,cfl
>  	 * Display WA #1141: kbl,cfl
>  	 */
> -	if ((IS_KABYLAKE(dev_priv) || IS_COFFEELAKE(dev_priv)) ||
> +	if ((IS_KABYLAKE(dev_priv) || IS_COFFEELAKE(dev_priv)) &&

Whoops. Thanks for the fix. Pushed.

>  	    dev_priv->ipc_enabled)
>  		latency += 4;
>  
> -- 
> 2.26.2

-- 
Ville Syrjälä
Intel
