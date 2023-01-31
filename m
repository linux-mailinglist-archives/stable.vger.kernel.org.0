Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31026683A43
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 00:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjAaXOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 18:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjAaXOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 18:14:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5229D7A8D
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 15:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675206794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GuPLxxwLlIMb4e5mC8mkW+RMdG9aD5bdoF2Q5DsUBtk=;
        b=WjwZQ7Nrd2cBV48c3MNaMjrngnUM7Zhb2n38Rqju0yQoNQrk/Q2X4fyZAavufxt9XZNj2a
        axr1tAk/SFYVQREBC5b+++AJt7o39ksilBnGPEDaQlWrubLYhMz5HUOC01mnhCM8prnOlc
        CU8mKMEjaRkUZBXDWl54fLupTGOJIzs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-L_Uw1ypZPTuJhJEbFHInaQ-1; Tue, 31 Jan 2023 18:13:12 -0500
X-MC-Unique: L_Uw1ypZPTuJhJEbFHInaQ-1
Received: by mail-qk1-f200.google.com with SMTP id u11-20020a05620a430b00b007052a66d201so10224956qko.23
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 15:13:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GuPLxxwLlIMb4e5mC8mkW+RMdG9aD5bdoF2Q5DsUBtk=;
        b=19nQdWKr6fqCTCBGG7K986QArNspfgpkLDLA9NkstR2bZCK8OPDKf/ujp1S0z4lcpL
         /LBvc0v3jeyiWC+TbjXYIppIcXFERRnNy9uYpn03DDj2BSVBsU4ioVGHJqOIYSwQY58M
         LxU3Fh30+ZUNRbAHnuYE4nZqb3XSMexq8g/m6XrS3UAmeN0OPt/I/coQZEcuIXssHEvw
         +CbDjmGXcPq+P6KtVIDx2RkEFjAuEGypNgvOjXfd3yLS4tPwDp8/xMiOdWWY40oI5+Tp
         mtUN3W07eboUMYiRxjSmc9ewfgBqdx2L6IyigVUy/WuGUW/EA8btOa7+ntU0VS8t0wif
         Z6yg==
X-Gm-Message-State: AO0yUKUZdHFmgfi6utHBPbqTBZGms5jcv7/kBsF+KeZ0FD2kMi83+FiQ
        3B6iGshtIZNma9V/aPDirQ6SySFYzNDNIvePwiRgoNOIBiRx1v+c/UEc99b8VoVOvuibbECCjnF
        Pn2bImEtK+76OZgb5
X-Received: by 2002:a0c:ee90:0:b0:531:91cd:59de with SMTP id u16-20020a0cee90000000b0053191cd59demr16680084qvr.26.1675206791867;
        Tue, 31 Jan 2023 15:13:11 -0800 (PST)
X-Google-Smtp-Source: AK7set+U8IFBJjnSngopEHdO6P381kRED55/VU9cShm+LNOPTG4WX6UdvtmgTYUVLk6QaAv2MzY6FA==
X-Received: by 2002:a0c:ee90:0:b0:531:91cd:59de with SMTP id u16-20020a0cee90000000b0053191cd59demr16680063qvr.26.1675206791634;
        Tue, 31 Jan 2023 15:13:11 -0800 (PST)
Received: from ?IPv6:2600:4040:5c68:6800::feb? ([2600:4040:5c68:6800::feb])
        by smtp.gmail.com with ESMTPSA id o13-20020a05620a2a0d00b006ce580c2663sm11056795qkp.35.2023.01.31.15.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 15:13:11 -0800 (PST)
Message-ID: <ed8b73096a576f317979c3dd65392371d5b77612.camel@redhat.com>
Subject: Re: [PATCH v2 02/17] drm/display/dp_mst: Handle old/new payload
 states in drm_dp_remove_payload()
From:   Lyude Paul <lyude@redhat.com>
To:     Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org
Cc:     Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date:   Tue, 31 Jan 2023 18:13:10 -0500
In-Reply-To: <20230131150548.1614458-3-imre.deak@intel.com>
References: <20230131150548.1614458-1-imre.deak@intel.com>
         <20230131150548.1614458-3-imre.deak@intel.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2023-01-31 at 17:05 +0200, Imre Deak wrote:
> Atm, drm_dp_remove_payload() uses the same payload state to both get the
> vc_start_slot required for the payload removal DPCD message and to
> deduct time_slots from vc_start_slot of all payloads after the one being
> removed.
>=20
> The above isn't always correct, as vc_start_slot must be the up-to-date
> version contained in the new payload state, but time_slots must be the
> one used when the payload was previously added, contained in the old
> payload state. The new payload's time_slots can change vs. the old one
> if the current atomic commit changes the corresponding mode.
>=20
> This patch let's drivers pass the old and new payload states to
> drm_dp_remove_payload(), but keeps these the same for now in all drivers
> not to change the behavior. A follow-up i915 patch will pass in that
> driver the correct old and new states to the function.

Oh wow, this was definitely a mistake on my part, thanks for catching this!
TBH, I think this behavior is correct so (now that I actually have a setup
capable of testing amdgpu's MST fully thanks to gitlab issue 2171=E2=80=A6)=
 if you'd
like to change it on other drivers as well I can test it fully. Or feel fre=
e
to leave it to me, shouldn't be too difficult I think :).

For 0-2:

Reviewed-by: Lyude Paul <lyude@redhat.com>

>=20
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Karol Herbst <kherbst@redhat.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Wayne Lin <Wayne.Lin@amd.com>
> Cc: stable@vger.kernel.org # 6.1
> Cc: dri-devel@lists.freedesktop.org
> Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c |  2 +-
>  drivers/gpu/drm/display/drm_dp_mst_topology.c | 26 ++++++++++---------
>  drivers/gpu/drm/i915/display/intel_dp_mst.c   |  4 ++-
>  drivers/gpu/drm/nouveau/dispnv50/disp.c       |  2 +-
>  include/drm/display/drm_dp_mst_helper.h       |  3 ++-
>  5 files changed, 21 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/=
drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> index a50319fc42b11..180d3893b68da 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> @@ -208,7 +208,7 @@ bool dm_helpers_dp_mst_write_payload_allocation_table=
(
>  	if (enable)
>  		drm_dp_add_payload_part1(mst_mgr, mst_state, payload);
>  	else
> -		drm_dp_remove_payload(mst_mgr, mst_state, payload);
> +		drm_dp_remove_payload(mst_mgr, mst_state, payload, payload);
> =20
>  	/* mst_mgr->->payloads are VC payload notify MST branch using DPCD or
>  	 * AUX message. The sequence is slot 1-63 allocated sequence for each
> diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/=
drm/display/drm_dp_mst_topology.c
> index 847c10aa2098c..1990ff5dc7ddd 100644
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
>   * Removes a payload from an MST topology if it was successfully assigne=
d a start slot. Also updates
>   * the starting time slots of all other payloads which would have been s=
hifted towards the start of
> @@ -3350,36 +3351,37 @@ EXPORT_SYMBOL(drm_dp_add_payload_part1);
>   */
>  void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
>  			   struct drm_dp_mst_topology_state *mst_state,
> -			   struct drm_dp_mst_atomic_payload *payload)
> +			   const struct drm_dp_mst_atomic_payload *old_payload,
> +			   struct drm_dp_mst_atomic_payload *new_payload)
>  {
>  	struct drm_dp_mst_atomic_payload *pos;
>  	bool send_remove =3D false;
> =20
>  	/* We failed to make the payload, so nothing to do */
> -	if (payload->vc_start_slot =3D=3D -1)
> +	if (new_payload->vc_start_slot =3D=3D -1)
>  		return;
> =20
>  	mutex_lock(&mgr->lock);
> -	send_remove =3D drm_dp_mst_port_downstream_of_branch(payload->port, mgr=
->mst_primary);
> +	send_remove =3D drm_dp_mst_port_downstream_of_branch(new_payload->port,=
 mgr->mst_primary);
>  	mutex_unlock(&mgr->lock);
> =20
>  	if (send_remove)
> -		drm_dp_destroy_payload_step1(mgr, mst_state, payload);
> +		drm_dp_destroy_payload_step1(mgr, mst_state, new_payload);
>  	else
>  		drm_dbg_kms(mgr->dev, "Payload for VCPI %d not in topology, not sendin=
g remove\n",
> -			    payload->vcpi);
> +			    new_payload->vcpi);
> =20
>  	list_for_each_entry(pos, &mst_state->payloads, next) {
> -		if (pos !=3D payload && pos->vc_start_slot > payload->vc_start_slot)
> -			pos->vc_start_slot -=3D payload->time_slots;
> +		if (pos !=3D new_payload && pos->vc_start_slot > new_payload->vc_start=
_slot)
> +			pos->vc_start_slot -=3D old_payload->time_slots;
>  	}
> -	payload->vc_start_slot =3D -1;
> +	new_payload->vc_start_slot =3D -1;
> =20
>  	mgr->payload_count--;
> -	mgr->next_start_slot -=3D payload->time_slots;
> +	mgr->next_start_slot -=3D old_payload->time_slots;
> =20
> -	if (payload->delete)
> -		drm_dp_mst_put_port_malloc(payload->port);
> +	if (new_payload->delete)
> +		drm_dp_mst_put_port_malloc(new_payload->port);
>  }
>  EXPORT_SYMBOL(drm_dp_remove_payload);
> =20
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/dr=
m/i915/display/intel_dp_mst.c
> index f3cb12dcfe0a7..dc4e5ff1dbb31 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> @@ -526,6 +526,8 @@ static void intel_mst_disable_dp(struct intel_atomic_=
state *state,
>  		to_intel_connector(old_conn_state->connector);
>  	struct drm_dp_mst_topology_state *mst_state =3D
>  		drm_atomic_get_mst_topology_state(&state->base, &intel_dp->mst_mgr);
> +	struct drm_dp_mst_atomic_payload *payload =3D
> +		drm_atomic_get_mst_payload_state(mst_state, connector->port);
>  	struct drm_i915_private *i915 =3D to_i915(connector->base.dev);
> =20
>  	drm_dbg_kms(&i915->drm, "active links %d\n",
> @@ -534,7 +536,7 @@ static void intel_mst_disable_dp(struct intel_atomic_=
state *state,
>  	intel_hdcp_disable(intel_mst->connector);
> =20
>  	drm_dp_remove_payload(&intel_dp->mst_mgr, mst_state,
> -			      drm_atomic_get_mst_payload_state(mst_state, connector->port));
> +			      payload, payload);
> =20
>  	intel_audio_codec_disable(encoder, old_crtc_state, old_conn_state);
>  }
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/no=
uveau/dispnv50/disp.c
> index edcb2529b4025..ed9d374147b8d 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -885,7 +885,7 @@ nv50_msto_prepare(struct drm_atomic_state *state,
> =20
>  	// TODO: Figure out if we want to do a better job of handling VCPI allo=
cation failures here?
>  	if (msto->disabled) {
> -		drm_dp_remove_payload(mgr, mst_state, payload);
> +		drm_dp_remove_payload(mgr, mst_state, payload, payload);
> =20
>  		nvif_outp_dp_mst_vcpi(&mstm->outp->outp, msto->head->base.index, 0, 0,=
 0, 0);
>  	} else {
> diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/displa=
y/drm_dp_mst_helper.h
> index 41fd8352ab656..f5eb9aa152b14 100644
> --- a/include/drm/display/drm_dp_mst_helper.h
> +++ b/include/drm/display/drm_dp_mst_helper.h
> @@ -841,7 +841,8 @@ int drm_dp_add_payload_part2(struct drm_dp_mst_topolo=
gy_mgr *mgr,
>  			     struct drm_dp_mst_atomic_payload *payload);
>  void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
>  			   struct drm_dp_mst_topology_state *mst_state,
> -			   struct drm_dp_mst_atomic_payload *payload);
> +			   const struct drm_dp_mst_atomic_payload *old_payload,
> +			   struct drm_dp_mst_atomic_payload *new_payload);
> =20
>  int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr);
> =20

--=20
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

