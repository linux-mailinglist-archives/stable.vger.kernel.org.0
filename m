Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BE6415246
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 23:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237951AbhIVVCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 17:02:11 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33094 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237790AbhIVVBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 17:01:55 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 907CD1C0B76; Wed, 22 Sep 2021 23:00:15 +0200 (CEST)
Date:   Wed, 22 Sep 2021 23:00:15 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 100/122] gpio: mpc8xxx: Fix a potential double
 iounmap call in mpc8xxx_probe()
Message-ID: <20210922210014.GA27285@amd>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163919.067590477@linuxfoundation.org>
 <20210921212526.GA28467@duo.ucw.cz>
 <YUrxz1tG43TIyypq@kroah.com>
 <YUryE32/gr/HH+L8@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <YUryE32/gr/HH+L8@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > Commit 76c47d1449fc ("gpio: mpc8xxx: Add ACPI support") has switche=
d to a
> > > > managed version when dealing with 'mpc8xxx_gc->regs'. So the corres=
ponding
> > > > 'iounmap()' call in the error handling path and in the remove shoul=
d be
> > > > removed to avoid a double unmap.
> > >=20
> > > This is wrong, AFAICT. 5.10 does not have 76c47d1449fc ("gpio:
> > > mpc8xxx: Add ACPI support") so iounmap is still neccessary and this
> > > adds a memory leak.
> >=20
> > Ah, but then I have to drop 889a1b3f35db ("gpio: mpc8xxx: Use
> > 'devm_gpiochip_add_data()' to simplify the code and avoid a leak") from
> > the 5.10 queue as it depends on this one.
> >=20
> > Can you provide a working backport of that commit so that I can queue up
> > the fix?
>=20
> Oh nevermind, I fixed it up myself.

Thank you!
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmFLmV4ACgkQMOfwapXb+vKJ2ACgnOxLRd490CMXujD21PrSZCds
8p4An162c860YqMRc2FjSq27t8CxdrF8
=FNDf
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
