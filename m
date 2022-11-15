Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F4A62A0E6
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 19:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiKOSAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 13:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238130AbiKOR7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 12:59:33 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B903CE24
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 09:58:51 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ov0Cd-0007GZ-E7; Tue, 15 Nov 2022 18:58:31 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:6ac2:39cd:4970:9b29])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5794211F780;
        Tue, 15 Nov 2022 17:58:29 +0000 (UTC)
Date:   Tue, 15 Nov 2022 18:58:21 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Frieder Schrempf <frieder@fris.de>,
        David Jander <david@protonic.nl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Marek Vasut <marex@denx.de>,
        NXP Linux Team <linux-imx@nxp.com>, stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Baruch Siach <baruch.siach@siklu.com>,
        Fabio Estevam <festevam@gmail.com>,
        Minghao Chi <chi.minghao@zte.com.cn>
Subject: Re: [PATCH v2] spi: spi-imx: Fix spi_bus_clk if requested clock is
 higher than input clock
Message-ID: <20221115175821.4hs7k35fkxwkvew4@pengutronix.de>
References: <20221115162654.2016820-1-frieder@fris.de>
 <20221115165413.4tvmhiv64gdmctml@pengutronix.de>
 <06f8339c-4be1-159f-9374-ef8e6031da1e@kontron.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="k7skofa35hxg3udw"
Content-Disposition: inline
In-Reply-To: <06f8339c-4be1-159f-9374-ef8e6031da1e@kontron.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k7skofa35hxg3udw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.11.2022 18:14:38, Frieder Schrempf wrote:
> On 15.11.22 17:54, Marc Kleine-Budde wrote:
> > On 15.11.2022 17:26:53, Frieder Schrempf wrote:
> >> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> >>
> >> In case the requested bus clock is higher than the input clock, the co=
rrect
> >> dividers (pre =3D 0, post =3D 0) are returned from mx51_ecspi_clkdiv()=
, but
> >> *fres is left uninitialized and therefore contains an arbitrary value.
> >>
> >> This causes trouble for the recently introduced PIO polling feature as=
 the
> >> value in spi_imx->spi_bus_clk is used there to calculate for which
> >> transfers to enable PIO polling.
> >>
> >> Fix this by setting *fres even if no clock dividers are in use.
> >>
> >> This issue was observed on Kontron BL i.MX8MM with an SPI peripheral c=
lock set
> >> to 50 MHz by default and a requested SPI bus clock of 80 MHz for the S=
PI NOR
> >> flash.
> >>
> >> With the fix applied the debug message from mx51_ecspi_clkdiv() now pr=
ints the
> >> following:
> >>
> >> spi_imx 30820000.spi: mx51_ecspi_clkdiv: fin: 50000000, fspi: 50000000,
> >> post: 0, pre: 0
> >>
> >> Fixes: 07e759387788 ("spi: spi-imx: add PIO polling support")
>=20
> You want me to remove this tag?
>=20
> > The *fres parameter was introduced in:
> >=20
> > | Fixes: 6fd8b8503a0d ("spi: spi-imx: Fix out-of-order CS/SCLK operatio=
n at low speeds")
>=20
> and instead add back this tag? I wasn't really sure about that.

Keep both.

> >=20
> > The exiting code:
> >=20
> > |	if (unlikely(fspi > fin))
> > |		return 0;
> >=20
> > was not sufficient any more and should be fixed.
>=20
> You want me to add this in the description? Or is this just the
> explanation for why 6fd8b8503a0d should be in the Fixes tag?

No need to add the explanation to the patch.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--k7skofa35hxg3udw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNz0zoACgkQrX5LkNig
013UuwgAtv41tt1zXsWdLJ3pCyevuYY1FXRc3xhiFmuFZqEHQfpQ18i8PUYqxXPK
djB3VfGjq4VuPvRBl/Zeei1ccW0XSQ/uwUjzFQHzZFE3+Sk0cGE/A8BkK4DrQtoU
3DSaR1WHgM7ntoVOPGHiVs+r3Ab791LyFW4n7oZBqI5dRkyDe9avNbHghd76cfOe
ytXqJ9MzcFw3w1c/Fo43/wHv1ATcC8kBYHL4kw4B3Duo3iXMQlgY0XcATRCjetBf
L33EaAhGF3wJ0zV/SpXlY2mzUm2zqNN5RhiZz7JoZbev6R+uEsP2n6vOc8TKKe6d
utjHIxqXthrl1NQa9b7EJOA0TTK5Eg==
=sHfi
-----END PGP SIGNATURE-----

--k7skofa35hxg3udw--
