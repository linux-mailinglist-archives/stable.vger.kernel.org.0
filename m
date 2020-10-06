Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E43284BED
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 14:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgJFMqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 08:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgJFMqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 08:46:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7CFC061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 05:46:17 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kPmLz-00015o-Oc; Tue, 06 Oct 2020 14:46:03 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1kPmLy-0006tB-GM; Tue, 06 Oct 2020 14:46:02 +0200
Date:   Tue, 6 Oct 2020 14:46:02 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Christian Eggers' <ceggers@arri.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Message-ID: <20201006124602.oxfyzb3atoju7sva@pengutronix.de>
References: <20201006060528.drh2yoo2dklyntez@pengutronix.de>
 <20201006105135.28985-1-ceggers@arri.de>
 <20201006105135.28985-2-ceggers@arri.de>
 <f8f1a9f54e0e426dbe27cc13a3b9de8d@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4ptqo3najheuyrhr"
Content-Disposition: inline
In-Reply-To: <f8f1a9f54e0e426dbe27cc13a3b9de8d@AcuMS.aculab.com>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4ptqo3najheuyrhr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 06, 2020 at 12:06:36PM +0000, David Laight wrote:
> From: Christian Eggers
> > Sent: 06 October 2020 11:52
> >=20
> > According to the "VFxxx Controller Reference Manual" (and the comment
> > block starting at line 97), Vybrid requires writing a one for clearing
> > an interrupt flag. Syncing the method for clearing I2SR_IIF in
> > i2c_imx_isr().
> >=20
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/i2c/busses/i2c-imx.c | 20 +++++++++++++++-----
> >  1 file changed, 15 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> > index 0ab5381aa012..745f4071155a 100644
> > --- a/drivers/i2c/busses/i2c-imx.c
> > +++ b/drivers/i2c/busses/i2c-imx.c
> > @@ -412,6 +412,19 @@ static void i2c_imx_dma_free(struct imx_i2c_struct=
 *i2c_imx)
> >  	dma->chan_using =3D NULL;
> >  }
> >=20
> > +static void i2c_imx_clear_irq(struct imx_i2c_struct *i2c_imx, unsigned=
 int bits)
> > +{
> > +	unsigned int temp;
> > +
> > +	/*
> > +	 * i2sr_clr_opcode is the value to clear all interrupts.
> > +	 * Here we want to clear only <bits>, so we write
> > +	 * ~i2sr_clr_opcode with just <bits> toggled.
> > +	 */
> > +	temp =3D ~i2c_imx->hwdata->i2sr_clr_opcode ^ bits;
> > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
> > +}
>=20
> That looks either wrong or maybe just overcomplicated.
> Why isn't:
> 	imx_i2c_write_reg(bits, i2c_imx, IMX_I2C_I2SR);
> enough?

Your question suggests you either didn't read the comment or the comment
is not good enough. Maybe once you understood the complication (see
Christian's mail) you could suggest a better wording? Maybe we have to
mention that this handles both W1C and W0C.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--4ptqo3najheuyrhr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAl98ZwcACgkQwfwUeK3K
7AmylQf/RskD0N9+yhyywvgjG322YOktL1246GkcwmvR/dJ+O+lswlwLkHVaIj1K
gSStkM2SIsCr4gQazLjqZH3Yw59Tglnm40pABuq2hGeShFc1Q60C3GwAj0LYruOo
HLeD0ava0h3rJWrqdms2jxX7g4N3G5Teix1kJj9TuUu+XAtVib43WhO+wuoIq2JM
gicKSpRXodc8ZkwejYEoZ2U/gmpG0OjWgB2w3ZTsWuA2GZxVX4WAKeLV8ow5Isup
iAhIhLYHXkz2kjGey5lDLL/t6GRw+3TxcUieg1tbU4PPJ1Fndpat54OnmASXh2FQ
sXBCkrYImLusaVZt0BRVCMonIgKi2Q==
=LC/7
-----END PGP SIGNATURE-----

--4ptqo3najheuyrhr--
