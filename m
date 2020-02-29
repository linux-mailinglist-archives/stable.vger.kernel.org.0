Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 525D81747E6
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 17:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgB2QKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 11:10:00 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:36326 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbgB2QKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 11:10:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1582992596; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7mF5atke8Ap8hRErefVt8fGumK0zb1yGxaNC+9qAy0=;
        b=SuGPJR7okTC7LXBeeCaWdPsNYWDgT/MdrEz4hknnQcTSsvTGUCoNLuYy6UHuZOH37NrCyA
        CaUC8XMQ1Obzj8u011QtYf/NkiAktAdN8INTDSn7R9Vn1QnmvP8WSoLhAyQ5kNpFgeNEnA
        y3AFO/cxHpPBAHFfSp8kc3hVj1Dx2kM=
Date:   Sat, 29 Feb 2020 13:09:35 -0300
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH v4 2/5] MIPS: DTS: CI20: fix PMU definitions for ACT8600
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Paul Boddie <paul@boddie.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Message-Id: <1582992575.3.2@crapouillou.net>
In-Reply-To: <af70bb34d95746cdbc468e91e531c4576a1855a6.1582912972.git.hns@goldelico.com>
References: <cover.1582912972.git.hns@goldelico.com>
        <af70bb34d95746cdbc468e91e531c4576a1855a6.1582912972.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nikolaus,


Le ven., f=E9vr. 28, 2020 at 19:02, H. Nikolaus Schaller=20
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
> index 59c104289ece..44741e927d2b 100644
> --- a/arch/mips/boot/dts/ingenic/ci20.dts
> +++ b/arch/mips/boot/dts/ingenic/ci20.dts
> @@ -4,6 +4,8 @@
>  #include "jz4780.dtsi"
>  #include <dt-bindings/clock/ingenic,tcu.h>
>  #include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/interrupt-controller/irq.h>

This include should be in patch 3/5 where it's first used.

With that fixed:
Reviewed-by: Paul Cercueil <paul@crapouillou.net>

for the whole series.

Cheers,
-Paul

> +#include <dt-bindings/regulator/active-semi,8865-regulator.h>
>=20
>  / {
>  	compatible =3D "img,ci20", "ingenic,jz4780";
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

