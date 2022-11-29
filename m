Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821F563C025
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 13:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbiK2MfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 07:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiK2MfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 07:35:01 -0500
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033745DBAF;
        Tue, 29 Nov 2022 04:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1669725294; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eL6pPI+L/7yl681MBLlj5aEBo5qXXri4yiHQVrloheo=;
        b=gfjFN19UdzVsZboD3kNO1sYaHzs288HSiwbKnSYYScz/0ftxmJu0snh0T+SRwZsYsXoRGH
        WRXde81kPbQc7PuZtiuwtMk0LQqmYvefga+WI2PXVwPp+SIqlmGWLb7UqWOqUl7waSDyhV
        19KTRmx5n6jfF2OqJ9GWXFe+ShxTMHs=
Date:   Tue, 29 Nov 2022 12:34:44 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH 2/5] pwm: jz4740: Fix pin level of disabled TCU2 channels,
 part 2
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Uwe =?iso-8859-1?q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Message-Id: <W904MR.3RUCK63YXZDN1@crapouillou.net>
In-Reply-To: <Y4X4BQ7t2OnH+OGb@orome>
References: <20221024205213.327001-1-paul@crapouillou.net>
        <20221024205213.327001-3-paul@crapouillou.net>
        <20221025064410.brrx5faa4jtwo67b@pengutronix.de>
        <Y90BKR.1BA4VWKIBIKU@crapouillou.net>
        <20221128143911.n3woy6mjom5n4sad@pengutronix.de> <Y4X4BQ7t2OnH+OGb@orome>
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

Hi Thierry,

Le mar. 29 nov. 2022 =E0 13:16:05 +0100, Thierry Reding=20
<thierry.reding@gmail.com> a =E9crit :
> On Mon, Nov 28, 2022 at 03:39:11PM +0100, Uwe Kleine-K=F6nig wrote:
>>  Hello,
>>=20
>>  On Tue, Oct 25, 2022 at 11:10:46AM +0100, Paul Cercueil wrote:
>>  > Le mar. 25 oct. 2022 =E0 08:44:10 +0200, Uwe Kleine-K=F6nig
>>  > <u.kleine-koenig@pengutronix.de> a =E9crit :
>>  > > On Mon, Oct 24, 2022 at 09:52:10PM +0100, Paul Cercueil wrote:
>>  > > >  After commit a020f22a4ff5 ("pwm: jz4740: Make PWM start with=20
>> the
>>  > > > active part"),
>>  > > >  the trick to set duty > period to properly shut down TCU2=20
>> channels
>>  > > > did
>>  > > >  not work anymore, because of the polarity inversion.
>>  > > >
>>  > > >  Address this issue by restoring the proper polarity before
>>  > > > disabling the
>>  > > >  channels.
>>  > > >
>>  > > >  Fixes: a020f22a4ff5 ("pwm: jz4740: Make PWM start with the=20
>> active
>>  > > > part")
>>  > > >  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  > > >  Cc: stable@vger.kernel.org
>>  > > >  ---
>>  > > >   drivers/pwm/pwm-jz4740.c | 62
>>  > > > ++++++++++++++++++++++++++--------------
>>  > > >   1 file changed, 40 insertions(+), 22 deletions(-)
>>  > > >
>>  > > >  diff --git a/drivers/pwm/pwm-jz4740.c=20
>> b/drivers/pwm/pwm-jz4740.c
>>  > > >  index 228eb104bf1e..65462a0052af 100644
>>  > > >  --- a/drivers/pwm/pwm-jz4740.c
>>  > > >  +++ b/drivers/pwm/pwm-jz4740.c
>>  > > >  @@ -97,6 +97,19 @@ static int jz4740_pwm_enable(struct=20
>> pwm_chip
>>  > > > *chip, struct pwm_device *pwm)
>>  > > >   	return 0;
>>  > > >   }
>>  > > >
>>  > > >  +static void jz4740_pwm_set_polarity(struct jz4740_pwm_chip=20
>> *jz,
>>  > > >  +				    unsigned int hwpwm,
>>  > > >  +				    enum pwm_polarity polarity)
>>  > > >  +{
>>  > > >  +	unsigned int value =3D 0;
>>  > > >  +
>>  > > >  +	if (polarity =3D=3D PWM_POLARITY_INVERSED)
>>  > > >  +		value =3D TCU_TCSR_PWM_INITL_HIGH;
>>  > > >  +
>>  > > >  +	regmap_update_bits(jz->map, TCU_REG_TCSRc(hwpwm),
>>  > > >  +			   TCU_TCSR_PWM_INITL_HIGH, value);
>>  > > >  +}
>>  > > >  +
>>  > > >   static void jz4740_pwm_disable(struct pwm_chip *chip, struct
>>  > > > pwm_device *pwm)
>>  > > >   {
>>  > > >   	struct jz4740_pwm_chip *jz =3D to_jz4740(chip);
>>  > > >  @@ -130,6 +143,7 @@ static int jz4740_pwm_apply(struct=20
>> pwm_chip
>>  > > > *chip, struct pwm_device *pwm,
>>  > > >   	unsigned long long tmp =3D 0xffffull * NSEC_PER_SEC;
>>  > > >   	struct clk *clk =3D pwm_get_chip_data(pwm);
>>  > > >   	unsigned long period, duty;
>>  > > >  +	enum pwm_polarity polarity;
>>  > > >   	long rate;
>>  > > >   	int err;
>>  > > >
>>  > > >  @@ -169,6 +183,9 @@ static int jz4740_pwm_apply(struct=20
>> pwm_chip
>>  > > > *chip, struct pwm_device *pwm,
>>  > > >   	if (duty >=3D period)
>>  > > >   		duty =3D period - 1;
>>  > > >
>>  > > >  +	/* Restore regular polarity before disabling the channel.=20
>> */
>>  > > >  +	jz4740_pwm_set_polarity(jz4740, pwm->hwpwm,=20
>> state->polarity);
>>  > > >  +
>>  > >
>>  > > Does this introduce a glitch?
>>  >
>>  > Maybe. But the PWM is shut down before finishing its period=20
>> anyway, so there
>>  > was already a glitch.
>>  >
>>  > > >   	jz4740_pwm_disable(chip, pwm);
>>  > > >
>>  > > >   	err =3D clk_set_rate(clk, rate);
>>  > > >  @@ -190,29 +207,30 @@ static int jz4740_pwm_apply(struct=20
>> pwm_chip
>>  > > > *chip, struct pwm_device *pwm,
>>  > > >   	regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
>>  > > >   			   TCU_TCSR_PWM_SD, TCU_TCSR_PWM_SD);
>>  > > >
>>  > > >  -	/*
>>  > > >  -	 * Set polarity.
>>  > > >  -	 *
>>  > > >  -	 * The PWM starts in inactive state until the internal=20
>> timer
>>  > > > reaches the
>>  > > >  -	 * duty value, then becomes active until the timer reaches=20
>> the
>>  > > > period
>>  > > >  -	 * value. In theory, we should then use (period - duty) as=20
>> the
>>  > > > real duty
>>  > > >  -	 * value, as a high duty value would otherwise result in=20
>> the PWM
>>  > > > pin
>>  > > >  -	 * being inactive most of the time.
>>  > > >  -	 *
>>  > > >  -	 * Here, we don't do that, and instead invert the polarity=20
>> of the
>>  > > > PWM
>>  > > >  -	 * when it is active. This trick makes the PWM start with=20
>> its
>>  > > > active
>>  > > >  -	 * state instead of its inactive state.
>>  > > >  -	 */
>>  > > >  -	if ((state->polarity =3D=3D PWM_POLARITY_NORMAL) ^=20
>> state->enabled)
>>  > > >  -		regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
>>  > > >  -				   TCU_TCSR_PWM_INITL_HIGH, 0);
>>  > > >  -	else
>>  > > >  -		regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
>>  > > >  -				   TCU_TCSR_PWM_INITL_HIGH,
>>  > > >  -				   TCU_TCSR_PWM_INITL_HIGH);
>>  > > >  -
>>  > > >  -	if (state->enabled)
>>  > > >  +	if (state->enabled) {
>>  > > >  +		/*
>>  > > >  +		 * Set polarity.
>>  > > >  +		 *
>>  > > >  +		 * The PWM starts in inactive state until the internal=20
>> timer
>>  > > >  +		 * reaches the duty value, then becomes active until the=20
>> timer
>>  > > >  +		 * reaches the period value. In theory, we should then use
>>  > > >  +		 * (period - duty) as the real duty value, as a high duty=20
>> value
>>  > > >  +		 * would otherwise result in the PWM pin being inactive=20
>> most of
>>  > > >  +		 * the time.
>>  > > >  +		 *
>>  > > >  +		 * Here, we don't do that, and instead invert the=20
>> polarity of
>>  > > >  +		 * the PWM when it is active. This trick makes the PWM=20
>> start
>>  > > >  +		 * with its active state instead of its inactive state.
>>  > > >  +		 */
>>  > > >  +		if (state->polarity =3D=3D PWM_POLARITY_NORMAL)
>>  > > >  +			polarity =3D PWM_POLARITY_INVERSED;
>>  > > >  +		else
>>  > > >  +			polarity =3D PWM_POLARITY_NORMAL;
>>  > > >  +
>>  > > >  +		jz4740_pwm_set_polarity(jz4740, pwm->hwpwm, polarity);
>>  > > >  +
>>  > > >   		jz4740_pwm_enable(chip, pwm);
>>  > > >  +	}
>>  > >
>>  > > Note that for disabled PWMs there is no official guaranty about=20
>> the pin
>>  > > state. So it would be ok (but admittedly not great) to simplify=20
>> the
>>  > > driver and accept that the pinstate is active while the PWM is=20
>> off.
>>  > > IMHO this is also better than a glitch.
>>  > >
>>  > > If a consumer wants the PWM to be in its inactive state, they=20
>> should
>>  > > not disable it.
>>  >
>>  > Completely disagree. I absolutely do not want the backlight to go=20
>> full
>>  > bright mode when the PWM pin is disabled. And disabling the=20
>> backlight is a
>>  > thing (for screen blanking and during mode changes).
>>=20
>>  For some hardwares there is no pretty choice. So the gist is: If the
>>  backlight driver wants to ensure that the PWM pin is driven to its
>>  inactive level, it should use:
>>=20
>>  	pwm_apply(pwm, { .period =3D ..., .duty_cycle =3D 0, .enabled =3D true=
=20
>> });
>>=20
>>  and better not
>>=20
>>  	pwm_apply(pwm, { ..., .enabled =3D false });
>=20
> Depending on your hardware capabilities you may also be able to use
> pinctrl to configure the pin to behave properly when the PWM is
> disabled. Not all hardware can do that, though.

Been there, done that. It got refused.
https://lkml.org/lkml/2019/5/22/607

Cheers,
-Paul


