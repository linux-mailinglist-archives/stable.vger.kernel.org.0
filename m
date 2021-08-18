Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E811A3F0BBC
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 21:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhHRT1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 15:27:22 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33320 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbhHRT1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 15:27:21 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 903D91C0B7A; Wed, 18 Aug 2021 21:26:45 +0200 (CEST)
Date:   Wed, 18 Aug 2021 21:26:45 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Ben Hutchings <ben.hutchings@essensium.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 51/96] net: dsa: microchip: Fix ksz_read64()
Message-ID: <20210818192645.GA28932@amd>
References: <20210816125434.948010115@linuxfoundation.org>
 <20210816125436.659359567@linuxfoundation.org>
 <20210817175630.GB30136@amd>
 <20210817182040.GA12678@cephalopod>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20210817182040.GA12678@cephalopod>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > [ Upstream commit c34f674c8875235725c3ef86147a627f165d23b4 ]
> > >=20
> > > ksz_read64() currently does some dubious byte-swapping on the two
> > > halves of a 64-bit register, and then only returns the high bits.
> > > Replace this with a straightforward expression.
> >=20
> > The code indeed is very strange, but there are just 2 users, and they
> > will now receive byteswapped values, right? If it worked before, it
> > will be broken.
>=20
> The old code swaps the bytes within each 32-bit word, attempts to
> concatenate them into a 64-bit word, then swaps the bytes within the
> 64-bit word.  There is no need for byte-swapping, only (on little-
> endian platforms) a word-swap, which is what the new code does.
>=20
> > Did this get enough testing for -stable?
>=20
> Yes, I actually developed and tested all the ksz8795 changes in 5.10
> before forward-porting to mainline.
>=20
> > Is hw little endian or high endian or...?
>=20
> The hardware is big-endian and regmap handles any necessary
> byte-swapping for values up to 32 bits.
>=20
> > Note that ksz_write64() still contains the strange code, at least in
> > 5.10.
>=20
> It's unnecessarily complex, but it does work.

Thanks for the explanations and sorry for the noise. Indeed
ksz_write64() is quite obfuscated, but I can't see a problem.

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEdXvUACgkQMOfwapXb+vI8TQCdFSWUkNVyfdY4AfE9eIc8Xvh/
GyQAnjouAa8AXfoFoEXhTvUXUq7npQcu
=ZUWL
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
