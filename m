Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313A810068D
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 14:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfKRNfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 08:35:14 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46834 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbfKRNfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 08:35:14 -0500
Received: by mail-wr1-f66.google.com with SMTP id b3so19495567wrs.13;
        Mon, 18 Nov 2019 05:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zaeZ/eGEzVvRBbdY039Qp5QEt+gZ5N+85ekhGbyVhdQ=;
        b=nNzc+oTxT3pXHGkbncXbzyCrKjzML/vbKhmmfP8w8NDzcCoqu3TT05Ugd7vnmhKfUD
         uiR2yLedRezV6VKr7b/75CQtabKx7pSb7CG/MfrCdKiDgqSTOOezuqvDv1rDoGFkuFAh
         yzpdm/PnL0Wc3uHmtbjXci1zWI5a4ehsEl/qYuctnR6t0vXgxcW9bIhKG/bwuv0FTbnd
         llhZZlZez6SLsy4VAT8CIZEMovkQQNjDBcTIrTSelA2j2dHxZ/Svd43ShIrop0mpjXNH
         l933ZiKBhza/MKVj5elKXrrl6D/M/tE1N1kcohNU4L7cKc6isKbEJUGmNdtTP/MHc/vx
         9N1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zaeZ/eGEzVvRBbdY039Qp5QEt+gZ5N+85ekhGbyVhdQ=;
        b=J146tSk7nfGd6c/uRjulCk4oHd/BypzOHB35+WUk1T+XkrrDecuvinZouwSCL0lwfE
         +XbPXHtoehK+H8mSchvNog0KOz2SFxAf+CCcsMp96Ojreno4qQP8EKdPXtw8TsZA3oV8
         i/ZK1oPZDdvXILLaqOjU1SZ55EkkQFhDeCDKbj35XVrsVQ88NGWWAKkSG4MKw5m3QdZn
         g2eztjwYkIkUHa08NZuJg4aOPIUy0MXVftSKYUyXFmR5L/2CHYX1Pbjy5gQXgdOw4J64
         e4ER0QMUgqweNToHZtXv46hjiEjaTKlJe8OYOyl/kRwfTs+pvraXeCkSlKx3pPWSpAuo
         KccQ==
X-Gm-Message-State: APjAAAULDVGyhPH9vveLlTIfzy6bQtqO39hVlwreimYlYzEsQSq4qAb4
        wHuLf/B9NiLgcgK+AiWhWVk=
X-Google-Smtp-Source: APXvYqxTpgPSyxcUwmHVTG1P4H61C+kHatKaZ5j+LgFqsYFz5qSfbj20uyq+wHICSctqK6wmPFjT4w==
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr32477202wrr.279.1574084110606;
        Mon, 18 Nov 2019 05:35:10 -0800 (PST)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id w19sm19984313wmk.36.2019.11.18.05.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:35:08 -0800 (PST)
Date:   Mon, 18 Nov 2019 14:35:07 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     nouveau@lists.freedesktop.org, Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jerry Zuo <Jerry.Zuo@amd.com>,
        Sean Paul <seanpaul@chromium.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Peteris Rudzusiks <peteris.rudzusiks@gmail.com>,
        David Airlie <airlied@redhat.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Juston Li <juston.li@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [Nouveau] [PATCH 2/3] drm/nouveau/kms/nv50-: Store the bpc we're
 using in nv50_head_atom
Message-ID: <20191118133507.GD2246533@ulmo>
References: <20191115210728.3467-1-lyude@redhat.com>
 <20191115210728.3467-3-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Content-Disposition: inline
In-Reply-To: <20191115210728.3467-3-lyude@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2019 at 04:07:19PM -0500, Lyude Paul wrote:
> In order to be able to use bpc values that are different from what the
> connector reports, we want to be able to store the bpc value we decide
> on using for an atomic state in nv50_head_atom and refer to that instead
> of simply using the value that the connector reports throughout the
> whole atomic check phase and commit phase. This will let us (eventually)
> implement the max bpc connector property, and will also be needed for
> limiting the bpc we use on MST displays to 8 in the next commit.
>=20
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 232c9eec417a ("drm/nouveau: Use atomic VCPI helpers for MST")
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: David Airlie <airlied@redhat.com>
> Cc: Jerry Zuo <Jerry.Zuo@amd.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Juston Li <juston.li@intel.com>
> Cc: Sean Paul <seanpaul@chromium.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: <stable@vger.kernel.org> # v5.1+
> ---
>  drivers/gpu/drm/nouveau/dispnv50/atom.h |  1 +
>  drivers/gpu/drm/nouveau/dispnv50/disp.c | 57 ++++++++++++++-----------
>  drivers/gpu/drm/nouveau/dispnv50/head.c |  5 +--
>  3 files changed, 36 insertions(+), 27 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/atom.h b/drivers/gpu/drm/no=
uveau/dispnv50/atom.h
> index 43df86c38f58..24f7700768da 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/atom.h
> +++ b/drivers/gpu/drm/nouveau/dispnv50/atom.h
> @@ -114,6 +114,7 @@ struct nv50_head_atom {
>  		u8 nhsync:1;
>  		u8 nvsync:1;
>  		u8 depth:4;
> +		u8 bpc;
>  	} or;
> =20
>  	/* Currently only used for MST */
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/no=
uveau/dispnv50/disp.c
> index 6327aaf37c08..93665aecce57 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -353,10 +353,20 @@ nv50_outp_atomic_check(struct drm_encoder *encoder,
>  		       struct drm_crtc_state *crtc_state,
>  		       struct drm_connector_state *conn_state)
>  {
> -	struct nouveau_connector *nv_connector =3D
> -		nouveau_connector(conn_state->connector);
> -	return nv50_outp_atomic_check_view(encoder, crtc_state, conn_state,
> -					   nv_connector->native_mode);
> +	struct drm_connector *connector =3D conn_state->connector;
> +	struct nouveau_connector *nv_connector =3D nouveau_connector(connector);
> +	struct nv50_head_atom *asyh =3D nv50_head_atom(crtc_state);
> +	int ret;
> +
> +	ret =3D nv50_outp_atomic_check_view(encoder, crtc_state, conn_state,
> +					  nv_connector->native_mode);
> +	if (ret)
> +		return ret;
> +
> +	if (crtc_state->mode_changed || crtc_state->connectors_changed)
> +		asyh->or.bpc =3D connector->display_info.bpc;
> +
> +	return 0;
>  }
> =20
>  /***********************************************************************=
*******
> @@ -786,10 +796,10 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
>  	 * may have changed after the state was duplicated
>  	 */
>  	if (!state->duplicated) {
> -		const int bpp =3D connector->display_info.bpc * 3;
>  		const int clock =3D crtc_state->adjusted_mode.clock;
> =20
> -		asyh->dp.pbn =3D drm_dp_calc_pbn_mode(clock, bpp);
> +		asyh->or.bpc =3D connector->display_info.bpc;
> +		asyh->dp.pbn =3D drm_dp_calc_pbn_mode(clock, asyh->or.bpc * 3);
>  	}
> =20
>  	slots =3D drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr, mstc->port,
> @@ -802,6 +812,17 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
>  	return 0;
>  }
> =20
> +static u8
> +nv50_dp_bpc_to_depth(unsigned int bpc)
> +{
> +	switch (bpc) {
> +	case  6: return 0x2;
> +	case  8: return 0x5;
> +	case 10: /* fall-through */
> +	default: return 0x6;
> +	}

This is obviously just refactored from the code below, so this is
probably fine for now. But what about BPC > 10? The OR here seems to be
very similar to what's used on Tegra where the same values are used in
the SOR_STATE1 register, see:

	drivers/gpu/drm/tegra/sor.h

There are additional values for 12 and 16 BPC (see the definitions for
SOR_STATE_ASY_PIXELDEPTH_BPP_*). With the above anything higher than 10
BPC will be treated the same and likely lead to wrong results. So I
think either a WARN for the "default" case or additional cases for the
other values would be good to have.

Like I said, if this even is problematic (and given that userspace does
not really support > 8 BPC yet, it probably isn't) it's a preexisting
problem, so can be done in a different patch.

Other than that this looks good, so:

Reviewed-by: Thierry Reding <treding@nvidia.com>

> +}
> +
>  static void
>  nv50_msto_enable(struct drm_encoder *encoder)
>  {
> @@ -812,7 +833,7 @@ nv50_msto_enable(struct drm_encoder *encoder)
>  	struct nv50_mstm *mstm =3D NULL;
>  	struct drm_connector *connector;
>  	struct drm_connector_list_iter conn_iter;
> -	u8 proto, depth;
> +	u8 proto;
>  	bool r;
> =20
>  	drm_connector_list_iter_begin(encoder->dev, &conn_iter);
> @@ -841,14 +862,8 @@ nv50_msto_enable(struct drm_encoder *encoder)
>  	else
>  		proto =3D 0x9;
> =20
> -	switch (mstc->connector.display_info.bpc) {
> -	case  6: depth =3D 0x2; break;
> -	case  8: depth =3D 0x5; break;
> -	case 10:
> -	default: depth =3D 0x6; break;
> -	}
> -
> -	mstm->outp->update(mstm->outp, head->base.index, armh, proto, depth);
> +	mstm->outp->update(mstm->outp, head->base.index, armh, proto,
> +			   nv50_dp_bpc_to_depth(armh->or.bpc));
> =20
>  	msto->head =3D head;
>  	msto->mstc =3D mstc;
> @@ -1502,20 +1517,14 @@ nv50_sor_enable(struct drm_encoder *encoder)
>  					lvds.lvds.script |=3D 0x0200;
>  			}
> =20
> -			if (nv_connector->base.display_info.bpc =3D=3D 8)
> +			if (asyh->or.bpc =3D=3D 8)
>  				lvds.lvds.script |=3D 0x0200;
>  		}
> =20
>  		nvif_mthd(&disp->disp->object, 0, &lvds, sizeof(lvds));
>  		break;
>  	case DCB_OUTPUT_DP:
> -		if (nv_connector->base.display_info.bpc =3D=3D 6)
> -			depth =3D 0x2;
> -		else
> -		if (nv_connector->base.display_info.bpc =3D=3D 8)
> -			depth =3D 0x5;
> -		else
> -			depth =3D 0x6;
> +		depth =3D nv50_dp_bpc_to_depth(asyh->or.bpc);
> =20
>  		if (nv_encoder->link & 1)
>  			proto =3D 0x8;
> @@ -1666,7 +1675,7 @@ nv50_pior_enable(struct drm_encoder *encoder)
>  	nv50_outp_acquire(nv_encoder);
> =20
>  	nv_connector =3D nouveau_encoder_connector_get(nv_encoder);
> -	switch (nv_connector->base.display_info.bpc) {
> +	switch (asyh->or.bpc) {
>  	case 10: asyh->or.depth =3D 0x6; break;
>  	case  8: asyh->or.depth =3D 0x5; break;
>  	case  6: asyh->or.depth =3D 0x2; break;
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.c b/drivers/gpu/drm/no=
uveau/dispnv50/head.c
> index 71c23bf1fe25..c9692df2b76c 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/head.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
> @@ -81,18 +81,17 @@ nv50_head_atomic_check_dither(struct nv50_head_atom *=
armh,
>  			      struct nv50_head_atom *asyh,
>  			      struct nouveau_conn_atom *asyc)
>  {
> -	struct drm_connector *connector =3D asyc->state.connector;
>  	u32 mode =3D 0x00;
> =20
>  	if (asyc->dither.mode =3D=3D DITHERING_MODE_AUTO) {
> -		if (asyh->base.depth > connector->display_info.bpc * 3)
> +		if (asyh->base.depth > asyh->or.bpc * 3)
>  			mode =3D DITHERING_MODE_DYNAMIC2X2;
>  	} else {
>  		mode =3D asyc->dither.mode;
>  	}
> =20
>  	if (asyc->dither.depth =3D=3D DITHERING_DEPTH_AUTO) {
> -		if (connector->display_info.bpc >=3D 8)
> +		if (asyh->or.bpc >=3D 8)
>  			mode |=3D DITHERING_DEPTH_8BPC;
>  	} else {
>  		mode |=3D asyc->dither.depth;
> --=20
> 2.21.0
>=20
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/nouveau

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl3SngkACgkQ3SOs138+
s6FaaQ/+MVx8LDs3/gwa+nLCOUhtbwDunZ+5+stYfJtA62hCK/wdMk9G1B8ugpwO
aoGL0rPcarCb4fXx+85sFNTSgRGq2pU5X2rJVw0J0jHCEKuTONDKO7/Cn1tLCTUA
gW2+cMDSnk2uxk55CGuHTXhm/8b1HS8r2q+AZZc0a8TBquEFIoXNszsxeRudfBeo
zkMwvGxogE3ZSczBK0tgavJ7F3Ha3yw9K9F5L+7V06zD4OYwzOBYIKigrO9wF9gm
5fn17XsPH+qI4rKJDV8mMkE3Ik8bb12TSsRltY+cYSka2S9QP31LOLjPd9QBPpQs
+1DVAP3hFWEHoWi7wrhOY61Mlh9/F4v9O3GDPdSrm1Hey7/9ADBAb77AYdfMmgv5
eLoX3AaAbeetWbPuUT7AhPSFkIElL7MDg9IcDrFeLzdkU2bfgcbN6RKhefJn5MU2
/qy6wsBZ2SqvROPuwTzy5lkVjz0zhW16zSsthP+tJOmP3CTOpeDZP8sc0k2EKPiK
YHcweBdubmu1gWcckquLnW6wrSEZQayveKW5SotU+0YXAptE0escGIblvb+d22WZ
6hNpvIcmDjEIMB/I2oMSSjvekKt8dAJ4dJgwErPUE9hoXj398kwqFBWIPPgBtqsb
DQV9dxOEXSiA0OaYR+I5P0uKeuza3CTyhMEY86z/foAD22o1Wro=
=qa8R
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
