Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D66670E23
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 00:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjAQXx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 18:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjAQXwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 18:52:02 -0500
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EE83A9A;
        Tue, 17 Jan 2023 15:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1673996713; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xas+WWnU0h9XNtsIj3PC1hwar1e/lTCwSRez9hjFWFQ=;
        b=OHXopnoa0C2i0W8pYsoCvD1Aeo0SpZtThVWG9Mff5xglEGv6UOTU+78cCATIqpOGbQXpyk
        HHCeOuHOD16Ui+AsASMKBme3kyaUHcC2ztLuiFtGYB3vLbJw4X481wHpZ8WfB7AsKb/GvL
        p6W9cRWb2f/FEXrLAkTiHCCfH2H7Zrk=
Message-ID: <846b27400a72db8ca9b7497a6c032bdaacd62fc6.camel@crapouillou.net>
Subject: Re: [PATCH 1/5] pwm: jz4740: Fix pin level of disabled TCU2
 channels, part 1
From:   Paul Cercueil <paul@crapouillou.net>
To:     Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Thierry Reding <thierry.reding@gmail.com>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 17 Jan 2023 23:05:10 +0000
In-Reply-To: <20230117213556.vdurctncvnjom62g@pengutronix.de>
References: <20221024205213.327001-1-paul@crapouillou.net>
         <20221024205213.327001-2-paul@crapouillou.net>
         <20221025062129.drzltbavg6hrhv7r@pengutronix.de>
         <CVZAKR.06MA7BGA170W3@crapouillou.net>
         <20221117132927.mom5klfd4eww5amk@pengutronix.de>
         <SKFJLR.07UMT1VWJOD52@crapouillou.net>
         <20230117213556.vdurctncvnjom62g@pengutronix.de>
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

Hi Uwe,

Le mardi 17 janvier 2023 =C3=A0 22:35 +0100, Uwe Kleine-K=C3=B6nig a =C3=A9=
crit=C2=A0:
> Hello Paul,
>=20
> On Fri, Nov 18, 2022 at 09:55:40AM +0000, Paul Cercueil wrote:
> > Le jeu. 17 nov. 2022 =C3=A0 14:29:27 +0100, Uwe Kleine-K=C3=B6nig
> > <u.kleine-koenig@pengutronix.de> a =C3=A9crit :
> > > Hello Paul,
> > >=20
> > > On Tue, Oct 25, 2022 at 11:02:00AM +0100, Paul Cercueil wrote:
> > > > =C2=A0Le mar. 25 oct. 2022 =C3=A0 08:21:29 +0200, Uwe Kleine-K=C3=
=B6nig
> > > > =C2=A0<u.kleine-koenig@pengutronix.de> a =C3=A9crit :
> > > > =C2=A0> Hello,
> > > > =C2=A0>
> > > > =C2=A0> On Mon, Oct 24, 2022 at 09:52:09PM +0100, Paul Cercueil
> > > > wrote:
> > > > =C2=A0> >=C2=A0 The "duty > cycle" trick to force the pin level of =
a
> > > > disabled
> > > > TCU2
> > > > =C2=A0> >=C2=A0 channel would only work when the channel had been e=
nabled
> > > > =C2=A0> > previously.
> > > > =C2=A0> >
> > > > =C2=A0> >=C2=A0 Address this issue by enabling the PWM mode in
> > > > jz4740_pwm_disable
> > > > =C2=A0> >=C2=A0 (I know, right) so that the "duty > cycle" trick wo=
rks
> > > > before
> > > > =C2=A0> > disabling
> > > > =C2=A0> >=C2=A0 the PWM channel right after.
> > > > =C2=A0> >
> > > > =C2=A0> >=C2=A0 This issue went unnoticed, as the PWM pins on the
> > > > majority of
> > > > the
> > > > =C2=A0> > boards
> > > > =C2=A0> >=C2=A0 tested would default to the inactive level once the
> > > > corresponding
> > > > =C2=A0> > TCU
> > > > =C2=A0> >=C2=A0 clock was enabled, so the first call to
> > > > jz4740_pwm_disable()
> > > > would
> > > > =C2=A0> > not
> > > > =C2=A0> >=C2=A0 actually change the pin levels.
> > > > =C2=A0> >
> > > > =C2=A0> >=C2=A0 On the GCW Zero however, the PWM pin for the backli=
ght
> > > > (PWM1,
> > > > which
> > > > =C2=A0> > is
> > > > =C2=A0> >=C2=A0 a TCU2 channel) goes active as soon as the timer1 c=
lock
> > > > is
> > > > enabled.
> > > > =C2=A0> >=C2=A0 Since the jz4740_pwm_disable() function did not wor=
k on
> > > > channels not
> > > > =C2=A0> >=C2=A0 previously enabled, the backlight would shine at fu=
ll
> > > > brightness
> > > > =C2=A0> > from
> > > > =C2=A0> >=C2=A0 the moment the backlight driver would probe, until =
the
> > > > backlight
> > > > =C2=A0> > driver
> > > > =C2=A0> >=C2=A0 tried to *enable* the PWM output.
> > > > =C2=A0> >
> > > > =C2=A0> >=C2=A0 With this fix, the PWM pins will be forced inactive=
 as
> > > > soon as
> > > > =C2=A0> >=C2=A0 jz4740_pwm_apply() is called (and might be reconfig=
ured
> > > > to
> > > > active if
> > > > =C2=A0> >=C2=A0 dictated by the pwm_state). This means that there i=
s
> > > > still a
> > > > tiny
> > > > =C2=A0> > time
> > > > =C2=A0> >=C2=A0 frame between the .request() and .apply() callbacks=
 where
> > > > the
> > > > PWM
> > > > =C2=A0> > pin
> > > > =C2=A0> >=C2=A0 might be active. Sadly, there is no way to fix this
> > > > issue: it
> > > > is
> > > > =C2=A0> >=C2=A0 impossible to write a PWM channel's registers if th=
e
> > > > corresponding
> > > > =C2=A0> > clock
> > > > =C2=A0> >=C2=A0 is not enabled, and enabling the clock is what caus=
es the
> > > > PWM
> > > > pin
> > > > =C2=A0> > to go
> > > > =C2=A0> >=C2=A0 active.
> > > > =C2=A0> >
> > > > =C2=A0> >=C2=A0 There is a workaround, though, which complements th=
is
> > > > fix:
> > > > simply
> > > > =C2=A0> >=C2=A0 starting the backlight driver (or any PWM client dr=
iver)
> > > > with a
> > > > =C2=A0> > "init"
> > > > =C2=A0> >=C2=A0 pinctrl state that sets the pin as an inactive GPIO=
. Once
> > > > the
> > > > =C2=A0> > driver is
> > > > =C2=A0> >=C2=A0 probed and the pinctrl state switches to "default",=
 the
> > > > regular PWM
> > > > =C2=A0> > pin
> > > > =C2=A0> >=C2=A0 configuration can be used as it will be properly dr=
iven.
> > > > =C2=A0> >
> > > > =C2=A0> >=C2=A0 Fixes: c2693514a0a1 ("pwm: jz4740: Obtain regmap fr=
om
> > > > parent
> > > > node")
> > > > =C2=A0> >=C2=A0 Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> > > > =C2=A0> >=C2=A0 Cc: stable@vger.kernel.org
> > > > =C2=A0>
> > > > =C2=A0> OK, understood the issue. I think there is another similar
> > > > issue:
> > > > The
> > > > =C2=A0> clk is get and enabled only in the .request() callback. The
> > > > result is (I
> > > > =C2=A0> think---depends on a few further conditions) that if you
> > > > have the
> > > > =C2=A0> backlight driver as a module and the bootloader enables the
> > > > backlight to
> > > > =C2=A0> show a splash screen, the backlight goes off because of the
> > > > =C2=A0> clk_disable_unused initcall.
> > > >=20
> > > > =C2=A0I will have to verify, but I'm pretty sure disabling the cloc=
k
> > > > doesn't
> > > > =C2=A0change the pin level back to inactive.
> > >=20
> > > Given that you set the clk's rate depending on the period to
> > > apply, I'd
> > > claim that you need to keep the clk on. Maybe it doesn't hurt,
> > > because
> > > another component of the system keeps the clk running, but it's
> > > wrong
> > > anyhow. Assumptions like these tend to break on new chip
> > > revisions.
> >=20
> > If the backlight driver is a module then it will probe before the
> > clk_disable_unused initcall, unless something is really wrong.
>=20
> I'd claim the clk_disable_unused initcall is called before userspace
> starts and so before the module can be loaded. Who is wrong here?

Probably me.

> > So the backlight would stay ON if it was enabled by the bootloader,
> > unless the DTB decides it doesn't have to be.
>=20
> Don't understand that. How could hte DTB decide the backlight can be
> disabled?

I don't remember what I meant by that :)
=C2=A0
> > Anyway, I can try your suggestion, and move the trick to force-
> > disable PWM
> > pins in the probe(). After that, the clocks can be safely disabled,
> > so I can
> > disable them (for the disabled PWMs) at the end of the probe and
> > re-enable
> > them again in their respective .request() callback.
>=20
> I really lost track of the problem here and would appreciate a new
> submission of the remaining (and improved?) patches.

Sure. I still have the patchset on the backburner and plan to
(eventually) send an updated version.

If you are fishing for patches I think you can take patches 3/5 and 4/5
of this patchset. Then I won't have to send them again in v2.

Cheers,
-Paul
