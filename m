Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E88304BE5
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbhAZV5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390695AbhAZSHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 13:07:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962D5C061573
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 10:06:53 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1l4Sjs-0004PW-92; Tue, 26 Jan 2021 19:06:52 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1l4Sjr-0000Ge-2I; Tue, 26 Jan 2021 19:06:51 +0100
Date:   Tue, 26 Jan 2021 19:06:50 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     stable@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 5.10-stable] gpio: mvebu: fix pwm .get_state period
 calculation
Message-ID: <20210126180650.xsrycbnwzu4lzl55@pengutronix.de>
References: <d1d7d548eba25119397de87211de763c54b5d8cd.1611651611.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aa5fbk45owefugof"
Content-Disposition: inline
In-Reply-To: <d1d7d548eba25119397de87211de763c54b5d8cd.1611651611.git.baruch@tkos.co.il>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aa5fbk45owefugof
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 26, 2021 at 11:00:11AM +0200, Baruch Siach wrote:
> commit e73b0101ae5124bf7cd3fb5d250302ad2f16a416 upstream.
>=20
> The period is the sum of on and off values. That is, calculate period as
>=20
>   ($on + $off) / clkrate
>=20
> instead of
>=20
>   $off / clkrate - $on / clkrate
>=20
> that makes no sense.
>=20
> Reported-by: Russell King <linux@armlinux.org.uk>
> Reviewed-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Fixes: 757642f9a584e ("gpio: mvebu: Add limited PWM support")
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Doesn't this need something like:

	[baruch: Backported to 5.10]

plus a new S-o-B?

> ---
>=20
> This backported patch applies to all kernels between 4.14 and 5.10
> (inclusive).
> ---
>  drivers/gpio/gpio-mvebu.c | 25 ++++++++++---------------
>  1 file changed, 10 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
> index 2f245594a90a..ed7c5fc47f52 100644
> --- a/drivers/gpio/gpio-mvebu.c
> +++ b/drivers/gpio/gpio-mvebu.c
> @@ -660,9 +660,8 @@ static void mvebu_pwm_get_state(struct pwm_chip *chip,
> =20
>  	spin_lock_irqsave(&mvpwm->lock, flags);
> =20
> -	val =3D (unsigned long long)
> -		readl_relaxed(mvebu_pwmreg_blink_on_duration(mvpwm));
> -	val *=3D NSEC_PER_SEC;
> +	u =3D readl_relaxed(mvebu_pwmreg_blink_on_duration(mvpwm));
> +	val =3D (unsigned long long) u * NSEC_PER_SEC;
>  	do_div(val, mvpwm->clk_rate);
>  	if (val > UINT_MAX)
>  		state->duty_cycle =3D UINT_MAX;
> @@ -671,21 +670,17 @@ static void mvebu_pwm_get_state(struct pwm_chip *ch=
ip,
>  	else
>  		state->duty_cycle =3D 1;
> =20
> -	val =3D (unsigned long long)
> -		readl_relaxed(mvebu_pwmreg_blink_off_duration(mvpwm));
> +	val =3D (unsigned long long) u; /* on duration */
> +	/* period =3D on + off duration */
> +	val +=3D readl_relaxed(mvebu_pwmreg_blink_off_duration(mvpwm));
>  	val *=3D NSEC_PER_SEC;
>  	do_div(val, mvpwm->clk_rate);
> -	if (val < state->duty_cycle) {
> +	if (val > UINT_MAX)
> +		state->period =3D UINT_MAX;
> +	else if (val)
> +		state->period =3D val;
> +	else
>  		state->period =3D 1;
> -	} else {
> -		val -=3D state->duty_cycle;
> -		if (val > UINT_MAX)
> -			state->period =3D UINT_MAX;
> -		else if (val)
> -			state->period =3D val;
> -		else
> -			state->period =3D 1;
> -	}
> =20
>  	regmap_read(mvchip->regs, GPIO_BLINK_EN_OFF + mvchip->offset, &u);
>  	if (u)

Reviewed-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--aa5fbk45owefugof
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmAQWjcACgkQwfwUeK3K
7AnYEwgAmwzBgCsqRu/G9lEIQE8O5nzXuxzEWiPgSE3nKk8LkHdEd91PC8sdTzJ7
G4m1IM/FxRLy0y+Yr/O+bMKJjAfhMJbTy8ULlXj8ObLnZ1A5XRDHkY6U+2fnAGqB
ArWDkrxToS0MzUP7XoV1KooKnVzNhmZKkoqUQ7naWqkZuOAzvfsQp1+MjkLISK1e
wtNeLwTtxx1KYpimBK5tx1oi5ENQuyrOvQvCYxG/U5INqmLSR41opLeFs4y5N30Z
AYy+NIyFmRybqrltsyXIIVOQ0V2mJUYrEkCH5gYAmmD1bsj6+mS2aZmxJPM83b+h
NlCuWAyiKJGhtBkNW1wd8Ab9CC/VyQ==
=86/2
-----END PGP SIGNATURE-----

--aa5fbk45owefugof--
