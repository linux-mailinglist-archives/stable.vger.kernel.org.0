Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9184860C9C2
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 12:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiJYKRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 06:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbiJYKQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 06:16:45 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFBA10EA18;
        Tue, 25 Oct 2022 03:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1666692656; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5szuNODWsyD37i1tjLgoHPKhtfoUcmFUJEZ/3TrxYgU=;
        b=E/87ejWZxZlkW7IiIX4bDVxP2pmhKIQWnE183GBmF4UXaMvFCFsdb7kzupIZH3R1ZZYFtY
        BPGIcd9ml7iOf5ZA+TXkgjlRHQ9QalWe1Z4rTvJaGFa6asinRwxsms3ESFpy10OB3kNsKh
        ozpOzW6JBh7zot1w0pdsUmC1wV08hHc=
Date:   Tue, 25 Oct 2022 11:10:46 +0100
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH 2/5] pwm: jz4740: Fix pin level of disabled TCU2 channels,
 part 2
To:     Uwe =?iso-8859-1?q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Thierry Reding <thierry.reding@gmail.com>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Message-Id: <Y90BKR.1BA4VWKIBIKU@crapouillou.net>
In-Reply-To: <20221025064410.brrx5faa4jtwo67b@pengutronix.de>
References: <20221024205213.327001-1-paul@crapouillou.net>
        <20221024205213.327001-3-paul@crapouillou.net>
        <20221025064410.brrx5faa4jtwo67b@pengutronix.de>
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



Le mar. 25 oct. 2022 =E0 08:44:10 +0200, Uwe Kleine-K=F6nig=20
<u.kleine-koenig@pengutronix.de> a =E9crit :
> On Mon, Oct 24, 2022 at 09:52:10PM +0100, Paul Cercueil wrote:
>>  After commit a020f22a4ff5 ("pwm: jz4740: Make PWM start with the=20
>> active part"),
>>  the trick to set duty > period to properly shut down TCU2 channels=20
>> did
>>  not work anymore, because of the polarity inversion.
>>=20
>>  Address this issue by restoring the proper polarity before=20
>> disabling the
>>  channels.
>>=20
>>  Fixes: a020f22a4ff5 ("pwm: jz4740: Make PWM start with the active=20
>> part")
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  Cc: stable@vger.kernel.org
>>  ---
>>   drivers/pwm/pwm-jz4740.c | 62=20
>> ++++++++++++++++++++++++++--------------
>>   1 file changed, 40 insertions(+), 22 deletions(-)
>>=20
>>  diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
>>  index 228eb104bf1e..65462a0052af 100644
>>  --- a/drivers/pwm/pwm-jz4740.c
>>  +++ b/drivers/pwm/pwm-jz4740.c
>>  @@ -97,6 +97,19 @@ static int jz4740_pwm_enable(struct pwm_chip=20
>> *chip, struct pwm_device *pwm)
>>   	return 0;
>>   }
>>=20
>>  +static void jz4740_pwm_set_polarity(struct jz4740_pwm_chip *jz,
>>  +				    unsigned int hwpwm,
>>  +				    enum pwm_polarity polarity)
>>  +{
>>  +	unsigned int value =3D 0;
>>  +
>>  +	if (polarity =3D=3D PWM_POLARITY_INVERSED)
>>  +		value =3D TCU_TCSR_PWM_INITL_HIGH;
>>  +
>>  +	regmap_update_bits(jz->map, TCU_REG_TCSRc(hwpwm),
>>  +			   TCU_TCSR_PWM_INITL_HIGH, value);
>>  +}
>>  +
>>   static void jz4740_pwm_disable(struct pwm_chip *chip, struct=20
>> pwm_device *pwm)
>>   {
>>   	struct jz4740_pwm_chip *jz =3D to_jz4740(chip);
>>  @@ -130,6 +143,7 @@ static int jz4740_pwm_apply(struct pwm_chip=20
>> *chip, struct pwm_device *pwm,
>>   	unsigned long long tmp =3D 0xffffull * NSEC_PER_SEC;
>>   	struct clk *clk =3D pwm_get_chip_data(pwm);
>>   	unsigned long period, duty;
>>  +	enum pwm_polarity polarity;
>>   	long rate;
>>   	int err;
>>=20
>>  @@ -169,6 +183,9 @@ static int jz4740_pwm_apply(struct pwm_chip=20
>> *chip, struct pwm_device *pwm,
>>   	if (duty >=3D period)
>>   		duty =3D period - 1;
>>=20
>>  +	/* Restore regular polarity before disabling the channel. */
>>  +	jz4740_pwm_set_polarity(jz4740, pwm->hwpwm, state->polarity);
>>  +
>=20
> Does this introduce a glitch?

Maybe. But the PWM is shut down before finishing its period anyway, so=20
there was already a glitch.

>>   	jz4740_pwm_disable(chip, pwm);
>>=20
>>   	err =3D clk_set_rate(clk, rate);
>>  @@ -190,29 +207,30 @@ static int jz4740_pwm_apply(struct pwm_chip=20
>> *chip, struct pwm_device *pwm,
>>   	regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
>>   			   TCU_TCSR_PWM_SD, TCU_TCSR_PWM_SD);
>>=20
>>  -	/*
>>  -	 * Set polarity.
>>  -	 *
>>  -	 * The PWM starts in inactive state until the internal timer=20
>> reaches the
>>  -	 * duty value, then becomes active until the timer reaches the=20
>> period
>>  -	 * value. In theory, we should then use (period - duty) as the=20
>> real duty
>>  -	 * value, as a high duty value would otherwise result in the PWM=20
>> pin
>>  -	 * being inactive most of the time.
>>  -	 *
>>  -	 * Here, we don't do that, and instead invert the polarity of the=20
>> PWM
>>  -	 * when it is active. This trick makes the PWM start with its=20
>> active
>>  -	 * state instead of its inactive state.
>>  -	 */
>>  -	if ((state->polarity =3D=3D PWM_POLARITY_NORMAL) ^ state->enabled)
>>  -		regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
>>  -				   TCU_TCSR_PWM_INITL_HIGH, 0);
>>  -	else
>>  -		regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
>>  -				   TCU_TCSR_PWM_INITL_HIGH,
>>  -				   TCU_TCSR_PWM_INITL_HIGH);
>>  -
>>  -	if (state->enabled)
>>  +	if (state->enabled) {
>>  +		/*
>>  +		 * Set polarity.
>>  +		 *
>>  +		 * The PWM starts in inactive state until the internal timer
>>  +		 * reaches the duty value, then becomes active until the timer
>>  +		 * reaches the period value. In theory, we should then use
>>  +		 * (period - duty) as the real duty value, as a high duty value
>>  +		 * would otherwise result in the PWM pin being inactive most of
>>  +		 * the time.
>>  +		 *
>>  +		 * Here, we don't do that, and instead invert the polarity of
>>  +		 * the PWM when it is active. This trick makes the PWM start
>>  +		 * with its active state instead of its inactive state.
>>  +		 */
>>  +		if (state->polarity =3D=3D PWM_POLARITY_NORMAL)
>>  +			polarity =3D PWM_POLARITY_INVERSED;
>>  +		else
>>  +			polarity =3D PWM_POLARITY_NORMAL;
>>  +
>>  +		jz4740_pwm_set_polarity(jz4740, pwm->hwpwm, polarity);
>>  +
>>   		jz4740_pwm_enable(chip, pwm);
>>  +	}
>=20
> Note that for disabled PWMs there is no official guaranty about the=20
> pin
> state. So it would be ok (but admittedly not great) to simplify the
> driver and accept that the pinstate is active while the PWM is off.
> IMHO this is also better than a glitch.
>=20
> If a consumer wants the PWM to be in its inactive state, they should
> not disable it.

Completely disagree. I absolutely do not want the backlight to go full=20
bright mode when the PWM pin is disabled. And disabling the backlight=20
is a thing (for screen blanking and during mode changes).

-Paul


