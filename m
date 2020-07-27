Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B099A22FAC3
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 22:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgG0U4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 16:56:37 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48848 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgG0U4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 16:56:37 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0A38E1C0BEC; Mon, 27 Jul 2020 22:56:36 +0200 (CEST)
Date:   Mon, 27 Jul 2020 22:56:35 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4.19 84/86] dm integrity: fix integrity recalculation
 that is improperly skipped
Message-ID: <20200727205635.t23z72lkdofoewi3@duo.ucw.cz>
References: <20200727134914.312934924@linuxfoundation.org>
 <20200727134918.614819996@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="c2ffx63o2i5ruzqb"
Content-Disposition: inline
In-Reply-To: <20200727134918.614819996@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--c2ffx63o2i5ruzqb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Mikulas Patocka <mpatocka@redhat.com>
>=20
> commit 5df96f2b9f58a5d2dc1f30fe7de75e197f2c25f2 upstream.
>=20
> Commit adc0daad366b62ca1bce3e2958a40b0b71a8b8b3 ("dm: report suspended
> device during destroy") broke integrity recalculation.
>=20
> The problem is dm_suspended() returns true not only during suspend,
> but also during resume. So this race condition could occur:
> 1. dm_integrity_resume calls queue_work(ic->recalc_wq, &ic->recalc_work)
> 2. integrity_recalc (&ic->recalc_work) preempts the current thread
> 3. integrity_recalc calls if (unlikely(dm_suspended(ic->ti))) goto unlock=
_ret;
> 4. integrity_recalc exits and no recalculating is done.
>=20
> To fix this race condition, add a function dm_post_suspending that is
> only true during the postsuspend phase and use it instead of
> dm_suspended().
>=20
> Signed-off-by: Mikulas Patocka <mpatocka redhat com>

Something is wrong with signoff here...

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--c2ffx63o2i5ruzqb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXx8/gwAKCRAw5/Bqldv6
8tdoAJ491zLI5+qrKuaseLHCAYS45lbfPgCeO+xsnnL50rvpSSMij8DKb/4Izbg=
=l0en
-----END PGP SIGNATURE-----

--c2ffx63o2i5ruzqb--
