Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B692D8236
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 23:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406981AbgLKWhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 17:37:39 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42288 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436812AbgLKWg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 17:36:59 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 408C11C0BC2; Fri, 11 Dec 2020 23:35:57 +0100 (CET)
Date:   Fri, 11 Dec 2020 23:35:56 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        Luo Meng <luomeng12@huawei.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 4.19 37/39] Input: i8042 - fix error return code in
 i8042_setup_aux()
Message-ID: <20201211223556.GA18452@amd>
References: <20201210142602.272595094@linuxfoundation.org>
 <20201210142604.116728762@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20201210142604.116728762@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Luo Meng <luomeng12@huawei.com>
>=20
> commit 855b69857830f8d918d715014f05e59a3f7491a0 upstream.
>=20
> Fix to return a negative error code from the error handling case
> instead of 0 in function i8042_setup_aux(), as done elsewhere in this
> function.
>=20
> Fixes: f81134163fc7 ("Input: i8042 - use platform_driver_probe")

I'd recommend not taking this. It is not known to fix
end-user-visible-bug, i8042 is normally quite fragile, and the patch
is less then month old so did not get adequate testing.

Yes, code looks cleaner after the fix. With i8042, that does not mean
much.

Best regards,
								Pavel


> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -1472,7 +1472,8 @@ static int __init i8042_setup_aux(void)
>  	if (error)
>  		goto err_free_ports;
> =20
> -	if (aux_enable())
> +	error =3D aux_enable();
> +	if (error)
>  		goto err_free_irq;
> =20
>  	i8042_aux_irq_registered =3D true;
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/T9EwACgkQMOfwapXb+vIOrgCgkleQhHVlJ1+qKo3j36KSD2wp
LVoAn3a8CM3snysTQMMiT45RcjNmKw7J
=tIwr
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
