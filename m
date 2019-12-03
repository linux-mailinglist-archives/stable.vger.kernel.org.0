Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 154D310FBB0
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 11:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfLCKWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 05:22:53 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:37340 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfLCKWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 05:22:52 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E6E531C25CF; Tue,  3 Dec 2019 11:22:50 +0100 (CET)
Date:   Tue, 3 Dec 2019 11:22:50 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 211/306] media: ov13858: Check for possible null
 pointer
Message-ID: <20191203102250.GA27320@amd>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203130.540872040@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20191127203130.540872040@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
>=20
> [ Upstream commit 35629182eb8f931b0de6ed38c0efac58e922c801 ]
>=20
> Check for possible null pointer to avoid crash.

> diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
> index 0e7a85c4996c7..afd66d243403b 100644
> --- a/drivers/media/i2c/ov13858.c
> +++ b/drivers/media/i2c/ov13858.c
> @@ -1612,7 +1612,8 @@ static int ov13858_init_controls(struct ov13858 *ov=
13858)
>  				OV13858_NUM_OF_LINK_FREQS - 1,
>  				0,
>  				link_freq_menu_items);
> -	ov13858->link_freq->flags |=3D V4L2_CTRL_FLAG_READ_ONLY;
> +	if (ov13858->link_freq)
> +		ov13858->link_freq->flags |=3D V4L2_CTRL_FLAG_READ_ONLY;
> =20
>  	pixel_rate_max =3D link_freq_to_pixel_rate(link_freq_menu_items[0]);
>  	pixel_rate_min =3D

I don't think this is right fix. If ov13858->link_freq initialization
fails, we want to fail the initialization, not present
half-initialized device to userland, no?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3mN3kACgkQMOfwapXb+vKiSACguJff7ExHy9eC8bWnsSV+Ndph
KHcAoLasf4QJOMo9rBzIW6QdMs5qVbvq
=Iz20
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
