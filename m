Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3555E6912E3
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 22:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBIV7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 16:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBIV7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 16:59:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D54E65686
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 13:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675979937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vXYIk8oZD/hNuBr0ZdgeM5sLVWe+1NS473W5ypKbHCs=;
        b=Ei00jzVR8972CJahiD2yHQjyUj+DaykMqN5kjuJC76hN6KFz7eRGI9MqlaFB/Mf773iqO2
        BmvAysxGr6Qc+nxTGKmLvw5cp118HWjAN52ULRpiBTgbT/J+Y0J22YO7PO+WGimlftHf0b
        CgNhWDxxQvRWarV0Cxvu7Tiz4i+kEAs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-381-O-hUxCuKNY2IsrtwKWf9sg-1; Thu, 09 Feb 2023 16:58:56 -0500
X-MC-Unique: O-hUxCuKNY2IsrtwKWf9sg-1
Received: by mail-qk1-f199.google.com with SMTP id a6-20020a05620a102600b00729952b4c73so2117096qkk.6
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 13:58:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vXYIk8oZD/hNuBr0ZdgeM5sLVWe+1NS473W5ypKbHCs=;
        b=Sd6LOvJGaEX9Bk3W1vF6EfZDDBCeaI+ufLzZcdTb6+/2XICj4+99w3+en9kUXVCjrg
         p5k92KO8Jlvl+n5rha9Oa5Rb0ibA0A3w9IAL7lPRG9YmSYXruDGZ1dPheKKjipM3uQ76
         doHZCTR7F6ar68oJoFeAci/P/mJtSR49bivtR0FmIVkXlYRRZNaWcyIPcSrg3Nh+IgOf
         StSGK8DSvlombEWS3+oFRCpRPbaF4ML0kIiTry+VLv5+b75zeyk7qzcFNdiIcqKTTmYC
         a6OCWA/4NgwUs9Kx5zxZmhazhLvnBXogMIsJPQ+dtPsLhfFnF48YeT67Urf6N87SmMtv
         65ag==
X-Gm-Message-State: AO0yUKVEP6EofSr7f+GERS1ue9u7hId2rBTrpg8D3fiTlyhKpeOfzGGg
        BJkNvB5prYsyhp+fTikMBqqSnBYgEa+rTDDc5Bje69RxIPQCBvJxJBUOLFrStwrMHR41d//jIQP
        7GLOrdRv4b+CIE7ja
X-Received: by 2002:a05:6214:5013:b0:56b:ed80:6bec with SMTP id jo19-20020a056214501300b0056bed806becmr24159266qvb.20.1675979935792;
        Thu, 09 Feb 2023 13:58:55 -0800 (PST)
X-Google-Smtp-Source: AK7set+GMJqeL5R/Cw8KkWGw/2A6ABhbVBnlRlSuL6pwgE1TsHJROGJi+T47vCS/Y6G9Cr7p4GwYJA==
X-Received: by 2002:a05:6214:5013:b0:56b:ed80:6bec with SMTP id jo19-20020a056214501300b0056bed806becmr24159232qvb.20.1675979935528;
        Thu, 09 Feb 2023 13:58:55 -0800 (PST)
Received: from ?IPv6:2600:4040:5c68:6800:3463:5df7:aced:152e? ([2600:4040:5c68:6800:3463:5df7:aced:152e])
        by smtp.gmail.com with ESMTPSA id b62-20020a378041000000b00726b480880esm2164111qkd.68.2023.02.09.13.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 13:58:55 -0800 (PST)
Message-ID: <0b5a4e81dc98f9c28d77f0f53741712d1c7c3c09.camel@redhat.com>
Subject: [Cc: drm-misc folks] Re: [Intel-gfx] [CI 1/4] drm/i915/dp_mst: Add
 the MST topology state for modesetted CRTCs
From:   Lyude Paul <lyude@redhat.com>
To:     imre.deak@intel.com, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>, Ben Skeggs <bskeggs@redhat.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Karol Herbst <kherbst@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Date:   Thu, 09 Feb 2023 16:58:54 -0500
In-Reply-To: <Y+JLQfuSAS6xLPIS@ideak-desk.fi.intel.com>
References: <20230206114856.2665066-1-imre.deak@intel.com>
         <Y+JLQfuSAS6xLPIS@ideak-desk.fi.intel.com>
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

On Tue, 2023-02-07 at 14:59 +0200, Imre Deak wrote:
> Hi all,
>=20
> On Mon, Feb 06, 2023 at 01:48:53PM +0200, Imre Deak wrote:
> > Add the MST topology for a CRTC to the atomic state if the driver
> > needs to force a modeset on the CRTC after the encoder compute config
> > functions are called.
> >=20
> > Later the MST encoder's disable hook also adds the state, but that isn'=
t
> > guaranteed to work (since in that hook getting the state may fail, whic=
h
> > can't be handled there). This should fix that, while a later patch fixe=
s
> > the use of the MST state in the disable hook.
> >=20
> > v2: Add missing forward struct declartions, caught by hdrtest.
> > v3: Factor out intel_dp_mst_add_topology_state_for_connector() used
> >     later in the patchset.
> >=20
> > Cc: Lyude Paul <lyude@redhat.com>
> > Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > Cc: stable@vger.kernel.org # 6.1
> > Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com> # =
v2
> > Reviewed-by: Lyude Paul <lyude@redhat.com>
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
>=20
> Is it ok to merge these 4 patches (also at [1]), via the i915 tree?
>=20
> If so could it be also acked from the AMD and Nouveau side?

Whichever branch works best for y'all is fine by me, if it's via i915's tre=
e I
guess we might need to back-merge drm-misc at some point so I can write up
equivalent fixes for nouveau as well.

(Added Thomas Zimmermann to Cc)

>=20
> [1] https://patchwork.freedesktop.org/series/113703/
>=20
> > ---
> >  drivers/gpu/drm/i915/display/intel_display.c |  4 ++
> >  drivers/gpu/drm/i915/display/intel_dp_mst.c  | 61 ++++++++++++++++++++
> >  drivers/gpu/drm/i915/display/intel_dp_mst.h  |  4 ++
> >  3 files changed, 69 insertions(+)
> >=20
> > diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu=
/drm/i915/display/intel_display.c
> > index 166662ade593c..38106cf63b3b9 100644
> > --- a/drivers/gpu/drm/i915/display/intel_display.c
> > +++ b/drivers/gpu/drm/i915/display/intel_display.c
> > @@ -5936,6 +5936,10 @@ int intel_modeset_all_pipes(struct intel_atomic_=
state *state,
> >  		if (ret)
> >  			return ret;
> > =20
> > +		ret =3D intel_dp_mst_add_topology_state_for_crtc(state, crtc);
> > +		if (ret)
> > +			return ret;
> > +
> >  		ret =3D intel_atomic_add_affected_planes(state, crtc);
> >  		if (ret)
> >  			return ret;
> > diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/=
drm/i915/display/intel_dp_mst.c
> > index 8b0e4defa3f10..f3cb12dcfe0a7 100644
> > --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > @@ -1223,3 +1223,64 @@ bool intel_dp_mst_is_slave_trans(const struct in=
tel_crtc_state *crtc_state)
> >  	return crtc_state->mst_master_transcoder !=3D INVALID_TRANSCODER &&
> >  	       crtc_state->mst_master_transcoder !=3D crtc_state->cpu_transco=
der;
> >  }
> > +
> > +/**
> > + * intel_dp_mst_add_topology_state_for_connector - add MST topology st=
ate for a connector
> > + * @state: atomic state
> > + * @connector: connector to add the state for
> > + * @crtc: the CRTC @connector is attached to
> > + *
> > + * Add the MST topology state for @connector to @state.
> > + *
> > + * Returns 0 on success, negative error code on failure.
> > + */
> > +static int
> > +intel_dp_mst_add_topology_state_for_connector(struct intel_atomic_stat=
e *state,
> > +					      struct intel_connector *connector,
> > +					      struct intel_crtc *crtc)
> > +{
> > +	struct drm_dp_mst_topology_state *mst_state;
> > +
> > +	if (!connector->mst_port)
> > +		return 0;
> > +
> > +	mst_state =3D drm_atomic_get_mst_topology_state(&state->base,
> > +						      &connector->mst_port->mst_mgr);
> > +	if (IS_ERR(mst_state))
> > +		return PTR_ERR(mst_state);
> > +
> > +	mst_state->pending_crtc_mask |=3D drm_crtc_mask(&crtc->base);
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * intel_dp_mst_add_topology_state_for_crtc - add MST topology state f=
or a CRTC
> > + * @state: atomic state
> > + * @crtc: CRTC to add the state for
> > + *
> > + * Add the MST topology state for @crtc to @state.
> > + *
> > + * Returns 0 on success, negative error code on failure.
> > + */
> > +int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_state=
 *state,
> > +					     struct intel_crtc *crtc)
> > +{
> > +	struct drm_connector *_connector;
> > +	struct drm_connector_state *conn_state;
> > +	int i;
> > +
> > +	for_each_new_connector_in_state(&state->base, _connector, conn_state,=
 i) {
> > +		struct intel_connector *connector =3D to_intel_connector(_connector)=
;
> > +		int ret;
> > +
> > +		if (conn_state->crtc !=3D &crtc->base)
> > +			continue;
> > +
> > +		ret =3D intel_dp_mst_add_topology_state_for_connector(state, connect=
or, crtc);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.h b/drivers/gpu/=
drm/i915/display/intel_dp_mst.h
> > index f7301de6cdfb3..f1815bb722672 100644
> > --- a/drivers/gpu/drm/i915/display/intel_dp_mst.h
> > +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.h
> > @@ -8,6 +8,8 @@
> > =20
> >  #include <linux/types.h>
> > =20
> > +struct intel_atomic_state;
> > +struct intel_crtc;
> >  struct intel_crtc_state;
> >  struct intel_digital_port;
> >  struct intel_dp;
> > @@ -18,5 +20,7 @@ int intel_dp_mst_encoder_active_links(struct intel_di=
gital_port *dig_port);
> >  bool intel_dp_mst_is_master_trans(const struct intel_crtc_state *crtc_=
state);
> >  bool intel_dp_mst_is_slave_trans(const struct intel_crtc_state *crtc_s=
tate);
> >  bool intel_dp_mst_source_support(struct intel_dp *intel_dp);
> > +int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_state=
 *state,
> > +					     struct intel_crtc *crtc);
> > =20
> >  #endif /* __INTEL_DP_MST_H__ */
> > --=20
> > 2.37.1
> >=20
>=20

--=20
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

