Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9F410F75
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 00:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfEAW5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 18:57:42 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37532 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfEAW5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 18:57:41 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id C35C0261212
Received: by earth.universe (Postfix, from userid 1000)
        id B9AF23C0D1B; Thu,  2 May 2019 00:57:36 +0200 (CEST)
Date:   Thu, 2 May 2019 00:57:36 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] power: supply: axp288_fuel_gauge: Add ACEPC T8 and T11
 mini PCs to the blacklist
Message-ID: <20190501225736.jhbyklotrtndux5v@earth.universe>
References: <20190422204301.6233-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4pxoyuqearsvopnh"
Content-Disposition: inline
In-Reply-To: <20190422204301.6233-1-hdegoede@redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4pxoyuqearsvopnh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 22, 2019 at 10:43:01PM +0200, Hans de Goede wrote:
> The ACEPC T8 and T11 Cherry Trail Z8350 mini PCs use an AXP288 and as PCs,
> rather then portables, they does not have a battery. Still for some
> reason the AXP288 not only thinks there is a battery, it actually
> thinks it is discharging while the PC is running, slowly going to
> 0% full, causing userspace to shutdown the system due to the battery
> being critically low after a while.
>
> This commit adds the ACEPC T8 and T11 to the axp288 fuel-gauge driver
> blacklist, so that we stop reporting bogus battery readings on this devic=
e.
>=20
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1690852
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---

Thanks, you made my day =F0=9F=98=82. Queued to power-supply's for-next bra=
nch.

-- Sebastian

>  drivers/power/supply/axp288_fuel_gauge.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>=20
> diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/sup=
ply/axp288_fuel_gauge.c
> index 9ff2461820d8..368281bc0d2b 100644
> --- a/drivers/power/supply/axp288_fuel_gauge.c
> +++ b/drivers/power/supply/axp288_fuel_gauge.c
> @@ -685,6 +685,26 @@ static void fuel_gauge_init_irq(struct axp288_fg_inf=
o *info)
>   * detection reports one despite it not being there.
>   */
>  static const struct dmi_system_id axp288_fuel_gauge_blacklist[] =3D {
> +	{
> +		/* ACEPC T8 Cherry Trail Z8350 mini PC */
> +		.matches =3D {
> +			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "To be filled by O.E.M."),
> +			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "T8"),
> +			/* also match on somewhat unique bios-version */
> +			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "1.000"),
> +		},
> +	},
> +	{
> +		/* ACEPC T11 Cherry Trail Z8350 mini PC */
> +		.matches =3D {
> +			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "To be filled by O.E.M."),
> +			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "T11"),
> +			/* also match on somewhat unique bios-version */
> +			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "1.000"),
> +		},
> +	},
>  	{
>  		/* Intel Cherry Trail Compute Stick, Windows version */
>  		.matches =3D {
> --=20
> 2.21.0
>=20

--4pxoyuqearsvopnh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlzKJF0ACgkQ2O7X88g7
+pqOAA/+OYV/kWE96sNXL8NC8HBO1UDZCTL5+6c0WPit1ocVRYXw8Zl2bBD9UeGG
+qWPTgzJrlxv4WIv420x99yjJNYoCJTyZsLjpLAGxuIJ37vRMOYOgd6eh/qsiown
T45XYWVTtdznhpeciJxW+FkqxfKGriZgD7aaV4tzAoXjb/nGvYwy4MSTnL+fpwzi
yVkEJvBbIGyp2S+gHNotPXvZ6g7mKd9uEO8kBUi4OlPjD44ZtE8cVx1t2lNAqJQv
8yRHFaQSJM99aRVdtQ6DoEYft3A35FkSuWAW741h8K/GSH93yFfNEw4GE1lBOPoW
Y4Yn4XoISo5RIwWjUJafpOuEnEQF+SKaFuDP62wwUpJOpLN8gF/BJS/WhmZSaizx
dE9764X7AfylMlj2v//tAS0jfPrsMeafZdGfnwZuAOyy8y2IJ3j7pPOqIZLLD9LR
T1iNAADQU0An0HX60tewCxzEUMrnf+2miret0l5g25s3uWCOlBcNImUuG3sgfZRA
PTQJdsIdsqVpqBGm1MbbKIcuJ222MqtWt7d9BW45xtLoecGKHHLtvjZBdo5gDxqY
W5vtZr7ZAwT9bqPqHCqouurW+AADa7d1SZiGo/blIklO3K0uJ+27lKWNXEtCHwm+
yyerIOhx4wiq9uFtaHrAjOosfe0gZ8VIfgaJfYgvU97efGypTgk=
=91c6
-----END PGP SIGNATURE-----

--4pxoyuqearsvopnh--
