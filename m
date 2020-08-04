Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9912623B5DA
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 09:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgHDHjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 03:39:10 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48628 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbgHDHjK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 03:39:10 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E922E1C0BD7; Tue,  4 Aug 2020 09:39:06 +0200 (CEST)
Date:   Tue, 4 Aug 2020 09:39:06 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 31/56] net/mlx5: Verify Hardware supports requested
 ptp function on a given pin
Message-ID: <20200804073906.jo6y4iaa5vqa4ixz@duo.ucw.cz>
References: <20200803121850.306734207@linuxfoundation.org>
 <20200803121851.847496622@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2deo36yqpzzaylvk"
Content-Disposition: inline
In-Reply-To: <20200803121851.847496622@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2deo36yqpzzaylvk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 071995c877a8646209d55ff8edddd2b054e7424c ]
>=20
> Fix a bug where driver did not verify Hardware pin capabilities for
> PTP functions.
>=20
> Fixes: ee7f12205abc ("net/mlx5e: Implement 1PPS support")
> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> Reviewed-by: Ariel Levkovich <lariel@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

> +
>  static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
>  			   enum ptp_pin_function func, unsigned int chan)
>  {
> -	return (func =3D=3D PTP_PF_PHYSYNC) ? -EOPNOTSUPP : 0;
> +	struct mlx5_clock *clock =3D container_of(ptp, struct mlx5_clock,
> +						ptp_info);
> +
> +	switch (func) {
> +	case PTP_PF_NONE:
> +		return 0;
> +	case PTP_PF_EXTTS:
> +		return !(clock->pps_info.pin_caps[pin] &
> +			 MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_IN);
> +	case PTP_PF_PEROUT:
> +		return !(clock->pps_info.pin_caps[pin] &
> +			 MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_OUT);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return -EOPNOTSUPP;
>  }

The last return statement is unreachable code. I'm not sure if it will
provoke any warnings, but it looks ugly.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lib/clock.c
index 2d55b7c22c03..a804f92ccf23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -431,8 +431,6 @@ static int mlx5_ptp_verify(struct ptp_clock_info *ptp, =
unsigned int pin,
 	default:
 		return -EOPNOTSUPP;
 	}
-
-	return -EOPNOTSUPP;
 }
=20
 static const struct ptp_clock_info mlx5_ptp_clock_info =3D {


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--2deo36yqpzzaylvk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXykQmgAKCRAw5/Bqldv6
8mBZAJ44rSH77O3rwY3K6531GcdnCUsEeQCgui5/iR1zubZIKtvj8O2IL5zkGEg=
=nDF/
-----END PGP SIGNATURE-----

--2deo36yqpzzaylvk--
