Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EB43D0435
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 00:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhGTVYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 17:24:19 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:44250 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhGTVYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 17:24:10 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 96D981C0B77; Wed, 21 Jul 2021 00:04:46 +0200 (CEST)
Date:   Wed, 21 Jul 2021 00:04:46 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 074/243] iommu/arm-smmu: Fix arm_smmu_device
 refcount leak when arm_smmu_rpm_get fails
Message-ID: <20210720220445.GA1557@amd>
References: <20210719144940.904087935@linuxfoundation.org>
 <20210719144943.296807839@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <20210719144943.296807839@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
>=20
> [ Upstream commit 1adf30f198c26539a62d761e45af72cde570413d ]
>=20
> arm_smmu_rpm_get() invokes pm_runtime_get_sync(), which increases the
> refcount of the "smmu" even though the return value is less than 0.

Yes.

> The reference counting issue happens in some error handling paths of
> arm_smmu_rpm_get() in its caller functions. When arm_smmu_rpm_get()
> fails, the caller functions forget to decrease the refcount of "smmu"
> increased by arm_smmu_rpm_get(), causing a refcount leak.

Yes, some error paths do that. But some callers (arm_smmu_map,
arm_smmu_unmap, arm_smmu_flush_iotlb_all, ...) ignore return value of
arm_smmu_rpm_get().

> Fix this issue by calling pm_runtime_resume_and_get() instead of
> pm_runtime_get_sync() in arm_smmu_rpm_get(), which can keep the refcount
> balanced in case of failure.

So no, this is not fixed; it is just unbalanced in the other (more
dangerous) direction now.

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmD3SH0ACgkQMOfwapXb+vIWAgCeM843/S/by8WDaeHAteRRms3m
9BUAniOph6NCoPFAm4gdwPuWcs3S3XGR
=88E1
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
