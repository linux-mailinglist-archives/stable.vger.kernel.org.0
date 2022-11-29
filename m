Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9AC063C5FF
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 18:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbiK2RBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 12:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236419AbiK2RBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 12:01:03 -0500
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0F76F0E3;
        Tue, 29 Nov 2022 08:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1669741111; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qMqQlsyRM0UP8kIJwP1B4YWhuabDQy8K03Oc8LDvyvw=;
        b=FA5fBDpr3VWfFKeT1evu/h8AF/h8Tci8uCekv7sGgNZosDQ4IM9U1BoXxyNRrKyCblyD+D
        WRlJxEBqyTHrxjffS9mWouNXMMIk+qNXMZUGZet3PEYGHwkIzZnlm8z7Oob2qVv+ahC+Nl
        m6PL+Nnpyt+s/HJ775+yE1ftJAzLfh0=
Message-ID: <dfb368f51365ab068d477154c8051117bae197de.camel@crapouillou.net>
Subject: Re: [PATCH 2/5] pwm: jz4740: Fix pin level of disabled TCU2
 channels, part 2
From:   Paul Cercueil <paul@crapouillou.net>
To:     Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Thierry Reding <thierry.reding@gmail.com>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 29 Nov 2022 16:58:28 +0000
In-Reply-To: <20221129162447.sqa6veugc2xn6vui@pengutronix.de>
References: <20221024205213.327001-1-paul@crapouillou.net>
         <20221024205213.327001-3-paul@crapouillou.net>
         <20221025064410.brrx5faa4jtwo67b@pengutronix.de>
         <Y90BKR.1BA4VWKIBIKU@crapouillou.net>
         <20221128143911.n3woy6mjom5n4sad@pengutronix.de>
         <8VZ3MR.B9R316RWSFMQ@crapouillou.net>
         <20221129162447.sqa6veugc2xn6vui@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le mardi 29 novembre 2022 =C3=A0 17:24 +0100, Uwe Kleine-K=C3=B6nig a =C3=
=A9crit=C2=A0:
> Hello Paul,
>=20
> On Tue, Nov 29, 2022 at 12:25:56PM +0000, Paul Cercueil wrote:
> > Hi Uwe,
> >=20
> > Le lun. 28 nov. 2022 =C3=A0 15:39:11 +0100, Uwe Kleine-K=C3=B6nig
> > <u.kleine-koenig@pengutronix.de> a =C3=A9crit :
> > > Hello,
> > >=20
> > > On Tue, Oct 25, 2022 at 11:10:46AM +0100, Paul Cercueil wrote:
> > > > > Note that for disabled PWMs there is no official guaranty
> > > > > about the pin
> > > > > state. So it would be ok (but admittedly not great) to
> > > > > simplify the
> > > > > driver and accept that the pinstate is active while the PWM
> > > > > is off.
> > > > > IMHO this is also better than a glitch.
> > > > >=20
> > > > > If a consumer wants the PWM to be in its inactive state, they
> > > > > should
> > > > > not disable it.
> > > >=20
> > > > Completely disagree. I absolutely do not want the backlight to
> > > > go full
> > > > bright mode when the PWM pin is disabled. And disabling the
> > > > backlight is a
> > > > thing (for screen blanking and during mode changes).
> > >=20
> > > For some hardwares there is no pretty choice. So the gist is: If
> > > the
> > > backlight driver wants to ensure that the PWM pin is driven to
> > > its
> > > inactive level, it should use:
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pwm_apply(pwm, { .per=
iod =3D ..., .duty_cycle =3D 0, .enabled
> > > =3D true });
> > >=20
> > > and better not
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pwm_apply(pwm, { ...,=
 .enabled =3D false });
> >=20
> > Well that sounds pretty stupid to me; why doesn't the PWM subsystem
> > enforce
> > that the pins must be driven to their inactive level when the PWM
> > function
> > is disabled?
> >=20
> > Then for such hardware you describe, the corresponding PWM
> > driver could itself apply a duty_cycle =3D 0 if that's what it takes
> > to get an
> > inactive state.
>=20
> Let's assume we claim that on disable the pin is driven to the
> inactive level.
>=20
> The (bad) effect is that for a use case where the pin state doesn't
> matter (e.g. a backlight where the power regulator is off), the PWM
> keeps running even though it could be disabled and so save some
> power.
>=20
> So to make this use case properly supported, we need another flag in
> struct pwm_state that allows the consumer to tell the lowlevel driver
> that it's ok to disable the hardware even with the output being UB.
> Let's call this new flag "spam" and the pin is allowed to do whatever
> it
> wants with .spam =3D false.
>=20
> After that you can realize that applying any state with:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.duty_cycle =3D A,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.period =3D B,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.polarity =3D C,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.enabled =3D false,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.spam =3D true,
>=20
> semantically (i.e. just looking at the output) has the same effect as
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.duty_cycle =3D 0,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.period =3D $something,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.polarity =3D C,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.enabled =3D true,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.spam =3D true,
>=20
> So having .enabled doesn't add to the expressiveness of pwm_apply(),
> because you can specify any configuration without having to resort to
> .enabled =3D false. So the enabled member of struct pwm_state can be
> dropped.
>=20
> Then we end up with the exact scenario we have now, just that the
> flag
> that specifies if the output should be held in the inactive state has
> a
> bad name.

If I follow you, then it means that the PWM backlight driver pwm_bl.c
should set state.enabled=3Dtrue in pwm_backlight_power_off() to make sure
that the pin is inactive?

-Paul
