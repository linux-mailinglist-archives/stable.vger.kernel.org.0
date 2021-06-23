Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15F53B21A3
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 22:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFWUQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 16:16:08 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35382 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFWUQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 16:16:07 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A5A461C0B76; Wed, 23 Jun 2021 22:13:48 +0200 (CEST)
Date:   Wed, 23 Jun 2021 22:13:48 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RFC 2/2] ARM: dts: imx6dl-yapp4: Fix lp5562 driver probe
Message-ID: <20210623201347.GC8540@amd>
References: <1621003477-11250-1-git-send-email-michal.vokac@ysoft.com>
 <1621003477-11250-3-git-send-email-michal.vokac@ysoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <1621003477-11250-3-git-send-email-michal.vokac@ysoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2021-05-14 16:44:37, Michal Vok=C3=A1=C4=8D wrote:
> Since the LED multicolor framework support was added in commit
> 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
> LEDs on this platform stopped working.
>=20
> Author of the framework attempted to accommodate this DT to the
> framework in commit b86d3d21cd4c ("ARM: dts: imx6dl-yapp4: Add reg proper=
ty
> to the lp5562 channel node") but that is not sufficient. A color property
> is now required even if the multicolor framework is not used, otherwise
> the driver probe fails:
>=20
>   lp5562: probe of 1-0030 failed with error -22
>=20
> Add the color property to fix this and remove the actually unused white
> channel.
>=20
> Fixes: b86d3d21cd4c ("ARM: dts: imx6dl-yapp4: Add reg property to the lp5=
562 channel node")

I believe this is for arm maintainers to take...

> diff --git a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi b/arch/arm/boot/d=
ts/imx6dl-yapp4-common.dtsi
> index 7d2c72562c73..3107bf7fbce5 100644
> --- a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
> +++ b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
> @@ -5,6 +5,7 @@
>  #include <dt-bindings/gpio/gpio.h>
>  #include <dt-bindings/interrupt-controller/irq.h>
>  #include <dt-bindings/input/input.h>
> +#include <dt-bindings/leds/common.h>
>  #include <dt-bindings/pwm/pwm.h>
> =20
>  / {
> @@ -271,6 +272,7 @@
>  			led-cur =3D /bits/ 8 <0x20>;
>  			max-cur =3D /bits/ 8 <0x60>;
>  			reg =3D <0>;
> +			color =3D <LED_COLOR_ID_RED>;
>  		};
> =20
>  		chan@1 {
> @@ -278,6 +280,7 @@
>  			led-cur =3D /bits/ 8 <0x20>;
>  			max-cur =3D /bits/ 8 <0x60>;
>  			reg =3D <1>;
> +			color =3D <LED_COLOR_ID_GREEN>;
>  		};
> =20
>  		chan@2 {
> @@ -285,13 +288,7 @@
>  			led-cur =3D /bits/ 8 <0x20>;
>  			max-cur =3D /bits/ 8 <0x60>;
>  			reg =3D <2>;
> -		};
> -
> -		chan@3 {
> -			chan-name =3D "W";
> -			led-cur =3D /bits/ 8 <0x0>;
> -			max-cur =3D /bits/ 8 <0x0>;
> -			reg =3D <3>;
> +			color =3D <LED_COLOR_ID_BLUE>;
>  		};
>  	};
> =20

What is going on here? "White" channel seems to have disappeared?

Best regards,
							Pavel
--=20
http://www.livejournal.com/~pavelmachek

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDTlfsACgkQMOfwapXb+vKDiQCgtAHVU0b0Z46fbRCOpxwGZ6qT
kzEAoLQzIKhTs9F7ZzphvFOCfHKy02CU
=XyKw
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
