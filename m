Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37474204AF8
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 09:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgFWHZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 03:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730830AbgFWHZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 03:25:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED479C061573
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 00:25:38 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1jndJH-0000sL-GZ; Tue, 23 Jun 2020 09:25:35 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1jndJG-0000Zs-Fe; Tue, 23 Jun 2020 09:25:34 +0200
Date:   Tue, 23 Jun 2020 09:25:34 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, paul@crapouillou.net,
        stable@vger.kernel.org, thierry.reding@gmail.com
Subject: Re: FAILED: patch "[PATCH] pwm: jz4740: Enhance precision in
 calculation of duty cycle" failed to apply to 5.4-stable tree
Message-ID: <20200623072534.pw4t4bi3klz57wce@taurus.defre.kleine-koenig.org>
References: <1592574307840@kroah.com>
 <20200623003943.GQ1931@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6xfbb6cikvhnivcm"
Content-Disposition: inline
In-Reply-To: <20200623003943.GQ1931@sasha-vm>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6xfbb6cikvhnivcm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2020 at 08:39:43PM -0400, Sasha Levin wrote:
> On Fri, Jun 19, 2020 at 03:45:07PM +0200, gregkh@linuxfoundation.org wrot=
e:
> >=20
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.

See below for a backport.

> > thanks,
> >=20
> > greg k-h
> >=20
> > ------------------ original commit in Linus's tree ------------------
> >=20
> > From 9017dc4fbd59c09463019ce494cfe36d654495a8 Mon Sep 17 00:00:00 2001
> > From: Paul Cercueil <paul@crapouillou.net>
> > Date: Wed, 27 May 2020 13:52:23 +0200
> > Subject: [PATCH] pwm: jz4740: Enhance precision in calculation of duty =
cycle
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=3DUTF-8
> > Content-Transfer-Encoding: 8bit
> >=20
> > Calculating the hardware value for the duty from the hardware value of
> > the period resulted in a precision loss versus calculating it from the
> > clock rate directly.
> >=20
> > (Also remove a cast that doesn't really need to be here)
> >=20
> > Fixes: f6b8a5700057 ("pwm: Add Ingenic JZ4740 support")
> > Cc: <stable@vger.kernel.org>
> > Suggested-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > Reviewed-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> > Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
>=20
> I suspect that the fixes tag should have been pointing to ce1f9cece057
> ("pwm: jz4740: Use clocks from TCU driver") instead.

No, f6b8a5700057 is right. The cast that was dropped isn't there, but
the suboptimal calculation is.

The backport on top of 5.4.y looks as follows:

=46rom b39d3d4c6ba4b7ba8b97a0f7e650924920e4d95c Mon Sep 17 00:00:00 2001
=46rom: Paul Cercueil <paul@crapouillou.net>
Date: Wed, 27 May 2020 13:52:23 +0200
Subject: [PATCH] pwm: jz4740: Enhance precision in calculation of duty cycle
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

commit 9017dc4fbd59c09463019ce494cfe36d654495a8 upstream.

Calculating the hardware value for the duty from the hardware value of
the period resulted in a precision loss versus calculating it from the
clock rate directly.

Fixes: f6b8a5700057 ("pwm: Add Ingenic JZ4740 support")
Cc: <stable@vger.kernel.org>
Suggested-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Reviewed-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
[ukl: backport to v5.4.y and adapt commit log accordingly]
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
---
 drivers/pwm/pwm-jz4740.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
index 9d78cc21cb12..d0f5c69930d0 100644
--- a/drivers/pwm/pwm-jz4740.c
+++ b/drivers/pwm/pwm-jz4740.c
@@ -108,8 +108,8 @@ static int jz4740_pwm_apply(struct pwm_chip *chip, stru=
ct pwm_device *pwm,
 	if (prescaler =3D=3D 6)
 		return -EINVAL;
=20
-	tmp =3D (unsigned long long)period * state->duty_cycle;
-	do_div(tmp, state->period);
+	tmp =3D (unsigned long long)rate * state->duty_cycle;
+	do_div(tmp, NSEC_PER_SEC);
 	duty =3D period - tmp;
=20
 	if (duty >=3D period)

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--6xfbb6cikvhnivcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAl7xrmsACgkQwfwUeK3K
7AlH9wf+LpV6Egq9iB4LpNxtJQ5q22BwcWa+bQNzen6wO1rLNypfDNl4oWB9V0V5
xgQ/Yg3Kb/eElh7g1hjXRbft08triElxeNqHiYtWqzLAcMxPUgfhSKKhS1rG0FWY
zvcIWGDlEWz2xCM1v/KTdCAGh8Ox2LsOPX1/ngyBIfzQUBRPSLR4jRoSYF5J1plP
QtWiGR7fSZWh6mom5gyHEsDa8oQiw6WyrOgA2DDpi2trcFHWmXlvZ4AgjSS7DhAu
tn20ZBFI2OQgKn6mgxCcEtMX0Aq2oXsAz5UJwSjWCOtIAU7mpCV17MWeefjYiTRr
9rg/lLdU60E80+WvdwvVOfI21NgQrQ==
=DL0J
-----END PGP SIGNATURE-----

--6xfbb6cikvhnivcm--
