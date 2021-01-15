Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6508F2F86A6
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 21:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731808AbhAOU1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 15:27:24 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:36936 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731529AbhAOU1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 15:27:23 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 837A11C0B7C; Fri, 15 Jan 2021 21:26:40 +0100 (CET)
Date:   Fri, 15 Jan 2021 21:26:40 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiaolei Wang <xiaolei.wang@windriver.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 5.10 086/103] regmap: debugfs: Fix a memory leak when
 calling regmap_attach_dev
Message-ID: <20210115202639.GB8375@amd>
References: <20210115122006.047132306@linuxfoundation.org>
 <20210115122010.175920983@linuxfoundation.org>
 <20210115201819.GA8375@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <20210115201819.GA8375@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > From: Xiaolei Wang <xiaolei.wang@windriver.com>
> >=20
> > commit cffa4b2122f5f3e53cf3d529bbc74651f95856d5 upstream.
> >=20
> > After initializing the regmap through
> > syscon_regmap_lookup_by_compatible, then regmap_attach_dev to the
> > device, because the debugfs_name has been allocated, there is no
> > need to redistribute it again
>=20
> ? redistribute?
>=20
> Anyway, this patch is clearly buggy:
>=20
> > =20
> >  	if (!strcmp(name, "dummy")) {
> > -		kfree(map->debugfs_name);
> > +		if (!map->debugfs_name)
> > +			kfree(map->debugfs_name);
> > =20
>=20
> It runs kfree only if the variable is NULL. That's clearly useless,
> kfree(NULL) is NOP, and this causes memory leak.

103/ of the series fixes this up. Sorry for the noise...=20

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAB+n8ACgkQMOfwapXb+vJliACgpoeT7By9CujULzQaL50htqmR
4+YAoMKq6dpJulqr8R1fHSXL0kSysJyn
=BVar
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
