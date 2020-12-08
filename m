Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843182D277C
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 10:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgLHJZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 04:25:21 -0500
Received: from mga05.intel.com ([192.55.52.43]:48064 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbgLHJZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 04:25:21 -0500
IronPort-SDR: 7Ig3T/V7u08zSOBFmiISwMexS10bkbFsbfke1RJ2OrRuMvVgRO9EpnOj6Dr1A9QK0Zc6g5jqyc
 F3iqc7rIqWRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="258568797"
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="258568797"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 01:24:36 -0800
IronPort-SDR: fIQfc9WYHC05Fws7CFW5MRw21s7WPSybQeeKvAUub45CX7807k8NWZBeFolymUwMxUqBRs5sA5
 EEIvm7YIHMMA==
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="407549040"
Received: from genxfsim-desktop.iind.intel.com (HELO intel.com) ([10.223.74.178])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 01:24:34 -0800
Date:   Tue, 8 Dec 2020 14:41:07 +0530
From:   Anshuman Gupta <anshuman.gupta@intel.com>
To:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        imre.deak@intel.com
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [RFC 2/2] drm/i915/display: Protect pipe_update against dc3co
 exit
Message-ID: <20201208091104.GJ30377@intel.com>
References: <20201130091646.25576-1-anshuman.gupta@intel.com>
 <20201130091646.25576-3-anshuman.gupta@intel.com>
 <20201130152832.GB2348711@ideak-desk.fi.intel.com>
 <20201204081003.GC30377@intel.com>
 <X8pbBsHVRVV4cNfJ@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X8pbBsHVRVV4cNfJ@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-12-04 at 17:51:34 +0200, Ville Syrjälä wrote:
> On Fri, Dec 04, 2020 at 01:40:03PM +0530, Anshuman Gupta wrote:
> > On 2020-11-30 at 17:28:32 +0200, Imre Deak wrote:
> > > On Mon, Nov 30, 2020 at 02:46:46PM +0530, Anshuman Gupta wrote:
> > > > At usual case DC3CO exit happen automatically by DMC f/w whenever
> > > > PSR2 clears idle. This happens smoothly by DMC f/w to work with flips.
> > > > But there are certain scenario where DC3CO  Disallowed by driver
> > > > asynchronous with flips. In such scenario display engine could
> > > > be already in DC3CO state and driver has disallowed it,
> > > > It initiates DC3CO exit sequence in DMC f/w which requires a
> > > > dc3co exit delay of 200us in driver.
> > > > It requires to protect intel_pipe_update_{update_end} with
> > > > dc3co exit delay.
> > > > 
> > > > Cc: Imre Deak <imre.deak@intel.com>
> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
> > > 
> > > To make sure that it doesn't hide the root cause (or affects unrelated
> > > platforms), I'd only add locking around DC3co changes with a new lock,
> > > using lock/unlock helpers in intel_display_power.c called from
> > > intel_pipe_update_start/end.
> > > 
> > > Also please submit this patch separately, w/o the optimization in patch
> > > 1/2, so we know that this change fixes the problem.
> > This patch doesn't seems to fix the issue.
> > Looks like there is some other set of display register updates before
> > completing the dc3co exit delay beyond intel_pipe_update_start/end causing this issue.
> 
> Not really sure I understand the DC3CO issue here, nor how grabbing a
> mutex across the update could help.
> 
> But anyways, maybe we should just:
> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> index 2e2dd746921f..96276f0feddc 100644
> --- a/drivers/gpu/drm/i915/display/intel_display.c
> +++ b/drivers/gpu/drm/i915/display/intel_display.c
> @@ -16268,8 +16268,7 @@ static void intel_atomic_commit_tail(struct intel_atomic_state *state)
>  
>  	drm_atomic_helper_wait_for_dependencies(&state->base);
>  
> -	if (state->modeset)
> -		wakeref = intel_display_power_get(dev_priv, POWER_DOMAIN_MODESET);
> +	wakeref = intel_display_power_get(dev_priv, POWER_DOMAIN_MODESET);
>  
>  	for_each_oldnew_intel_crtc_in_state(state, crtc, old_crtc_state,
>  					    new_crtc_state, i) {
> @@ -16415,8 +16414,8 @@ static void intel_atomic_commit_tail(struct intel_atomic_state *state)
>  		 * the culprit.
>  		 */
>  		intel_uncore_arm_unclaimed_mmio_detection(&dev_priv->uncore);
> -		intel_display_power_put(dev_priv, POWER_DOMAIN_MODESET, wakeref);
>  	}
> +	intel_display_power_put(dev_priv, POWER_DOMAIN_MODESET, wakeref);
>  	intel_runtime_pm_put(&dev_priv->runtime_pm, state->wakeref);
>  
>  	/*
> 
> To get the DMC out of equation entirely for all plane updates?
Hi Ville / Imre ,
Above suggested chnages is not helping to fix the display glitches.
Could you please provide your inputs to debug the possible root cause considering the patch https://patchwork.freedesktop.org/patch/405585/?series=84394&rev=2
fixes the glitch.
Thanks,
Anshuman Gupta.
 
> 
> -- 
> Ville Syrjälä
> Intel
