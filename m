Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1E760C3F1
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 08:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiJYGoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 02:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiJYGoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 02:44:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B31F147D3B
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 23:44:18 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1onDfY-00019b-5n; Tue, 25 Oct 2022 08:44:12 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1onDfY-000G6b-2I; Tue, 25 Oct 2022 08:44:11 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1onDfW-00ASK5-9r; Tue, 25 Oct 2022 08:44:10 +0200
Date:   Tue, 25 Oct 2022 08:44:10 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Thierry Reding <thierry.reding@gmail.com>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/5] pwm: jz4740: Fix pin level of disabled TCU2
 channels, part 2
Message-ID: <20221025064410.brrx5faa4jtwo67b@pengutronix.de>
References: <20221024205213.327001-1-paul@crapouillou.net>
 <20221024205213.327001-3-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a2p5pd46iq5waynm"
Content-Disposition: inline
In-Reply-To: <20221024205213.327001-3-paul@crapouillou.net>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--a2p5pd46iq5waynm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 24, 2022 at 09:52:10PM +0100, Paul Cercueil wrote:
> After commit a020f22a4ff5 ("pwm: jz4740: Make PWM start with the active p=
art"),
> the trick to set duty > period to properly shut down TCU2 channels did
> not work anymore, because of the polarity inversion.
>=20
> Address this issue by restoring the proper polarity before disabling the
> channels.
>=20
> Fixes: a020f22a4ff5 ("pwm: jz4740: Make PWM start with the active part")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Cc: stable@vger.kernel.org
> ---
>  drivers/pwm/pwm-jz4740.c | 62 ++++++++++++++++++++++++++--------------
>  1 file changed, 40 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
> index 228eb104bf1e..65462a0052af 100644
> --- a/drivers/pwm/pwm-jz4740.c
> +++ b/drivers/pwm/pwm-jz4740.c
> @@ -97,6 +97,19 @@ static int jz4740_pwm_enable(struct pwm_chip *chip, st=
ruct pwm_device *pwm)
>  	return 0;
>  }
> =20
> +static void jz4740_pwm_set_polarity(struct jz4740_pwm_chip *jz,
> +				    unsigned int hwpwm,
> +				    enum pwm_polarity polarity)
> +{
> +	unsigned int value =3D 0;
> +
> +	if (polarity =3D=3D PWM_POLARITY_INVERSED)
> +		value =3D TCU_TCSR_PWM_INITL_HIGH;
> +
> +	regmap_update_bits(jz->map, TCU_REG_TCSRc(hwpwm),
> +			   TCU_TCSR_PWM_INITL_HIGH, value);
> +}
> +
>  static void jz4740_pwm_disable(struct pwm_chip *chip, struct pwm_device =
*pwm)
>  {
>  	struct jz4740_pwm_chip *jz =3D to_jz4740(chip);
> @@ -130,6 +143,7 @@ static int jz4740_pwm_apply(struct pwm_chip *chip, st=
ruct pwm_device *pwm,
>  	unsigned long long tmp =3D 0xffffull * NSEC_PER_SEC;
>  	struct clk *clk =3D pwm_get_chip_data(pwm);
>  	unsigned long period, duty;
> +	enum pwm_polarity polarity;
>  	long rate;
>  	int err;
> =20
> @@ -169,6 +183,9 @@ static int jz4740_pwm_apply(struct pwm_chip *chip, st=
ruct pwm_device *pwm,
>  	if (duty >=3D period)
>  		duty =3D period - 1;
> =20
> +	/* Restore regular polarity before disabling the channel. */
> +	jz4740_pwm_set_polarity(jz4740, pwm->hwpwm, state->polarity);
> +

Does this introduce a glitch?

>  	jz4740_pwm_disable(chip, pwm);
> =20
>  	err =3D clk_set_rate(clk, rate);
> @@ -190,29 +207,30 @@ static int jz4740_pwm_apply(struct pwm_chip *chip, =
struct pwm_device *pwm,
>  	regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
>  			   TCU_TCSR_PWM_SD, TCU_TCSR_PWM_SD);
> =20
> -	/*
> -	 * Set polarity.
> -	 *
> -	 * The PWM starts in inactive state until the internal timer reaches the
> -	 * duty value, then becomes active until the timer reaches the period
> -	 * value. In theory, we should then use (period - duty) as the real duty
> -	 * value, as a high duty value would otherwise result in the PWM pin
> -	 * being inactive most of the time.
> -	 *
> -	 * Here, we don't do that, and instead invert the polarity of the PWM
> -	 * when it is active. This trick makes the PWM start with its active
> -	 * state instead of its inactive state.
> -	 */
> -	if ((state->polarity =3D=3D PWM_POLARITY_NORMAL) ^ state->enabled)
> -		regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
> -				   TCU_TCSR_PWM_INITL_HIGH, 0);
> -	else
> -		regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
> -				   TCU_TCSR_PWM_INITL_HIGH,
> -				   TCU_TCSR_PWM_INITL_HIGH);
> -
> -	if (state->enabled)
> +	if (state->enabled) {
> +		/*
> +		 * Set polarity.
> +		 *
> +		 * The PWM starts in inactive state until the internal timer
> +		 * reaches the duty value, then becomes active until the timer
> +		 * reaches the period value. In theory, we should then use
> +		 * (period - duty) as the real duty value, as a high duty value
> +		 * would otherwise result in the PWM pin being inactive most of
> +		 * the time.
> +		 *
> +		 * Here, we don't do that, and instead invert the polarity of
> +		 * the PWM when it is active. This trick makes the PWM start
> +		 * with its active state instead of its inactive state.
> +		 */
> +		if (state->polarity =3D=3D PWM_POLARITY_NORMAL)
> +			polarity =3D PWM_POLARITY_INVERSED;
> +		else
> +			polarity =3D PWM_POLARITY_NORMAL;
> +
> +		jz4740_pwm_set_polarity(jz4740, pwm->hwpwm, polarity);
> +
>  		jz4740_pwm_enable(chip, pwm);
> +	}

Note that for disabled PWMs there is no official guaranty about the pin
state. So it would be ok (but admittedly not great) to simplify the
driver and accept that the pinstate is active while the PWM is off.
IMHO this is also better than a glitch.

If a consumer wants the PWM to be in its inactive state, they should
not disable it.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--a2p5pd46iq5waynm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmNXhbcACgkQwfwUeK3K
7AkPTAgAkbbVJH6ml6oRq6JZCZitTIWqrX4K2Hy3diqa+rEFz0d9cQTpP09RsXtn
zy8yon2OauzmhKKm2kKAYI0OcEROOXQzDHuWqItTJbt1yxs/p97bvCg5+8Ws518x
PgxEqVQOxm3X6+mbrP3AW4Db1AJpmvUIroN224WY/n2JS2g4/fwzIIsx6K3vWNAf
m5MpedDo78923RrMWBJc+n7v/7fuFKIitVzFLbuBZTGTHvwFrObfRTxucQmpDC1j
wEs7fCAYXy6ia4vcMAj+a0mJpyt7y2if+/r/dhvPdGh6Dppm3xMPdYmvRepZdQ2B
vwtYzKON1dlzjFi5MFx0QnDUHEGcVg==
=zXwJ
-----END PGP SIGNATURE-----

--a2p5pd46iq5waynm--
