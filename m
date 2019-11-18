Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E4F1006AC
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 14:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfKRNlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 08:41:23 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41963 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfKRNlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 08:41:23 -0500
Received: by mail-wr1-f65.google.com with SMTP id b18so18091337wrj.8;
        Mon, 18 Nov 2019 05:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z0aQEuEWVYOY25OSopDEM1+jRYUvN106q0DaUIl2CRg=;
        b=IFIqSmKsJr6OEKPfMfZ1NhGTMjOfVnC+NdpQHTUXEyIpsXZTWZ66A4pCcEdnKQB8Wq
         6HhKNVxxOoAzfJOVNM3tsERwPbWBcyrS+63jiCDmjmT7TAXszQQTOa553i2VyT+RP77U
         WMf/M5u4MTVr9eptIwvF/tsFfu+Z561P9GpcpcFJtvydNQkB7rYpkfiH88QOu7JHmftj
         BYGNPMsj4pkGOQuGhFemDbO2CNE8UQoTE9PmxefH0QwG0gYtOLu7S7AkObkEYj7VYmt7
         zLFwkVUwaxqsiRG2VpQIcCZeDIrFhCnBaRzIEkUeHt5bTo3oKQPspZNewvqlg+Nwr+nc
         TrKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z0aQEuEWVYOY25OSopDEM1+jRYUvN106q0DaUIl2CRg=;
        b=Ra7DV883jeTE0X1nGyGpgvYM6Y6OYxpGHOzOyiHqxh0eY33w0aarZZah5C6hNHg4Ek
         HWM9b0hFQimzUsXFB5rN7vonkJuNb5hk2V7E7kiwcKw5cH1QkGQBicVwi9PJ7hXtIBjo
         DVvvXfMr5018f+arHWP6eLRkLc4i4hacYUEqaihzs1QLA0fW+dra1ZjdkB4RgJnHdhk1
         pdbM2BNN0uOL2dg3bBPT6uL1XWhNk+75Delj8z6QfJ6dYI1d3Vy7Hpl9SS4sAl/Ifjmk
         EQUy9U3Y48mtflG4szMbl1R+V/fq85rrDix/r6Ot974aHqYm6hUrzbw/gLrlYpvOILVi
         HfGA==
X-Gm-Message-State: APjAAAWptWVYZB3QiffVqDMPjXxGjnUyn8pGmGub0sGMq8yyDIrJjrvI
        FS+WOap7Tya/KkAE4w4Mu2c=
X-Google-Smtp-Source: APXvYqyXftHW1UyaiLvRvoUnRPTSuoR2Dwb8ij9MJp3oXQ9lGytqOe7Gw+ISCkBiqnQpUf8HVqmySg==
X-Received: by 2002:adf:ef51:: with SMTP id c17mr16909570wrp.266.1574084480349;
        Mon, 18 Nov 2019 05:41:20 -0800 (PST)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id k125sm21825959wmf.2.2019.11.18.05.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:41:18 -0800 (PST)
Date:   Mon, 18 Nov 2019 14:41:17 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     nouveau@lists.freedesktop.org, Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jerry Zuo <Jerry.Zuo@amd.com>,
        Sean Paul <seanpaul@chromium.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@redhat.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Juston Li <juston.li@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [Nouveau] [PATCH 1/3] drm/nouveau/kms/nv50-: Call
 outp_atomic_check_view() before handling PBN
Message-ID: <20191118134117.GF2246533@ulmo>
References: <20191115210728.3467-1-lyude@redhat.com>
 <20191115210728.3467-2-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lIrNkN/7tmsD/ALM"
Content-Disposition: inline
In-Reply-To: <20191115210728.3467-2-lyude@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lIrNkN/7tmsD/ALM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2019 at 04:07:18PM -0500, Lyude Paul wrote:
> Since nv50_outp_atomic_check_view() can set crtc_state->mode_changed, we
> probably should be calling it before handling any PBN changes. Just a
> precaution.
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
>  drivers/gpu/drm/nouveau/dispnv50/disp.c | 44 ++++++++++++++-----------
>  1 file changed, 24 insertions(+), 20 deletions(-)

Looks reasonable:

Reviewed-by: Thierry Reding <treding@nvidia.com>

> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/no=
uveau/dispnv50/disp.c
> index 549486f1d937..6327aaf37c08 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -770,32 +770,36 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
>  	struct nv50_mstm *mstm =3D mstc->mstm;
>  	struct nv50_head_atom *asyh =3D nv50_head_atom(crtc_state);
>  	int slots;
> +	int ret;
> =20
> -	if (crtc_state->mode_changed || crtc_state->connectors_changed) {
> -		/*
> -		 * When restoring duplicated states, we need to make sure that
> -		 * the bw remains the same and avoid recalculating it, as the
> -		 * connector's bpc may have changed after the state was
> -		 * duplicated
> -		 */
> -		if (!state->duplicated) {
> -			const int bpp =3D connector->display_info.bpc * 3;
> -			const int clock =3D crtc_state->adjusted_mode.clock;
> +	ret =3D nv50_outp_atomic_check_view(encoder, crtc_state, conn_state,
> +					  mstc->native);
> +	if (ret)
> +		return ret;
> =20
> -			asyh->dp.pbn =3D drm_dp_calc_pbn_mode(clock, bpp);
> -		}
> +	if (!crtc_state->mode_changed && !crtc_state->connectors_changed)
> +		return 0;
> =20
> -		slots =3D drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr,
> -						      mstc->port,
> -						      asyh->dp.pbn);
> -		if (slots < 0)
> -			return slots;
> +	/*
> +	 * When restoring duplicated states, we need to make sure that the bw
> +	 * remains the same and avoid recalculating it, as the connector's bpc
> +	 * may have changed after the state was duplicated
> +	 */
> +	if (!state->duplicated) {
> +		const int bpp =3D connector->display_info.bpc * 3;
> +		const int clock =3D crtc_state->adjusted_mode.clock;
> =20
> -		asyh->dp.tu =3D slots;
> +		asyh->dp.pbn =3D drm_dp_calc_pbn_mode(clock, bpp);
>  	}
> =20
> -	return nv50_outp_atomic_check_view(encoder, crtc_state, conn_state,
> -					   mstc->native);
> +	slots =3D drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr, mstc->port,
> +					      asyh->dp.pbn);
> +	if (slots < 0)
> +		return slots;
> +
> +	asyh->dp.tu =3D slots;
> +
> +	return 0;
>  }
> =20
>  static void
> --=20
> 2.21.0
>=20
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/nouveau

--lIrNkN/7tmsD/ALM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl3Sn30ACgkQ3SOs138+
s6EyzQ/+IArAf9hKT/2e6Mlc2DorOY+nMESy0hRnHy+ojoq/Wm8ZjvaoPjFW9fIv
Z7x5IdYTFMGyaac16UK+fQUE39VklexlzkIuGWUlIAsQ1QJG3/XGDNdKOvBoMeqD
DTsN6xI1UseWWk6NI06e/3IhdqqqT6bYMPXebxhObxgehgtAnwEoH4mFRB0ciWE1
Nh1anXSWdDaSG4ZdxY5RXOkGO4Nn6k3P7dEXZupjVqNon3sk/2aMPO26MKVEPpdB
cQT6Div3Jo1nzDUMdl8suZqGpsVz6vfcRZ3rixBXIPXdPozXLMpcmx5qtTj2EJnZ
xuhSZBQrj4yBhBQ2m6gUnS0t2kw3/r6yWUKr0vNzMpjTMa9d7Wy0bHPatPFQej6o
z9sueVwgTQ1At0vu3kyVxxSR/OKScAkwtZfAgpKCJfQr+JrInLt7+1rAMhB/qYtF
EIHCoxEja/K9DGLPECxIwmHAiEGAvC7dbnM4+tKYPc3z9z/mhTjZ80P33SHIz6dj
31TGEoDSmfFmseFCg7SCbsSnOMkH+V3kANq3WGn5jVneRp/tTOo2Ha13wtwH6Ymh
vW2Y6iMu1l1vrChmZVtGlAianrGUPuOskhyxHsukETqFQ42fYqYdffdg87P9rnWV
C+i2ZDFyahifVws7JFAGwXAzvCkdBLXdXSwOdpCvn3Uq0z77DnU=
=Ojn4
-----END PGP SIGNATURE-----

--lIrNkN/7tmsD/ALM--
