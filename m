Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2EFA507C
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 09:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbfIBH7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 03:59:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729382AbfIBH7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 03:59:12 -0400
Received: from earth.universe (dyndsl-091-096-044-124.ewe-ip-backbone.de [91.96.44.124])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF54E22CF7;
        Mon,  2 Sep 2019 07:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567411151;
        bh=o5Et7ujTI8AOdbxcoxOspVTCOEP9MtLJB0EW/OWRuX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qCDn1YSBV491zHbqvt1m7qFNyzIPpeUDkFctTVemLCCT3iVPzvP//0an+dpk9I3Aj
         Xn8SGj6vH9+9j181OzMQHbDgV/oxLr0QOC0ioB7Xny9nv8TobAVJHd8T629BZzAqeo
         TtzZJwIpobds8mXw32eTpOIrzjWphxfG8fskJDq4=
Received: by earth.universe (Postfix, from userid 1000)
        id E39523C0B7F; Mon,  2 Sep 2019 09:59:08 +0200 (CEST)
Date:   Mon, 2 Sep 2019 09:59:08 +0200
From:   Sebastian Reichel <sre@kernel.org>
To:     Michael Nosthoff <committed@heine.so>
Cc:     linux-pm@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] power: supply: sbs-battery: only return health when
 battery present
Message-ID: <20190902075908.k6mbi7fzp6ikqk4g@earth.universe>
References: <20190816075842.27333-1-committed@heine.so>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zqepmauvldqd5ebk"
Content-Disposition: inline
In-Reply-To: <20190816075842.27333-1-committed@heine.so>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zqepmauvldqd5ebk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 16, 2019 at 09:58:42AM +0200, Michael Nosthoff wrote:
> when the battery is set to sbs-mode and  no gpio detection is enabled
> "health" is always returning a value even when the battery is not present.
> All other fields return "not present".
> This leads to a scenario where the driver is constantly switching between
> "present" and "not present" state. This generates a lot of constant
> traffic on the i2c.
>=20
> This commit changes the response of "health" to an error when the battery
> is not responding leading to a consistent "not present" state.
>=20
> Fixes: 76b16f4cdfb8 ("power: supply: sbs-battery: don't assume
> MANUFACTURER_DATA formats")
>=20
> Signed-off-by: Michael Nosthoff <committed@heine.so>
> Cc: Brian Norris <briannorris@chromium.org>
> Cc: <stable@vger.kernel.org>
> ---

Thanks, queued.

-- Sebastian

>  drivers/power/supply/sbs-battery.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/power/supply/sbs-battery.c b/drivers/power/supply/sb=
s-battery.c
> index 2e86cc1e0e35..f8d74e9f7931 100644
> --- a/drivers/power/supply/sbs-battery.c
> +++ b/drivers/power/supply/sbs-battery.c
> @@ -314,17 +314,22 @@ static int sbs_get_battery_presence_and_health(
>  {
>  	int ret;
> =20
> -	if (psp =3D=3D POWER_SUPPLY_PROP_PRESENT) {
> -		/* Dummy command; if it succeeds, battery is present. */
> -		ret =3D sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
> -		if (ret < 0)
> -			val->intval =3D 0; /* battery disconnected */
> -		else
> -			val->intval =3D 1; /* battery present */
> -	} else { /* POWER_SUPPLY_PROP_HEALTH */
> +	/* Dummy command; if it succeeds, battery is present. */
> +	ret =3D sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
> +
> +	if (ret < 0) { /* battery not present*/
> +		if (psp =3D=3D POWER_SUPPLY_PROP_PRESENT) {
> +			val->intval =3D 0;
> +			return 0;
> +		}
> +		return ret;
> +	}
> +
> +	if (psp =3D=3D POWER_SUPPLY_PROP_PRESENT)
> +		val->intval =3D 1; /* battery present */
> +	else /* POWER_SUPPLY_PROP_HEALTH */
>  		/* SBS spec doesn't have a general health command. */
>  		val->intval =3D POWER_SUPPLY_HEALTH_UNKNOWN;
> -	}
> =20
>  	return 0;
>  }
> @@ -626,6 +631,8 @@ static int sbs_get_property(struct power_supply *psy,
>  		else
>  			ret =3D sbs_get_battery_presence_and_health(client, psp,
>  								  val);
> +
> +		/* this can only be true if no gpio is used */
>  		if (psp =3D=3D POWER_SUPPLY_PROP_PRESENT)
>  			return 0;
>  		break;
> --=20
> 2.20.1
>=20

--zqepmauvldqd5ebk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl1sy8kACgkQ2O7X88g7
+po6XQ//Qrf6hQVpCarNRgYLt/3oWyix/JzTRPtFCwCcUBMJVtFn8pW30q65nLvl
4G8r4hxi8GPstI2wXO4Cb1WTC0OtOzvQsvlRbJtzWnycCwtI/g9s0HqCUqbEK170
pWcaT0PtBLftiy2z7qsNkTo0m8DFAglDtqQuA5dIUZInbBcZScrwZzVcUNJ1kvUQ
8M5SWS5AVWpVClwfnn/zo9hsQyQo8a6Zam68o9vwitGwl83mDrYlrh/5Chi2I5bc
8ltCHK7NJIv0AlT/fKfUmS+ORS/vchPM66wrAnOF9t2XEBCsMOOzZXP1YIz263Ao
HQ0vYt8Tu5U1tD8in/i24q0r1qnoUahlcBivF8fWPRuD2sC+m1SpnomDa/Vnnjzo
tdNOQW6/4hUk5BrjR8O7lCwp4gG+JZ483WyeftwETqPt/WIc9fi14aSBIsBwDpqQ
D6ihm/AcC3btiHahcE8aKM3bCUULtwljD/xEliw4im3vU5FjarBHAncKyRDS10Yd
9OowLXabXz4HggM3/LjXbWglA2a8+dI9KOlTNXxuCZ1TBSS+tnrvrfACh3Xup4B5
hkoFVlhNOtfo9JIpO90N7F2Jh5BGSL/ksGFgJgY2ViFVTgQ40ATbY9wF8mRkcgO6
S0xCvrcwywWOzWAMFozaMl4PR4ey4FENPr2ONLWA0ElfSomsxCc=
=Imm2
-----END PGP SIGNATURE-----

--zqepmauvldqd5ebk--
