Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB59468CB5C
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 01:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjBGAnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 19:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjBGAnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 19:43:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3969016AF6
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 16:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675730556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9PL65Ot97HxurY2i6/J8tAA9u5Jl4yQNwsMewS8lKv8=;
        b=f/mvusCz3dDwIyRK0iIoeY7b7Kell15IITxDKxyXAoM4K7TAMz71vU835i8jfVTuZNv6Y7
        rl9xN+VCdUt2i4d6pjukB3/1cPj85lRZQEd3omeNwPQ0TygFGfm8IfCzR812B3X2yzIQFq
        Qh0S0uH1AywYHOQQQ+e2qwH1u0OOkkU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-615-zj9G4uFSNVayS0BW5poo8Q-1; Mon, 06 Feb 2023 19:42:35 -0500
X-MC-Unique: zj9G4uFSNVayS0BW5poo8Q-1
Received: by mail-qt1-f197.google.com with SMTP id bz17-20020a05622a1e9100b003b9c1013018so7620612qtb.18
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 16:42:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9PL65Ot97HxurY2i6/J8tAA9u5Jl4yQNwsMewS8lKv8=;
        b=t31GVD/E2pV+1i9wDgy6ovOHew8v4705Oy7x0um4UD8ADXOWTRNuYoosXWItgJfN7R
         02x34vdP+dCLWo/GauM0sc4v6V0ob8l89h13e8siXSu+NGUUq3ExPdKwM9RAZE2hHQDu
         5FTdJnxRQLjtT4U6IEQSgquokuDHo9p8XAlKcdoIOCoWbzuAj+55vZnh79euYxLuRk4E
         e20ayuyg4MgC2asOlRghmoEYYkZQ9kUdyvE3zHvGqTVBf2SgNb9p8r49AH2GpaApXWNt
         V9Loj8VVBqFal3/EUUkUrxtLi9exXxBWnBa3r5/zZsrPQu4RfPLPSkHK7XsGEtfhsoRE
         d/tA==
X-Gm-Message-State: AO0yUKUqWYcWx5yNurLDSOiI/H8YAUocsz+0rlEYE+7dyQxm1/kHVN8/
        HfCEknFwqMPhfbaxpB/rXhPzuMnBSgbH8dypE92b/l/PMsqqwMhAjbI8Fjwm8tZGo20P9w50HtT
        deqBiv2yeTK8odaMF
X-Received: by 2002:a05:622a:513:b0:3b6:3512:eec9 with SMTP id l19-20020a05622a051300b003b63512eec9mr2084814qtx.51.1675730554717;
        Mon, 06 Feb 2023 16:42:34 -0800 (PST)
X-Google-Smtp-Source: AK7set/2/RXcu0+XdXBcKJ9IB+foxl8+YciCfBTMv070Rr3TzCgj4JtCo/9brBcBRFuZJc3bcnGgJw==
X-Received: by 2002:a05:622a:513:b0:3b6:3512:eec9 with SMTP id l19-20020a05622a051300b003b63512eec9mr2084797qtx.51.1675730554423;
        Mon, 06 Feb 2023 16:42:34 -0800 (PST)
Received: from ?IPv6:2600:4040:5c68:6800::feb? ([2600:4040:5c68:6800::feb])
        by smtp.gmail.com with ESMTPSA id y21-20020a05622a005500b003b9bb59543fsm8448841qtw.61.2023.02.06.16.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 16:42:33 -0800 (PST)
Message-ID: <c74b71b1d998ce6b062405508354dd1943aafa38.camel@redhat.com>
Subject: Re: [PATCH v2 02/17] drm/display/dp_mst: Handle old/new payload
 states in drm_dp_remove_payload()
From:   Lyude Paul <lyude@redhat.com>
To:     imre.deak@intel.com
Cc:     intel-gfx@lists.freedesktop.org,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date:   Mon, 06 Feb 2023 19:42:32 -0500
In-Reply-To: <Y9p/ZqVVpW/YMdUy@ideak-desk.fi.intel.com>
References: <20230131150548.1614458-1-imre.deak@intel.com>
         <20230131150548.1614458-3-imre.deak@intel.com>
         <ed8b73096a576f317979c3dd65392371d5b77612.camel@redhat.com>
         <Y9p/ZqVVpW/YMdUy@ideak-desk.fi.intel.com>
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

On Wed, 2023-02-01 at 17:04 +0200, Imre Deak wrote:
>=20
> Yes, this patch should have no functional change, so please check what
> would apply to other drivers as well.
>=20
> Could you also check Ville's comment about storing start_slot elsewhere
> than the atomic state (leaving only time_slots there). I wonder if that
> would work, at least it would simplify things I think.

Ideally it'd be nice if we could have all this info in the atomic commit, b=
ut
yeah - you're not the first person to find this a bit confusing. FWIW thoug=
h,
the way we store start_slot right now is intended to follow the same kind o=
f
behavior we have with atomic CRTC commit dependencies, I think I also made =
it
that way so all of the state would be in a single place but there's no hard
requirement for it.

So if you guys think it'd be better design-wise to store this something els=
e,
I've got no strong feelings either way
>=20
> > For 0-2:
> >=20
> > Reviewed-by: Lyude Paul <lyude@redhat.com>
>=20
> Thanks.
>=20
> >=20
> > >=20
> > > Cc: Lyude Paul <lyude@redhat.com>
> > > Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > > Cc: Ben Skeggs <bskeggs@redhat.com>
> > > Cc: Karol Herbst <kherbst@redhat.com>
> > > Cc: Harry Wentland <harry.wentland@amd.com>
> > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > Cc: Wayne Lin <Wayne.Lin@amd.com>
> > > Cc: stable@vger.kernel.org # 6.1
> > > Cc: dri-devel@lists.freedesktop.org
> > > Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > > ---
> > >  .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c |  2 +-
> > >  drivers/gpu/drm/display/drm_dp_mst_topology.c | 26 ++++++++++-------=
--
> > >  drivers/gpu/drm/i915/display/intel_dp_mst.c   |  4 ++-
> > >  drivers/gpu/drm/nouveau/dispnv50/disp.c       |  2 +-
> > >  include/drm/display/drm_dp_mst_helper.h       |  3 ++-
> > >  5 files changed, 21 insertions(+), 16 deletions(-)
> > >=20
> > > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.=
c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > > index a50319fc42b11..180d3893b68da 100644
> > > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > > @@ -208,7 +208,7 @@ bool dm_helpers_dp_mst_write_payload_allocation_t=
able(
> > >  	if (enable)
> > >  		drm_dp_add_payload_part1(mst_mgr, mst_state, payload);
> > >  	else
> > > -		drm_dp_remove_payload(mst_mgr, mst_state, payload);
> > > +		drm_dp_remove_payload(mst_mgr, mst_state, payload, payload);
> > > =20
> > >  	/* mst_mgr->->payloads are VC payload notify MST branch using DPCD =
or
> > >  	 * AUX message. The sequence is slot 1-63 allocated sequence for ea=
ch
> > > diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/=
gpu/drm/display/drm_dp_mst_topology.c
> > > index 847c10aa2098c..1990ff5dc7ddd 100644
> > > --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > > +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > > @@ -3342,7 +3342,8 @@ EXPORT_SYMBOL(drm_dp_add_payload_part1);
> > >   * drm_dp_remove_payload() - Remove an MST payload
> > >   * @mgr: Manager to use.
> > >   * @mst_state: The MST atomic state
> > > - * @payload: The payload to write
> > > + * @old_payload: The payload with its old state
> > > + * @new_payload: The payload to write
> > >   *
> > >   * Removes a payload from an MST topology if it was successfully ass=
igned a start slot. Also updates
> > >   * the starting time slots of all other payloads which would have be=
en shifted towards the start of
> > > @@ -3350,36 +3351,37 @@ EXPORT_SYMBOL(drm_dp_add_payload_part1);
> > >   */
> > >  void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
> > >  			   struct drm_dp_mst_topology_state *mst_state,
> > > -			   struct drm_dp_mst_atomic_payload *payload)
> > > +			   const struct drm_dp_mst_atomic_payload *old_payload,
> > > +			   struct drm_dp_mst_atomic_payload *new_payload)
> > >  {
> > >  	struct drm_dp_mst_atomic_payload *pos;
> > >  	bool send_remove =3D false;
> > > =20
> > >  	/* We failed to make the payload, so nothing to do */
> > > -	if (payload->vc_start_slot =3D=3D -1)
> > > +	if (new_payload->vc_start_slot =3D=3D -1)
> > >  		return;
> > > =20
> > >  	mutex_lock(&mgr->lock);
> > > -	send_remove =3D drm_dp_mst_port_downstream_of_branch(payload->port,=
 mgr->mst_primary);
> > > +	send_remove =3D drm_dp_mst_port_downstream_of_branch(new_payload->p=
ort, mgr->mst_primary);
> > >  	mutex_unlock(&mgr->lock);
> > > =20
> > >  	if (send_remove)
> > > -		drm_dp_destroy_payload_step1(mgr, mst_state, payload);
> > > +		drm_dp_destroy_payload_step1(mgr, mst_state, new_payload);
> > >  	else
> > >  		drm_dbg_kms(mgr->dev, "Payload for VCPI %d not in topology, not se=
nding remove\n",
> > > -			    payload->vcpi);
> > > +			    new_payload->vcpi);
> > > =20
> > >  	list_for_each_entry(pos, &mst_state->payloads, next) {
> > > -		if (pos !=3D payload && pos->vc_start_slot > payload->vc_start_slo=
t)
> > > -			pos->vc_start_slot -=3D payload->time_slots;
> > > +		if (pos !=3D new_payload && pos->vc_start_slot > new_payload->vc_s=
tart_slot)
> > > +			pos->vc_start_slot -=3D old_payload->time_slots;
> > >  	}
> > > -	payload->vc_start_slot =3D -1;
> > > +	new_payload->vc_start_slot =3D -1;
> > > =20
> > >  	mgr->payload_count--;
> > > -	mgr->next_start_slot -=3D payload->time_slots;
> > > +	mgr->next_start_slot -=3D old_payload->time_slots;
> > > =20
> > > -	if (payload->delete)
> > > -		drm_dp_mst_put_port_malloc(payload->port);
> > > +	if (new_payload->delete)
> > > +		drm_dp_mst_put_port_malloc(new_payload->port);
> > >  }
> > >  EXPORT_SYMBOL(drm_dp_remove_payload);
> > > =20
> > > diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gp=
u/drm/i915/display/intel_dp_mst.c
> > > index f3cb12dcfe0a7..dc4e5ff1dbb31 100644
> > > --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > > +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > > @@ -526,6 +526,8 @@ static void intel_mst_disable_dp(struct intel_ato=
mic_state *state,
> > >  		to_intel_connector(old_conn_state->connector);
> > >  	struct drm_dp_mst_topology_state *mst_state =3D
> > >  		drm_atomic_get_mst_topology_state(&state->base, &intel_dp->mst_mgr=
);
> > > +	struct drm_dp_mst_atomic_payload *payload =3D
> > > +		drm_atomic_get_mst_payload_state(mst_state, connector->port);
> > >  	struct drm_i915_private *i915 =3D to_i915(connector->base.dev);
> > > =20
> > >  	drm_dbg_kms(&i915->drm, "active links %d\n",
> > > @@ -534,7 +536,7 @@ static void intel_mst_disable_dp(struct intel_ato=
mic_state *state,
> > >  	intel_hdcp_disable(intel_mst->connector);
> > > =20
> > >  	drm_dp_remove_payload(&intel_dp->mst_mgr, mst_state,
> > > -			      drm_atomic_get_mst_payload_state(mst_state, connector->port=
));
> > > +			      payload, payload);
> > > =20
> > >  	intel_audio_codec_disable(encoder, old_crtc_state, old_conn_state);
> > >  }
> > > diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/dr=
m/nouveau/dispnv50/disp.c
> > > index edcb2529b4025..ed9d374147b8d 100644
> > > --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> > > +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> > > @@ -885,7 +885,7 @@ nv50_msto_prepare(struct drm_atomic_state *state,
> > > =20
> > >  	// TODO: Figure out if we want to do a better job of handling VCPI =
allocation failures here?
> > >  	if (msto->disabled) {
> > > -		drm_dp_remove_payload(mgr, mst_state, payload);
> > > +		drm_dp_remove_payload(mgr, mst_state, payload, payload);
> > > =20
> > >  		nvif_outp_dp_mst_vcpi(&mstm->outp->outp, msto->head->base.index, 0=
, 0, 0, 0);
> > >  	} else {
> > > diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/di=
splay/drm_dp_mst_helper.h
> > > index 41fd8352ab656..f5eb9aa152b14 100644
> > > --- a/include/drm/display/drm_dp_mst_helper.h
> > > +++ b/include/drm/display/drm_dp_mst_helper.h
> > > @@ -841,7 +841,8 @@ int drm_dp_add_payload_part2(struct drm_dp_mst_to=
pology_mgr *mgr,
> > >  			     struct drm_dp_mst_atomic_payload *payload);
> > >  void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
> > >  			   struct drm_dp_mst_topology_state *mst_state,
> > > -			   struct drm_dp_mst_atomic_payload *payload);
> > > +			   const struct drm_dp_mst_atomic_payload *old_payload,
> > > +			   struct drm_dp_mst_atomic_payload *new_payload);
> > > =20
> > >  int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr);
> > > =20
> >=20
> > --=20
> > Cheers,
> >  Lyude Paul (she/her)
> >  Software Engineer at Red Hat
> >=20
>=20

--=20
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

