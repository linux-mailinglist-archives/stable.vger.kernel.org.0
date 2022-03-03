Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5214C4CC870
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 22:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiCCV5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 16:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiCCV5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 16:57:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A295341FA1
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 13:56:55 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nPtRG-0006SQ-4Q; Thu, 03 Mar 2022 22:56:46 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nPtRF-002UFJ-A5; Thu, 03 Mar 2022 22:56:44 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nPtRD-006n2H-UC; Thu, 03 Mar 2022 22:56:43 +0100
Date:   Thu, 3 Mar 2022 22:56:40 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Max Kellermann <max.kellermann@gmail.com>
Cc:     linux-pwm@vger.kernel.org, thierry.reding@gmail.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        andrey@lebedev.lt, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] pwm-sun4i: calculate the delay without rounding down
 to jiffies
Message-ID: <20220303215640.m23yozioeqxvmlfc@pengutronix.de>
References: <20220125123429.3490883-1-max.kellermann@gmail.com>
 <20220125123429.3490883-3-max.kellermann@gmail.com>
 <20220224165135.g4ufknd3alrhnfx3@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jer5rcewuptdavq4"
Content-Disposition: inline
In-Reply-To: <20220224165135.g4ufknd3alrhnfx3@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jer5rcewuptdavq4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 24, 2022 at 05:51:35PM +0100, Uwe Kleine-K=F6nig wrote:
> On Tue, Jan 25, 2022 at 01:34:29PM +0100, Max Kellermann wrote:
> > This fixes a problem that was supposed to be addressed by commit
> > 6eefb79d6f5bc ("pwm: sun4i: Remove erroneous else branch") - backlight
> > could not be switched off on some Allwinner A20.  The commit was
> > correct, but was not a reliable fix for the problem, which was timing
> > related.
> >=20
> > The real problem for the backlight switching problem was that sleeping
> > for a full period did not work, because delay_us is always zero.
> >=20
> > It is zero because the period (plus 1 microsecond) is rounded down to
> > the next "jiffies", but the period is less than one jiffy.
> >=20
> > On my Cubieboard 2, the period is 5ms, and 1 jiffy (at the default
> > HZ=3D100) is 10ms, so nsecs_to_jiffies(10ms+1us)=3D0.
> >=20
> > The roundtrip from nanoseconds to jiffies and back to microseconds is
> > an unnecessary loss of precision; always rounding down (via
> > nsecs_to_jiffies()) then causes the breakage.
> >=20
> > This patch eliminates this roundtrip, and directly converts from
> > nanoseconds to microseconds (for usleep_range()), using
> > DIV_ROUND_UP_ULL() to force rounding up.  This way, the sleep time is
> > never zero, and after the sleep, we are guaranteed to be in a
> > different period, and the device is ready for another control command
> > for sure.
> >=20
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
>=20
> Sounds reasonable
>=20
> Acked-by; Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

/me had problems with is keyboard, the Shift-key didn't work and so I
typed a ; instead a :. To make patchwork pick up my tag, I'll repeat it
here:

Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--jer5rcewuptdavq4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmIhOZUACgkQwfwUeK3K
7AlIfgf9HeL94rE/TP4y8ECAlIoCb0eRRWZ4Zj1TM0SxRd1KtmcvQHx/jfivLc8H
IVuljJbzUmrEKRTTXzSZ2Ptj4Lgs3jBYARTklK/lR+NTn9dI1AQyv2TK7Sf3S4fE
ZESjVxH610fLuLTG8aVVCT3mN8PMb6V5RJfIZ1ee5/lyWWkzXWkvGvW89I8+vZYe
ic93WQx9tKt93L8w8SAat/J6OhLhHVXHUSc0Ia/LBGpU6KDHCsaSj58W5G9bbF76
1/YKmMj636lZfN8ts7kNmHiwCsgwFbFqd/nPuRehyDITg1vBADDlPboyTk0KHf8h
7KT0qN1D2OIqm/ZeWWEpm1sszA5d7w==
=DJyp
-----END PGP SIGNATURE-----

--jer5rcewuptdavq4--
