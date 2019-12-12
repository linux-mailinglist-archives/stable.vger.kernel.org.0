Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9DA11CE55
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 14:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfLLNbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 08:31:35 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:47976 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729302AbfLLNbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 08:31:35 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 723A61C2461; Thu, 12 Dec 2019 14:31:33 +0100 (CET)
Date:   Thu, 12 Dec 2019 14:31:32 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 185/243] ARM: dts: sun8i: a23/a33: Fix up RTC device
 node
Message-ID: <20191212133132.GA13171@amd>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150351.658072828@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20191211150351.658072828@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The RTC module on the A23 was claimed to be the same as on the A31, when
> in fact it is not. The A31 does not have an RTC external clock output,
> and its internal RC oscillator's average clock rate is not in the same
> range. The A33's RTC is the same as the A23.
>=20
> This patch fixes the compatible string and clock properties to conform
> to the updated bindings. The register range is also fixed.

No, this is not okay for v4.19. New compatible is not in
=2E/drivers/rtc/rtc-sun6i.c, so this will completely break rtc support.

Best regards,
								Pavel

> +++ b/arch/arm/boot/dts/sun8i-a23-a33.dtsi
> @@ -565,11 +565,11 @@
>  		};
> =20
>  		rtc: rtc@1f00000 {
> -			compatible =3D "allwinner,sun6i-a31-rtc";
> -			reg =3D <0x01f00000 0x54>;
> +			compatible =3D "allwinner,sun8i-a23-rtc";
> +			reg =3D <0x01f00000 0x400>;
>  			interrupts =3D <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>,
>  				     <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
> -			clock-output-names =3D "osc32k";
> +			clock-output-names =3D "osc32k", "osc32k-out";
>  			clocks =3D <&ext_osc32k>;
>  			#clock-cells =3D <1>;
>  		};

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3yQTQACgkQMOfwapXb+vINnACfSuFVVvBSSyClbD3yZFaOyLyO
HiIAoK7yohRRq657OxcfA88kbpQdOpHe
=opG4
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
