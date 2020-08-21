Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A81B24CF44
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 09:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgHUH1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 03:27:23 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50300 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbgHUH1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 03:27:23 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9404C1C0BE2; Fri, 21 Aug 2020 09:27:18 +0200 (CEST)
Date:   Fri, 21 Aug 2020 09:27:18 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Denis Efremov <efremov@linux.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 4.19 90/92] drm/radeon: fix fb_div check in
 ni_init_smc_spll_table()
Message-ID: <20200821072718.GD23823@amd>
References: <20200820091537.490965042@linuxfoundation.org>
 <20200820091542.324851351@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6WlEvdN9Dv0WHSBl"
Content-Disposition: inline
In-Reply-To: <20200820091542.324851351@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Denis Efremov <efremov@linux.com>
>=20
> commit f29aa08852e1953e461f2d47ab13c34e14bc08b3 upstream.
>=20
> clk_s is checked twice in a row in ni_init_smc_spll_table().
> fb_div should be checked instead.
>=20
> Fixes: 69e0b57a91ad ("drm/radeon/kms: add dpm support for cayman (v5)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

No, this is wrong.

We already have the fix in -stable, as:

commit a083deda0b4179fb6780bc53d900794c4952339f
Author: Denis Efremov <efremov@linux.com>
Date:   Mon Jun 22 23:31:22 2020 +0300

    drm/radeon: fix fb_div check in ni_init_smc_spll_table()

    commit 35f760b44b1b9cb16a306bdcc7220fbbf78c4789 upstream.

Result is that we now convert _second_ copy clk_s check, and check
fb_div twice. This introduces error, rather than fixing one.

Best regards,
								Pavel

> +++ b/drivers/gpu/drm/radeon/ni_dpm.c
> @@ -2123,7 +2123,7 @@ static int ni_init_smc_spll_table(struct
>  		if (p_div & ~(SMC_NISLANDS_SPLL_DIV_TABLE_PDIV_MASK >> SMC_NISLANDS_SP=
LL_DIV_TABLE_PDIV_SHIFT))
>  			ret =3D -EINVAL;
> =20
> -		if (clk_s & ~(SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_MASK >> SMC_NISLANDS_SP=
LL_DIV_TABLE_CLKS_SHIFT))
> +		if (fb_div & ~(SMC_NISLANDS_SPLL_DIV_TABLE_FBDIV_MASK >> SMC_NISLANDS_=
SPLL_DIV_TABLE_FBDIV_SHIFT))
>  			ret =3D -EINVAL;
> =20
>  		if (fb_div & ~(SMC_NISLANDS_SPLL_DIV_TABLE_FBDIV_MASK >> SMC_NISLANDS_=
SPLL_DIV_TABLE_FBDIV_SHIFT))
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--6WlEvdN9Dv0WHSBl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8/d1YACgkQMOfwapXb+vJR7wCfXp94AdeIyd/cGYuRr34ZF/Ao
7yUAn1m1fTd3YyI88ZpKhBsppm3xUnoA
=AfIV
-----END PGP SIGNATURE-----

--6WlEvdN9Dv0WHSBl--
