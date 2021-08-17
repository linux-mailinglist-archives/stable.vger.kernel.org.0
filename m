Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A095B3EF129
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 19:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbhHQR5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 13:57:06 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:40932 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbhHQR5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 13:57:05 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 98F751C0B77; Tue, 17 Aug 2021 19:56:30 +0200 (CEST)
Date:   Tue, 17 Aug 2021 19:56:30 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@mind.be>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 51/96] net: dsa: microchip: Fix ksz_read64()
Message-ID: <20210817175630.GB30136@amd>
References: <20210816125434.948010115@linuxfoundation.org>
 <20210816125436.659359567@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <20210816125436.659359567@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit c34f674c8875235725c3ef86147a627f165d23b4 ]
>=20
> ksz_read64() currently does some dubious byte-swapping on the two
> halves of a 64-bit register, and then only returns the high bits.
> Replace this with a straightforward expression.

The code indeed is very strange, but there are just 2 users, and they
will now receive byteswapped values, right? If it worked before, it
will be broken.

Did this get enough testing for -stable?

Is hw little endian or high endian or...? Note that ksz_write64()
still contains the strange code, at least in 5.10.

Best regards,
							Pavel
						=09
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -210,12 +210,8 @@ static inline int ksz_read64(struct ksz_device *dev,=
 u32 reg, u64 *val)
>  	int ret;
> =20
>  	ret =3D regmap_bulk_read(dev->regmap[2], reg, value, 2);
> -	if (!ret) {
> -		/* Ick! ToDo: Add 64bit R/W to regmap on 32bit systems */
> -		value[0] =3D swab32(value[0]);
> -		value[1] =3D swab32(value[1]);
> -		*val =3D swab64((u64)*value);
> -	}
> +	if (!ret)
> +		*val =3D (u64)value[0] << 32 | value[1];
> =20
>  	return ret;
>  }

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEb+E4ACgkQMOfwapXb+vLY1ACfbgtvVkwqEAvCZ5IufHIfjZnT
MOIAoKD98CkSOrEZhxLyb9svnfFtVRup
=mXk/
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
