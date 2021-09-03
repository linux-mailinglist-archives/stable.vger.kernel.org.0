Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733053FFAA7
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 08:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347407AbhICGvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 02:51:37 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55948 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347344AbhICGvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 02:51:37 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BE5AE1C0B7F; Fri,  3 Sep 2021 08:50:36 +0200 (CEST)
Date:   Fri, 3 Sep 2021 08:50:35 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gerd Rausch <gerd.rausch@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 12/16] net/rds: dma_map_sg is entitled to merge
 entries
Message-ID: <20210903065035.GA11871@amd>
References: <20210901122248.920548099@linuxfoundation.org>
 <20210901122249.305212889@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20210901122249.305212889@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit fb4b1373dcab086d0619c29310f0466a0b2ceb8a ]
>=20
> Function "dma_map_sg" is entitled to merge adjacent entries
> and return a value smaller than what was passed as "nents".
>=20
> Subsequently "ib_map_mr_sg" needs to work with this value ("sg_dma_len")
> rather than the original "nents" parameter ("sg_len").
>=20
> This old RDS bug was exposed and reliably causes kernel panics
> (using RDMA operations "rds-stress -D") on x86_64 starting with:
> commit c588072bba6b ("iommu/vt-d: Convert intel iommu driver to the iommu=
 ops")
>=20
> Simply put: Linux 5.11 and later.

I see this queued for 4.19 and 5.10 where "iommu/vt-d: Convert intel
iommu driver to the iommu ops" is not present. It may be okay for
older kernels, too, but I wanted to double-check.

Best regards,
								Pavel

> +++ b/net/rds/ib_frmr.c
> @@ -112,9 +112,9 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibm=
r)
>  		cpu_relax();
>  	}
> =20
> -	ret =3D ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_len,
> +	ret =3D ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_dma_len,
>  				&off, PAGE_SIZE);
> -	if (unlikely(ret !=3D ibmr->sg_len))
> +	if (unlikely(ret !=3D ibmr->sg_dma_len))
>  		return ret < 0 ? ret : -EINVAL;
> =20
>  	/* Perform a WR for the fast_reg_mr. Each individual page

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmExxbsACgkQMOfwapXb+vIokACfWIp9qI4rPFIGtWVW2efztgjx
5mgAn3I6yh7BljGER3XX9UJQgWCG3aKb
=7bBt
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
