Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0BE6114050
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 12:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfLELup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 06:50:45 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55532 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729044AbfLELup (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 06:50:45 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 38DB51C2597; Thu,  5 Dec 2019 12:50:44 +0100 (CET)
Date:   Thu, 5 Dec 2019 12:50:43 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wentao Wang <witallwang@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 200/321] mm/page_alloc.c: deduplicate
 __memblock_free_early() and memblock_free()
Message-ID: <20191205115043.GA25107@duo.ucw.cz>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223437.527630884@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20191203223437.527630884@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
On Tue 2019-12-03 23:34:26, Greg Kroah-Hartman wrote:
> From: Wentao Wang <witallwang@gmail.com>
>=20
> [ Upstream commit d31cfe7bff9109476da92c245b56083e9b48d60a ]


> @@ -1537,12 +1537,7 @@ void * __init memblock_virt_alloc_try_nid(
>   */
>  void __init __memblock_free_early(phys_addr_t base, phys_addr_t size)
>  {
> -	phys_addr_t end =3D base + size - 1;
> -
> -	memblock_dbg("%s: [%pa-%pa] %pF\n",
> -		     __func__, &base, &end, (void *)_RET_IP_);
> -	kmemleak_free_part_phys(base, size);
> -	memblock_remove_range(&memblock.reserved, base, size);
> +	memblock_free(base, size);
>  }

This makes the memblock_dbg() less useful: _RET_IP_ will now be one of
__memblock_free_early(), not of the original caller.

That may be okay, but I guess it should be mentioned in changelog, and
I don't really see why it is queued for -stable.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXejvEwAKCRAw5/Bqldv6
8ih8AJ9df6YaSULuf6SBzmDGYpRKG/VG8QCfcT6m7kgjoOtQhmcjG+92gfsGp20=
=d0CK
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
