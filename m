Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22ED332CEB1
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 09:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbhCDIop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 03:44:45 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56162 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236435AbhCDIo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 03:44:29 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A5AFD1C0B87; Thu,  4 Mar 2021 09:43:30 +0100 (CET)
Date:   Thu, 4 Mar 2021 09:43:29 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yong Wu <yong.wu@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 337/663] iommu: Move iotlb_sync_map out from
 __iommu_map
Message-ID: <20210304084329.GA25188@amd>
References: <20210301161141.760350206@linuxfoundation.org>
 <20210301161158.520692499@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20210301161158.520692499@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit d8c1df02ac7f2c802a9b2afc0f5c888c4217f1d5 ]
>=20
> In the end of __iommu_map, It alway call iotlb_sync_map.
>=20
> This patch moves iotlb_sync_map out from __iommu_map since it is
> unnecessary to call this for each sg segment especially iotlb_sync_map
> is flush tlb all currently. Add a little helper _iommu_map for this.

> Signed-off-by: Sasha Levin <sashal@kernel.org>

AFAICT this is slight performance optimalization, not a bugfix. It
actually introduces a bug, fixed by the next patch. I'd preffer not to
have it in stable.

Best regards,
								Pavel

> @@ -2421,18 +2418,31 @@ static int __iommu_map(struct iommu_domain *domai=
n, unsigned long iova,
> =20
> +static int _iommu_map(struct iommu_domain *domain, unsigned long iova,
> +		      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> +{
> +	const struct iommu_ops *ops =3D domain->ops;
> +	int ret;
> +
> +	ret =3D __iommu_map(domain, iova, paddr, size, prot, GFP_KERNEL);
> +	if (ret =3D=3D 0 && ops->iotlb_sync_map)
> +		ops->iotlb_sync_map(domain);
> +
> +	return ret;
> +}

--=20
http://www.livejournal.com/~pavelmachek

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBAnbEACgkQMOfwapXb+vIVvACgshwz5xeQjuPBx5Me4eiCuLPc
H2cAn0tp1BDr8V0rf+DIijdLJ4J+w/f+
=5sHE
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
