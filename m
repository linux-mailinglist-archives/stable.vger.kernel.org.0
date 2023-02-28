Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653CD6A5675
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 11:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjB1KQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 05:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjB1KQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 05:16:11 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F55D2A6CA
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 02:16:08 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pWx1c-00047a-4O; Tue, 28 Feb 2023 11:16:00 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pWx1a-000qPj-Ug; Tue, 28 Feb 2023 11:15:58 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pWx1a-000zTY-9Q; Tue, 28 Feb 2023 11:15:58 +0100
Date:   Tue, 28 Feb 2023 11:15:58 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Munehisa Kamata <kamatam@amazon.com>
Cc:     thierry.reding@gmail.com, tobetter@gmail.com,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] pwm: Zero-initialize the pwm_state passed to driver's
 .get_state()
Message-ID: <20230228101558.b4dosk54jojfqkgi@pengutronix.de>
References: <20230226013722.1802842-1-kamatam@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bd76unbsfstrl6f7"
Content-Disposition: inline
In-Reply-To: <20230226013722.1802842-1-kamatam@amazon.com>
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


--bd76unbsfstrl6f7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is just to ensure that .usage_power is properly initialized and
doesn't contain random stack data. The other members of struct pwm_state
should get a value assigned in a successful call to .get_state(). So in
the absence of bugs in driver implementations, this is only a safe-guard
and no fix.

Reported-by: Munehisa Kamata <kamatam@amazon.com>
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
---
 drivers/pwm/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Hello,

On Sat, Feb 25, 2023 at 05:37:21PM -0800, Munehisa Kamata wrote:
> Zero-initialize the on-stack structure to avoid unexpected behaviors. Some
> drivers may not set or initialize all the values in pwm_state through the=
ir
> .get_state() callback and therefore some random values may remain there a=
nd
> be set into pwm->state eventually.
>=20
> This actually caused regression on ODROID-N2+ as reported in [1]; kernel
> fails to boot due to random panic or hang-up.
>=20
> [1] https://forum.odroid.com/viewtopic.php?f=3D177&t=3D46360
>=20
> Fixes: c73a3107624d ("pwm: Handle .get_state() failures")
> Cc: stable@vger.kernel.org # 6.2
> Signed-off-by: Munehisa Kamata <kamatam@amazon.com>

My patch is essentially the same as Munehisa's, just written a bit
differently (to maybe make it easier for the compiler to optimize it?)
and with an explaining comment. The actual motivation is different so
the commit log is considerably different, too.

I was unsure how to honor Munehisa's effort, I went with a
"Reported-by". Please tell me if you want this to be different.

Best regards
Uwe

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index e01147f66e15..533ef5bd3add 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -115,7 +115,14 @@ static int pwm_device_request(struct pwm_device *pwm, =
const char *label)
 	}
=20
 	if (pwm->chip->ops->get_state) {
-		struct pwm_state state;
+		/*
+		 * Zero-initialize state because most drivers are unaware of
+		 * .usage_power. The other members of state are supposed to be
+		 * set by lowlevel drivers. We still initialize the whole
+		 * structure for simplicity even though this might paper over
+		 * faulty implementations of .get_state().
+		 */
+		struct pwm_state state =3D { 0, };
=20
 		err =3D pwm->chip->ops->get_state(pwm->chip, pwm, &state);
 		trace_pwm_get(pwm, &state, err);
--=20
2.39.1


--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--bd76unbsfstrl6f7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmP91FsACgkQwfwUeK3K
7AmsCgf/eRMqDHCB9MFwz2J4+eO1GBN7uA8nfwjMVBT2RMbZ3fIRsKehLMgz/HHs
FFDZp+RYpiglA8jxVrWf3yJxHu3ZIIyavmLXHZxG1meao2qqnNg76wyVMlbbfe3t
ijzvxJzB130a4dRbxuexptTHLhQLA8e1K7lEOxbFARo58sCmajWT0xRPM2wzX1gq
FmsZOtv2ZiBPYTyMl1tdKeRskNSf18xj2toDPKyrMtZquOJLbd+UBTmepChzgrVW
YSpl4QLDhvUY40Ro/tOdJZiQGlkqpuJNCvfSSQPl/8UOFkKhbqETB3EArBW3SWOR
iioBTB1fWXG1wsWUV8oX0wgVdUX3AA==
=55iK
-----END PGP SIGNATURE-----

--bd76unbsfstrl6f7--
