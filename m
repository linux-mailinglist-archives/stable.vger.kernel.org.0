Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FE62CF14D
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 16:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbgLDPxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 10:53:18 -0500
Received: from mga07.intel.com ([134.134.136.100]:19836 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730603AbgLDPxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Dec 2020 10:53:18 -0500
IronPort-SDR: b5w7eHgS5HfE7ijb35nQBPosdPWn04x0Xmec/VCtAvLfmvSF3nE+Y2nplLrb1RaKyBeceTTYwc
 6IS4m6gYVlwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9825"; a="237510474"
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="237510474"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2020 07:51:37 -0800
IronPort-SDR: vxZxKm4hu9mCfL6WbZIw6VGRZfYwemk+6NrhhY8VEtwTgudiuwklfL3wA4kVLpsuSJ+RFyfMs/
 OC3lGk0qoUIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="435843025"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga001.fm.intel.com with SMTP; 04 Dec 2020 07:51:35 -0800
Received: by stinkbox (sSMTP sendmail emulation); Fri, 04 Dec 2020 17:51:34 +0200
Date:   Fri, 4 Dec 2020 17:51:34 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Anshuman Gupta <anshuman.gupta@intel.com>
Cc:     Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [RFC 2/2] drm/i915/display: Protect pipe_update against dc3co
 exit
Message-ID: <X8pbBsHVRVV4cNfJ@intel.com>
References: <20201130091646.25576-1-anshuman.gupta@intel.com>
 <20201130091646.25576-3-anshuman.gupta@intel.com>
 <20201130152832.GB2348711@ideak-desk.fi.intel.com>
 <20201204081003.GC30377@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201204081003.GC30377@intel.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 04, 2020 at 01:40:03PM +0530, Anshuman Gupta wrote:
> On 2020-11-30 at 17:28:32 +0200, Imre Deak wrote:
> > On Mon, Nov 30, 2020 at 02:46:46PM +0530, Anshuman Gupta wrote:
> > > At usual case DC3CO exit happen automatically by DMC f/w whenever
> > > PSR2 clears idle. This happens smoothly by DMC f/w to work with flips.
> > > But there are certain scenario where DC3CO  Disallowed by driver
> > > asynchronous with flips. In such scenario display engine could
> > > be already in DC3CO state and driver has disallowed it,
> > > It initiates DC3CO exit sequence in DMC f/w which requires a
> > > dc3co exit delay of 200us in driver.
> > > It requires to protect intel_pipe_update_{update_end} with
> > > dc3co exit delay.
> > > 
> > > Cc: Imre Deak <imre.deak@intel.com>
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
> > 
> > To make sure that it doesn't hide the root cause (or affects unrelated
> > platforms), I'd only add locking around DC3co changes with a new lock,
> > using lock/unlock helpers in intel_display_power.c called from
> > intel_pipe_update_start/end.
> > 
> > Also please submit this patch separately, w/o the optimization in patch
> > 1/2, so we know that this change fixes the problem.
> This patch doesn't seems to fix the issue.
> Looks like there is some other set of display register updates before
> completing the dc3co exit delay beyond intel_pipe_update_start/end causing this issue.

Not really sure I understand the DC3CO issue here, nor how grabbing a
mutex across the update could help.

But anyways, maybe we should just:
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 2e2dd746921f..96276f0feddc 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -16268,8 +16268,7 @@ static void intel_atomic_commit_tail(struct intel_atomic_state *state)
 
 	drm_atomic_helper_wait_for_dependencies(&state->base);
 
-	if (state->modeset)
-		wakeref = intel_display_power_get(dev_priv, POWER_DOMAIN_MODESET);
+	wakeref = intel_display_power_get(dev_priv, POWER_DOMAIN_MODESET);
 
 	for_each_oldnew_intel_crtc_in_state(state, crtc, old_crtc_state,
 					    new_crtc_state, i) {
@@ -16415,8 +16414,8 @@ static void intel_atomic_commit_tail(struct intel_atomic_state *state)
 		 * the culprit.
 		 */
 		intel_uncore_arm_unclaimed_mmio_detection(&dev_priv->uncore);
-		intel_display_power_put(dev_priv, POWER_DOMAIN_MODESET, wakeref);
 	}
+	intel_display_power_put(dev_priv, POWER_DOMAIN_MODESET, wakeref);
 	intel_runtime_pm_put(&dev_priv->runtime_pm, state->wakeref);
 
 	/*

To get the DMC out of equation entirely for all plane updates?

-- 
Ville Syrjälä
Intel
