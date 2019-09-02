Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1C6CA4F9D
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 09:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbfIBHS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 03:18:58 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:58263 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfIBHS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 03:18:58 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46MLzf3gM2z1rLFL;
        Mon,  2 Sep 2019 09:18:52 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46MLzc4myWz1qqkT;
        Mon,  2 Sep 2019 09:18:52 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id iRjT9HkWJF2O; Mon,  2 Sep 2019 09:18:51 +0200 (CEST)
X-Auth-Info: 1fofoDkj/sSISQ7mkFsrw3FNiILFdTXV4XFMgUK3HCY=
Received: from jawa (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon,  2 Sep 2019 09:18:51 +0200 (CEST)
Date:   Mon, 2 Sep 2019 09:18:44 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Alexander Sverdlin <alexander.sverdlin@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-spi@vger.kernel.org,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@armlinux.org.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] spi: ep93xx: Repair SPI CS lookup tables
Message-ID: <20190902091844.7151e0c7@jawa>
In-Reply-To: <20190831180402.10008-1-alexander.sverdlin@gmail.com>
References: <20190831180402.10008-1-alexander.sverdlin@gmail.com>
Organization: denx.de
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.E1ugfHjC1jx=p6Oc2PH0Ak"; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/.E1ugfHjC1jx=p6Oc2PH0Ak
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Aug 2019 20:04:02 +0200
Alexander Sverdlin <alexander.sverdlin@gmail.com> wrote:

> The actual device name of the SPI controller being registered on
> EP93xx is "spi0" (as seen by gpiod_find_lookup_table()). This patch
> fixes all relevant lookup tables and the following failure (seen on
> EDB9302):
>=20
> ep93xx-spi ep93xx-spi.0: failed to register SPI master
> ep93xx-spi: probe of ep93xx-spi.0 failed with error -22
>=20
> Fixes: 1dfbf334f1236 ("spi: ep93xx: Convert to use CS GPIO
> descriptors") Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
> ---
>  arch/arm/mach-ep93xx/edb93xx.c       | 2 +-
>  arch/arm/mach-ep93xx/simone.c        | 2 +-
>  arch/arm/mach-ep93xx/ts72xx.c        | 4 ++--
>  arch/arm/mach-ep93xx/vision_ep9307.c | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/arm/mach-ep93xx/edb93xx.c
> b/arch/arm/mach-ep93xx/edb93xx.c index 1f0da76a39de..7b7280c21ee0
> 100644 --- a/arch/arm/mach-ep93xx/edb93xx.c
> +++ b/arch/arm/mach-ep93xx/edb93xx.c
> @@ -103,7 +103,7 @@ static struct spi_board_info
> edb93xx_spi_board_info[] __initdata =3D { };
> =20
>  static struct gpiod_lookup_table edb93xx_spi_cs_gpio_table =3D {
> -	.dev_id =3D "ep93xx-spi.0",
> +	.dev_id =3D "spi0",
>  	.table =3D {
>  		GPIO_LOOKUP("A", 6, "cs", GPIO_ACTIVE_LOW),
>  		{ },
> diff --git a/arch/arm/mach-ep93xx/simone.c
> b/arch/arm/mach-ep93xx/simone.c index e2658e22bba1..8a53b74dc4b2
> 100644 --- a/arch/arm/mach-ep93xx/simone.c
> +++ b/arch/arm/mach-ep93xx/simone.c
> @@ -73,7 +73,7 @@ static struct spi_board_info simone_spi_devices[]
> __initdata =3D {
>   * v1.3 parts will still work, since the signal on SFRMOUT is
> automatic. */
>  static struct gpiod_lookup_table simone_spi_cs_gpio_table =3D {
> -	.dev_id =3D "ep93xx-spi.0",
> +	.dev_id =3D "spi0",
>  	.table =3D {
>  		GPIO_LOOKUP("A", 1, "cs", GPIO_ACTIVE_LOW),
>  		{ },
> diff --git a/arch/arm/mach-ep93xx/ts72xx.c
> b/arch/arm/mach-ep93xx/ts72xx.c index 582e06e104fd..e0e1b11032f1
> 100644 --- a/arch/arm/mach-ep93xx/ts72xx.c
> +++ b/arch/arm/mach-ep93xx/ts72xx.c
> @@ -267,7 +267,7 @@ static struct spi_board_info bk3_spi_board_info[]
> __initdata =3D {
>   * goes through CPLD
>   */
>  static struct gpiod_lookup_table bk3_spi_cs_gpio_table =3D {
> -	.dev_id =3D "ep93xx-spi.0",
> +	.dev_id =3D "spi0",
>  	.table =3D {
>  		GPIO_LOOKUP("F", 3, "cs", GPIO_ACTIVE_LOW),
>  		{ },
> @@ -316,7 +316,7 @@ static struct spi_board_info ts72xx_spi_devices[]
> __initdata =3D { };
> =20
>  static struct gpiod_lookup_table ts72xx_spi_cs_gpio_table =3D {
> -	.dev_id =3D "ep93xx-spi.0",
> +	.dev_id =3D "spi0",
>  	.table =3D {
>  		/* DIO_17 */
>  		GPIO_LOOKUP("F", 2, "cs", GPIO_ACTIVE_LOW),
> diff --git a/arch/arm/mach-ep93xx/vision_ep9307.c
> b/arch/arm/mach-ep93xx/vision_ep9307.c index
> a88a1d807b32..cbcba3136d74 100644 ---
> a/arch/arm/mach-ep93xx/vision_ep9307.c +++
> b/arch/arm/mach-ep93xx/vision_ep9307.c @@ -242,7 +242,7 @@ static
> struct spi_board_info vision_spi_board_info[] __initdata =3D { };
> =20
>  static struct gpiod_lookup_table vision_spi_cs_gpio_table =3D {
> -	.dev_id =3D "ep93xx-spi.0",
> +	.dev_id =3D "spi0",
>  	.table =3D {
>  		GPIO_LOOKUP_IDX("A", 6, "cs", 0, GPIO_ACTIVE_LOW),
>  		GPIO_LOOKUP_IDX("A", 7, "cs", 1, GPIO_ACTIVE_LOW),

Reviewed-by: Lukasz Majewski <lukma@denx.de>



Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/.E1ugfHjC1jx=p6Oc2PH0Ak
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAl1swlQACgkQAR8vZIA0
zr3+WQf/XIsR1DvcVHYrv/AqG2VMK2nHuEmL7pQRG+F6npsf4ZtJA1itjJFaJTfK
Fto3DNWJT/AILpKyWiitz37tEjWWTBrlnFauCTmIWQImCw3BYVhMLUs/I3Nabup5
OnBaFb2mBMJaCc0kLFL+mWxq3tU0fBwJKYA0zbsPQf/0gIUL6s/ywpdwql87uLfW
H+0B4xofjPQavzt/wy5K0yo4lYO9g8UxOSJn8e0CSJh6u9NVzqidcmmBSCw1vSC5
6D0di0GiJp9nQLxO+DrEnvy6F6ia3Up3CqQqk36mhZaFIHb4jQtTAAvupvRPFCxF
BgI8cjOVEkbIIwl6J8C91BOwOdQpmg==
=8uiE
-----END PGP SIGNATURE-----

--Sig_/.E1ugfHjC1jx=p6Oc2PH0Ak--
