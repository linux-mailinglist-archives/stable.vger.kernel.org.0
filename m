Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA6C7B2AA
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 20:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbfG3SvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 14:51:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42057 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfG3SvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 14:51:17 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 085DA8022C; Tue, 30 Jul 2019 20:51:02 +0200 (CEST)
Date:   Tue, 30 Jul 2019 20:51:14 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bastien Nocera <hadess@hadess.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 044/113] iio: iio-utils: Fix possible incorrect mask
 calculation
Message-ID: <20190730185114.GA9061@amd>
References: <20190729190655.455345569@linuxfoundation.org>
 <20190729190706.217460325@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20190729190706.217460325@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 208a68c8393d6041a90862992222f3d7943d44d6 ]
>=20
> On some machines, iio-sensor-proxy was returning all 0's for IIO sensor
> values. It turns out that the bits_used for this sensor is 32, which makes
> the mask calculation:
>=20
> *mask =3D (1 << 32) - 1;
>=20
> If the compiler interprets the 1 literals as 32-bit ints, it generates
> undefined behavior depending on compiler version and optimization
> level.

Ok, it would be problem if code was like that. But it is not:

> @@ -159,9 +159,9 @@ int iioutils_get_type(unsigned *is_signed, unsigned *=
bytes, unsigned *bits_used,
>  			*be =3D (endianchar =3D=3D 'b');
>  			*bytes =3D padint / 8;
>  			if (*bits_used =3D=3D 64)
> -				*mask =3D ~0;
> +				*mask =3D ~(0ULL);
>  			else
> -				*mask =3D (1ULL << *bits_used) - 1;
> +				*mask =3D (1ULL << *bits_used) - 1ULL;
> =20

Note 1ULL already being there before the change. AFAICT this does not
change anything; 1ULL << foo will already have long long type, so
substraction will be long long too.

AFAICT this does not change the binary code at all, so it can't fix a
bug...

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1AkaIACgkQMOfwapXb+vIz1wCdFnxRxuvUPqBT4+aAx/xeDgxh
DYAAnibK5SoZyFhiFuV15BOC/Bixqt5L
=P1tq
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
