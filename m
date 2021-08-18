Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982C13F0BC1
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 21:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhHRT2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 15:28:53 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33454 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbhHRT2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 15:28:52 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DC8AA1C0B77; Wed, 18 Aug 2021 21:28:16 +0200 (CEST)
Date:   Wed, 18 Aug 2021 21:28:16 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "pavel@denx.de" <pavel@denx.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aya Levin <ayal@nvidia.com>
Subject: Re: [PATCH 5.10 49/96] net/mlx5: Fix return value from tracer
 initialization
Message-ID: <20210818192816.GB28932@amd>
References: <20210816125434.948010115@linuxfoundation.org>
 <20210816125436.588162993@linuxfoundation.org>
 <20210817175137.GA30136@amd>
 <ddb6cd7b4e7a7b1d0fb46809702f0d7a2fc9c419.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
In-Reply-To: <ddb6cd7b4e7a7b1d0fb46809702f0d7a2fc9c419.camel@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Could someone familiar with the code verify it after me?

> > Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> >=20
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> > index 3dfcb20e97c6..857be86b4a11 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> > @@ -1007,7 +1007,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer
> > *tracer)
> > =A0=A0=A0=A0=A0=A0=A0=A0err =3D mlx5_core_alloc_pd(dev, &tracer->buff.p=
dn);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (err) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mlx5_core_warn(dev, "FW=
Tracer: Failed to allocate PD
> > %d\n", err);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return err;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto err_cancel_work;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0err =3D mlx5_fw_tracer_create_mkey(tracer);
> > @@ -1031,6 +1031,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer
> > *tracer)
> > =A0=A0=A0=A0=A0=A0=A0=A0mlx5_core_destroy_mkey(dev, &tracer->buff.mkey);
> > =A0err_dealloc_pd:
> > =A0=A0=A0=A0=A0=A0=A0=A0mlx5_core_dealloc_pd(dev, tracer->buff.pdn);
> > +err_cancel_work:
> > =A0=A0=A0=A0=A0=A0=A0=A0cancel_work_sync(&tracer->read_fw_strings_work);
> > =A0=A0=A0=A0=A0=A0=A0=A0return err;
>=20
> this is correct, do you want to submit this patch or do you want us to
> handle ?
> maybe it is better if we delayed queue_work() to after all the fragile
> code behind it, to reduce the error path handling ..=20

I'd prefer you to handle it.

Thank you,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEdX1AACgkQMOfwapXb+vLLSQCgvCfYD6lm/8ZMcO41vEXriUFU
YUoAnjqINnLp6qOPKqS+tm5uzlYxaUbb
=J+Iv
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
