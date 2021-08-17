Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9933EF11B
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 19:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhHQRwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 13:52:12 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:40438 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbhHQRwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 13:52:12 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 077B31C0B77; Tue, 17 Aug 2021 19:51:38 +0200 (CEST)
Date:   Tue, 17 Aug 2021 19:51:37 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 49/96] net/mlx5: Fix return value from tracer
 initialization
Message-ID: <20210817175137.GA30136@amd>
References: <20210816125434.948010115@linuxfoundation.org>
 <20210816125436.588162993@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20210816125436.588162993@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit bd37c2888ccaa5ceb9895718f6909b247cc372e0 ]
>=20
> Check return value of mlx5_fw_tracer_start(), set error path and fix
> return value of mlx5_fw_tracer_init() accordingly.

This is actually two fixes in one: There's cancel_work_sync() added to
the error path, but there's additional error that needs fixing.

Could someone familiar with the code verify it after me?

Best regards,
								Pavel

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 3dfcb20e97c6..857be86b4a11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1007,7 +1007,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	err =3D mlx5_core_alloc_pd(dev, &tracer->buff.pdn);
 	if (err) {
 		mlx5_core_warn(dev, "FWTracer: Failed to allocate PD %d\n", err);
-		return err;
+		goto err_cancel_work;
 	}
=20
 	err =3D mlx5_fw_tracer_create_mkey(tracer);
@@ -1031,6 +1031,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	mlx5_core_destroy_mkey(dev, &tracer->buff.mkey);
 err_dealloc_pd:
 	mlx5_core_dealloc_pd(dev, tracer->buff.pdn);
+err_cancel_work:
 	cancel_work_sync(&tracer->read_fw_strings_work);
 	return err;
 }


> +++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> @@ -1019,12 +1019,19 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tr=
acer)
=2E..
>  err_dealloc_pd:
>  	mlx5_core_dealloc_pd(dev, tracer->buff.pdn);
> +	cancel_work_sync(&tracer->read_fw_strings_work);
>  	return err;
>  }
> =20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEb9ykACgkQMOfwapXb+vJktgCgvG+gFh7KblyrgFLpsbOPslOQ
MjUAn0RUmjV0gRzjuh5jyVACMv1eDr1t
=SwLs
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
