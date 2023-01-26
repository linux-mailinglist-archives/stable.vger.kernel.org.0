Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0D167D352
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 18:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjAZRhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 12:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjAZRhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 12:37:24 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78884134
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 09:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674754643; x=1706290643;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Lqutl9bhgI4S8SlFAnyAxVShqTKq0/cefhe5ZHLd1TM=;
  b=J6YHx8UZZ9PZOA47MWjntqY3ncF9O/gLbTKx5s1d2v4gptj6SDhUAXEm
   9/WAV5/9l281HyxVsKIzxlWyQ3H2J72ru0alm+VuLE924o6y30JXkvRtC
   RyAkzyS6plPv786iTF/+Mspapz6QrQpgogFglt245EHBMst5pXYYtYiz0
   wOyqTQyRwYVybfpTQhvNOlq1/3z4nkYWGsvMw+bz7uGjD0jqboQZbK8It
   Q5HABf2rR2ZK3Zh5HWiNtFWQwAONpOcXy+6gvy+g4Cx1+Ft7MBs+fqXcM
   Ij7s2PsHQfFLnjvbCYDNp0h73yikpqhNnfCpr7iiQw59qHa8rvvCzfY/n
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="354180314"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="354180314"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 09:37:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="656252858"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="656252858"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.55])
  by orsmga007.jf.intel.com with SMTP; 26 Jan 2023 09:37:05 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 26 Jan 2023 19:37:04 +0200
Date:   Thu, 26 Jan 2023 19:37:04 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Imre Deak <imre.deak@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, Karol Herbst <kherbst@redhat.com>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, Wayne Lin <Wayne.Lin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 2/9] drm/display/dp_mst: Handle old/new payload states in
 drm_dp_remove_payload()
Message-ID: <Y9K6QPz/OnHuXrp4@intel.com>
References: <20230125114852.748337-1-imre.deak@intel.com>
 <20230125114852.748337-3-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230125114852.748337-3-imre.deak@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 25, 2023 at 01:48:45PM +0200, Imre Deak wrote:
> Atm, drm_dp_remove_payload() uses the same payload state to both get the
> vc_start_slot required for the payload removal DPCD message and to
> deduct time_slots from vc_start_slot of all payloads after the one being
> removed.
> 
> The above isn't always correct, as vc_start_slot must be the up-to-date
> version contained in the new payload state,

Why is that? In fact couldn't we just clear both start_slot and
pbn to 0 here?

> but time_slots must be the
> one used when the payload was previously added, contained in the old
> payload state. The new payload's time_slots can change vs. the old one
> if the current atomic commit changes the corresponding mode.
> 
> This patch let's drivers pass the old and new payload states to
> drm_dp_remove_payload(), but keeps these the same for now in all drivers
> not to change the behavior. A follow-up i915 patch will pass in that
> driver the correct old and new states to the function.
> 
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Karol Herbst <kherbst@redhat.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Wayne Lin <Wayne.Lin@amd.com>
> Cc: stable@vger.kernel.org # 6.1
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c |  2 +-
>  drivers/gpu/drm/display/drm_dp_mst_topology.c | 22 ++++++++++---------
>  drivers/gpu/drm/i915/display/intel_dp_mst.c   |  4 +++-
>  drivers/gpu/drm/nouveau/dispnv50/disp.c       |  2 +-
>  include/drm/display/drm_dp_mst_helper.h       |  3 ++-
>  5 files changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> index 6994c9a1ed858..fed4ce6821161 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> @@ -179,7 +179,7 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
>  	if (enable)
>  		drm_dp_add_payload_part1(mst_mgr, mst_state, payload);
>  	else
> -		drm_dp_remove_payload(mst_mgr, mst_state, payload);
> +		drm_dp_remove_payload(mst_mgr, mst_state, payload, payload);
>  
>  	/* mst_mgr->->payloads are VC payload notify MST branch using DPCD or
>  	 * AUX message. The sequence is slot 1-63 allocated sequence for each
> diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> index 5861b0a6247bc..ebf6e31e156e0 100644
> --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> @@ -3342,7 +3342,8 @@ EXPORT_SYMBOL(drm_dp_add_payload_part1);
>   * drm_dp_remove_payload() - Remove an MST payload
>   * @mgr: Manager to use.
>   * @mst_state: The MST atomic state
> - * @payload: The payload to write
> + * @old_payload: The payload with its old state
> + * @new_payload: The payload to write
>   *
>   * Removes a payload from an MST topology if it was successfully assigned a start slot. Also updates
>   * the starting time slots of all other payloads which would have been shifted towards the start of
> @@ -3350,33 +3351,34 @@ EXPORT_SYMBOL(drm_dp_add_payload_part1);
>   */
>  void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
>  			   struct drm_dp_mst_topology_state *mst_state,
> -			   struct drm_dp_mst_atomic_payload *payload)
> +			   const struct drm_dp_mst_atomic_payload *old_payload,
> +			   struct drm_dp_mst_atomic_payload *new_payload)
>  {
>  	struct drm_dp_mst_atomic_payload *pos;
>  	bool send_remove = false;
>  
>  	/* We failed to make the payload, so nothing to do */
> -	if (payload->vc_start_slot == -1)
> +	if (new_payload->vc_start_slot == -1)
>  		return;

So I take it the only reason we even have that is the copy being done in
drm_dp_mst_atomic_wait_for_dependencies()? I don't really understand
why any of that is being done tbh. If the new payload hasn't been
allocated yet then why can't its vc_start_slots just stay at -1
until that time?

This whole thing feels a bit weird since the payload table really isn't
your normal atomic state that is computed ahead of time. Instead it just
gets built up on as we go during the actual commit. So not really sure
why we're even tracking it in atomic state...

>  
>  	mutex_lock(&mgr->lock);
> -	send_remove = drm_dp_mst_port_downstream_of_branch(payload->port, mgr->mst_primary);
> +	send_remove = drm_dp_mst_port_downstream_of_branch(new_payload->port, mgr->mst_primary);
>  	mutex_unlock(&mgr->lock);
>  
>  	if (send_remove)
> -		drm_dp_destroy_payload_step1(mgr, mst_state, payload);
> +		drm_dp_destroy_payload_step1(mgr, mst_state, new_payload);
>  	else
>  		drm_dbg_kms(mgr->dev, "Payload for VCPI %d not in topology, not sending remove\n",
> -			    payload->vcpi);
> +			    new_payload->vcpi);
>  
>  	list_for_each_entry(pos, &mst_state->payloads, next) {
> -		if (pos != payload && pos->vc_start_slot > payload->vc_start_slot)
> -			pos->vc_start_slot -= payload->time_slots;
> +		if (pos != new_payload && pos->vc_start_slot > new_payload->vc_start_slot)
> +			pos->vc_start_slot -= old_payload->time_slots;
>  	}
> -	payload->vc_start_slot = -1;
> +	new_payload->vc_start_slot = -1;
>  
>  	mgr->payload_count--;
> -	mgr->next_start_slot -= payload->time_slots;
> +	mgr->next_start_slot -= old_payload->time_slots;
>  }
>  EXPORT_SYMBOL(drm_dp_remove_payload);
>  
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> index ba29c294b7c1b..5f7bcb5c14847 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> @@ -526,6 +526,8 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
>  		to_intel_connector(old_conn_state->connector);
>  	struct drm_dp_mst_topology_state *mst_state =
>  		drm_atomic_get_mst_topology_state(&state->base, &intel_dp->mst_mgr);
> +	struct drm_dp_mst_atomic_payload *payload =
> +		drm_atomic_get_mst_payload_state(mst_state, connector->port);
>  	struct drm_i915_private *i915 = to_i915(connector->base.dev);
>  
>  	drm_dbg_kms(&i915->drm, "active links %d\n",
> @@ -534,7 +536,7 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
>  	intel_hdcp_disable(intel_mst->connector);
>  
>  	drm_dp_remove_payload(&intel_dp->mst_mgr, mst_state,
> -			      drm_atomic_get_mst_payload_state(mst_state, connector->port));
> +			      payload, payload);
>  
>  	intel_audio_codec_disable(encoder, old_crtc_state, old_conn_state);
>  }
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> index edcb2529b4025..ed9d374147b8d 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -885,7 +885,7 @@ nv50_msto_prepare(struct drm_atomic_state *state,
>  
>  	// TODO: Figure out if we want to do a better job of handling VCPI allocation failures here?
>  	if (msto->disabled) {
> -		drm_dp_remove_payload(mgr, mst_state, payload);
> +		drm_dp_remove_payload(mgr, mst_state, payload, payload);
>  
>  		nvif_outp_dp_mst_vcpi(&mstm->outp->outp, msto->head->base.index, 0, 0, 0, 0);
>  	} else {
> diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/display/drm_dp_mst_helper.h
> index 41fd8352ab656..f5eb9aa152b14 100644
> --- a/include/drm/display/drm_dp_mst_helper.h
> +++ b/include/drm/display/drm_dp_mst_helper.h
> @@ -841,7 +841,8 @@ int drm_dp_add_payload_part2(struct drm_dp_mst_topology_mgr *mgr,
>  			     struct drm_dp_mst_atomic_payload *payload);
>  void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
>  			   struct drm_dp_mst_topology_state *mst_state,
> -			   struct drm_dp_mst_atomic_payload *payload);
> +			   const struct drm_dp_mst_atomic_payload *old_payload,
> +			   struct drm_dp_mst_atomic_payload *new_payload);
>  
>  int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr);
>  
> -- 
> 2.37.1

-- 
Ville Syrjälä
Intel
