Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A85431CA34
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 12:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhBPLxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 06:53:18 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57416 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbhBPLvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 06:51:16 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 69A331C0B81; Tue, 16 Feb 2021 12:50:31 +0100 (CET)
Date:   Tue, 16 Feb 2021 12:50:29 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 043/104] kasan: add explicit preconditions to
 kasan_report()
Message-ID: <20210216115029.GA25795@amd>
References: <20210215152719.459796636@linuxfoundation.org>
 <20210215152720.867409732@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20210215152720.867409732@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Vincenzo Frascino <vincenzo.frascino@arm.com>
>=20
> [ Upstream commit 49c6631d3b4f61a7b5bb0453a885a12bfa06ffd8 ]
>=20
> Patch series "kasan: Fix metadata detection for KASAN_HW_TAGS", v5.
>=20
> With the introduction of KASAN_HW_TAGS, kasan_report() currently assumes
> that every location in memory has valid metadata associated.  This is
> due to the fact that addr_has_metadata() returns always true.
>=20
> As a consequence of this, an invalid address (e.g.  NULL pointer
> address) passed to kasan_report() when KASAN_HW_TAGS is enabled, leads
> to a kernel panic.
=2E..
> This patch (of 2):
>=20
> With the introduction of KASAN_HW_TAGS, kasan_report() accesses the
> metadata only when addr_has_metadata() succeeds.
>=20
> Add a comment to make sure that the preconditions to the function are
> explicitly clarified.

As the other patch from the series is not applied, I don't believe we
need this in stable. Changelog does not make any sense with just
comment change cherry-picked...

Best regards,
								Pavel


> +++ b/include/linux/kasan.h
> @@ -196,6 +196,13 @@ void kasan_init_tags(void);
> =20
>  void *kasan_reset_tag(const void *addr);
> =20
> +/**
> + * kasan_report - print a report about a bad memory access detected by K=
ASAN
> + * @addr: address of the bad access
> + * @size: size of the bad access
> + * @is_write: whether the bad access is a write or a read
> + * @ip: instruction pointer for the accessibility check or the bad acces=
s itself
> + */
>  bool kasan_report(unsigned long addr, size_t size,
>  		bool is_write, unsigned long ip);
> =20

--=20
http://www.livejournal.com/~pavelmachek

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmArsYUACgkQMOfwapXb+vL16QCgwGjk5bVNHx2wt4tQeadsawcK
dgkAnjv+tCzrSGev/VKMFDMwEZG4J8LY
=I9ka
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
