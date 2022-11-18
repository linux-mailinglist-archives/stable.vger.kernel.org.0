Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969F562F1F0
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 10:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240778AbiKRJzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 04:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbiKRJzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 04:55:52 -0500
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BE78E0AA;
        Fri, 18 Nov 2022 01:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1668765350; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6XNQnzVk9riDdeXq+9UMc2lKBE5CylsUGgRXuU/IvoA=;
        b=lP8PARIJ1MGPuSFRXoZdjDQldeDX9gaAL8k6+ck7PFoPEr/pfVYxjDVHYtpLT9/6oltISw
        axe4KwYExIC3fbuX3Vdw5FQcDGfcZA+AoBUTXzpwPyVmEacl1F7QisvJtCY7T79sG17bb5
        b4/03lyP69aMqj4L9x1xBzMC6qdib+c=
Date:   Fri, 18 Nov 2022 09:55:40 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH 1/5] pwm: jz4740: Fix pin level of disabled TCU2 channels,
 part 1
To:     Uwe =?iso-8859-1?q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Thierry Reding <thierry.reding@gmail.com>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Message-Id: <SKFJLR.07UMT1VWJOD52@crapouillou.net>
In-Reply-To: <20221117132927.mom5klfd4eww5amk@pengutronix.de>
References: <20221024205213.327001-1-paul@crapouillou.net>
        <20221024205213.327001-2-paul@crapouillou.net>
        <20221025062129.drzltbavg6hrhv7r@pengutronix.de>
        <CVZAKR.06MA7BGA170W3@crapouillou.net>
        <20221117132927.mom5klfd4eww5amk@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Uwe,

Le jeu. 17 nov. 2022 =E0 14:29:27 +0100, Uwe Kleine-K=F6nig=20
<u.kleine-koenig@pengutronix.de> a =E9crit :
> Hello Paul,
>=20
> On Tue, Oct 25, 2022 at 11:02:00AM +0100, Paul Cercueil wrote:
>>  Le mar. 25 oct. 2022 =E0 08:21:29 +0200, Uwe Kleine-K=F6nig
>>  <u.kleine-koenig@pengutronix.de> a =E9crit :
>>  > Hello,
>>  >
>>  > On Mon, Oct 24, 2022 at 09:52:09PM +0100, Paul Cercueil wrote:
>>  > >  The "duty > cycle" trick to force the pin level of a disabled=20
>> TCU2
>>  > >  channel would only work when the channel had been enabled
>>  > > previously.
>>  > >
>>  > >  Address this issue by enabling the PWM mode in=20
>> jz4740_pwm_disable
>>  > >  (I know, right) so that the "duty > cycle" trick works before
>>  > > disabling
>>  > >  the PWM channel right after.
>>  > >
>>  > >  This issue went unnoticed, as the PWM pins on the majority of=20
>> the
>>  > > boards
>>  > >  tested would default to the inactive level once the=20
>> corresponding
>>  > > TCU
>>  > >  clock was enabled, so the first call to jz4740_pwm_disable()=20
>> would
>>  > > not
>>  > >  actually change the pin levels.
>>  > >
>>  > >  On the GCW Zero however, the PWM pin for the backlight (PWM1,=20
>> which
>>  > > is
>>  > >  a TCU2 channel) goes active as soon as the timer1 clock is=20
>> enabled.
>>  > >  Since the jz4740_pwm_disable() function did not work on=20
>> channels not
>>  > >  previously enabled, the backlight would shine at full=20
>> brightness
>>  > > from
>>  > >  the moment the backlight driver would probe, until the=20
>> backlight
>>  > > driver
>>  > >  tried to *enable* the PWM output.
>>  > >
>>  > >  With this fix, the PWM pins will be forced inactive as soon as
>>  > >  jz4740_pwm_apply() is called (and might be reconfigured to=20
>> active if
>>  > >  dictated by the pwm_state). This means that there is still a=20
>> tiny
>>  > > time
>>  > >  frame between the .request() and .apply() callbacks where the=20
>> PWM
>>  > > pin
>>  > >  might be active. Sadly, there is no way to fix this issue: it=20
>> is
>>  > >  impossible to write a PWM channel's registers if the=20
>> corresponding
>>  > > clock
>>  > >  is not enabled, and enabling the clock is what causes the PWM=20
>> pin
>>  > > to go
>>  > >  active.
>>  > >
>>  > >  There is a workaround, though, which complements this fix:=20
>> simply
>>  > >  starting the backlight driver (or any PWM client driver) with a
>>  > > "init"
>>  > >  pinctrl state that sets the pin as an inactive GPIO. Once the
>>  > > driver is
>>  > >  probed and the pinctrl state switches to "default", the=20
>> regular PWM
>>  > > pin
>>  > >  configuration can be used as it will be properly driven.
>>  > >
>>  > >  Fixes: c2693514a0a1 ("pwm: jz4740: Obtain regmap from parent=20
>> node")
>>  > >  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  > >  Cc: stable@vger.kernel.org
>>  >
>>  > OK, understood the issue. I think there is another similar issue:=20
>> The
>>  > clk is get and enabled only in the .request() callback. The=20
>> result is (I
>>  > think---depends on a few further conditions) that if you have the
>>  > backlight driver as a module and the bootloader enables the=20
>> backlight to
>>  > show a splash screen, the backlight goes off because of the
>>  > clk_disable_unused initcall.
>>=20
>>  I will have to verify, but I'm pretty sure disabling the clock=20
>> doesn't
>>  change the pin level back to inactive.
>=20
> Given that you set the clk's rate depending on the period to apply,=20
> I'd
> claim that you need to keep the clk on. Maybe it doesn't hurt, because
> another component of the system keeps the clk running, but it's wrong
> anyhow. Assumptions like these tend to break on new chip revisions.

If the backlight driver is a module then it will probe before the=20
clk_disable_unused initcall, unless something is really wrong. So the=20
backlight would stay ON if it was enabled by the bootloader, unless the=20
DTB decides it doesn't have to be.

Anyway, I can try your suggestion, and move the trick to force-disable=20
PWM pins in the probe(). After that, the clocks can be safely disabled,=20
so I can disable them (for the disabled PWMs) at the end of the probe=20
and re-enable them again in their respective .request() callback.

Cheers,
-Paul


