Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11AF327583
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 01:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhCAAN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 19:13:58 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:58158 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhCAAN5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 19:13:57 -0500
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGWBW-0007iO-Rr; Mon, 01 Mar 2021 01:13:14 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGWBV-004W9a-BQ; Mon, 01 Mar 2021 01:13:13 +0100
Message-ID: <66826ac72356b00814f51487dd1008298e52ed9b.camel@decadent.org.uk>
Subject: futex breakage in 4.9 stable branch
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Cc:     lwn@lwn.net, jslaby@suse.cz
Date:   Mon, 01 Mar 2021 01:13:08 +0100
In-Reply-To: <161408880177110@kroah.com>
References: <161408880177110@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-YUn168QV9efsPaMvpgQb"
User-Agent: Evolution 3.38.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-YUn168QV9efsPaMvpgQb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-02-23 at 15:00 +0100, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 4.9.258 kernel.
>=20
> All users of the 4.9 kernel series must upgrade.
>=20
> The updated 4.9.y git tree can be found at:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0git://git.kernel.org/pub/=
scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
> and can be browsed at the normal kernel.org git web browser:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0

The backported futex fixes are still incomplete/broken in this version.
If I enable lockdep and run the futex self-tests (from 5.10):

- on 4.9.246, they pass with no lockdep output
- on 4.9.257 and 4.9.258, they pass but futex_requeue_pi trigers a
  lockdep splat

I have a local branch that essentially updates futex and rtmutex in
4.9-stable to match 4.14-stable.  With this, the tests pass and lockdep
is happy.

Unfortunately, that branch has about another 60 commits.  Further, the
more we change futex in 4.9, the more difficult it is going to be to
update the 4.9-rt branch.  But I don't see any better option available
at the moment.

Thoughts?

Ben.

--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett

--=-YUn168QV9efsPaMvpgQb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmA8MZQACgkQ57/I7JWG
EQnKVg/9FdQqGBfLCDP5gL+FeOrGcHw1ICY9UR9yQLjWY7mDlTxMmEXUABQOjpS3
G7QX7Vf1zQwfWGqogEQopgIsa/FRYGt9dOs/689DnI2Qt9evo+zhvfVvEvyrVsBl
eH6V5CG0mgJxtYcgQcKuUWS/vn0nzaVApWsbLsZeVDpc2U0TVJeIrN6vYlRcsCkP
8NSsYPb9NiQZOUu35HD3Bx6JWZLm2CBRJVG5iE4ErTR2rVgrnIHSSfIxRLjnGo/8
KgNAgYJUnayQlOU4MHs2QlPC0xOjfEUDttGpFVOIu4AmhvDr6N+3EPETU4m8U0tU
x8Hxyg+8njW22Zrh8pcxgKoqb20z7o6tLsg2Xzp3UFkbhFtPQlVXwmEFYzpL7Huy
l7sC5kQzcGExoS2noWW//1+Y3WGnwZJJT4VGlTOAqHqNSTLAsLNVCnQI3LQ1Oaf3
+VOUA8vuL+nIsHRzFloSSKPbTmQMe/AqnBL8kh2cwCMD0eKMr936L43cGBQ3jZF9
IpVYqOLrzk8mA3DBm8VEie+R/uslmodxfJqY20V+DmOMW+kNelBDmvl1gfkN3Vxn
vIxBw3OBfgwWJAnwgMLbnqaKGmpTEHsiJmt8nxW3wM5X90PrVfCY1Vd+pFCA6w2q
DbRJTEWcVHYmZ1mG/Z5sqGIYrbzDl6SFNSz5Zbi6LdvfnCLHiH8=
=d0ry
-----END PGP SIGNATURE-----

--=-YUn168QV9efsPaMvpgQb--
