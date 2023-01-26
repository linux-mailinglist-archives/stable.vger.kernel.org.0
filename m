Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BDE67D66E
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 21:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjAZUao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 15:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjAZUan (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 15:30:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95EA4B8AE
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 12:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674764999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=byAmqBKql90Eqj1B9LX0em0qmfqjPBR2a/BeudYh0iM=;
        b=XnHpIEysA8/O0MpKkQw5Axt6FVfVXyBKC7thC8sjrs5Ve7ASSbDQPieN7tPliGYQMXFLOv
        IvQPziqhLvvL4gfYxf5E96nhwviG5zNQbj1wkBg3f42fc465USGPfbI20rzM/qOuHcx8fl
        5+4bRoN7ijfrcrJ77mxMcj2fBwj6FEY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-518-3PCDOClWO4yfEZCWsC99OA-1; Thu, 26 Jan 2023 15:29:57 -0500
X-MC-Unique: 3PCDOClWO4yfEZCWsC99OA-1
Received: by mail-qv1-f69.google.com with SMTP id r10-20020ad4522a000000b004d28fcbfe17so1686675qvq.4
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 12:29:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=byAmqBKql90Eqj1B9LX0em0qmfqjPBR2a/BeudYh0iM=;
        b=Jf55ajPgT2cPpor+QVKV9KQErbo04WCCiBkD50YUJ8yA8eSceNP3jhvRpNQGOvn8nE
         FOwpd6Tpt5ZuIbZzMcR7s90vMUp5QLRNdKmsOPtgewDsQaEJqMVNJIaWyVRnPk27uEmd
         d9llT7j2zuR+gMn4pFVWyAPRiag+kiobYnlCXhqqdUfqNp2yevUwiywRPQ2y2n3AC6db
         gupRd27CSKEaMiFRmbCW96gItVvyVzYwVbbHoffUzRwgnRaPpp4j+3KUZPvyHg7IV+2D
         hBazAyWXkn3xaSljV8CQeFUAKJFiXfNUHHCEUdHs0NJexfXpvtNSsDWrdBYMc+SIGUBk
         2SDA==
X-Gm-Message-State: AFqh2koz5zxsLeEMLgvofjHI17XOyAlhczjjDnrk8BX044FcJrbPH2QG
        kjLvoxCnEAh5Ocq0l5bnd+U4AwzPCPFi7iVmoTpuWr7xnjWoY/4KKYxkpI12A94nvFS2b2fwL92
        PxW4yoVAMmz0j9HcL
X-Received: by 2002:ac8:7602:0:b0:3a9:8c90:dcd6 with SMTP id t2-20020ac87602000000b003a98c90dcd6mr49257232qtq.51.1674764997327;
        Thu, 26 Jan 2023 12:29:57 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsHNl6VGePA09F6lPINX6N6zYEQNSpkAMn6j530HCOs9fTXHwyiEct/7i0IOag9evFq/Mfg4Q==
X-Received: by 2002:ac8:7602:0:b0:3a9:8c90:dcd6 with SMTP id t2-20020ac87602000000b003a98c90dcd6mr49257205qtq.51.1674764997030;
        Thu, 26 Jan 2023 12:29:57 -0800 (PST)
Received: from ?IPv6:2600:4040:5c68:6800::feb? ([2600:4040:5c68:6800::feb])
        by smtp.gmail.com with ESMTPSA id n3-20020a05620a294300b00704df12317esm1569630qkp.24.2023.01.26.12.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 12:29:56 -0800 (PST)
Message-ID: <cf6f73e4a30745a9c1ec4f5b5e10e064de60c7da.camel@redhat.com>
Subject: Re: [PATCH v2 1/9] drm/i915/dp_mst: Add the MST topology state for
 modesetted CRTCs
From:   Lyude Paul <lyude@redhat.com>
To:     Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Date:   Thu, 26 Jan 2023 15:29:55 -0500
In-Reply-To: <20230126091310.1154148-1-imre.deak@intel.com>
References: <20230125114852.748337-2-imre.deak@intel.com>
         <20230126091310.1154148-1-imre.deak@intel.com>
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

Hi! should have a chance to look at this at the start of next week

On Thu, 2023-01-26 at 11:13 +0200, Imre Deak wrote:
> Add the MST topology for a CRTC to the atomic state if the driver
> needs to force a modeset on the CRTC after the encoder compute config
> functions are called.
>=20
> Later the MST encoder's disable hook also adds the state, but that isn't
> guaranteed to work (since in that hook getting the state may fail, which
> can't be handled there). This should fix that, while a later patch fixes
> the use of the MST state in the disable hook.
>=20
> v2: Add missing forward struct declartions, caught by hdrtest.
>=20
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: stable@vger.kernel.org # 6.1
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_display.c |  4 +++
>  drivers/gpu/drm/i915/display/intel_dp_mst.c  | 37 ++++++++++++++++++++
>  drivers/gpu/drm/i915/display/intel_dp_mst.h  |  4 +++
>  3 files changed, 45 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/d=
rm/i915/display/intel_display.c
> index 717ca3d7890d3..d3994e2a7d636 100644
> --- a/drivers/gpu/drm/i915/display/intel_display.c
> +++ b/drivers/gpu/drm/i915/display/intel_display.c
> @@ -5934,6 +5934,10 @@ int intel_modeset_all_pipes(struct intel_atomic_st=
ate *state,
>  		if (ret)
>  			return ret;
> =20
> +		ret =3D intel_dp_mst_add_topology_state_for_crtc(state, crtc);
> +		if (ret)
> +			return ret;
> +
>  		ret =3D intel_atomic_add_affected_planes(state, crtc);
>  		if (ret)
>  			return ret;
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/dr=
m/i915/display/intel_dp_mst.c
> index 8b0e4defa3f10..ba29c294b7c1b 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> @@ -1223,3 +1223,40 @@ bool intel_dp_mst_is_slave_trans(const struct inte=
l_crtc_state *crtc_state)
>  	return crtc_state->mst_master_transcoder !=3D INVALID_TRANSCODER &&
>  	       crtc_state->mst_master_transcoder !=3D crtc_state->cpu_transcode=
r;
>  }
> +
> +/**
> + * intel_dp_mst_add_topology_state_for_crtc - add MST topology state for=
 a CRTC
> + * @state: atomic state
> + * @crtc: CRTC
> + *
> + * Add the MST topology state for @crtc to @state.
> + *
> + * Returns 0 on success, negative error code on failure.
> + */
> +int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_state *=
state,
> +					     struct intel_crtc *crtc)
> +{
> +	struct drm_connector *_connector;
> +	struct drm_connector_state *conn_state;
> +	int i;
> +
> +	for_each_new_connector_in_state(&state->base, _connector, conn_state, i=
) {
> +		struct drm_dp_mst_topology_state *mst_state;
> +		struct intel_connector *connector =3D to_intel_connector(_connector);
> +
> +		if (conn_state->crtc !=3D &crtc->base)
> +			continue;
> +
> +		if (!connector->mst_port)
> +			continue;
> +
> +		mst_state =3D drm_atomic_get_mst_topology_state(&state->base,
> +							      &connector->mst_port->mst_mgr);
> +		if (IS_ERR(mst_state))
> +			return PTR_ERR(mst_state);
> +
> +		mst_state->pending_crtc_mask |=3D drm_crtc_mask(&crtc->base);
> +	}
> +
> +	return 0;
> +}
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.h b/drivers/gpu/dr=
m/i915/display/intel_dp_mst.h
> index f7301de6cdfb3..f1815bb722672 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_mst.h
> +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.h
> @@ -8,6 +8,8 @@
> =20
>  #include <linux/types.h>
> =20
> +struct intel_atomic_state;
> +struct intel_crtc;
>  struct intel_crtc_state;
>  struct intel_digital_port;
>  struct intel_dp;
> @@ -18,5 +20,7 @@ int intel_dp_mst_encoder_active_links(struct intel_digi=
tal_port *dig_port);
>  bool intel_dp_mst_is_master_trans(const struct intel_crtc_state *crtc_st=
ate);
>  bool intel_dp_mst_is_slave_trans(const struct intel_crtc_state *crtc_sta=
te);
>  bool intel_dp_mst_source_support(struct intel_dp *intel_dp);
> +int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_state *=
state,
> +					     struct intel_crtc *crtc);
> =20
>  #endif /* __INTEL_DP_MST_H__ */

--=20
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

