Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2E73348A0
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 21:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhCJUFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 15:05:35 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56304 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhCJUFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 15:05:03 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 014941C0B77; Wed, 10 Mar 2021 21:04:58 +0100 (CET)
Date:   Wed, 10 Mar 2021 21:04:58 +0100
From:   Pavel Machek <pavel@denx.de>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Jasper St. Pierre" <jstpierre@mecheye.net>,
        Chris Chiu <chiu@endlessos.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 23/49] ACPI: video: Add DMI quirk for GIGABYTE
 GB-BXBT-2807
Message-ID: <20210310200458.GA12122@amd>
References: <20210310132321.948258062@linuxfoundation.org>
 <20210310132322.685806668@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20210310132322.685806668@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Wed 2021-03-10 14:23:34, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> From: Jasper St. Pierre <jstpierre@mecheye.net>

Something is funny with the From header here. But that's not main
thing -- this patch is evil.

>=20
> [ Upstream commit 25417185e9b5ff90746d50769d2a3fcd1629e254 ]
>=20
> The GIGABYTE GB-BXBT-2807 is a mini-PC which uses off the shelf
> components, like an Intel GPU which is meant for mobile systems.
> As such, it, by default, has a backlight controller exposed.
>=20
> Unfortunately, the backlight controller only confuses userspace, which
> sees the existence of a backlight device node and has the unrealistic
> belief that there is actually a backlight there!
>=20
> Add a DMI quirk to force the backlight off on this system.

> +++ b/drivers/acpi/video_detect.c
> @@ -140,6 +140,13 @@ static const struct dmi_system_id video_detect_dmi_t=
able[] =3D {
>  	},
>  	{
>  	.callback =3D video_detect_force_vendor,
> +	.ident =3D "GIGABYTE GB-BXBT-2807",
> +	.matches =3D {
> +		DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "GB-BXBT-2807"),
> +		},
> +	},
> +	{
>  	.ident =3D "Sony VPCEH3U1E",
>  	.matches =3D {
>  		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),

Yup, and it looks like this fixes the problem for GIGABYTE
GB-BXBT-2807 but re-introduces the problem for Sony VPCEH3U1E, because
its .callback is now NULL.

Best regards,
								Pavel

IOW I'm suggesting this:

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 811d298637cb..83cd4c95faf0 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -147,6 +147,7 @@ static const struct dmi_system_id video_detect_dmi_tabl=
e[] =3D {
 		},
 	},
 	{
+	.callback =3D video_detect_force_vendor,
 	.ident =3D "Sony VPCEH3U1E",
 	.matches =3D {
 		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBJJmoACgkQMOfwapXb+vIsdwCfeCY3SIy6H7DZYpEFjOqUtPYg
mgUAn32aOTavWmFomqX5zF/BpF2ouph2
=ZXeI
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
