Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2B026DE82
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgIQO2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbgIQO2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 10:28:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E41C061355
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 07:02:45 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kIuUe-0000yr-Dp; Thu, 17 Sep 2020 16:02:36 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1kIuUd-0007sB-D8; Thu, 17 Sep 2020 16:02:35 +0200
Date:   Thu, 17 Sep 2020 16:02:35 +0200
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
Subject: Re: [PATCH 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Message-ID: <20200917140235.igfq2hq63f4qqhrr@pengutronix.de>
References: <20200917122029.11121-1-ceggers@arri.de>
 <20200917122029.11121-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hsjb7ttwvxthj4ux"
Content-Disposition: inline
In-Reply-To: <20200917122029.11121-2-ceggers@arri.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hsjb7ttwvxthj4ux
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thu, Sep 17, 2020 at 02:20:27PM +0200, Christian Eggers wrote:
> According to the "VFxxx Controller Reference Manual" (and the comment
> block starting at line 97), Vybrid requires writing a one for clearing
> an interrupt flag. Syncing with the method for clearing I2SR_IIF in
> i2c_imx_isr().
>=20
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/i2c/busses/i2c-imx.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> index 0ab5381aa012..d8b2e632dd10 100644
> --- a/drivers/i2c/busses/i2c-imx.c
> +++ b/drivers/i2c/busses/i2c-imx.c
> @@ -425,6 +425,7 @@ static int i2c_imx_bus_busy(struct imx_i2c_struct *i2=
c_imx, int for_busy, bool a
>  		/* check for arbitration lost */
>  		if (temp & I2SR_IAL) {
>  			temp &=3D ~I2SR_IAL;
> +			temp |=3D (i2c_imx->hwdata->i2sr_clr_opcode & I2SR_IAL);
>  			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
>  			return -EAGAIN;

This looks strange. First the flag is cleared and then it is (in some
cases) set again.

If I2SR_IIF is set in temp you ack this irq without handling it. (Which
might happen if atomic is set and irqs are off?!)

I see this idiom is used in a few more places in the driver already, I
didn't check but these might have the same problem maybe?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--hsjb7ttwvxthj4ux
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAl9jbHgACgkQwfwUeK3K
7AnqUggAgYDa1nLQExNfvQp94aJ/t79An/B/XcB5UDUqZ72sqiC6zOQnyYIFJui9
a9JZvsTefCEy2BCl88oV1HTpF6BybDDTEFOukk1z7PhDIK9tvfMxbuXZ+ZUdLzOn
fC0QHdwgfAzVm+hCTYUNIP6fyNnjsZb8TAVU4IHZnttKdVN7Yz6qAcMYWEWSCFL6
Tj/fheKBHs7/uwzOgjZk7D1IwM1GtjMn7O3jwOMioQs1uum092iiFFjeZX7ma/mE
G9wmBXniFtxWoxmWJmzxNE8QKA0ATuWV4GmKzpFzf0BuaypM8RfGHcSlbxvJnn8q
XanIVZM4uKj/je+xNideXjFmp7BU3A==
=eJd3
-----END PGP SIGNATURE-----

--hsjb7ttwvxthj4ux--
