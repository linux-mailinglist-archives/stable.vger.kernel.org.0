Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A05247696
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 21:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfFPTmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 15:42:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54628 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfFPTmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jun 2019 15:42:39 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 1F4B580204; Sun, 16 Jun 2019 21:42:26 +0200 (CEST)
Date:   Sun, 16 Jun 2019 21:42:36 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 070/118] iommu/arm-smmu-v3: Dont disable SMMU in
 kdump kernel
Message-ID: <20190616194236.GB6676@amd>
References: <20190613075643.642092651@linuxfoundation.org>
 <20190613075647.892923884@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <20190613075647.892923884@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 3f54c447df34ff9efac7809a4a80fd3208efc619 ]
>=20
> Disabling the SMMU when probing from within a kdump kernel so that all
> incoming transactions are terminated can prevent the core of the crashed
> kernel from being transferred off the machine if all I/O devices are
> behind the SMMU.
>=20
> Instead, continue to probe the SMMU after it is disabled so that we can
> reinitialise it entirely and re-attach the DMA masters as they are reset.
> Since the kdump kernel may not have drivers for all of the active DMA
> masters, we suppress fault reporting to avoid spamming the console and
> swamping the IRQ threads.

> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -2414,13 +2414,9 @@ static int arm_smmu_device_reset(struct arm_smmu_d=
evice *smmu, bool bypass)
>  	/* Clear CR0 and sync (disables SMMU and queue processing) */
>  	reg =3D readl_relaxed(smmu->base + ARM_SMMU_CR0);
>  	if (reg & CR0_SMMUEN) {
> -		if (is_kdump_kernel()) {
> -			arm_smmu_update_gbpa(smmu, GBPA_ABORT, 0);
> -			arm_smmu_device_disable(smmu);
> -			return -EBUSY;
> -		}
> -
>  		dev_warn(smmu->dev, "SMMU currently enabled! Resetting...\n");
> +		WARN_ON(is_kdump_kernel() && !disable_bypass);
> +		arm_smmu_update_gbpa(smmu, GBPA_ABORT, 0);
>  	}
>

This changes behaviour in !is_kdump_kernel() case. Is that
ok/intended?

Best regards,
     								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl0Gm6wACgkQMOfwapXb+vL0pQCgqLA/bem8NVC1lT8LN2u7MclX
Is0AoKmqyUk8s8kGfeLWjcW57gvEPwyL
=LnpM
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
