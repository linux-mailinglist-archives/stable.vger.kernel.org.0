Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B5DCC93B
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 12:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfJEKCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 06:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfJEKCP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Oct 2019 06:02:15 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F13112133F;
        Sat,  5 Oct 2019 10:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570269734;
        bh=m6LrBg7MJD79UJpB4HucLtlJvJ8+4uAw8KrPnz16hH4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EPZC3YH/iyV3EmrMJLSGYrKUMpzwTd7G2x0SWAkOlMrsb1+2c/WCN1oPIuyiIGJlO
         QPZ1G2x2FzT4tj2q9v57sisMM/JHradVxCvcGd9jlglk3hbawRo3Fhoz3diypd5mUZ
         R4yntHyhn7aiRBb8YS9puqp6Blg5CoJjF2BsWmf0=
Date:   Sat, 5 Oct 2019 11:02:09 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Chen-Yu Tsai <wens@csie.org>, linux-iio@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] iio: adc: axp288: Override TS pin bias current for some
 models
Message-ID: <20191005110209.16a9041d@archlinux>
In-Reply-To: <20190915185342.235354-1-hdegoede@redhat.com>
References: <20190915185342.235354-1-hdegoede@redhat.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 15 Sep 2019 20:53:42 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> Since commit 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling") we
> preserve the bias current set by the firmware at boot.  This fixes issues
> we were seeing on various models, but it seems our old hardcoded 80=C5=B3=
A bias
> current was working around a firmware bug on at least one model laptop.
>=20
> In order to both have our cake and eat it, this commit adds a dmi based
> list of models where we need to override the firmware set bias current and
> adds the one model we now know needs this to it: The Lenovo Ideapad 100S
> (11 inch version).

Ouch.

>=20
> Cc: stable@vger.kernel.org
> Fixes: 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling")
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D203829
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Applied to the fixes-togreg branch of iio.git.

Thanks,

Jonathan

> ---
>  drivers/iio/adc/axp288_adc.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>=20
> diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
> index 31d51bcc5f2c..85d08e68b34f 100644
> --- a/drivers/iio/adc/axp288_adc.c
> +++ b/drivers/iio/adc/axp288_adc.c
> @@ -7,6 +7,7 @@
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
>   */
> =20
> +#include <linux/dmi.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/device.h>
> @@ -25,6 +26,11 @@
>  #define AXP288_ADC_EN_MASK				0xF0
>  #define AXP288_ADC_TS_ENABLE				0x01
> =20
> +#define AXP288_ADC_TS_BIAS_MASK				GENMASK(5, 4)
> +#define AXP288_ADC_TS_BIAS_20UA				(0 << 4)
> +#define AXP288_ADC_TS_BIAS_40UA				(1 << 4)
> +#define AXP288_ADC_TS_BIAS_60UA				(2 << 4)
> +#define AXP288_ADC_TS_BIAS_80UA				(3 << 4)
>  #define AXP288_ADC_TS_CURRENT_ON_OFF_MASK		GENMASK(1, 0)
>  #define AXP288_ADC_TS_CURRENT_OFF			(0 << 0)
>  #define AXP288_ADC_TS_CURRENT_ON_WHEN_CHARGING		(1 << 0)
> @@ -177,10 +183,36 @@ static int axp288_adc_read_raw(struct iio_dev *indi=
o_dev,
>  	return ret;
>  }
> =20
> +/*
> + * We rely on the machine's firmware to correctly setup the TS pin bias =
current
> + * at boot. This lists systems with broken fw where we need to set it ou=
rselves.
> + */
> +static const struct dmi_system_id axp288_adc_ts_bias_override[] =3D {
> +	{
> +		/* Lenovo Ideapad 100S (11 inch) */
> +		.matches =3D {
> +		  DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +		  DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad 100S-11IBY"),
> +		},
> +		.driver_data =3D (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
> +	},
> +	{}
> +};
> +
>  static int axp288_adc_initialize(struct axp288_adc_info *info)
>  {
> +	const struct dmi_system_id *bias_override;
>  	int ret, adc_enable_val;
> =20
> +	bias_override =3D dmi_first_match(axp288_adc_ts_bias_override);
> +	if (bias_override) {
> +		ret =3D regmap_update_bits(info->regmap, AXP288_ADC_TS_PIN_CTRL,
> +					 AXP288_ADC_TS_BIAS_MASK,
> +					 (uintptr_t)bias_override->driver_data);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	/*
>  	 * Determine if the TS pin is enabled and set the TS current-source
>  	 * accordingly.

