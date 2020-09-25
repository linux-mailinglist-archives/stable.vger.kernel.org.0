Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB4A278245
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 10:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgIYILQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 04:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgIYILM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 04:11:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F628C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 01:11:12 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kLioo-0007Qy-PY; Fri, 25 Sep 2020 10:11:02 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1kLion-0008H6-SP; Fri, 25 Sep 2020 10:11:01 +0200
Date:   Fri, 25 Sep 2020 10:11:01 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Message-ID: <20200925081101.dthsj4hokqz2vsgp@pengutronix.de>
References: <20200917122029.11121-1-ceggers@arri.de>
 <20200917122029.11121-2-ceggers@arri.de>
 <20200917140235.igfq2hq63f4qqhrr@pengutronix.de>
 <16013235.tl8pWZfNaG@n95hx1g2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rpqafbpfmp6buotd"
Content-Disposition: inline
In-Reply-To: <16013235.tl8pWZfNaG@n95hx1g2>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rpqafbpfmp6buotd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2020 at 04:13:50PM +0200, Christian Eggers wrote:
> Hello Uwe,
>=20
> On Thursday, 17 September 2020, 16:02:35 CEST, Uwe Kleine-K=F6nig wrote:
> > Hello,
> >
> > On Thu, Sep 17, 2020 at 02:20:27PM +0200, Christian Eggers wrote:
> > ...
> > >             /* check for arbitration lost */
> > >             if (temp & I2SR_IAL) {
> > >                     temp &=3D ~I2SR_IAL;
> > > +                   temp |=3D (i2c_imx->hwdata->i2sr_clr_opcode & I2S=
R_IAL);
> > >                     imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
> > >                     return -EAGAIN;
> > ...
>=20
> > This looks strange. First the flag is cleared and then it is (in some
> > cases) set again.
> i.MX controllers require writing a 0 to clear these bits. Vybrid controll=
ers
> need writing a 1 for the same.

Yes, I understood that.

> > If I2SR_IIF is set in temp you ack this irq without handling it. (Which
> > might happen if atomic is set and irqs are off?!)
> This patch is only about using the correct processor specific value for
> acknowledging an IRQ... But I think that returning EAGAIN (which aborts t=
he
> transfer) should be handling enough. At the next transfer, the controller=
 will
> be set back to master mode.

Either you didn't understand what I meant, or I don't understand why you
consider your patch right anyhow. So I try to explain in other and more
words.

IMHO the intention here (and also what happens on i.MX) is that exactly
the AL interrupt pending bit should be cleared and the IF irq is
supposed to be untouched.

Given there are only two irq flags in the I2SR register (which is called
IBSR on Vybrid) the status quo (i.e. without your patch) is:

  On i.MX IAL is cleared
  On Vybrid IIF (which is called IBIF there) is cleared.

With your patch we get:

  On i.MX IAL is cleared
  On Vybrid both IIF (aka IBIF) and IAL (aka IBAL) are cleared.

To get it right for both SoC types you have to do (e.g.):

	temp =3D ~i2c_imx->hwdata->i2sr_clr_opcode ^ I2SR_IAL;

(and in i2c_imx_isr() the same using I2SR_IIF instead of I2SR_IAL
because there currently IAL might be cleared by mistake on Vybrid).

I considered creating a patch, but as I don't have a Vybrid on my desk
and on i.MX there is no change, I let you do this.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--rpqafbpfmp6buotd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAl9tphIACgkQwfwUeK3K
7AneRwf+JcnV53qWQCh7RldBTTEDQwDlmjS9dhIIry/Q+bGBQK+1cCSKTnEsXPAD
eK9uKw9avB1/AjErj47M0zg+jvq7Sj8t7xVmLFhXmN4WfHQ84tVPgqedTExMgLWz
VD2Kz66Grhic1FS8/NPI/GtTHjuFVw5TsSmmzCVDZHPeDMXgnmamWpU7pvwyz8uS
ytQIIFouibq4TY/otlP9xaib6kxQr4qJYJ/uz+TpMdBMatDl/L2PQ8po2p5VylvD
8bAzJ7+uhqISfh6ERiTEga0GJCzg/3Px4ZQqIDSxPuPH3c7PUBvd50jPpFzZKAyA
dLIkPtWTYyAY52l4kjK/PwOHpAmgXg==
=hldl
-----END PGP SIGNATURE-----

--rpqafbpfmp6buotd--
