Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA3D10277E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 15:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfKSO7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 09:59:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46130 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727066AbfKSO7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 09:59:06 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iX4y8-0005vn-1X; Tue, 19 Nov 2019 14:59:04 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iX4y7-0007ii-Kc; Tue, 19 Nov 2019 14:59:03 +0000
Message-ID: <13b0e0ced6e9420dc91242dbe85cdf96c06fb645.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 000/132] 3.16.74-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 19 Nov 2019 14:58:58 +0000
In-Reply-To: <CANiq72mYYzH1oS4h9GTODMP1ckZn2GnGTGirue1VLU1aw+Qo2A@mail.gmail.com>
References: <lsq.1568989414.954567518@decadent.org.uk>
         <20190920200423.GA26056@roeck-us.net>
         <8dbced01558cd8d4a1d4f058010e7d63e5f6810e.camel@decadent.org.uk>
         <CANiq72mYYzH1oS4h9GTODMP1ckZn2GnGTGirue1VLU1aw+Qo2A@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-CCLje6oWa7qQ32vv3ncu"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-CCLje6oWa7qQ32vv3ncu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2019-09-22 at 21:26 +0200, Miguel Ojeda wrote:
> On Sun, Sep 22, 2019 at 9:04 PM Ben Hutchings <ben@decadent.org.uk> wrote=
:
> > It looks like this is triggered by you switching arm builds from gcc 8
> > to 9, rather than by any code change.
> >=20
> > Does it actually make sense to try to support building Linux 3.16 with
> > gcc 9?  If so, I suppose I'll need to add:
> >=20
> > commit edc966de8725f9186cc9358214da89d335f0e0bd
> > Author: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> > Date:   Fri Aug 2 12:37:56 2019 +0200
> >=20
> >     Backport minimal compiler_attributes.h to support GCC 9
> >=20
> > commit a6e60d84989fa0e91db7f236eda40453b0e44afa
> > Author: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> > Date:   Sat Jan 19 20:59:34 2019 +0100
> >=20
> >     include/linux/module.h: copy __init/__exit attrs to init/cleanup_mo=
dule
>=20
> Yeah, those should fix it.

A week or two back I tried building 3.16 for x86_64 with gcc 8, which
produced some warnings but did succeed (and I know Guenter successfully
build-tests 3.16 with gcc 8 for many architectures).  However, the
kernel didn't boot on a test system, while the same code built with gcc
4.9 (if I remember correctly) did boot.

While I'm not about to remove support for gcc 8, this makes me think
that there are some not-so-obvious fixes required to make 3.16 properly
compatible with recent gcc versions.  So I would rather not continue
adding superficial support for them, that may lead to people wasting
time building broken kernels.

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice - John Levine



--=-CCLje6oWa7qQ32vv3ncu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3UAzIACgkQ57/I7JWG
EQlxLBAAt4lSvhoJrHinIE6LimmHJMxhZWsXzdpWWEbO7b7HEd5zu7hvyN0D1wQ0
RU4uLLamyXyNBckUOpgzbdODIjLJIZN+EOQlbaC766A0b7VE/Gq5Qbb8ckzGOhtU
I/Dr3rjzoGU1+0kQ4RewvdHubmp8MQjtSoz4fZ4SL9lWK2Hm9P5YHhpVfM2t3b8r
dEfMycHR7+mS5Lu1hwkglyFWlqmmfVlAjkLmNe8NVD/BiThGCo2cN0sm4kB2mMkL
QsE70l6QQzQt63zMivqrUcFlCKFP3KGPnuJBsww4n3BKvhT9+fzl0OA8VVhp8+0d
j3h3FbzHXrWV6nU7/wMMj67Zmc5qQMT3tOlmRWgdWcrNgOx6tyJ38DrajAyBZPwt
9Uv12k4WTIlDeLf0u7ah4dPaua4y7OQpFPbUP+G3QV2gIXnKG2Z7h39/jakdPMXH
s4/4e1FaqQmGvsYPAYZWkrpU3SzyslRp2KG7WNVw5ElluccDuxsPlEZgjnVnk1dX
6qrTi7R/JGqycyo9QW2Qr7iZVzuh7BhisXp1CSr2KXCyY/51LOtCAvCaC4h97QR6
+6SYUQZiGs01Dswf5hFnP8RslGynMDUgsxO9+ugGddSY8TyahsWZ08/Tv/O+tSCR
E+KQ5yopcSxAAXo/wcrinJrKHl29y6Eo3r0iEXP1ahWj3Ti6lIc=
=CpbM
-----END PGP SIGNATURE-----

--=-CCLje6oWa7qQ32vv3ncu--
