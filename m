Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABE0261E98
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbgIHTxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:53:19 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46598 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730662AbgIHTxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 15:53:17 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9157E1C0B87; Tue,  8 Sep 2020 21:53:11 +0200 (CEST)
Date:   Tue, 8 Sep 2020 21:53:11 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 41/88] net: ethernet: mlx4: Fix memory allocation in
 mlx4_buddy_init()
Message-ID: <20200908195311.GC6758@duo.ucw.cz>
References: <20200908152221.082184905@linuxfoundation.org>
 <20200908152223.178555420@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
In-Reply-To: <20200908152223.178555420@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On machines with much memory (> 2 TByte) and log_mtts_per_seg =3D=3D 0, a
> max_order of 31 will be passed to mlx_buddy_init(), which results in
> s =3D BITS_TO_LONGS(1 << 31) becoming a negative value, leading to
> kvmalloc_array() failure when it is converted to size_t.
>=20
>   mlx4_core 0000:b1:00.0: Failed to initialize memory region table, abort=
ing
>   mlx4_core: probe of 0000:b1:00.0 failed with error -12
>=20
> Fix this issue by changing the left shifting operand from a signed litera=
l to
> an unsigned one.

Will we still have problems with > 4 TByte machines? Should the
computation be done in u64?

Best regards,
									Pavel

> Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniBand =
adapters")
> Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

> +++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
> @@ -114,7 +114,7 @@ static int mlx4_buddy_init(struct mlx4_buddy *buddy, =
int max_order)
>  		goto err_out;
> =20
>  	for (i =3D 0; i <=3D buddy->max_order; ++i) {
> -		s =3D BITS_TO_LONGS(1 << (buddy->max_order - i));
> +		s =3D BITS_TO_LONGS(1UL << (buddy->max_order - i));
>  		buddy->bits[i] =3D kvmalloc_array(s, sizeof(long), GFP_KERNEL | __GFP_=
ZERO);
>  		if (!buddy->bits[i])
>  			goto err_out_free;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX1fhJwAKCRAw5/Bqldv6
8rSiAJ0SDlKpMvw+OEk/HI9lrjlcK2+O6wCguY0eWqm2yogCIc5Ym9GDPYo7I2k=
=xI+r
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--
