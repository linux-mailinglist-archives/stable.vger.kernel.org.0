Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EF663C513
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 17:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbiK2QZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 11:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234741AbiK2QY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 11:24:59 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99966686B3
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 08:24:57 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1p03Pd-0002zD-JP; Tue, 29 Nov 2022 17:24:49 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1p03Pb-0017EK-U5; Tue, 29 Nov 2022 17:24:48 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1p03Pb-001Gn4-Jm; Tue, 29 Nov 2022 17:24:47 +0100
Date:   Tue, 29 Nov 2022 17:24:47 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Thierry Reding <thierry.reding@gmail.com>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/5] pwm: jz4740: Fix pin level of disabled TCU2
 channels, part 2
Message-ID: <20221129162447.sqa6veugc2xn6vui@pengutronix.de>
References: <20221024205213.327001-1-paul@crapouillou.net>
 <20221024205213.327001-3-paul@crapouillou.net>
 <20221025064410.brrx5faa4jtwo67b@pengutronix.de>
 <Y90BKR.1BA4VWKIBIKU@crapouillou.net>
 <20221128143911.n3woy6mjom5n4sad@pengutronix.de>
 <8VZ3MR.B9R316RWSFMQ@crapouillou.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qrmmrpl6dvcpt7ff"
Content-Disposition: inline
In-Reply-To: <8VZ3MR.B9R316RWSFMQ@crapouillou.net>
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


--qrmmrpl6dvcpt7ff
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Paul,

On Tue, Nov 29, 2022 at 12:25:56PM +0000, Paul Cercueil wrote:
> Hi Uwe,
>=20
> Le lun. 28 nov. 2022 =E0 15:39:11 +0100, Uwe Kleine-K=F6nig
> <u.kleine-koenig@pengutronix.de> a =E9crit :
> > Hello,
> >=20
> > On Tue, Oct 25, 2022 at 11:10:46AM +0100, Paul Cercueil wrote:
> > > > Note that for disabled PWMs there is no official guaranty about the=
 pin
> > > > state. So it would be ok (but admittedly not great) to simplify the
> > > > driver and accept that the pinstate is active while the PWM is off.
> > > > IMHO this is also better than a glitch.
> > > >
> > > > If a consumer wants the PWM to be in its inactive state, they should
> > > > not disable it.
> > >=20
> > > Completely disagree. I absolutely do not want the backlight to go full
> > > bright mode when the PWM pin is disabled. And disabling the backlight=
 is a
> > > thing (for screen blanking and during mode changes).
> >=20
> > For some hardwares there is no pretty choice. So the gist is: If the
> > backlight driver wants to ensure that the PWM pin is driven to its
> > inactive level, it should use:
> >=20
> > 	pwm_apply(pwm, { .period =3D ..., .duty_cycle =3D 0, .enabled =3D true=
 });
> >=20
> > and better not
> >=20
> > 	pwm_apply(pwm, { ..., .enabled =3D false });
>=20
> Well that sounds pretty stupid to me; why doesn't the PWM subsystem enfor=
ce
> that the pins must be driven to their inactive level when the PWM function
> is disabled?
>=20
> Then for such hardware you describe, the corresponding PWM
> driver could itself apply a duty_cycle =3D 0 if that's what it takes to g=
et an
> inactive state.

Let's assume we claim that on disable the pin is driven to the inactive lev=
el.

The (bad) effect is that for a use case where the pin state doesn't
matter (e.g. a backlight where the power regulator is off), the PWM
keeps running even though it could be disabled and so save some power.

So to make this use case properly supported, we need another flag in
struct pwm_state that allows the consumer to tell the lowlevel driver
that it's ok to disable the hardware even with the output being UB.
Let's call this new flag "spam" and the pin is allowed to do whatever it
wants with .spam =3D false.

After that you can realize that applying any state with:

	.duty_cycle =3D A,
	.period =3D B,
	.polarity =3D C,
	.enabled =3D false,
	.spam =3D true,

semantically (i.e. just looking at the output) has the same effect as

	.duty_cycle =3D 0,
	.period =3D $something,
	.polarity =3D C,
	.enabled =3D true,
	.spam =3D true,

So having .enabled doesn't add to the expressiveness of pwm_apply(),
because you can specify any configuration without having to resort to
=2Eenabled =3D false. So the enabled member of struct pwm_state can be
dropped.

Then we end up with the exact scenario we have now, just that the flag
that specifies if the output should be held in the inactive state has a
bad name.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--qrmmrpl6dvcpt7ff
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmOGMkwACgkQwfwUeK3K
7AlUsgf+LpMJoHdd3/SM9UwRd04VHIptKQn1IOnh8MRrgFEppdeUpA8csEChotzb
6DuYP2hId2a0PsZNssjURCX7LWsuLsqhIyXlsu8XcwAUgVEd/eBQ9rp3oV+BJWfs
Agfcxm5INTB7+8FfUf1f57K1El+1wwft34zovBAP8zcP7kBgkGObwFVptSXJaIgx
qOsD087Y+765gyFU9wvAbptR2DRhAGYifjrgxcE08uy36Kg1Kvm8MxHgKJKnBoQB
3CC1eplbmKUallLkelCnWFCxFdGbgWkMQbfDVrFDVSojAaYPR9H5Is35UbBIR5uG
YHJ4oX/otJ7ERN7wtiZybpgOWo4tKg==
=/C6a
-----END PGP SIGNATURE-----

--qrmmrpl6dvcpt7ff--
