Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615172E72D9
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 18:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgL2R7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 12:59:01 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:60106 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgL2R7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 12:59:01 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 79E721C0B7C; Tue, 29 Dec 2020 18:58:19 +0100 (CET)
Date:   Tue, 29 Dec 2020 18:58:19 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Harry Wentland <harry.wentland@amd.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 099/453] drm/amdgpu: fix build_coefficients() argument
Message-ID: <20201229175819.GA15548@duo.ucw.cz>
References: <20201228124937.240114599@linuxfoundation.org>
 <20201228124941.984955049@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20201228124941.984955049@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Arnd Bergmann <arnd@arndb.de>
>=20
> [ Upstream commit dbb60031dd0c2b85f10ce4c12ae604c28d3aaca4 ]
>=20
> gcc -Wextra warns about a function taking an enum argument
> being called with a bool:
>=20
> drivers/gpu/drm/amd/amdgpu/../display/modules/color/color_gamma.c: In fun=
ction 'apply_degamma_for_user_regamma':
> drivers/gpu/drm/amd/amdgpu/../display/modules/color/color_gamma.c:1617:29=
: warning: implicit conversion from 'enum <anonymous>' to 'enum dc_transfer=
_func_predefined' [-Wenum-conversion]
>  1617 |  build_coefficients(&coeff, true);
>=20
> It appears that a patch was added using the old calling conventions
> after the type was changed, and the value should actually be 0
> (TRANSFER_FUNCTION_SRGB) here instead of 1 (true).

Yeah, but 4.19 still uses bool there, so this actually introduces a
bug.

Please drop.
								Pavel
							=09
> +++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
> @@ -1576,7 +1576,7 @@ static void apply_degamma_for_user_regamma(struct p=
wl_float_data_ex *rgb_regamma
>  	struct pwl_float_data_ex *rgb =3D rgb_regamma;
>  	const struct hw_x_point *coord_x =3D coordinates_x;
> =20
> -	build_coefficients(&coeff, true);
> +	build_coefficients(&coeff, TRANSFER_FUNCTION_SRGB);
> =20
>  	i =3D 0;
>  	while (i !=3D hw_points_num + 1) {
> --=20
> 2.27.0
>=20
>=20

--=20
http://www.livejournal.com/~pavelmachek

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX+tuOwAKCRAw5/Bqldv6
8uulAJwIUoSsl2ZwsrxZA8ubSs7l0Z7JdACgjlh6B59mSECfllRDvBIPP06zPcs=
=Mqgm
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
