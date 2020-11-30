Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0D52C87F9
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 16:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgK3P3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 10:29:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:12816 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbgK3P3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 10:29:19 -0500
IronPort-SDR: uMYewLBG2RD8nBN2J1jFavETldxBmgZw2rbt05WURROedyI1k/mg1lzIvDhm6fC6tnq5JWSN5J
 wClecqjRqzkw==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="171869538"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="171869538"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 07:28:38 -0800
IronPort-SDR: /EdJ1k597F3vjdC5owwNeXdjyehuZe2+CXX1O4dfbzlcbGIfIF2TvT3MP/XwuexNYsg6MjJoo/
 aFFn0FSJyKpA==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="549141821"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 07:28:36 -0800
Date:   Mon, 30 Nov 2020 17:28:32 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Anshuman Gupta <anshuman.gupta@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, ville.syrjala@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: [RFC 2/2] drm/i915/display: Protect pipe_update against dc3co
 exit
Message-ID: <20201130152832.GB2348711@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20201130091646.25576-1-anshuman.gupta@intel.com>
 <20201130091646.25576-3-anshuman.gupta@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130091646.25576-3-anshuman.gupta@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 30, 2020 at 02:46:46PM +0530, Anshuman Gupta wrote:
> At usual case DC3CO exit happen automatically by DMC f/w whenever
> PSR2 clears idle. This happens smoothly by DMC f/w to work with flips.
> But there are certain scenario where DC3CO  Disallowed by driver
> asynchronous with flips. In such scenario display engine could
> be already in DC3CO state and driver has disallowed it,
> It initiates DC3CO exit sequence in DMC f/w which requires a
> dc3co exit delay of 200us in driver.
> It requires to protect intel_pipe_update_{update_end} with
> dc3co exit delay.
> 
> Cc: Imre Deak <imre.deak@intel.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>

To make sure that it doesn't hide the root cause (or affects unrelated
platforms), I'd only add locking around DC3co changes with a new lock,
using lock/unlock helpers in intel_display_power.c called from
intel_pipe_update_start/end.

Also please submit this patch separately, w/o the optimization in patch
1/2, so we know that this change fixes the problem.

--Imre

> ---
>  drivers/gpu/drm/i915/display/intel_display.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> index ba26545392bc..3b81b98c0daf 100644
> --- a/drivers/gpu/drm/i915/display/intel_display.c
> +++ b/drivers/gpu/drm/i915/display/intel_display.c
> @@ -15924,6 +15924,8 @@ static void intel_update_crtc(struct intel_atomic_state *state,
>  	else
>  		intel_fbc_enable(state, crtc);
>  
> +	/* Protect intel_pipe_update_{start,end} with power_domians lock */
> +	mutex_lock(&dev_priv->power_domains.lock);
>  	/* Perform vblank evasion around commit operation */
>  	intel_pipe_update_start(new_crtc_state);
>  
> @@ -15935,6 +15937,7 @@ static void intel_update_crtc(struct intel_atomic_state *state,
>  		i9xx_update_planes_on_crtc(state, crtc);
>  
>  	intel_pipe_update_end(new_crtc_state);
> +	mutex_unlock(&dev_prive->power_domains.lock);
>  
>  	/*
>  	 * We usually enable FIFO underrun interrupts as part of the
> -- 
> 2.26.2
> 
