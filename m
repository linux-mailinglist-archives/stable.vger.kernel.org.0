Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB9B14ECCA
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 13:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgAaM5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 07:57:48 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:48040 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbgAaM5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 07:57:47 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 930C61C228F; Fri, 31 Jan 2020 13:57:46 +0100 (CET)
Date:   Fri, 31 Jan 2020 13:57:31 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 36/55] drivers/net/b44: Change to non-atomic bit
 operations on pwol_mask
Message-ID: <20200131125730.GA20888@duo.ucw.cz>
References: <20200130183608.563083888@linuxfoundation.org>
 <20200130183615.120752961@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20200130183615.120752961@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-01-30 19:39:17, Greg Kroah-Hartman wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
>=20
> [ Upstream commit f11421ba4af706cb4f5703de34fa77fba8472776 ]

This is not suitable for stable. It does not fix anything. It prepares
for theoretical bug that author claims might be introduced to BIOS in
future... I doubt it, even BIOS authors boot their machines from time
to time.

> Atomic operations that span cache lines are super-expensive on x86
> (not just to the current processor, but also to other processes as all
> memory operations are blocked until the operation completes). Upcoming
> x86 processors have a switch to cause such operations to generate a #AC
> trap. It is expected that some real time systems will enable this mode
> in BIOS.

And I wonder if this is even good idea for mainline. x86 architecture
is here for long time, and I doubt Intel is going to break it like
this. Do you have documentation pointer?=20

> In preparation for this, it is necessary to fix code that may execute
> atomic instructions with operands that cross cachelines because the #AC
> trap will crash the kernel.

How does single bit operation "cross cacheline"? How is this going to
impact non-x86 architectures?

> Since "pwol_mask" is local and never exposed to concurrency, there is
> no need to set bits in pwol_mask using atomic operations.
>=20
> Directly operate on the byte which contains the bit instead of using
> __set_bit() to avoid any big endian concern due to type cast to
> unsigned long in __set_bit().

What concerns? Is __set_bit() now useless and are we going to open-code
it everywhere? Is set_bit() now unusable on x86?
							=09
								Pavel
							=09
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/b44.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/b=
roadcom/b44.c
> index e445ab724827f..88f8d31e4c833 100644
> --- a/drivers/net/ethernet/broadcom/b44.c
> +++ b/drivers/net/ethernet/broadcom/b44.c
> @@ -1519,8 +1519,10 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppat=
tern, u8 *pmask, int offset)
>  	int ethaddr_bytes =3D ETH_ALEN;
> =20
>  	memset(ppattern + offset, 0xff, magicsync);
> -	for (j =3D 0; j < magicsync; j++)
> -		set_bit(len++, (unsigned long *) pmask);
> +	for (j =3D 0; j < magicsync; j++) {
> +		pmask[len >> 3] |=3D BIT(len & 7);
> +		len++;
> +	}
> =20
>  	for (j =3D 0; j < B44_MAX_PATTERNS; j++) {
>  		if ((B44_PATTERN_SIZE - len) >=3D ETH_ALEN)
> @@ -1532,7 +1534,8 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppatt=
ern, u8 *pmask, int offset)
>  		for (k =3D 0; k< ethaddr_bytes; k++) {
>  			ppattern[offset + magicsync +
>  				(j * ETH_ALEN) + k] =3D macaddr[k];
> -			set_bit(len++, (unsigned long *) pmask);
> +			pmask[len >> 3] |=3D BIT(len & 7);
> +			len++;
>  		}
>  	}
>  	return len - 1;
> --=20
> 2.20.1
>=20
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXjQkOgAKCRAw5/Bqldv6
8sEXAKDEBaLFMfGhZMoUFbXvMi75isxPaQCePgdIxpXSVK7wV2W2gywre2XfJso=
=7k6g
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
