Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84512845C9
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 08:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgJFGFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 02:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgJFGFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 02:05:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E75C0613A8
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 23:05:39 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kPg6L-0000oO-Ed; Tue, 06 Oct 2020 08:05:29 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1kPg6K-0008VL-6x; Tue, 06 Oct 2020 08:05:28 +0200
Date:   Tue, 6 Oct 2020 08:05:28 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Message-ID: <20201006060528.drh2yoo2dklyntez@pengutronix.de>
References: <20201002152305.4963-1-ceggers@arri.de>
 <20201002152305.4963-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="beidewvdqrs5sqid"
Content-Disposition: inline
In-Reply-To: <20201002152305.4963-2-ceggers@arri.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--beidewvdqrs5sqid
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 02, 2020 at 05:23:03PM +0200, Christian Eggers wrote:
> According to the "VFxxx Controller Reference Manual" (and the comment
> block starting at line 97), Vybrid requires writing a one for clearing
> an interrupt flag. Syncing the method for clearing I2SR_IIF in
> i2c_imx_isr().
>=20
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/i2c/busses/i2c-imx.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> index 0ab5381aa012..34648df7f1a6 100644
> --- a/drivers/i2c/busses/i2c-imx.c
> +++ b/drivers/i2c/busses/i2c-imx.c
> @@ -424,7 +424,12 @@ static int i2c_imx_bus_busy(struct imx_i2c_struct *i=
2c_imx, int for_busy, bool a
> =20
>  		/* check for arbitration lost */
>  		if (temp & I2SR_IAL) {
> -			temp &=3D ~I2SR_IAL;
> +			/*
> +			 * i2sr_clr_opcode is the value to clear all interrupts.
> +			 * Here we want to clear only I2SR_IAL, so we write
> +			 * ~i2sr_clr_opcode with just the I2SR_IAL bit toggled.
> +			 */
> +			temp =3D ~i2c_imx->hwdata->i2sr_clr_opcode ^ I2SR_IAL;
>  			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
>  			return -EAGAIN;

Could we please move clearing an irq to a dedicated function? Such that
it looks like:

	/* check for arbitration lost */
	if (temp & I2SR_IAL) {
		i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
		return -EAGAIN;
	}

Then you also don't need to duplicate the describing comment but just
add it to the implementation of i2c_imx_clear_irq().

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--beidewvdqrs5sqid
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAl98CSUACgkQwfwUeK3K
7Am04Af+OTHNZcf5HD/6YfTPax3ijKMVsrDbdquTlavc18g1lO3D/xaDPAY5mi36
bh/qE6BmZhlIkmUMK01v48HMbItfQsI7B+r5qVoVdH6RXzsNC9nHsoHwcyULBba4
apXyv5v1gmySyFiyA+udRI38vv4+4NPX48YAiKIFuMl7TYzI8wFNYQmaywWVvAya
tGy06ddMFv5Sz5gIlm0wxNZ54L1UPSdvxFtzdkWPD98liHG7hxNK0EsmAwNfherR
0lhL9CpNcP49RSEgI6wYOEAWCc4iRWoZ1C/hGQWkL58mttTv8TaCGuzgGvjR6yC/
+Lb/zwLwG5jqdfSEiLjMUvUTMF4JLw==
=RlAA
-----END PGP SIGNATURE-----

--beidewvdqrs5sqid--
