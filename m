Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCDCF3B767
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388996AbfFJObt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:31:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34082 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390812AbfFJObt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 10:31:49 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 05B5980246; Mon, 10 Jun 2019 16:31:36 +0200 (CEST)
Date:   Mon, 10 Jun 2019 16:31:46 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Amber Lin <Amber.Lin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 4.19 46/51] drm/amdgpu/soc15: skip reset on init
Message-ID: <20190610143146.GA19565@amd>
References: <20190609164127.123076536@linuxfoundation.org>
 <20190609164130.489004849@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20190609164130.489004849@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Alex Deucher <alexander.deucher@amd.com>
>=20
> commit 5887a59961e2295c5b02f39dbc0ecf9212709b7b upstream.
>=20
> Not necessary on soc15 and breaks driver reload on server cards.

> --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
> +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
> @@ -495,6 +495,11 @@ int soc15_set_ip_blocks(struct amdgpu_de
>  		return -EINVAL;
>  	}
> =20
> +	/* Just return false for soc15 GPUs.  Reset does not seem to
> +	 * be necessary.
> +	 */
> +	return false;
> +
>  	if (adev->flags & AMD_IS_APU)
>  		adev->nbio_funcs =3D &nbio_v7_0_funcs;
>  	else if (adev->asic_type =3D=3D CHIP_VEGA20)

Something is seriously wrong here.

Upstream commit goes to soc15_need_reset_on_init() and creates dead
variable and quite a bit of dead code. Is that intended?

But this stable version... goes to different function, and returns
false in function returning 0/-EINVAL, simulating success. New place
does not seem right; it seems like patch misplaced it.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlz+adIACgkQMOfwapXb+vL9zwCfaWXb1BH3290hErTcBaxxREGa
PqYAoJKCnzhWw6Kgy9stTLjBCzrCkVBS
=ZlxE
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
