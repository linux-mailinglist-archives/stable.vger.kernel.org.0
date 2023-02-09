Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B54E6912BA
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 22:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjBIVoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 16:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBIVoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 16:44:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBBA5EF9F
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 13:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675979014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MlEz8Y+/mCd30QRfDM6T2n4F1GL0JbkH6Xfu4wv13Dg=;
        b=iM9NDiodRrCG5VdLaGENegosgsOFmPzHCX3uESGyIS9lX/abXlkrNHudpRFDnF27iP7UKv
        QAaxZRkXp1Ttud8kIa63Kku2y1BoA/N00Cigu2DL0urlBRgJTKcxRqCapUkfCHiEnnCfJt
        gM6RCGuforiGUe2tnCko3RBUC3EZU1Q=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-28-sM0iYqYdM_uhTxZ0LLAedw-1; Thu, 09 Feb 2023 16:43:33 -0500
X-MC-Unique: sM0iYqYdM_uhTxZ0LLAedw-1
Received: by mail-qt1-f197.google.com with SMTP id v3-20020a05622a188300b003ba183e8272so1946334qtc.0
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 13:43:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MlEz8Y+/mCd30QRfDM6T2n4F1GL0JbkH6Xfu4wv13Dg=;
        b=PVDScKpLji20os5wUG3oN5x/P0lJjrw1HOAnrJ/WjDMySRm4tcjWIKPShqrVEpZ+xu
         1fN61Q7AHFVIie2sccL2HHAawYfMcnuQ5Nnd5LD/SKfuHGgol9ZdWI2W7mzkrNArXB6T
         ssEMIN0JfH+o0ElAiQPJeGBFFI6LbuoGt+Hpm+DHnG8nIdSJAKkbtBOUVTZuPSLrqh9Z
         UgmA5gCDQOXI7vi1fzutpeNfWfaQ3FxFL8JiHh/4VQvkWTsSY5hUJpT7Jn9jElcSouO+
         BdYiMMPaZGVrXTcTTOYUnyaf+fpHToXS9KjA+qgsytl3Y3VYnOVd3j6LpLmQxYWBJKzl
         t0BA==
X-Gm-Message-State: AO0yUKXB/LunXpeQUA6Zp2a7EW2qBqYo8vmIlTZ1pcnWI3pTPgWe4ClQ
        VKjtlgJGDNoQNqn4V8mnbGB0XFMBc0HVrhcZyY5tr/MBmoxRC9y6xTwmqydYeKUjlRwWxfVGrh9
        nO0mV+92tNKncnwEN
X-Received: by 2002:a05:622a:1191:b0:3b9:d14c:39f8 with SMTP id m17-20020a05622a119100b003b9d14c39f8mr22362748qtk.40.1675979012754;
        Thu, 09 Feb 2023 13:43:32 -0800 (PST)
X-Google-Smtp-Source: AK7set8ROgI3fLMZCjyJWqImLj4ICkSrLxgbOZVxOrVIDsUn7+XQUmoCbI+52Z2LSUjCedrfqW9SJw==
X-Received: by 2002:a05:622a:1191:b0:3b9:d14c:39f8 with SMTP id m17-20020a05622a119100b003b9d14c39f8mr22362715qtk.40.1675979012472;
        Thu, 09 Feb 2023 13:43:32 -0800 (PST)
Received: from ?IPv6:2600:4040:5c68:6800:3463:5df7:aced:152e? ([2600:4040:5c68:6800:3463:5df7:aced:152e])
        by smtp.gmail.com with ESMTPSA id q1-20020ac84101000000b003b9dca4cdf4sm2000532qtl.83.2023.02.09.13.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 13:43:32 -0800 (PST)
Message-ID: <551c4eb4cb91d05393b6e740d94eabb0330d3149.camel@redhat.com>
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
Date:   Thu, 09 Feb 2023 16:43:30 -0500
In-Reply-To: <Y+NSHI9QgcLGe2c1@ideak-desk.fi.intel.com>
References: <20230131150548.1614458-1-imre.deak@intel.com>
         <20230131150548.1614458-3-imre.deak@intel.com>
         <ed8b73096a576f317979c3dd65392371d5b77612.camel@redhat.com>
         <Y9p/ZqVVpW/YMdUy@ideak-desk.fi.intel.com>
         <c74b71b1d998ce6b062405508354dd1943aafa38.camel@redhat.com>
         <Y+I/wcEExBEbAV4L@ideak-desk.fi.intel.com>
         <045569b5595e77d169bb91c101df7544fb94bf0b.camel@redhat.com>
         <Y+NSHI9QgcLGe2c1@ideak-desk.fi.intel.com>
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

On Wed, 2023-02-08 at 09:41 +0200, Imre Deak wrote:
> On Tue, Feb 07, 2023 at 07:21:48PM -0500, Lyude Paul wrote:
> > On Tue, 2023-02-07 at 14:11 +0200, Imre Deak wrote:
> >=20
> > And then disabled say, payload #1, that immediately after we get the AC=
T that
> > the payload table in hardware would look like this:
> >=20
> > Payload #2: 15 slots, start_slot=3D0
> > Payload #3: 15 slots, start_slot=3D15
>=20
> The above is the actual and expected HW state state yes.
>=20
> > But it sounds like it actually would look like this in the real world?
> >=20
> > Payload #2: 15 slots, start_slot=3D15
> > Payload #3: 15 slots, start_slot=3D30
>=20
> No, the problem currently is not that start_slot of the subsequent
> payloads are not shifted towards the beginning. Rather the atomic state
> doesn't get updated properly, becoming out of sync with the HW. For
> instance in a commit resizing payload #1, in the commit phase
> (intel_atomic_commit_tail()) will begin by removing payload #1. The
> initial state is
>=20
>             old payload state         new payload state
> Payload #1: 15 slots, start_slot=3D0    20 slots, start_slot=3D0
> Payload #2: 15 slots, start_slot=3D15   15 slots, start_slot=3D15
> Payload #3: 15 slots, start_slot=3D30   15 slots, start_slot=3D30
>=20
> mgr->next_start_slot =3D 45
>=20
> intel_mst_disable_dp() will pass the old MST and payload state to
> drm_dp_remove_payload(): The MST state was added during atomic check,
> since payload #1 changed, then intel_atomic_commit() ->
> drm_atomic_helper_swap_state() sets the MST current state (returned by
> drm_atomic_get_mst_topology_state()) to point to the old state. So at

OK - this took me a while to wrap my head around but you're completely righ=
t.
It appears I totally misunderstood where the state swapping actually happen=
s
during the check -> commit sequence. I think if that's how things work too
then yeah, it definitely might not be a bad idea to move the start slot out=
 of
the atomic state :P. I guess we could just keep this in the mst manager str=
uct
instead of the commit state and make the rules for access be the same: prot=
ect
them through commit ordering, and document that the proper way of accessing
start values outside of the context of an atomic commit (if this was needed
for some reason) is:

* grab mst lock
* call drm_dp_mst_atomic_wait_for_dependencies()
* read values under lock

Thank y'all again so much for helping out with this! It is super appreciate=
d,
and once you guys push these patches upstream I will look into adopting thi=
s
for nouveau. I already poked some folks from AMD as well to make sure they'=
re
keeping an eye on this (although looking at the Cc I realize they were alre=
ady
added a while ago, whoops lol).=20

> the point drm_dp_remove_payload() returns we have:
>=20
>             old payload state         new payload state
> Payload #1: 15 slots, start_slot=3D-1   20 slots, start_slot=3D0
> Payload #2: 15 slots, start_slot=3D0    15 slots, start_slot=3D15
> Payload #3: 15 slots, start_slot=3D15   15 slots, start_slot=3D30
>=20
> mgr->next_start_slot =3D 30
>=20
> then after re-enabling payload #1, after drm_dp_add_payload_part1()
> returns (passing to it the new MST and payload state) we have:
>=20
>             old payload state         new payload state
> Payload #1: 15 slots, start_slot=3D-1   20 slots, start_slot=3D30
> Payload #2: 15 slots, start_slot=3D0    15 slots, start_slot=3D15
> Payload #3: 15 slots, start_slot=3D15   15 slots, start_slot=3D30
>=20
> mgr->next_start_slot =3D 50
>=20
> So in the new SW state payload #1 and #3 incorrectly overlap, with the
> actual HW state being:
>=20
> Payload #1: 20 slots, start_slot=3D30
> Payload #2: 15 slots, start_slot=3D0
> Payload #3: 15 slots, start_slot=3D15
>=20
> A subsequent commit will see the wrong start_slot in the SW state for
> payload #2 (15) and #3 (30).
>=20
> > So I'm curious, is there something I missed here? At what point does th=
e MST
> > hub at the other end decide that it's time to move the start slots back=
?
>=20
> The hub shifts back payloads after the DPCD write command to 0x1c0 -
> 0x1c2 to remove a payload. (The HW OTOH does the corresponding shift at
> the point of disabling the stream, in intel_mst_post_disable_dp() ->
> intel_disable_transcoder() for i915).
>=20
> > (keep in mind, the MST specification does explicitly mention that
> > there should never be holes in the payload table - so something has to
> > be shifting the payloads back).
>=20
> Right, the hubs I checked conform to this.

>=20
> > > > So if you guys think it'd be better design-wise to store this somet=
hing else,
> > > > I've got no strong feelings either way
> > > > >=20
> > > > > > For 0-2:
> > > > > >=20
> > > > > > Reviewed-by: Lyude Paul <lyude@redhat.com>
> > > > >=20
> > > > > Thanks.
> > > > >=20
> > > > > >=20
> > > > > > >=20
> > > > > > > Cc: Lyude Paul <lyude@redhat.com>
> > > > > > > Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > > > > > > Cc: Ben Skeggs <bskeggs@redhat.com>
> > > > > > > Cc: Karol Herbst <kherbst@redhat.com>
> > > > > > > Cc: Harry Wentland <harry.wentland@amd.com>
> > > > > > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > > > > > Cc: Wayne Lin <Wayne.Lin@amd.com>
> > > > > > > Cc: stable@vger.kernel.org # 6.1
> > > > > > > Cc: dri-devel@lists.freedesktop.org
> > > > > > > Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.int=
el.com>
> > > > > > > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > > > > > > ---
> > > > > > >  .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c |  2 +-
> > > > > > >  drivers/gpu/drm/display/drm_dp_mst_topology.c | 26 +++++++++=
+---------
> > > > > > >  drivers/gpu/drm/i915/display/intel_dp_mst.c   |  4 ++-
> > > > > > >  drivers/gpu/drm/nouveau/dispnv50/disp.c       |  2 +-
> > > > > > >  include/drm/display/drm_dp_mst_helper.h       |  3 ++-
> > > > > > >  5 files changed, 21 insertions(+), 16 deletions(-)
> > > > > > >=20
> > > > > > > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_=
helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > > > > > > index a50319fc42b11..180d3893b68da 100644
> > > > > > > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers=
.c
> > > > > > > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers=
.c
> > > > > > > @@ -208,7 +208,7 @@ bool dm_helpers_dp_mst_write_payload_allo=
cation_table(
> > > > > > >  	if (enable)
> > > > > > >  		drm_dp_add_payload_part1(mst_mgr, mst_state, payload);
> > > > > > >  	else
> > > > > > > -		drm_dp_remove_payload(mst_mgr, mst_state, payload);
> > > > > > > +		drm_dp_remove_payload(mst_mgr, mst_state, payload, payload=
);
> > > > > > > =20
> > > > > > >  	/* mst_mgr->->payloads are VC payload notify MST branch usi=
ng DPCD or
> > > > > > >  	 * AUX message. The sequence is slot 1-63 allocated sequenc=
e for each
> > > > > > > diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/=
drivers/gpu/drm/display/drm_dp_mst_topology.c
> > > > > > > index 847c10aa2098c..1990ff5dc7ddd 100644
> > > > > > > --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > > > > > > +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > > > > > > @@ -3342,7 +3342,8 @@ EXPORT_SYMBOL(drm_dp_add_payload_part1)=
;
> > > > > > >   * drm_dp_remove_payload() - Remove an MST payload
> > > > > > >   * @mgr: Manager to use.
> > > > > > >   * @mst_state: The MST atomic state
> > > > > > > - * @payload: The payload to write
> > > > > > > + * @old_payload: The payload with its old state
> > > > > > > + * @new_payload: The payload to write
> > > > > > >   *
> > > > > > >   * Removes a payload from an MST topology if it was successf=
ully assigned a start slot. Also updates
> > > > > > >   * the starting time slots of all other payloads which would=
 have been shifted towards the start of
> > > > > > > @@ -3350,36 +3351,37 @@ EXPORT_SYMBOL(drm_dp_add_payload_part=
1);
> > > > > > >   */
> > > > > > >  void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *m=
gr,
> > > > > > >  			   struct drm_dp_mst_topology_state *mst_state,
> > > > > > > -			   struct drm_dp_mst_atomic_payload *payload)
> > > > > > > +			   const struct drm_dp_mst_atomic_payload *old_payload,
> > > > > > > +			   struct drm_dp_mst_atomic_payload *new_payload)
> > > > > > >  {
> > > > > > >  	struct drm_dp_mst_atomic_payload *pos;
> > > > > > >  	bool send_remove =3D false;
> > > > > > > =20
> > > > > > >  	/* We failed to make the payload, so nothing to do */
> > > > > > > -	if (payload->vc_start_slot =3D=3D -1)
> > > > > > > +	if (new_payload->vc_start_slot =3D=3D -1)
> > > > > > >  		return;
> > > > > > > =20
> > > > > > >  	mutex_lock(&mgr->lock);
> > > > > > > -	send_remove =3D drm_dp_mst_port_downstream_of_branch(payloa=
d->port, mgr->mst_primary);
> > > > > > > +	send_remove =3D drm_dp_mst_port_downstream_of_branch(new_pa=
yload->port, mgr->mst_primary);
> > > > > > >  	mutex_unlock(&mgr->lock);
> > > > > > > =20
> > > > > > >  	if (send_remove)
> > > > > > > -		drm_dp_destroy_payload_step1(mgr, mst_state, payload);
> > > > > > > +		drm_dp_destroy_payload_step1(mgr, mst_state, new_payload);
> > > > > > >  	else
> > > > > > >  		drm_dbg_kms(mgr->dev, "Payload for VCPI %d not in topology=
, not sending remove\n",
> > > > > > > -			    payload->vcpi);
> > > > > > > +			    new_payload->vcpi);
> > > > > > > =20
> > > > > > >  	list_for_each_entry(pos, &mst_state->payloads, next) {
> > > > > > > -		if (pos !=3D payload && pos->vc_start_slot > payload->vc_s=
tart_slot)
> > > > > > > -			pos->vc_start_slot -=3D payload->time_slots;
> > > > > > > +		if (pos !=3D new_payload && pos->vc_start_slot > new_paylo=
ad->vc_start_slot)
> > > > > > > +			pos->vc_start_slot -=3D old_payload->time_slots;
> > > > > > >  	}
> > > > > > > -	payload->vc_start_slot =3D -1;
> > > > > > > +	new_payload->vc_start_slot =3D -1;
> > > > > > > =20
> > > > > > >  	mgr->payload_count--;
> > > > > > > -	mgr->next_start_slot -=3D payload->time_slots;
> > > > > > > +	mgr->next_start_slot -=3D old_payload->time_slots;
> > > > > > > =20
> > > > > > > -	if (payload->delete)
> > > > > > > -		drm_dp_mst_put_port_malloc(payload->port);
> > > > > > > +	if (new_payload->delete)
> > > > > > > +		drm_dp_mst_put_port_malloc(new_payload->port);
> > > > > > >  }
> > > > > > >  EXPORT_SYMBOL(drm_dp_remove_payload);
> > > > > > > =20
> > > > > > > diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/dr=
ivers/gpu/drm/i915/display/intel_dp_mst.c
> > > > > > > index f3cb12dcfe0a7..dc4e5ff1dbb31 100644
> > > > > > > --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > > > > > > +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > > > > > > @@ -526,6 +526,8 @@ static void intel_mst_disable_dp(struct i=
ntel_atomic_state *state,
> > > > > > >  		to_intel_connector(old_conn_state->connector);
> > > > > > >  	struct drm_dp_mst_topology_state *mst_state =3D
> > > > > > >  		drm_atomic_get_mst_topology_state(&state->base, &intel_dp-=
>mst_mgr);
> > > > > > > +	struct drm_dp_mst_atomic_payload *payload =3D
> > > > > > > +		drm_atomic_get_mst_payload_state(mst_state, connector->por=
t);
> > > > > > >  	struct drm_i915_private *i915 =3D to_i915(connector->base.d=
ev);
> > > > > > > =20
> > > > > > >  	drm_dbg_kms(&i915->drm, "active links %d\n",
> > > > > > > @@ -534,7 +536,7 @@ static void intel_mst_disable_dp(struct i=
ntel_atomic_state *state,
> > > > > > >  	intel_hdcp_disable(intel_mst->connector);
> > > > > > > =20
> > > > > > >  	drm_dp_remove_payload(&intel_dp->mst_mgr, mst_state,
> > > > > > > -			      drm_atomic_get_mst_payload_state(mst_state, connect=
or->port));
> > > > > > > +			      payload, payload);
> > > > > > > =20
> > > > > > >  	intel_audio_codec_disable(encoder, old_crtc_state, old_conn=
_state);
> > > > > > >  }
> > > > > > > diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/driver=
s/gpu/drm/nouveau/dispnv50/disp.c
> > > > > > > index edcb2529b4025..ed9d374147b8d 100644
> > > > > > > --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> > > > > > > +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> > > > > > > @@ -885,7 +885,7 @@ nv50_msto_prepare(struct drm_atomic_state=
 *state,
> > > > > > > =20
> > > > > > >  	// TODO: Figure out if we want to do a better job of handli=
ng VCPI allocation failures here?
> > > > > > >  	if (msto->disabled) {
> > > > > > > -		drm_dp_remove_payload(mgr, mst_state, payload);
> > > > > > > +		drm_dp_remove_payload(mgr, mst_state, payload, payload);
> > > > > > > =20
> > > > > > >  		nvif_outp_dp_mst_vcpi(&mstm->outp->outp, msto->head->base.=
index, 0, 0, 0, 0);
> > > > > > >  	} else {
> > > > > > > diff --git a/include/drm/display/drm_dp_mst_helper.h b/includ=
e/drm/display/drm_dp_mst_helper.h
> > > > > > > index 41fd8352ab656..f5eb9aa152b14 100644
> > > > > > > --- a/include/drm/display/drm_dp_mst_helper.h
> > > > > > > +++ b/include/drm/display/drm_dp_mst_helper.h
> > > > > > > @@ -841,7 +841,8 @@ int drm_dp_add_payload_part2(struct drm_d=
p_mst_topology_mgr *mgr,
> > > > > > >  			     struct drm_dp_mst_atomic_payload *payload);
> > > > > > >  void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *m=
gr,
> > > > > > >  			   struct drm_dp_mst_topology_state *mst_state,
> > > > > > > -			   struct drm_dp_mst_atomic_payload *payload);
> > > > > > > +			   const struct drm_dp_mst_atomic_payload *old_payload,
> > > > > > > +			   struct drm_dp_mst_atomic_payload *new_payload);
> > > > > > > =20
> > > > > > >  int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *=
mgr);
> > > > > > > =20
> > > > > >=20
> > > > > > --=20
> > > > > > Cheers,
> > > > > >  Lyude Paul (she/her)
> > > > > >  Software Engineer at Red Hat
> > > > > >=20
> > > > >=20
> > > >=20
> > > > --=20
> > > > Cheers,
> > > >  Lyude Paul (she/her)
> > > >  Software Engineer at Red Hat
> > > >=20
> > >=20
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

