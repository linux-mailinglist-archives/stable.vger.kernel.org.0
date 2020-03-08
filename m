Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF5F17D100
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 04:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCHDTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 22:19:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgCHDTR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 22:19:17 -0500
Received: from earth.universe (unknown [185.62.205.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0696D206D5;
        Sun,  8 Mar 2020 03:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583637556;
        bh=Lxkl+cXPrnt028nmFZf9hC8DEReNgkxfG7mu+DTXxXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dTTTp7YF1BUUlsIHBYRB3TiPoqIfy7vQKgoj+l3TEfJIC5LLuQgsGgvJGaCX8Yabm
         8soSLi0BEjZkiKSHMzc+oxWO7S8Dz6L43feepgkZBxa4jmjA1QFjScWntltF6lr8lS
         safAOk5dQ6TbfovkUu7SeRClTJhuulKd9WxbFFXU=
Received: by earth.universe (Postfix, from userid 1000)
        id 834B73C0C82; Sun,  8 Mar 2020 04:19:13 +0100 (CET)
Date:   Sun, 8 Mar 2020 04:19:13 +0100
From:   Sebastian Reichel <sre@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] power: supply: axp288_charger: Add special handling for
 HP Pavilion x2 10
Message-ID: <20200308031913.7of7rgo3panpcbp3@earth.universe>
References: <20200223153208.312005-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rsp5gs46n5prqzc2"
Content-Disposition: inline
In-Reply-To: <20200223153208.312005-1-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rsp5gs46n5prqzc2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Feb 23, 2020 at 04:32:08PM +0100, Hans de Goede wrote:
> Some HP Pavilion x2 10 models use an AXP288 for charging and fuel-gauge.
> We use a native power_supply / PMIC driver in this case, because on most
> models with an AXP288 the ACPI AC / Battery code is either completely
> missing or relies on custom / proprietary ACPI OpRegions which Linux
> does not implement.
>=20
> The native drivers mostly work fine, but there are 2 problems:
>=20
> 1. These model uses a Type-C connector for charging which the AXP288 does
> not support. As long as a Type-A charger (which uses the USB data pins for
> charger type detection) is used everything is fine. But if a Type-C
> charger is used (such as the charger shipped with the device) then the
> charger is not recognized.
>=20
> So we end up slowly discharging the device even though a charger is
> connected, because we are limiting the current from the charger to 500mA.
> To make things worse this happens with the device's official charger.
>=20
> Looking at the ACPI tables HP has "solved" the problem of the AXP288 not
> being able to recognize Type-C chargers by simply always programming the
> input-current-limit at 3000mA and relying on a Vhold setting of 4.7V
> (normally 4.4V) to limit the current intake if the charger cannot handle
> this.
>=20
> 2. If no charger is connected when the machine boots then it boots with t=
he
> vbus-path disabled. On other devices this is done when a 5V boost convert=
er
> is active to avoid the PMIC trying to charge from the 5V boost output.
> This is done when an OTG host cable is inserted and the ID pin on the
> micro-B receptacle is pulled low, the ID pin has an ACPI event handler
> associated with it which re-enables the vbus-path when the ID pin is pull=
ed
> high when the OTG cable is removed. The Type-C connector has no ID pin,
> there is no ID pin handler and there appears to be no 5V boost converter,
> so we end up not charging because the vbus-path is disabled, until we
> unplug the charger which automatically clears the vbus-path disable bit a=
nd
> then on the second plug-in of the adapter we start charging.
>=20
> The HP Pavilion x2 10 models with an AXP288 do have mostly working ACPI
> AC / Battery code which does not rely on custom / proprietary ACPI
> OpRegions. So one possible solution would be to blacklist the AXP288
> native power_supply drivers and add the HP Pavilion x2 10 with AXP288
> DMI ids to the list of devices which should use the ACPI AC / Battery
> code even though they have an AXP288 PMIC. This would require changes to
> 4 files: drivers/acpi/ac.c, drivers/power/supply/axp288_charger.c,
> drivers/acpi/battery.c and drivers/power/supply/axp288_fuel_gauge.c.
>=20
> Beside needing adding the same DMI matches to 4 different files, this
> approach also triggers problem 2. from above, but then when suspended,
> during suspend the machine will not wakeup because the vbus path is
> disabled by the AML code when not charging, so the Vbus low-to-high
> IRQ is not triggered, the CPU never wakes up and the device does not
> charge even though the user likely things it is charging, esp. since
> the charge status LED is directly coupled to an adapter being plugged
> in and does not reflect actual charging.
>=20
> This could be worked by enabling vbus-path explicitly from say the
> axp288_charger driver's suspend handler.
>=20
> So neither situation is ideal, in both cased we need to explicitly enable
> the vbus-path to work around different variants of problem 2 above, this
> requires a quirk in the axp288_charger code.
>=20
> If we go the route of using the ACPI AC / Battery drivers then we need
> modifications to 3 other drivers; and we need to partially disable the
> axp288_charger code, while at the same time keeping it around to enable
> vbus-path on suspend.
>=20
> OTOH we can copy the hardcoding of 3A input-current-limit (we never touch
> Vhold, so that would stay at 4.7V) to the axp288_charger code, which needs
> changes regardless, then we concentrate all special handling of this
> interesting device model in the axp288_charger code. That is what this
> commit does.
>=20
> Cc: stable@vger.kernel.org
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1791098
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---

Thanks for the nice explanations in the commit message and the
comment in the code :) I queued the patch to power-supply's
for-next branch wondering if there is any sane system containing
an axp288.

-- Sebastian

>  drivers/power/supply/axp288_charger.c | 57 ++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/power/supply/axp288_charger.c b/drivers/power/supply=
/axp288_charger.c
> index 1bbba6bba673..cf4c67b2d235 100644
> --- a/drivers/power/supply/axp288_charger.c
> +++ b/drivers/power/supply/axp288_charger.c
> @@ -21,6 +21,7 @@
>  #include <linux/property.h>
>  #include <linux/mfd/axp20x.h>
>  #include <linux/extcon.h>
> +#include <linux/dmi.h>
> =20
>  #define PS_STAT_VBUS_TRIGGER		BIT(0)
>  #define PS_STAT_BAT_CHRG_DIR		BIT(2)
> @@ -545,6 +546,49 @@ static irqreturn_t axp288_charger_irq_thread_handler=
(int irq, void *dev)
>  	return IRQ_HANDLED;
>  }
> =20
> +/*
> + * The HP Pavilion x2 10 series comes in a number of variants:
> + * Bay Trail SoC    + AXP288 PMIC, DMI_BOARD_NAME: "815D"
> + * Cherry Trail SoC + AXP288 PMIC, DMI_BOARD_NAME: "813E"
> + * Cherry Trail SoC + TI PMIC,     DMI_BOARD_NAME: "827C" or "82F4"
> + *
> + * The variants with the AXP288 PMIC are all kinds of special:
> + *
> + * 1. All variants use a Type-C connector which the AXP288 does not supp=
ort, so
> + * when using a Type-C charger it is not recognized. Unlike most AXP288 =
devices,
> + * this model actually has mostly working ACPI AC / Battery code, the AC=
PI code
> + * "solves" this by simply setting the input_current_limit to 3A.
> + * There are still some issues with the ACPI code, so we use this native=
 driver,
> + * and to solve the charging not working (500mA is not enough) issue we =
hardcode
> + * the 3A input_current_limit like the ACPI code does.
> + *
> + * 2. If no charger is connected the machine boots with the vbus-path di=
sabled.
> + * Normally this is done when a 5V boost converter is active to avoid th=
e PMIC
> + * trying to charge from the 5V boost converter's output. This is done w=
hen
> + * an OTG host cable is inserted and the ID pin on the micro-B receptacl=
e is
> + * pulled low and the ID pin has an ACPI event handler associated with it
> + * which re-enables the vbus-path when the ID pin is pulled high when the
> + * OTG host cable is removed. The Type-C connector has no ID pin, there =
is
> + * no ID pin handler and there appears to be no 5V boost converter, so we
> + * end up not charging because the vbus-path is disabled, until we unplug
> + * the charger which automatically clears the vbus-path disable bit and =
then
> + * on the second plug-in of the adapter we start charging. To solve the =
not
> + * charging on first charger plugin we unconditionally enable the vbus-p=
ath at
> + * probe on this model, which is safe since there is no 5V boost convert=
er.
> + */
> +static const struct dmi_system_id axp288_hp_x2_dmi_ids[] =3D {
> +	{
> +		/*
> +		 * Bay Trail model has "Hewlett-Packard" as sys_vendor, Cherry
> +		 * Trail model has "HP", so we only match on product_name.
> +		 */
> +		.matches =3D {
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion x2 Detachable"),
> +		},
> +	},
> +	{} /* Terminating entry */
> +};
> +
>  static void axp288_charger_extcon_evt_worker(struct work_struct *work)
>  {
>  	struct axp288_chrg_info *info =3D
> @@ -568,7 +612,11 @@ static void axp288_charger_extcon_evt_worker(struct =
work_struct *work)
>  	}
> =20
>  	/* Determine cable/charger type */
> -	if (extcon_get_state(edev, EXTCON_CHG_USB_SDP) > 0) {
> +	if (dmi_check_system(axp288_hp_x2_dmi_ids)) {
> +		/* See comment above axp288_hp_x2_dmi_ids declaration */
> +		dev_dbg(&info->pdev->dev, "HP X2 with Type-C, setting inlmt to 3A\n");
> +		current_limit =3D 3000000;
> +	} else if (extcon_get_state(edev, EXTCON_CHG_USB_SDP) > 0) {
>  		dev_dbg(&info->pdev->dev, "USB SDP charger is connected\n");
>  		current_limit =3D 500000;
>  	} else if (extcon_get_state(edev, EXTCON_CHG_USB_CDP) > 0) {
> @@ -685,6 +733,13 @@ static int charger_init_hw_regs(struct axp288_chrg_i=
nfo *info)
>  		return ret;
>  	}
> =20
> +	if (dmi_check_system(axp288_hp_x2_dmi_ids)) {
> +		/* See comment above axp288_hp_x2_dmi_ids declaration */
> +		ret =3D axp288_charger_vbus_path_select(info, true);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
>  	/* Read current charge voltage and current limit */
>  	ret =3D regmap_read(info->regmap, AXP20X_CHRG_CTRL1, &val);
>  	if (ret < 0) {
> --=20
> 2.25.0
>=20

--rsp5gs46n5prqzc2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl5kZCYACgkQ2O7X88g7
+poJghAAmtfSikEs+QynEpoFaU8TL/AWZJ/wRWJEDo9LnSsfxaU7g76yXGsxKr80
cBICanSglAfvE2VQtQZdsjXBrixhgmzktZ830pjOK+1veZobFIYxT9MjmyKKsSXy
mAfm9dKSF7UB19svDP74UM9Z/YWoEdzc7cVi2l2l/A8RQb0ASRvDxtWP8gUGLEdN
wEsQSfYjS7ahjYcxYrOL4jsH4indvGWVVXIi02gIiRSZyMrG8eJ2Tg0fZh4TFig0
yMC7xiuZoGlNgzl29qeZbQvFvTKQU4aPdRyJ1wilIf433lCTQiKIikrJMSU5pzc5
3YxleH0r1+LmmCDWO1LKLgQ1cDtSle/0XUNk5HeXCRZCg6O88I26Rl9IBCqATZzX
XenOo8QB6pJZxp1huo7o4Ne3ahOEqBiIUBz+Rf5HR8HBlZPh6wiJ7agH2+7xoFvx
2C/3UX7Arrqb5YdDemsDMkz+uuXlnBP4s/jaioZd/9T9VxbnRkzgdtQOJxK77EAj
Go17Ur29nnlvoOxRRoO3KH4bmB/3zRdxovLl1r7ocvpiBdgQDr06igQeSFraxr0b
aLt8eQBTo1yp7Std0NmedxXn1aQTu9l2dSNU92T50gxYrta0IhexHYPEKwqFcaF9
2Ck2iRvk8NfSYBzvRniafpPg9zbdLpqIgal6OcydyHHU8VMIQwg=
=LGha
-----END PGP SIGNATURE-----

--rsp5gs46n5prqzc2--
