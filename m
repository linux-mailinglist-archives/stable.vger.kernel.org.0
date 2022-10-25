Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5642360C3C1
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 08:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiJYGVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 02:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJYGVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 02:21:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230AB1BE92
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 23:21:39 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1onDJb-0007AK-Jt; Tue, 25 Oct 2022 08:21:31 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1onDJb-000G3y-C5; Tue, 25 Oct 2022 08:21:30 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1onDJZ-00ASFg-Hl; Tue, 25 Oct 2022 08:21:29 +0200
Date:   Tue, 25 Oct 2022 08:21:29 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Thierry Reding <thierry.reding@gmail.com>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] pwm: jz4740: Fix pin level of disabled TCU2
 channels, part 1
Message-ID: <20221025062129.drzltbavg6hrhv7r@pengutronix.de>
References: <20221024205213.327001-1-paul@crapouillou.net>
 <20221024205213.327001-2-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5xgfedwwwq7lvzdq"
Content-Disposition: inline
In-Reply-To: <20221024205213.327001-2-paul@crapouillou.net>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5xgfedwwwq7lvzdq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Oct 24, 2022 at 09:52:09PM +0100, Paul Cercueil wrote:
> The "duty > cycle" trick to force the pin level of a disabled TCU2
> channel would only work when the channel had been enabled previously.
>=20
> Address this issue by enabling the PWM mode in jz4740_pwm_disable
> (I know, right) so that the "duty > cycle" trick works before disabling
> the PWM channel right after.
>=20
> This issue went unnoticed, as the PWM pins on the majority of the boards
> tested would default to the inactive level once the corresponding TCU
> clock was enabled, so the first call to jz4740_pwm_disable() would not
> actually change the pin levels.
>=20
> On the GCW Zero however, the PWM pin for the backlight (PWM1, which is
> a TCU2 channel) goes active as soon as the timer1 clock is enabled.
> Since the jz4740_pwm_disable() function did not work on channels not
> previously enabled, the backlight would shine at full brightness from
> the moment the backlight driver would probe, until the backlight driver
> tried to *enable* the PWM output.
>=20
> With this fix, the PWM pins will be forced inactive as soon as
> jz4740_pwm_apply() is called (and might be reconfigured to active if
> dictated by the pwm_state). This means that there is still a tiny time
> frame between the .request() and .apply() callbacks where the PWM pin
> might be active. Sadly, there is no way to fix this issue: it is
> impossible to write a PWM channel's registers if the corresponding clock
> is not enabled, and enabling the clock is what causes the PWM pin to go
> active.
>=20
> There is a workaround, though, which complements this fix: simply
> starting the backlight driver (or any PWM client driver) with a "init"
> pinctrl state that sets the pin as an inactive GPIO. Once the driver is
> probed and the pinctrl state switches to "default", the regular PWM pin
> configuration can be used as it will be properly driven.
>=20
> Fixes: c2693514a0a1 ("pwm: jz4740: Obtain regmap from parent node")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Cc: stable@vger.kernel.org

OK, understood the issue. I think there is another similar issue: The
clk is get and enabled only in the .request() callback. The result is (I
think---depends on a few further conditions) that if you have the
backlight driver as a module and the bootloader enables the backlight to
show a splash screen, the backlight goes off because of the
clk_disable_unused initcall.

So the right thing to do is to get the clock in .probe(), and ensure it
is kept on if the PWM is running already. Then you can also enable the
counter in .probe() and don't care for it in the enable and disable
functions.

The init pinctrl then has to be on the PWM then, but that's IMHO ok.

Best regards
Uwe

PS: While looking into the driver I noticed that .request() uses
dev_err_probe(). That's wrong, this function is only supposed to be used
in .probe().

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--5xgfedwwwq7lvzdq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmNXgGYACgkQwfwUeK3K
7AnfjggAnEOBtXlPzcBwx8UedR+Wp2Bwl4cWaX4hA3RCsLJJRov0yjJ0x9r5HGBf
kE+ut8y6I42VSGXLwaPZAwqjNhiAP7NPvXyTOckvrgUk4UZXXmRYVHqrkP7UQRWI
mVyJWG0LPMd45Swx66Rkf6IDnDwgUTpP8ClZqFaZo/luiPz2kI8IJ1OYLNFTRxis
k/OPQWYLeFtM4QAZXjH1PJq1W4RGKR8jZZTvyDOZkEuT1f5vQyeMeCIXdv9CxvOE
1VU/x/FpAsppfw7LwbTSzjJ+31OdWCWBpqZ7uH5J4G115q4dtc7FD1cLVNOx3E+/
YsVQS9JuYF0B/YlX9qv8v5KAhWagkw==
=sVSE
-----END PGP SIGNATURE-----

--5xgfedwwwq7lvzdq--
