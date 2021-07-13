Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEAA3C78FD
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 23:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhGMVeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 17:34:20 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55140 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhGMVeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 17:34:20 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A1E821C0B7A; Tue, 13 Jul 2021 23:31:28 +0200 (CEST)
Date:   Tue, 13 Jul 2021 23:31:28 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        frank zago <frank@zago.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 5.10 073/593] iio: light: tcs3472: do not free
 unallocated IRQ
Message-ID: <20210713213128.GA23770@amd>
References: <20210712060843.180606720@linuxfoundation.org>
 <20210712060851.173417192@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20210712060851.173417192@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 7cd04c863f9e1655d607705455e7714f24451984 upstream.
>=20
> Allocating an IRQ is conditional to the IRQ existence, but freeing it
> was not. If no IRQ was allocate, the driver would still try to free
> IRQ 0. Add the missing checks.
>=20
> This fixes the following trace when the driver is removed:
>=20
> [  100.667788] Trying to free already-free IRQ 0

AFAICT this will need more fixing, because IRQ =3D=3D 0 is a valid
IRQ. NO_IRQ (aka -1) should be safe to use for "no irq assigned".

Best regards,
								Pavel

> +++ b/drivers/iio/light/tcs3472.c
> @@ -531,7 +531,8 @@ static int tcs3472_probe(struct i2c_clie
>  	return 0;
> =20
>  free_irq:
> -	free_irq(client->irq, indio_dev);
> +	if (client->irq)
> +		free_irq(client->irq, indio_dev);
>  buffer_cleanup:
>  	iio_triggered_buffer_cleanup(indio_dev);
>  	return ret;

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDuBi8ACgkQMOfwapXb+vJSWQCgpLkJMsg1wPPNX2WYjSFsH/GB
In0Anj0BCzoFsL0FsXrXnVzAh23MYWrQ
=q8U2
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
