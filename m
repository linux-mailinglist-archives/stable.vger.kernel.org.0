Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8C9312077
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 00:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhBFXZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 18:25:53 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56442 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBFXZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 18:25:52 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0B03E1C0B7C; Sun,  7 Feb 2021 00:25:09 +0100 (CET)
Date:   Sun, 7 Feb 2021 00:25:08 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 16/17] kthread: Extract KTHREAD_IS_PER_CPU
Message-ID: <20210206232508.GA27515@amd>
References: <20210205140649.825180779@linuxfoundation.org>
 <20210205140650.464297049@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20210205140650.464297049@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Peter Zijlstra <peterz@infradead.org>
>=20
> [ Upstream commit ac687e6e8c26181a33270efd1a2e2241377924b0 ]
>=20
> There is a need to distinguish geniune per-cpu kthreads from kthreads
> that happen to have a single CPU affinity.
>=20
> Geniune per-cpu kthreads are kthreads that are CPU affine for
> correctness, these will obviously have PF_KTHREAD set, but must also
> have PF_NO_SETAFFINITY set, lest userspace modify their affinity and
> ruins things.
>=20
> However, these two things are not sufficient, PF_NO_SETAFFINITY is
> also set on other tasks that have their affinities controlled through
> other means, like for instance workqueues.
>=20
> Therefore another bit is needed; it turns out kthread_create_per_cpu()
> already has such a bit: KTHREAD_IS_PER_CPU, which is used to make
> kthread_park()/kthread_unpark() work correctly.
>=20
> Expose this flag and remove the implicit setting of it from
> kthread_create_on_cpu(); the io_uring usage of it seems dubious at
> best.

AFAIK this should not be in 4.19/5.10 as it does not fix anything w/o
5ba2ffba13a1e. Nobody calls kthread_is_per_cpu() in those kernels.

Best regards,
								Pavel

--=20
http://www.livejournal.com/~pavelmachek

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAfJVQACgkQMOfwapXb+vKIbgCgwhgFHYtEbIGxwQEqO/Hz8Nej
1QUAoIFCgZXOVP0o3W2xNOFMbJpI8S+q
=T/1f
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
