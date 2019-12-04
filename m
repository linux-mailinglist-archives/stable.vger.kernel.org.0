Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F78113714
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 22:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbfLDV1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 16:27:39 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:50386 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbfLDV1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 16:27:39 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4DC861C2462; Wed,  4 Dec 2019 22:27:37 +0100 (CET)
Date:   Wed, 4 Dec 2019 22:27:35 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 082/321] ACPI / LPSS: Ignore
 acpi_device_fix_up_power() return value
Message-ID: <20191204212735.GC7678@amd>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223431.423864271@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yLVHuoLXiP9kZBkt"
Content-Disposition: inline
In-Reply-To: <20191203223431.423864271@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yLVHuoLXiP9kZBkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Hans de Goede <hdegoede@redhat.com>
>=20
> [ Upstream commit 1a2fa02f7489dc4d746f2a15fb77b3ce1affade8 ]
>=20
> Ignore acpi_device_fix_up_power() return value. If we return an error
> we end up with acpi_default_enumeration() still creating a platform-
> device for the device and we end up with the device still being used
> but without the special LPSS related handling which is not useful.
>=20
> Specicifically ignoring the error fixes the touchscreen no longer
> working after a suspend/resume on a Prowise PT301 tablet.

I'm pretty sure it does, but:

a) do you believe this is right patch for -stable? Should it get lot
more testing in mainline as it.... may change things in a wrong way
for someone else?

b) if we are ignoring errors now, should we at least printk() to let
the user know that something is wrong with the ACPI tables?

Best regards,
									Pavel

> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index b21c241aaab9f..30ccd94f87d24 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -665,12 +665,7 @@ static int acpi_lpss_create_device(struct acpi_devic=
e *adev,
>  	 * have _PS0 and _PS3 without _PSC (and no power resources), so
>  	 * acpi_bus_init_power() will assume that the BIOS has put them into D0.
>  	 */
> -	ret =3D acpi_device_fix_up_power(adev);
> -	if (ret) {
> -		/* Skip the device, but continue the namespace scan. */
> -		ret =3D 0;
> -		goto err_out;
> -	}
> +	acpi_device_fix_up_power(adev);



>  	adev->driver_data =3D pdata;
>  	pdev =3D acpi_create_platform_device(adev, dev_desc->properties);

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--yLVHuoLXiP9kZBkt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3oJMcACgkQMOfwapXb+vLvRwCfYfl5N1m7vH0ZbIhocJ71Ldne
8hEAoL4rbNE4B+c2f2Nw9ZucvFaidAi+
=/Kkh
-----END PGP SIGNATURE-----

--yLVHuoLXiP9kZBkt--
