Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A75F14974D
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 19:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgAYS7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 13:59:38 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:44582 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgAYS7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 13:59:38 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F35CA1C213B; Sat, 25 Jan 2020 19:59:36 +0100 (CET)
Date:   Sat, 25 Jan 2020 19:59:36 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 309/639] hwmon: (w83627hf) Use request_muxed_region
 for Super-IO accesses
Message-ID: <20200125185935.GF14064@duo.ucw.cz>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093125.642179022@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eDB11BtaWSyaBkpc"
Content-Disposition: inline
In-Reply-To: <20200124093125.642179022@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--eDB11BtaWSyaBkpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
> [ Upstream commit e95fd518d05bfc087da6fcdea4900a57cfb083bd ]
>=20
> Super-IO accesses may fail on a system with no or unmapped LPC bus.
>=20
> Also, other drivers may attempt to access the LPC bus at the same time,
> resulting in undefined behavior.
>=20
> Use request_muxed_region() to ensure that IO access on the requested
> address space is supported, and to ensure that access by multiple drivers
> is synchronized.
>=20

> @@ -1644,9 +1654,21 @@ static int w83627thf_read_gpio5(struct platform_de=
vice *pdev)
>  	struct w83627hf_sio_data *sio_data =3D dev_get_platdata(&pdev->dev);
>  	int res =3D 0xff, sel;
> =20
> -	superio_enter(sio_data);
> +	if (superio_enter(sio_data)) {
> +		/*
> +		 * Some other driver reserved the address space for itself.
> +		 * We don't want to fail driver instantiation because of that,
> +		 * so display a warning and keep going.
> +		 */
> +		dev_warn(&pdev->dev,
> +			 "Can not read VID data: Failed to enable SuperIO access\n");
> +		return res;
> +	}
> +
>  	superio_select(sio_data, W83627HF_LD_GPIO5);
> =20
> +	res =3D 0xff;
> +

This is strange. res is not actually assigned in the code above, so we
have res =3D 0xff twice. Can we remove one of the initializations and do
'return 0xff' directly to make code more clear?


> @@ -1677,7 +1699,17 @@ static int w83687thf_read_vid(struct platform_devi=
ce *pdev)
>  	struct w83627hf_sio_data *sio_data =3D dev_get_platdata(&pdev->dev);
>  	int res =3D 0xff;
> =20
> -	superio_enter(sio_data);
> +	if (superio_enter(sio_data)) {
> +		/*
> +		 * Some other driver reserved the address space for itself.
> +		 * We don't want to fail driver instantiation because of that,
> +		 * so display a warning and keep going.
> +		 */
> +		dev_warn(&pdev->dev,
> +			 "Can not read VID data: Failed to enable SuperIO access\n");
> +		return res;
> +	}

Direct "return 0xff" would make more sense here, too.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--eDB11BtaWSyaBkpc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXiyQFwAKCRAw5/Bqldv6
8nvzAKC6CLvLaAD0Gk1Ci7ONd1tOIdOZzgCgw5Kh9Iidg+Iq18YwHCXBrzydIiw=
=kkYO
-----END PGP SIGNATURE-----

--eDB11BtaWSyaBkpc--
