Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB8D28CFFA
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 16:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388506AbgJMOOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 10:14:24 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33820 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388488AbgJMOOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 10:14:23 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EE30A1C0B77; Tue, 13 Oct 2020 16:14:21 +0200 (CEST)
Date:   Tue, 13 Oct 2020 16:14:21 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yu Kuai <yukuai3@huawei.com>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 27/38] iommu/exynos: add missing put_device() call
 in exynos_iommu_of_xlate()
Message-ID: <20201013141421.GA22886@duo.ucw.cz>
References: <20201005142108.650363140@linuxfoundation.org>
 <20201005142109.977461657@linuxfoundation.org>
 <CGME20201007095256eucas1p150311eeced01b2cc66f6a9ef7061e6ff@eucas1p1.samsung.com>
 <20201007094737.GA12593@duo.ucw.cz>
 <5b869c86-8d35-e834-4fec-6b63a942e484@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <5b869c86-8d35-e834-4fec-6b63a942e484@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> [ Upstream commit 1a26044954a6d1f4d375d5e62392446af663be7a ]
> >>
> >> if of_find_device_by_node() succeed, exynos_iommu_of_xlate() doesn't h=
ave
> >> a corresponding put_device(). Thus add put_device() to fix the excepti=
on
> >> handling for this function implementation.
> > Okay, this looks reasonable, but...
> >
> > Do we miss put_device() in normal path, too? I'd expect another
> > put_device at end of exynos_iommu_of_xlate() or perhaps in release
> > path somewhere...
>=20
> Frankly, there is no release path, so there is no need for put_device.=20
> Once initialized, Exynos IOMMU stays in the system forever. There is no=
=20
> point to remove IOMMU nor the API for that. Keeping increased refcount=20
> for its device just matches this behavior.
>=20
> If the missing put_device() is really a problem, then we can move it=20
> from the error path just after data =3D platform_get_drvdata(sysmmu)=20
> assignment. Feel free to send a patch if you think this is a more=20
> appropriate approach.

exynos_iommu_detach_device() looks like a place where resources could
be freed? But if there's no release path, we don't really need to do anythi=
ng.=20

Sorry about the noise.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX4W2PQAKCRAw5/Bqldv6
8m7vAJ4iXq02bm6+RavPQxrGMERfz/4fsQCfQdFAYbgb57aGCx7w0yA3EfNXz4Y=
=CDgo
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
