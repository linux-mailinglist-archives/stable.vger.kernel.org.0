Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930F85EA336
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbiIZLVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237478AbiIZLTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:19:37 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7676714B;
        Mon, 26 Sep 2022 03:39:10 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4682D1C09D6; Mon, 26 Sep 2022 12:37:58 +0200 (CEST)
Date:   Mon, 26 Sep 2022 12:38:00 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Melissa Wen <mwen@igalia.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 03/30] drm/vc4: crtc: Use an union to store the page
 flip callback
Message-ID: <20220926103759.GC8978@amd>
References: <20220926100736.153157100@linuxfoundation.org>
 <20220926100736.283415181@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
Content-Disposition: inline
In-Reply-To: <20220926100736.283415181@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TYecfFk8j8mZq+dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Maxime Ripard <maxime@cerno.tech>
>=20
> [ Upstream commit 2523e9dcc3be91bf9fdc0d1e542557ca00bbef42 ]
>=20
> We'll need to extend the vc4_async_flip_state structure to rely on
> another callback implementation, so let's move the current one into a
> union.

AFAICT this is preparation, not a bugfix; and I don't see patch this
prepares for queued. So we should not have this one, either.

Best regards,
								Pavel

> +++ b/drivers/gpu/drm/vc4/vc4_crtc.c
> @@ -717,17 +717,17 @@ struct vc4_async_flip_state {
>  	struct drm_framebuffer *fb;
>  	struct drm_pending_vblank_event *event;
> =20
> -	struct vc4_seqno_cb cb;
> +	union {
> +		struct vc4_seqno_cb seqno;
> +	} cb;
>  };
> =20
>  /* Called when the V3D execution for the BO being flipped to is done, so=
 that
>   * we can actually update the plane's address to point to it.
>   */
>  static void
> -vc4_async_page_flip_complete(struct vc4_seqno_cb *cb)
> +vc4_async_page_flip_complete(struct vc4_async_flip_state *flip_state)
>  {
> -	struct vc4_async_flip_state *flip_state =3D
> -		container_of(cb, struct vc4_async_flip_state, cb);
>  	struct drm_crtc *crtc =3D flip_state->crtc;
>  	struct drm_device *dev =3D crtc->dev;
>  	struct vc4_dev *vc4 =3D to_vc4_dev(dev);
> @@ -749,6 +749,14 @@ vc4_async_page_flip_complete(struct vc4_seqno_cb *cb)
>  	up(&vc4->async_modeset);
>  }
> =20
> +static void vc4_async_page_flip_seqno_complete(struct vc4_seqno_cb *cb)
> +{
> +	struct vc4_async_flip_state *flip_state =3D
> +		container_of(cb, struct vc4_async_flip_state, cb.seqno);
> +
> +	vc4_async_page_flip_complete(flip_state);
> +}
> +
>  /* Implements async (non-vblank-synced) page flips.
>   *
>   * The page flip ioctl needs to return immediately, so we grab the
> @@ -794,8 +802,8 @@ static int vc4_async_page_flip(struct drm_crtc *crtc,
>  	drm_atomic_set_fb_for_plane(plane->state, fb);
>  	plane->fb =3D fb;
> =20
> -	vc4_queue_seqno_cb(dev, &flip_state->cb, bo->seqno,
> -			   vc4_async_page_flip_complete);
> +	vc4_queue_seqno_cb(dev, &flip_state->cb.seqno, bo->seqno,
> +			   vc4_async_page_flip_seqno_complete);
> =20
>  	/* Driver takes ownership of state on successful async commit. */
>  	return 0;

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmMxgQcACgkQMOfwapXb+vLaWACfeUMP842BVLFHjEkQimvCiUxg
cAkAniOhQnP8FWBaXzUN4C7boo2pVCG+
=lMkv
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--
