Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3900F60C97E
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 12:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbiJYKJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 06:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiJYKIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 06:08:47 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810332981B;
        Tue, 25 Oct 2022 03:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1666692130; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GZQjd+Wa2neY9qwI0lk5D0hlo8qhC97lemY8oYsOL6Q=;
        b=KRvUJyGzMOrhIRfEabCCyBxTa37MSYJfAKXwdA45KS7sRBteAz4EJUTU+XUXe472KduOQT
        +uAAK+LaRR31+nsBVxmJ37qwXWMUdgohMjb68N0MpCf1Vq6/9aNzUSC1nOmV1G2Uq+Nvel
        mHd7E9211bYxMKzIhB+VNQfRfgsa/Go=
Date:   Tue, 25 Oct 2022 11:02:00 +0100
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH 1/5] pwm: jz4740: Fix pin level of disabled TCU2 channels,
 part 1
To:     Uwe =?iso-8859-1?q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Thierry Reding <thierry.reding@gmail.com>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Message-Id: <CVZAKR.06MA7BGA170W3@crapouillou.net>
In-Reply-To: <20221025062129.drzltbavg6hrhv7r@pengutronix.de>
References: <20221024205213.327001-1-paul@crapouillou.net>
        <20221024205213.327001-2-paul@crapouillou.net>
        <20221025062129.drzltbavg6hrhv7r@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le mar. 25 oct. 2022 =E0 08:21:29 +0200, Uwe Kleine-K=F6nig=20
<u.kleine-koenig@pengutronix.de> a =E9crit :
> Hello,
>=20
> On Mon, Oct 24, 2022 at 09:52:09PM +0100, Paul Cercueil wrote:
>>  The "duty > cycle" trick to force the pin level of a disabled TCU2
>>  channel would only work when the channel had been enabled=20
>> previously.
>>=20
>>  Address this issue by enabling the PWM mode in jz4740_pwm_disable
>>  (I know, right) so that the "duty > cycle" trick works before=20
>> disabling
>>  the PWM channel right after.
>>=20
>>  This issue went unnoticed, as the PWM pins on the majority of the=20
>> boards
>>  tested would default to the inactive level once the corresponding=20
>> TCU
>>  clock was enabled, so the first call to jz4740_pwm_disable() would=20
>> not
>>  actually change the pin levels.
>>=20
>>  On the GCW Zero however, the PWM pin for the backlight (PWM1, which=20
>> is
>>  a TCU2 channel) goes active as soon as the timer1 clock is enabled.
>>  Since the jz4740_pwm_disable() function did not work on channels not
>>  previously enabled, the backlight would shine at full brightness=20
>> from
>>  the moment the backlight driver would probe, until the backlight=20
>> driver
>>  tried to *enable* the PWM output.
>>=20
>>  With this fix, the PWM pins will be forced inactive as soon as
>>  jz4740_pwm_apply() is called (and might be reconfigured to active if
>>  dictated by the pwm_state). This means that there is still a tiny=20
>> time
>>  frame between the .request() and .apply() callbacks where the PWM=20
>> pin
>>  might be active. Sadly, there is no way to fix this issue: it is
>>  impossible to write a PWM channel's registers if the corresponding=20
>> clock
>>  is not enabled, and enabling the clock is what causes the PWM pin=20
>> to go
>>  active.
>>=20
>>  There is a workaround, though, which complements this fix: simply
>>  starting the backlight driver (or any PWM client driver) with a=20
>> "init"
>>  pinctrl state that sets the pin as an inactive GPIO. Once the=20
>> driver is
>>  probed and the pinctrl state switches to "default", the regular PWM=20
>> pin
>>  configuration can be used as it will be properly driven.
>>=20
>>  Fixes: c2693514a0a1 ("pwm: jz4740: Obtain regmap from parent node")
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  Cc: stable@vger.kernel.org
>=20
> OK, understood the issue. I think there is another similar issue: The
> clk is get and enabled only in the .request() callback. The result is=20
> (I
> think---depends on a few further conditions) that if you have the
> backlight driver as a module and the bootloader enables the backlight=20
> to
> show a splash screen, the backlight goes off because of the
> clk_disable_unused initcall.

I will have to verify, but I'm pretty sure disabling the clock doesn't=20
change the pin level back to inactive.

-Paul

> So the right thing to do is to get the clock in .probe(), and ensure=20
> it
> is kept on if the PWM is running already. Then you can also enable the
> counter in .probe() and don't care for it in the enable and disable
> functions.
>=20
> The init pinctrl then has to be on the PWM then, but that's IMHO ok.
>=20
> Best regards
> Uwe
>=20
> PS: While looking into the driver I noticed that .request() uses
> dev_err_probe(). That's wrong, this function is only supposed to be=20
> used
> in .probe().
>=20
> --
> Pengutronix e.K.                           | Uwe Kleine-K=F6nig       =20
>     |
> Industrial Linux Solutions                 |=20
> https://www.pengutronix.de/ |


