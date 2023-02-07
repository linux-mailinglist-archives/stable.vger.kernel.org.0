Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1C168D635
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjBGMLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjBGMLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:11:24 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4629929E30
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675771881; x=1707307881;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Iv1LhCTMrGj4lvOxxSzPqucf9wxFSxlQiom2lewwImI=;
  b=QVSlr/bH2EYO64o7q+9drGXB6iD80xjxqo1vYCpRrZ2G7CGIYuHRHu3W
   tVvf+j0GgAKCWdUYdXSt1wA3T2Y5mCrGkrcwevkGY3xJ8ePBgbMd66wsO
   sgAks+iW4s3mZvGDSwgOT6BeqC+nfB2A420GeCNKjnIRXGqMRpBjnYSjh
   G7U6mlD6pE4+Awqw0i4XYKxwTOQzehvYidq9fDl+S0v4uR545qBXgMSfT
   TnB3sRtwFRRRdYEnv0mM8nPuz9iVIBy6rQRmvU5kpDRl8ik+MqCO52Nos
   XB7S0YQhWLXu/HwhDxBdKzFy1n84YCpp3jyNFEg+7tVtNL6xoOmAJf7Lk
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317506099"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="317506099"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 04:11:20 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="644429963"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="644429963"
Received: from ideak-desk.fi.intel.com ([10.237.72.58])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 04:11:17 -0800
Date:   Tue, 7 Feb 2023 14:11:14 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 02/17] drm/display/dp_mst: Handle old/new payload
 states in drm_dp_remove_payload()
Message-ID: <Y+I/wcEExBEbAV4L@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20230131150548.1614458-1-imre.deak@intel.com>
 <20230131150548.1614458-3-imre.deak@intel.com>
 <ed8b73096a576f317979c3dd65392371d5b77612.camel@redhat.com>
 <Y9p/ZqVVpW/YMdUy@ideak-desk.fi.intel.com>
 <c74b71b1d998ce6b062405508354dd1943aafa38.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c74b71b1d998ce6b062405508354dd1943aafa38.camel@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 06, 2023 at 07:42:32PM -0500, Lyude Paul wrote:
> On Wed, 2023-02-01 at 17:04 +0200, Imre Deak wrote:
> > 
> > Yes, this patch should have no functional change, so please check what
> > would apply to other drivers as well.
> > 
> > Could you also check Ville's comment about storing start_slot elsewhere
> > than the atomic state (leaving only time_slots there). I wonder if that
> > would work, at least it would simplify things I think.
> 
> Ideally it'd be nice if we could have all this info in the atomic commit, but
> yeah - you're not the first person to find this a bit confusing. FWIW though,
> the way we store start_slot right now is intended to follow the same kind of
> behavior we have with atomic CRTC commit dependencies, I think I also made it
> that way so all of the state would be in a single place but there's no hard
> requirement for it.

As I understood the atomic state should be precomputed during atomic
check and not changed later during the commit phase. In case of
start_slot this would mean knowing in advance the actual (driver
specific) disabling / enabling sequence of the payloads, not sure how
feasible it is to figure that out. start_slot also changes dynamically
as each payload is disabled, so these intermediate versions of the field
would need to be tracked somehow separately from the final (precomputed)
versions.

> So if you guys think it'd be better design-wise to store this something else,
> I've got no strong feelings either way
> > 
> > > For 0-2:
> > > 
> > > Reviewed-by: Lyude Paul <lyude@redhat.com>
> > 
> > Thanks.
> > 
> > > 
> > > > 
> > > > Cc: Lyude Paul <lyude@redhat.com>
> > > > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > Cc: Ben Skeggs <bskeggs@redhat.com>
> > > > Cc: Karol Herbst <kherbst@redhat.com>
> > > > Cc: Harry Wentland <harry.wentland@amd.com>
> > > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > > Cc: Wayne Lin <Wayne.Lin@amd.com>
> > > > Cc: stable@vger.kernel.org # 6.1
> > > > Cc: dri-devel@lists.freedesktop.org
> > > > Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > > > ---
> > > >  .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c |  2 +-
> > > >  drivers/gpu/drm/display/drm_dp_mst_topology.c | 26 ++++++++++---------
> > > >  drivers/gpu/drm/i915/display/intel_dp_mst.c   |  4 ++-
> > > >  drivers/gpu/drm/nouveau/dispnv50/disp.c       |  2 +-
> > > >  include/drm/display/drm_dp_mst_helper.h       |  3 ++-
> > > >  5 files changed, 21 insertions(+), 16 deletions(-)
> > > > 
> > > > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > > > index a50319fc42b11..180d3893b68da 100644
> > > > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > > > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > > > @@ -208,7 +208,7 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
> > > >  	if (enable)
> > > >  		drm_dp_add_payload_part1(mst_mgr, mst_state, payload);
> > > >  	else
> > > > -		drm_dp_remove_payload(mst_mgr, mst_state, payload);
> > > > +		drm_dp_remove_payload(mst_mgr, mst_state, payload, payload);
> > > >  
> > > >  	/* mst_mgr->->payloads are VC payload notify MST branch using DPCD or
> > > >  	 * AUX message. The sequence is slot 1-63 allocated sequence for each
> > > > diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > > > index 847c10aa2098c..1990ff5dc7ddd 100644
> > > > --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > > > +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > > > @@ -3342,7 +3342,8 @@ EXPORT_SYMBOL(drm_dp_add_payload_part1);
> > > >   * drm_dp_remove_payload() - Remove an MST payload
> > > >   * @mgr: Manager to use.
> > > >   * @mst_state: The MST atomic state
> > > > - * @payload: The payload to write
> > > > + * @old_payload: The payload with its old state
> > > > + * @new_payload: The payload to write
> > > >   *
> > > >   * Removes a payload from an MST topology if it was successfully assigned a start slot. Also updates
> > > >   * the starting time slots of all other payloads which would have been shifted towards the start of
> > > > @@ -3350,36 +3351,37 @@ EXPORT_SYMBOL(drm_dp_add_payload_part1);
> > > >   */
> > > >  void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
> > > >  			   struct drm_dp_mst_topology_state *mst_state,
> > > > -			   struct drm_dp_mst_atomic_payload *payload)
> > > > +			   const struct drm_dp_mst_atomic_payload *old_payload,
> > > > +			   struct drm_dp_mst_atomic_payload *new_payload)
> > > >  {
> > > >  	struct drm_dp_mst_atomic_payload *pos;
> > > >  	bool send_remove = false;
> > > >  
> > > >  	/* We failed to make the payload, so nothing to do */
> > > > -	if (payload->vc_start_slot == -1)
> > > > +	if (new_payload->vc_start_slot == -1)
> > > >  		return;
> > > >  
> > > >  	mutex_lock(&mgr->lock);
> > > > -	send_remove = drm_dp_mst_port_downstream_of_branch(payload->port, mgr->mst_primary);
> > > > +	send_remove = drm_dp_mst_port_downstream_of_branch(new_payload->port, mgr->mst_primary);
> > > >  	mutex_unlock(&mgr->lock);
> > > >  
> > > >  	if (send_remove)
> > > > -		drm_dp_destroy_payload_step1(mgr, mst_state, payload);
> > > > +		drm_dp_destroy_payload_step1(mgr, mst_state, new_payload);
> > > >  	else
> > > >  		drm_dbg_kms(mgr->dev, "Payload for VCPI %d not in topology, not sending remove\n",
> > > > -			    payload->vcpi);
> > > > +			    new_payload->vcpi);
> > > >  
> > > >  	list_for_each_entry(pos, &mst_state->payloads, next) {
> > > > -		if (pos != payload && pos->vc_start_slot > payload->vc_start_slot)
> > > > -			pos->vc_start_slot -= payload->time_slots;
> > > > +		if (pos != new_payload && pos->vc_start_slot > new_payload->vc_start_slot)
> > > > +			pos->vc_start_slot -= old_payload->time_slots;
> > > >  	}
> > > > -	payload->vc_start_slot = -1;
> > > > +	new_payload->vc_start_slot = -1;
> > > >  
> > > >  	mgr->payload_count--;
> > > > -	mgr->next_start_slot -= payload->time_slots;
> > > > +	mgr->next_start_slot -= old_payload->time_slots;
> > > >  
> > > > -	if (payload->delete)
> > > > -		drm_dp_mst_put_port_malloc(payload->port);
> > > > +	if (new_payload->delete)
> > > > +		drm_dp_mst_put_port_malloc(new_payload->port);
> > > >  }
> > > >  EXPORT_SYMBOL(drm_dp_remove_payload);
> > > >  
> > > > diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > > > index f3cb12dcfe0a7..dc4e5ff1dbb31 100644
> > > > --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > > > +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > > > @@ -526,6 +526,8 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
> > > >  		to_intel_connector(old_conn_state->connector);
> > > >  	struct drm_dp_mst_topology_state *mst_state =
> > > >  		drm_atomic_get_mst_topology_state(&state->base, &intel_dp->mst_mgr);
> > > > +	struct drm_dp_mst_atomic_payload *payload =
> > > > +		drm_atomic_get_mst_payload_state(mst_state, connector->port);
> > > >  	struct drm_i915_private *i915 = to_i915(connector->base.dev);
> > > >  
> > > >  	drm_dbg_kms(&i915->drm, "active links %d\n",
> > > > @@ -534,7 +536,7 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
> > > >  	intel_hdcp_disable(intel_mst->connector);
> > > >  
> > > >  	drm_dp_remove_payload(&intel_dp->mst_mgr, mst_state,
> > > > -			      drm_atomic_get_mst_payload_state(mst_state, connector->port));
> > > > +			      payload, payload);
> > > >  
> > > >  	intel_audio_codec_disable(encoder, old_crtc_state, old_conn_state);
> > > >  }
> > > > diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> > > > index edcb2529b4025..ed9d374147b8d 100644
> > > > --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> > > > +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> > > > @@ -885,7 +885,7 @@ nv50_msto_prepare(struct drm_atomic_state *state,
> > > >  
> > > >  	// TODO: Figure out if we want to do a better job of handling VCPI allocation failures here?
> > > >  	if (msto->disabled) {
> > > > -		drm_dp_remove_payload(mgr, mst_state, payload);
> > > > +		drm_dp_remove_payload(mgr, mst_state, payload, payload);
> > > >  
> > > >  		nvif_outp_dp_mst_vcpi(&mstm->outp->outp, msto->head->base.index, 0, 0, 0, 0);
> > > >  	} else {
> > > > diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/display/drm_dp_mst_helper.h
> > > > index 41fd8352ab656..f5eb9aa152b14 100644
> > > > --- a/include/drm/display/drm_dp_mst_helper.h
> > > > +++ b/include/drm/display/drm_dp_mst_helper.h
> > > > @@ -841,7 +841,8 @@ int drm_dp_add_payload_part2(struct drm_dp_mst_topology_mgr *mgr,
> > > >  			     struct drm_dp_mst_atomic_payload *payload);
> > > >  void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
> > > >  			   struct drm_dp_mst_topology_state *mst_state,
> > > > -			   struct drm_dp_mst_atomic_payload *payload);
> > > > +			   const struct drm_dp_mst_atomic_payload *old_payload,
> > > > +			   struct drm_dp_mst_atomic_payload *new_payload);
> > > >  
> > > >  int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr);
> > > >  
> > > 
> > > -- 
> > > Cheers,
> > >  Lyude Paul (she/her)
> > >  Software Engineer at Red Hat
> > > 
> > 
> 
> -- 
> Cheers,
>  Lyude Paul (she/her)
>  Software Engineer at Red Hat
> 
