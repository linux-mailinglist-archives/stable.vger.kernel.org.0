Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615FF1739EF
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 15:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgB1OeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 09:34:25 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:36694 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbgB1OeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 09:34:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1582900463; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2iYh4GJzCLrpeJtYfBs2xAG0SYopNEWP83AbHh4thW0=;
        b=WpX2Sf49Pg3NYVfFNkB1+sdFRtdvG7324DYZQJC+r0R8jOEbxPd9Sl1beMCcybT3g3qE/4
        7VhUhSA40280rvkxb0YZeXo0Zi7SfuwjfGkva1nut9xwr5CRXaAJ+Zvr+MidI847N5jK8l
        /XvuqKBvVyA3Z0yMJA0rHGE/f2P3TMo=
Date:   Fri, 28 Feb 2020 11:34:04 -0300
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH v3 3/6] MIPS: DTS: CI20: fix PMU definitions for ACT8600
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Paul Boddie <paul@boddie.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Message-Id: <1582900444.3.1@crapouillou.net>
In-Reply-To: <36aa1e80153fbb29eeb56f65cac9e3672165f7b7.1581884459.git.hns@goldelico.com>
References: <cover.1581884459.git.hns@goldelico.com>
        <36aa1e80153fbb29eeb56f65cac9e3672165f7b7.1581884459.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nikolaus,


Le dim., f=E9vr. 16, 2020 at 21:20, H. Nikolaus Schaller=20
<hns@goldelico.com> a =E9crit :
> There is a ACT8600 on the CI20 board and the bindings of the
> ACT8865 driver have changed without updating the CI20 device
> tree. Therefore the PMU can not be probed successfully and
> is running in power-on reset state.
>=20
> Fix DT to match the latest act8865-regulator bindings.
>=20
> Fixes: 73f2b940474d ("MIPS: CI20: DTS: Add I2C nodes")
> Cc: stable@vger.kernel.org
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>  arch/mips/boot/dts/ingenic/ci20.dts | 48=20
> ++++++++++++++++++++---------
>  1 file changed, 33 insertions(+), 15 deletions(-)
>=20
> diff --git a/arch/mips/boot/dts/ingenic/ci20.dts=20
> b/arch/mips/boot/dts/ingenic/ci20.dts
> index 59c104289ece..4f48bc16fb52 100644
> --- a/arch/mips/boot/dts/ingenic/ci20.dts
> +++ b/arch/mips/boot/dts/ingenic/ci20.dts
> @@ -153,6 +153,8 @@
>  	pinctrl-0 =3D <&pins_uart4>;
>  };
>=20
> +#include <dt-bindings/regulator/active-semi,8865-regulator.h>

Includes at the beginning of the file please. Keeps it tidy.

> +
>  &i2c0 {
>  	status =3D "okay";
>=20
> @@ -166,65 +168,81 @@
>  		reg =3D <0x5a>;
>  		status =3D "okay";
>=20
> +/*
> +Optional input supply properties:
> +- for act8600:
> +  - vp1-supply: The input supply for DCDC_REG1
> +  - vp2-supply: The input supply for DCDC_REG2
> +  - vp3-supply: The input supply for DCDC_REG3
> +  - inl-supply: The input supply for LDO_REG5, LDO_REG6, LDO_REG7=20
> and LDO_REG8
> +  SUDCDC_REG4, LDO_REG9 and LDO_REG10 do not have separate supplies.
> +*/
> +
>  		regulators {
>  			vddcore: SUDCDC1 {
> -				regulator-name =3D "VDDCORE";
> +				regulator-name =3D "DCDC_REG1";
>  				regulator-min-microvolt =3D <1100000>;
>  				regulator-max-microvolt =3D <1100000>;
>  				regulator-always-on;
>  			};
>  			vddmem: SUDCDC2 {
> -				regulator-name =3D "VDDMEM";
> +				regulator-name =3D "DCDC_REG2";
>  				regulator-min-microvolt =3D <1500000>;
>  				regulator-max-microvolt =3D <1500000>;
>  				regulator-always-on;
>  			};
>  			vcc_33: SUDCDC3 {
> -				regulator-name =3D "VCC33";
> +				regulator-name =3D "DCDC_REG3";
>  				regulator-min-microvolt =3D <3300000>;
>  				regulator-max-microvolt =3D <3300000>;
>  				regulator-always-on;
>  			};
>  			vcc_50: SUDCDC4 {
> -				regulator-name =3D "VCC50";
> +				regulator-name =3D "SUDCDC_REG4";
>  				regulator-min-microvolt =3D <5000000>;
>  				regulator-max-microvolt =3D <5000000>;
>  				regulator-always-on;
>  			};
>  			vcc_25: LDO_REG5 {
> -				regulator-name =3D "VCC25";
> +				regulator-name =3D "LDO_REG5";
>  				regulator-min-microvolt =3D <2500000>;
>  				regulator-max-microvolt =3D <2500000>;
>  				regulator-always-on;
>  			};
>  			wifi_io: LDO_REG6 {
> -				regulator-name =3D "WIFIIO";
> +				regulator-name =3D "LDO_REG6";
>  				regulator-min-microvolt =3D <2500000>;
>  				regulator-max-microvolt =3D <2500000>;
>  				regulator-always-on;
>  			};
>  			vcc_28: LDO_REG7 {
> -				regulator-name =3D "VCC28";
> +				regulator-name =3D "LDO_REG7";
>  				regulator-min-microvolt =3D <2800000>;
>  				regulator-max-microvolt =3D <2800000>;
>  				regulator-always-on;
>  			};
>  			vcc_15: LDO_REG8 {
> -				regulator-name =3D "VCC15";
> +				regulator-name =3D "LDO_REG8";
>  				regulator-min-microvolt =3D <1500000>;
>  				regulator-max-microvolt =3D <1500000>;
>  				regulator-always-on;
>  			};
> -			vcc_18: LDO_REG9 {
> -				regulator-name =3D "VCC18";
> -				regulator-min-microvolt =3D <1800000>;
> -				regulator-max-microvolt =3D <1800000>;
> +			vrtc_18: LDO_REG9 {
> +				regulator-name =3D "LDO_REG9";
> +				/* Despite the datasheet stating 3.3V for REG9 and
> +				   driver expecting that, REG9 outputs 1.8V.
> +				   Likely the CI20 uses a chip variant.
> +				   Since it is a simple on/off LDO the exact values
> +				   do not matter.
> +				*/
> +				regulator-min-microvolt =3D <3300000>;
> +				regulator-max-microvolt =3D <3300000>;
>  				regulator-always-on;
>  			};
>  			vcc_11: LDO_REG10 {
> -				regulator-name =3D "VCC11";
> -				regulator-min-microvolt =3D <1100000>;
> -				regulator-max-microvolt =3D <1100000>;
> +				regulator-name =3D "LDO_REG10";
> +				regulator-min-microvolt =3D <1200000>;
> +				regulator-max-microvolt =3D <1200000>;
>  				regulator-always-on;
>  			};
>  		};
> --
> 2.23.0
>=20

=

