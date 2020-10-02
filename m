Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609D928107F
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 12:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387717AbgJBKVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 06:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJBKV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Oct 2020 06:21:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A282C0613D0
        for <stable@vger.kernel.org>; Fri,  2 Oct 2020 03:21:27 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kOIBV-0005MC-71; Fri, 02 Oct 2020 12:21:05 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1kOIBT-0000ks-6f; Fri, 02 Oct 2020 12:21:03 +0200
Date:   Fri, 2 Oct 2020 12:21:03 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Message-ID: <20201002102103.36uqajmvl5w2dqdv@pengutronix.de>
References: <20200917122029.11121-1-ceggers@arri.de>
 <16013235.tl8pWZfNaG@n95hx1g2>
 <20200925081101.dthsj4hokqz2vsgp@pengutronix.de>
 <3615207.ozermb6hxN@n95hx1g2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uqr4haxxluzemvr6"
Content-Disposition: inline
In-Reply-To: <3615207.ozermb6hxN@n95hx1g2>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uqr4haxxluzemvr6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Christian,

On Fri, Oct 02, 2020 at 10:01:30AM +0200, Christian Eggers wrote:
> On Friday, 25 September 2020, 10:11:01 CEST, Uwe Kleine-K=F6nig wrote:
> > On Thu, Sep 17, 2020 at 04:13:50PM +0200, Christian Eggers wrote:
> > IMHO the intention here (and also what happens on i.MX) is that exactly
> > the AL interrupt pending bit should be cleared and the IF irq is
> > supposed to be untouched.
>=20
> Yes.
>=20
> > Given there are only two irq flags in the I2SR register (which is called
> > IBSR on Vybrid) ...
>=20
> Vybrid:
> =3D=3D=3D=3D=3D=3D=3D
> +-------+-----+------+-----+------+-----+-----+------+------+
> | BIT   |  7  |  6   |  5  |  4   |  3  |  2  |  1   |  0   |
> +-------+-----+------+-----+------+-----+-----+------+------+
> | READ  | TCF | IAAS | IBB | IBAL |  0  | SRW | IBIF | RXAK |
> +-------+-----+------+-----+------+-----+-----+------+------+
> | WRITE |  -  |  -   |  -  | W1C  |  -  |  -  | W1C  |  -   |
> +-------+-----+------+-----+-^^^--+-----+-----+-^^^--+------+
>=20
> i.MX:
> =3D=3D=3D=3D=3D=3D=3D
> +-------+-----+------+-----+------+-----+-----+------+------+
> | BIT   |  7  |  6   |  5  |  4   |  3  |  2  |  1   |  0   |
> +-------+-----+------+-----+------+-----+-----+------+------+
> | READ  | ICF | IAAS | IBB | IAL  |  0  | SRW | IIF  | RXAK |
> +-------+-----+------+-----+------+-----+-----+------+------+
> | WRITE |  -  |  -   |  -  | W0C  |  -  |  -  | W0C  |  -   |
> +-------+-----+------+-----+-^^^--+-----+-----+-^^^--+------+
>=20
>=20
> > ... the status quo (i.e. without your patch) is:
> >
> >   On i.MX IAL is cleared
>=20
> Yes
>=20
> >   On Vybrid IIF (which is called IBIF there) is cleared.
> If IBIF is set, then it's cleared (probably by accident).
> But in the "if (temp & I2SR_IAL)" condition, I focus on
> the IBAL flag, not IBIF.
>=20
> > With your patch we get:
> >
> >   On i.MX IAL is cleared
>=20
> Yes
>=20
> >   On Vybrid both IIF (aka IBIF) and IAL (aka IBAL) are cleared.
> Agree. IBAL is cleared by intention, IBIF by accident (if set).
> Do you see any problem if IBIF is also cleared?

Yes. If there is a real problem I'm not sure, but it's enough of an
issue that there are possible side effects on Vybrid. I refuse to think
about real problems given that it is so easy to make it right.

> > To get it right for both SoC types you have to do (e.g.):
> >
> >       temp =3D ~i2c_imx->hwdata->i2sr_clr_opcode ^ I2SR_IAL;
> Sorry, even if this is correct, it looks hard to understand for me.

Maybe a comment would be appropriate, something like:

	/*
	 * i2sr_clr_opcode is the value to clear all interrupts. Here we
	 * want to clear no irq but I2SR_IAL, so we write
	 * ~i2sr_clr_opcode with just the I2SR_IAL bit toggled.
	 */

Maybe put this comment together with the code in a new function to have
it only once.

> > (and in i2c_imx_isr() the same using I2SR_IIF instead of I2SR_IAL
> > because there currently IAL might be cleared by mistake on Vybrid).
> >
> > I considered creating a patch, but as I don't have a Vybrid on my desk
> > and on i.MX there is no change, I let you do this.
> I also don't own a Vybrid system. I consider my patch correct in terms of
> clearing the IBAL flag (which was wrong before). Additional work may be
> useful for NOT clearing the other status flag. I also would like to keep
> this task for somebody who owns a Vybrid system. But the other patches
> in this series fixes some more important problems, so maybe you could
> give your acknowledge anyhow.

No, please don't replace one bug found by another (now) known bug. Still
more given that the newly introduced bug is much harder to trigger and
debug.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--uqr4haxxluzemvr6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAl92/wwACgkQwfwUeK3K
7Ak+DQf+MaEPQEwnlM7sKbV4xz4LkhYuGPFg3gJMv+4MPztBTEFbTmc7y5bhSFph
EkZi5lD5o/jQ9xpF+LAADxyqq7eAXf40F5evbDbSyWVEuX0DPq1xzfqrTtvokMD9
/bPOob4mFC6PHMgDhu3zHE+lhyfqEMa6/2711JPxoR0XkjZeqlCSv7E8+cY4i/2t
t1R8iWsTq3TqaKaTOuyI0KlAztBhaG/3r5Dbl3UQYNxBYPrlMlRobJz0Fb7ns8zO
J0Uwc/iGltNEylkpcP2X/PNhtT4CVmuwnSr4SdABszrKanW1vHRgv9z9sr2Btp+V
jGP50C5G5EWpQmzKQ9a4Qh7XAhFcAQ==
=SLBO
-----END PGP SIGNATURE-----

--uqr4haxxluzemvr6--
