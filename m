Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50774995A4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442165AbiAXUxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:53:36 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56536 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391925AbiAXUuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:50:04 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AB6CF1C0B76; Mon, 24 Jan 2022 21:41:48 +0100 (CET)
Date:   Mon, 24 Jan 2022 21:41:48 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Christian Eggers <ceggers@arri.de>, Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: Re: [PATCH 5.4 007/320] mtd: rawnand: gpmi: Add ERR007117 protection
 for nfc_apply_timings
Message-ID: <20220124204148.GB19321@duo.ucw.cz>
References: <20220124183953.750177707@linuxfoundation.org>
 <20220124183954.021297586@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <20220124183954.021297586@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit f53d4c109a666bf1a4883b45d546fba079258717 upstream.
>=20
> gpmi_io clock needs to be gated off when changing the parent/dividers of
> enfc_clk_root (i.MX6Q/i.MX6UL) respectively qspi2_clk_root (i.MX6SX).
> Otherwise this rate change can lead to an unresponsive GPMI core which
> results in DMA timeouts and failed driver probe:
=2E..

> @@ -2429,7 +2449,9 @@ static int gpmi_nfc_exec_op(struct nand_
>  	 */
>  	if (this->hw.must_apply_timings) {
>  		this->hw.must_apply_timings =3D false;
> -		gpmi_nfc_apply_timings(this);
> +		ret =3D gpmi_nfc_apply_timings(this);
> +		if (ret)
> +			return ret;
>  	}
> =20
>  	dev_dbg(this->dev, "%s: %d instructions\n", __func__, op->ninstrs);
>

AFAICT this leaks pm reference in the error case. Not sure what
variant is right, there, so...

Best regards,
								Pavel

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/=
raw/gpmi-nand/gpmi-nand.c
index 1b64c5a5140d..06840cff6945 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -2284,8 +2284,10 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
 	if (this->hw.must_apply_timings) {
 		this->hw.must_apply_timings =3D false;
 		ret =3D gpmi_nfc_apply_timings(this);
-		if (ret)
+		if (ret) {
+			pm_runtime_put_....(this->dev);
 			return ret;
+		}
 	}
=20
 	dev_dbg(this->dev, "%s: %d instructions\n", __func__, op->ninstrs);


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYe8PDAAKCRAw5/Bqldv6
8v7vAJoDfKtboxtAqFDCxbUgNCrwj/NDCwCgv3VjVjkIMPLCMGOdIpi+XjFLSjM=
=C1YM
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
