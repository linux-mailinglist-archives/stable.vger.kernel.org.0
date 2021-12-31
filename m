Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D88482324
	for <lists+stable@lfdr.de>; Fri, 31 Dec 2021 11:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhLaKEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Dec 2021 05:04:08 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:34178 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhLaKEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Dec 2021 05:04:06 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BEE5C1C0B77; Fri, 31 Dec 2021 11:04:05 +0100 (CET)
Date:   Fri, 31 Dec 2021 11:04:05 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 5.10 48/76] platform/x86: intel_pmc_core: fix memleak on
 registration failure
Message-ID: <20211231100405.GB17525@amd>
References: <20211227151324.694661623@linuxfoundation.org>
 <20211227151326.366957180@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <20211227151326.366957180@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Mon 2021-12-27 16:31:03, Greg Kroah-Hartman wrote:
> From: Johan Hovold <johan@kernel.org>
>=20
> commit 26a8b09437804fabfb1db080d676b96c0de68e7c upstream.
>=20
> In case device registration fails during module initialisation, the
> platform device structure needs to be freed using platform_device_put()
> to properly free all resources (e.g. the device name).
>

Does it? What exactly was leaking here?

> +++ b/drivers/platform/x86/intel_pmc_core_pltdrv.c
> @@ -65,7 +65,7 @@ static int __init pmc_core_platform_init
> =20
>  	retval =3D platform_device_register(pmc_core_device);
>  	if (retval)
> -		kfree(pmc_core_device);
> +		platform_device_put(pmc_core_device);
> =20

This is strange. Failing registration should have no effects that need
to be undone.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmHO1ZUACgkQMOfwapXb+vLN6QCgxMwXeJdYDLJcO8tQvdStj3Ex
e4oAoKn84XFXN8lZl/SuIX3AXFZphpQW
=fQz+
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
