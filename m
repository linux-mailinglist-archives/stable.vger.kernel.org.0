Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E801A5C72
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 20:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfIBS5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 14:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726750AbfIBS5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 14:57:51 -0400
Received: from earth.universe (unknown [185.62.205.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F01CC21883;
        Mon,  2 Sep 2019 18:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567450670;
        bh=b9q+F0oWgfqJemt7YPpgOVkZgFWsUthBT+dsjYcADps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ucpxDPnqMNLEOYNQMdQBWre8nDFaw9ck65PeaIpDMfwUfFUwrMihvqEmmMYa/BVXl
         5Rdh7dHeDnogDtM0cLGYdirddDYjHO5mLHnX5h6LtyNcLgi0I9Jy24FPrOhAa4gusP
         0woltmtq1NHGubwcHsx2KafCSlPBVJyWvLGv8hxE=
Received: by earth.universe (Postfix, from userid 1000)
        id 8B3A03C0B7F; Mon,  2 Sep 2019 20:57:47 +0200 (CEST)
Date:   Mon, 2 Sep 2019 20:57:47 +0200
From:   Sebastian Reichel <sre@kernel.org>
To:     Paul Cercueil <paul@crapouillou.net>,
        Artur Rojek <contact@artur-rojek.eu>
Cc:     od@zcrc.me, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] power/supply: ingenic-battery: Don't change scale if
 there's only one
Message-ID: <20190902185747.mt3jku4gfosfu4wz@earth.universe>
References: <20190723024554.9248-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="edm47sjsxpx3tepz"
Content-Disposition: inline
In-Reply-To: <20190723024554.9248-1-paul@crapouillou.net>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--edm47sjsxpx3tepz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 22, 2019 at 10:45:54PM -0400, Paul Cercueil wrote:
> The ADC in the JZ4740 can work either in high-precision mode with a 2.5V
> range, or in low-precision mode with a 7.5V range. The code in place in
> this driver will select the proper scale according to the maximum
> voltage of the battery.
>=20
> The JZ4770 however only has one mode, with a 6.6V range. If only one
> scale is available, there's no need to change it (and nothing to change
> it to), and trying to do so will fail with -EINVAL.
>=20
> Fixes commit fb24ccfbe1e0 ("power: supply: add Ingenic JZ47xx battery
> driver.")

There is a standard format for this. It should be

Fixes: fb24ccfbe1e0 ("power: supply: add Ingenic JZ47xx battery driver.")

> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Cc: stable@vger.kernel.org

Also it would be nice to have an Acked-by from Artur.

-- Sebastian

>  drivers/power/supply/ingenic-battery.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/power/supply/ingenic-battery.c b/drivers/power/suppl=
y/ingenic-battery.c
> index 35816d4b3012..5a53057b4f64 100644
> --- a/drivers/power/supply/ingenic-battery.c
> +++ b/drivers/power/supply/ingenic-battery.c
> @@ -80,6 +80,10 @@ static int ingenic_battery_set_scale(struct ingenic_ba=
ttery *bat)
>  	if (ret !=3D IIO_AVAIL_LIST || scale_type !=3D IIO_VAL_FRACTIONAL_LOG2)
>  		return -EINVAL;
> =20
> +	/* Only one (fractional) entry - nothing to change */
> +	if (scale_len =3D=3D 2)
> +		return 0;
> +
>  	max_mV =3D bat->info.voltage_max_design_uv / 1000;
> =20
>  	for (i =3D 0; i < scale_len; i +=3D 2) {
> --=20
> 2.21.0.593.g511ec345e18
>=20

--edm47sjsxpx3tepz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl1tZigACgkQ2O7X88g7
+pqIeA//bbrrfgxWrAbtsrO9ZahirCLvKBApSmv0pQQ7flaauiQiUxUNcDDnEVU/
aAty+Pta0ZUOsFm9xfGWLYB1qU0jyRvv2mBaCZRpr3W/K2fs8dLJSPXbVcgOYElz
0FdU5p72ksy2gr0vhPO++SccNNJYxVvCTs7ihiEpp2w6MVkcLLKfPPn8JsmteoJA
ZtsbYcRJr3I8z2VMhe0oT2xbAq9h9N/VCdZqccEDgIh3pvReEVXNyfgvZ+3BdZ3T
89eDpFST/XY9PZyWtlfBi18GEzd9Y9VQPgJro95/n1JoxmLOCyd0Bmh3Nc1Wykhv
E1aEgvI3tjiufbpaY8Oy2SoXEKG8nR77hCMw8wEswnpcqvaFPNNExEj3HtEWGaJC
Atyw/dppgRneeOgLXfxaIKqGHjyOTIZ/Q3Wm7CqHmQFAOHTcnQ48NRG0JjXzrxqO
0ykLvhHfpQ64xYAfzY5CdKCKplHQs7dt8ql2+y+GCg6rOYpRl6pgcSCaaEqV1u2a
L+Iu58ykLla3OXfniDl7ZywkhA+ssWjUUmjf0uf1ZC3EgiPA8bEaIZ+6AqaYpCES
QdXX6VJEaoh9RbdbADMXp+5dk/3xXSTffFxncwUZoT2Jy37Pb0Kim8lB10v4TASo
3GLpSDnixlny9WEapyG9oMC76dh1sZtQ6Bf/Ca5TgXAh+HwkBQI=
=ANOV
-----END PGP SIGNATURE-----

--edm47sjsxpx3tepz--
