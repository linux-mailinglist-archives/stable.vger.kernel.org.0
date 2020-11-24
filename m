Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093812C343C
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 23:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgKXWwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 17:52:41 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:48978 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgKXWwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 17:52:40 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 442061C0B78; Tue, 24 Nov 2020 23:52:38 +0100 (CET)
Date:   Tue, 24 Nov 2020 23:52:37 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 51/91] can: ti_hecc: Fix memleak in ti_hecc_probe
Message-ID: <20201124225237.GA12731@amd>
References: <20201123121809.285416732@linuxfoundation.org>
 <20201123121811.803791718@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20201123121811.803791718@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Zhang Qilong <zhangqilong3@huawei.com>
>=20
> [ Upstream commit 7968c7c79d3be8987feb8021f0c46e6866831408 ]
>=20
> In the error handling, we should goto the probe_exit_candev
> to free ndev to prevent memory leak.

Well, that's true.

Unfortunately, 4.19 version has way more exit paths than mainline, so
the fix is not nearly complete. Mainline code is fragile but okay.

> Fixes: dabf54dd1c63 ("can: ti_hecc: Convert TI HECC driver to DT  only dr=
iver")

I'm pretty sure problems were there before this commit.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 81a3fdd5e010..4400a1a7dbd0 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -897,7 +897,8 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "hecc");
 	if (!res) {
 		dev_err(&pdev->dev, "can't get IORESOURCE_MEM hecc\n");
-		return -EINVAL;
+		err =3D -EINVAL;
+		goto probe_exit_candev;
 	}
=20
 	priv->base =3D devm_ioremap_resource(&pdev->dev, res);
@@ -911,7 +912,8 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "hecc-ram");
 	if (!res) {
 		dev_err(&pdev->dev, "can't get IORESOURCE_MEM hecc-ram\n");
-		return -EINVAL;
+		err =3D -EINVAL;
+		goto probe_exit_candev;
 	}
=20
 	priv->hecc_ram =3D devm_ioremap_resource(&pdev->dev, res);
@@ -925,7 +927,8 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "mbx");
 	if (!res) {
 		dev_err(&pdev->dev, "can't get IORESOURCE_MEM mbx\n");
-		return -EINVAL;
+		err =3D -EINVAL;
+		goto probe_exit_candev;
 	}
=20
 	priv->mbx =3D devm_ioremap_resource(&pdev->dev, res);


--=20
http://www.livejournal.com/~pavelmachek

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+9jrUACgkQMOfwapXb+vJHNACeNctpl4WEfuB6GoxNeoOUzoyd
UM4AoI+9QA0ioS3HzbwnGuycX8Vclzpm
=Pwpl
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
