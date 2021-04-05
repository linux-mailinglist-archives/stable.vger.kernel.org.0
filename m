Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA95354385
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 17:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbhDEPma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 11:42:30 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49714 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237254AbhDEPma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 11:42:30 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1B2181C0B7D; Mon,  5 Apr 2021 17:42:22 +0200 (CEST)
Date:   Mon, 5 Apr 2021 17:42:21 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH 5.10 079/126] drm/tegra: sor: Grab runtime PM reference
 across reset
Message-ID: <20210405154221.GB305@amd>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085033.686284735@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <20210405085033.686284735@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> However, these functions alone don't provide any guarantees at the
> system level. Drivers need to ensure that the only a single consumer has
> access to the reset at the same time. In order for the SOR to be able to
> exclusively access its reset, it must therefore ensure that the SOR
> power domain is not powered off by holding on to a runtime PM reference
> to that power domain across the reset assert/deassert operation.

Yeah, but it should not leak the PM reference in the error handling.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel

diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 7b88261f57bb..b3b727b2a3c5 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -3125,21 +3125,21 @@ static int tegra_sor_init(struct host1x_client *cli=
ent)
 		if (err < 0) {
 			dev_err(sor->dev, "failed to acquire SOR reset: %d\n",
 				err);
-			return err;
+			goto maybe_put;
 		}
=20
 		err =3D reset_control_assert(sor->rst);
 		if (err < 0) {
 			dev_err(sor->dev, "failed to assert SOR reset: %d\n",
 				err);
-			return err;
+			goto maybe_put;
 		}
 	}
=20
 	err =3D clk_prepare_enable(sor->clk);
 	if (err < 0) {
 		dev_err(sor->dev, "failed to enable clock: %d\n", err);
-		return err;
+		goto maybe_put;
 	}
=20
 	usleep_range(1000, 3000);
@@ -3150,7 +3150,7 @@ static int tegra_sor_init(struct host1x_client *clien=
t)
 			dev_err(sor->dev, "failed to deassert SOR reset: %d\n",
 				err);
 			clk_disable_unprepare(sor->clk);
-			return err;
+			goto maybe_put;
 		}
=20
 		reset_control_release(sor->rst);
@@ -3171,6 +3171,11 @@ static int tegra_sor_init(struct host1x_client *clie=
nt)
 	}
=20
 	return 0;
+
+ maybe_put:
+	if (sor->rst)
+		pm_runtime_put(sor->dev);
+	return err;
 }
=20
 static int tegra_sor_exit(struct host1x_client *client)


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBrL90ACgkQMOfwapXb+vIE+wCdHHkpngng4wHW2vwssmWAFT9r
MlIAn15qzXAkKpR3X1Y2UnYe03EuuWqT
=9iYm
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
