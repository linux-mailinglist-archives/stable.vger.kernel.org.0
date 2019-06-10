Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1C43B0A7
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 10:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387862AbfFJIVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 04:21:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53535 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387825AbfFJIVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 04:21:16 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id CD59080266; Mon, 10 Jun 2019 10:21:02 +0200 (CEST)
Date:   Mon, 10 Jun 2019 10:21:12 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 01/51] ethtool: fix potential userspace buffer
 overflow
Message-ID: <20190610082112.GA8783@amd>
References: <20190609164127.123076536@linuxfoundation.org>
 <20190609164127.215699992@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20190609164127.215699992@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Vivien Didelot <vivien.didelot@gmail.com>
>=20
> [ Upstream commit 0ee4e76937d69128a6a66861ba393ebdc2ffc8a2 ]
>=20
> ethtool_get_regs() allocates a buffer of size ops->get_regs_len(),
> and pass it to the kernel driver via ops->get_regs() for filling.
>=20
> There is no restriction about what the kernel drivers can or cannot do
> with the open ethtool_regs structure. They usually set regs->version
> and ignore regs->len or set it to the same size as ops->get_regs_len().
>=20
> But if userspace allocates a smaller buffer for the registers dump,
> we would cause a userspace buffer overflow in the final copy_to_user()
> call, which uses the regs.len value potentially reset by the driver.
>=20
> To fix this, make this case obvious and store regs.len before calling
> ops->get_regs(), to only copy as much data as requested by userspace,
> up to the value returned by ops->get_regs_len().
>=20
> While at it, remove the redundant check for non-null regbuf.

Mainline differs from 4.19-stable here, and while the non-null check
is redundant in -mainline, it does not seem to be redundant in
-stable.

In stable, if get_regs_len() returns < 0, we'll pass it to vzalloc.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlz+EvgACgkQMOfwapXb+vLYDwCgpANVlxjsNizDo5i0pIDWsa3G
eWMAn04kn8dXdTe1HBOZbl9QHOw8fKHg
=3qAG
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
