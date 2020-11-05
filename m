Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B892A7D72
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 12:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgKELqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 06:46:53 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59770 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgKELqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 06:46:53 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7F67A1C0B85; Thu,  5 Nov 2020 12:46:48 +0100 (CET)
Date:   Thu, 5 Nov 2020 12:46:48 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 107/191] ARM: dts: s5pv210: move PMU node out of
 clock controller
Message-ID: <20201105114648.GB9009@duo.ucw.cz>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203243.594174920@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <20201103203243.594174920@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The Power Management Unit (PMU) is a separate device which has little
> common with clock controller.  Moving it to one level up (from clock
> controller child to SoC) allows to remove fake simple-bus compatible and
> dtbs_check warnings like:
>=20
>   clock-controller@e0100000: $nodename:0:
>     'clock-controller@e0100000' does not match '^([a-z][a-z0-9\\-]+-bus|b=
us|soc|axi|ahb|apb)(@[0-9a-f]+)?$'

> +++ b/arch/arm/boot/dts/s5pv210.dtsi
> @@ -98,19 +98,16 @@
>  		};
> =20
>  		clocks: clock-controller@e0100000 {
> -			compatible =3D "samsung,s5pv210-clock", "simple-bus";
> +			compatible =3D "samsung,s5pv210-clock";
>  			reg =3D <0xe0100000 0x10000>;
=2E..
> +		pmu_syscon: syscon@e0108000 {
> +			compatible =3D "samsung-s5pv210-pmu", "syscon";
> +			reg =3D <0xe0108000 0x8000>;
>  		};

Should clock-controller@e0100000's reg be shortened to 0x8000 so that
the ranges do not overlap?

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel

diff --git a/arch/arm/boot/dts/s5pv210.dtsi b/arch/arm/boot/dts/s5pv210.dtsi
index 020a864623ff..54fc3fb56ca1 100644
--- a/arch/arm/boot/dts/s5pv210.dtsi
+++ b/arch/arm/boot/dts/s5pv210.dtsi
@@ -99,7 +99,7 @@
=20
 		clocks: clock-controller@e0100000 {
 			compatible =3D "samsung,s5pv210-clock";
-			reg =3D <0xe0100000 0x10000>;
+			reg =3D <0xe0100000 0x8000>;
 			clock-names =3D "xxti", "xusbxti";
 			clocks =3D <&xxti>, <&xusbxti>;
 			#clock-cells =3D <1>;



--=20
http://www.livejournal.com/~pavelmachek

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX6PmKAAKCRAw5/Bqldv6
8j5nAJ0Rl6JZRJTHh1JgEDbzv0ce6O8sswCfdBBDlRFhZEpcqSURE5bvZ0sLRVE=
=6wTl
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
