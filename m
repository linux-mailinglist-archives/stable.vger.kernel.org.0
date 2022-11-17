Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1F762DCBE
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 14:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbiKQN3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 08:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239964AbiKQN3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 08:29:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1228716E5
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 05:29:36 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1ovexO-0005Hp-6O; Thu, 17 Nov 2022 14:29:30 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1ovexM-004rWq-1M; Thu, 17 Nov 2022 14:29:28 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1ovexM-00HHrg-1B; Thu, 17 Nov 2022 14:29:28 +0100
Date:   Thu, 17 Nov 2022 14:29:27 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Thierry Reding <thierry.reding@gmail.com>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] pwm: jz4740: Fix pin level of disabled TCU2
 channels, part 1
Message-ID: <20221117132927.mom5klfd4eww5amk@pengutronix.de>
References: <20221024205213.327001-1-paul@crapouillou.net>
 <20221024205213.327001-2-paul@crapouillou.net>
 <20221025062129.drzltbavg6hrhv7r@pengutronix.de>
 <CVZAKR.06MA7BGA170W3@crapouillou.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xsmjk3h2yzdssoiw"
Content-Disposition: inline
In-Reply-To: <CVZAKR.06MA7BGA170W3@crapouillou.net>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
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


--xsmjk3h2yzdssoiw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Paul,

On Tue, Oct 25, 2022 at 11:02:00AM +0100, Paul Cercueil wrote:
> Le mar. 25 oct. 2022 =E0 08:21:29 +0200, Uwe Kleine-K=F6nig
> <u.kleine-koenig@pengutronix.de> a =E9crit :
> > Hello,
> >=20
> > On Mon, Oct 24, 2022 at 09:52:09PM +0100, Paul Cercueil wrote:
> > >  The "duty > cycle" trick to force the pin level of a disabled TCU2
> > >  channel would only work when the channel had been enabled
> > > previously.
> > >=20
> > >  Address this issue by enabling the PWM mode in jz4740_pwm_disable
> > >  (I know, right) so that the "duty > cycle" trick works before
> > > disabling
> > >  the PWM channel right after.
> > >=20
> > >  This issue went unnoticed, as the PWM pins on the majority of the
> > > boards
> > >  tested would default to the inactive level once the corresponding
> > > TCU
> > >  clock was enabled, so the first call to jz4740_pwm_disable() would
> > > not
> > >  actually change the pin levels.
> > >=20
> > >  On the GCW Zero however, the PWM pin for the backlight (PWM1, which
> > > is
> > >  a TCU2 channel) goes active as soon as the timer1 clock is enabled.
> > >  Since the jz4740_pwm_disable() function did not work on channels not
> > >  previously enabled, the backlight would shine at full brightness
> > > from
> > >  the moment the backlight driver would probe, until the backlight
> > > driver
> > >  tried to *enable* the PWM output.
> > >=20
> > >  With this fix, the PWM pins will be forced inactive as soon as
> > >  jz4740_pwm_apply() is called (and might be reconfigured to active if
> > >  dictated by the pwm_state). This means that there is still a tiny
> > > time
> > >  frame between the .request() and .apply() callbacks where the PWM
> > > pin
> > >  might be active. Sadly, there is no way to fix this issue: it is
> > >  impossible to write a PWM channel's registers if the corresponding
> > > clock
> > >  is not enabled, and enabling the clock is what causes the PWM pin
> > > to go
> > >  active.
> > >=20
> > >  There is a workaround, though, which complements this fix: simply
> > >  starting the backlight driver (or any PWM client driver) with a
> > > "init"
> > >  pinctrl state that sets the pin as an inactive GPIO. Once the
> > > driver is
> > >  probed and the pinctrl state switches to "default", the regular PWM
> > > pin
> > >  configuration can be used as it will be properly driven.
> > >=20
> > >  Fixes: c2693514a0a1 ("pwm: jz4740: Obtain regmap from parent node")
> > >  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> > >  Cc: stable@vger.kernel.org
> >=20
> > OK, understood the issue. I think there is another similar issue: The
> > clk is get and enabled only in the .request() callback. The result is (I
> > think---depends on a few further conditions) that if you have the
> > backlight driver as a module and the bootloader enables the backlight to
> > show a splash screen, the backlight goes off because of the
> > clk_disable_unused initcall.
>=20
> I will have to verify, but I'm pretty sure disabling the clock doesn't
> change the pin level back to inactive.

Given that you set the clk's rate depending on the period to apply, I'd
claim that you need to keep the clk on. Maybe it doesn't hurt, because
another component of the system keeps the clk running, but it's wrong
anyhow. Assumptions like these tend to break on new chip revisions.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--xsmjk3h2yzdssoiw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmN2NzQACgkQwfwUeK3K
7AksvQf9EZfAv7iQBz9ZFUNDv/rCJVBR7ECu9o6TMX63AUmUcgxYFG5meUqypxK0
jRfD2P6pHB4+cL7W0D4L3t4vA5sS9tfl4egGC4y6wI05ircgRVaUIZfH+t+jjHlb
c2aOxTQ/eg65jyCkD+tNIE5BPPieMOojXat7rteGQok1JUEZfTMp21hygPYRBKiG
v5ILRExvbJaC1CYKyfw67P6mVazYfaQMU2UKGbpSHtO+yekIQas26hekUh1i81qC
Rk7OIMEGLQdMUISVvLtuNXVWRnCXW6GaC90eYrTcdPVpeyhQi7NJaUc6JMWT6Vdv
W+L1jN0wGwtWNsyy4zjgGnrGQis2zw==
=VCuW
-----END PGP SIGNATURE-----

--xsmjk3h2yzdssoiw--
