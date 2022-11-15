Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F199E629FAB
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 17:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiKOQyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 11:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233044AbiKOQyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 11:54:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3891F1CFF4
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 08:54:45 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ouzCc-0007iv-CD; Tue, 15 Nov 2022 17:54:26 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:6ac2:39cd:4970:9b29])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6717211F6D8;
        Tue, 15 Nov 2022 16:54:22 +0000 (UTC)
Date:   Tue, 15 Nov 2022 17:54:13 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frieder Schrempf <frieder@fris.de>
Cc:     David Jander <david@protonic.nl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Marek Vasut <marex@denx.de>,
        NXP Linux Team <linux-imx@nxp.com>, stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Baruch Siach <baruch.siach@siklu.com>,
        Fabio Estevam <festevam@gmail.com>,
        Minghao Chi <chi.minghao@zte.com.cn>
Subject: Re: [PATCH v2] spi: spi-imx: Fix spi_bus_clk if requested clock is
 higher than input clock
Message-ID: <20221115165413.4tvmhiv64gdmctml@pengutronix.de>
References: <20221115162654.2016820-1-frieder@fris.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ewz52byjukhww6c4"
Content-Disposition: inline
In-Reply-To: <20221115162654.2016820-1-frieder@fris.de>
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


--ewz52byjukhww6c4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.11.2022 17:26:53, Frieder Schrempf wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>=20
> In case the requested bus clock is higher than the input clock, the corre=
ct
> dividers (pre =3D 0, post =3D 0) are returned from mx51_ecspi_clkdiv(), b=
ut
> *fres is left uninitialized and therefore contains an arbitrary value.
>=20
> This causes trouble for the recently introduced PIO polling feature as the
> value in spi_imx->spi_bus_clk is used there to calculate for which
> transfers to enable PIO polling.
>=20
> Fix this by setting *fres even if no clock dividers are in use.
>=20
> This issue was observed on Kontron BL i.MX8MM with an SPI peripheral cloc=
k set
> to 50 MHz by default and a requested SPI bus clock of 80 MHz for the SPI =
NOR
> flash.
>=20
> With the fix applied the debug message from mx51_ecspi_clkdiv() now print=
s the
> following:
>=20
> spi_imx 30820000.spi: mx51_ecspi_clkdiv: fin: 50000000, fspi: 50000000,
> post: 0, pre: 0
>=20
> Fixes: 07e759387788 ("spi: spi-imx: add PIO polling support")

The *fres parameter was introduced in:

| Fixes: 6fd8b8503a0d ("spi: spi-imx: Fix out-of-order CS/SCLK operation at=
 low speeds")

The exiting code:

|	if (unlikely(fspi > fin))
|		return 0;

was not sufficient any more and should be fixed.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ewz52byjukhww6c4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNzxDMACgkQrX5LkNig
0110Zgf/Rqhnp8+E6FdaZsP6cCH4rkGX9yPjEfdoke2AoOZYNlE2+z/TNpYclQ5D
bTbfVjwa8E68JFsqUBwCoAY68xQ0N53ijC65ziL1veRdOJafpCIAUU12USeDCSvX
JzIQPTfzpzsHJyQqUoShoP4BGCZI0k56WQndSs2nrOcQku1u8XYuLlJHDyi8LhI4
p+W+o8Efaszewd4IuIrYPROrKA+FHGN4PHQh4UjQtICIWoFWQhaE4p0OeLY4yLph
Rf1/i+yrrxhciog1YkHEAqQfdofcCSAq6NrZo9/MdXQwiRCXyhDhe+L0YOfvXQn3
IGHS49ow9mnNg/LLLUUKOHDqzOcNvA==
=bbCr
-----END PGP SIGNATURE-----

--ewz52byjukhww6c4--
