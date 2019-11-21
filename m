Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF1510504C
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 11:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfKUKRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 05:17:52 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:38616 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfKUKRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 05:17:52 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CA4F71C1B52; Thu, 21 Nov 2019 11:17:50 +0100 (CET)
Date:   Thu, 21 Nov 2019 11:17:50 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 070/422] pinctrl: ingenic: Probe driver at
 subsys_initcall
Message-ID: <20191121101750.GB26882@amd>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051404.162474836@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <20191119051404.162474836@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-11-19 06:14:27, Greg Kroah-Hartman wrote:
> From: Paul Cercueil <paul@crapouillou.net>
>=20
> [ Upstream commit 556a36a71ed80e17ade49225b58513ea3c9e4558 ]
>=20
> Using postcore_initcall() makes the driver try to initialize way too
> early.

Does it fix concrete bug / would you say it is suitable for -stable?

> +++ b/drivers/pinctrl/pinctrl-ingenic.c
> @@ -847,4 +847,4 @@ static int __init ingenic_pinctrl_drv_register(void)
>  {
>  	return platform_driver_register(&ingenic_pinctrl_driver);
>  }
> -postcore_initcall(ingenic_pinctrl_drv_register);
> +subsys_initcall(ingenic_pinctrl_drv_register);

There are other pinctrl drivers initialized very early, do they need
fixing, too?

Best regards,
								Pavel

pavel@amd:~/cip/k$ grep _initcall drivers/pinctrl/pinctrl-*.c
drivers/pinctrl/pinctrl-artpec6.c:arch_initcall(artpec6_pmx_init);
drivers/pinctrl/pinctrl-at91.c:arch_initcall(at91_pinctrl_init);
drivers/pinctrl/pinctrl-coh901.c:arch_initcall(u300_gpio_init);
drivers/pinctrl/pinctrl-falcon.c:core_initcall_sync(pinctrl_falcon_init);
drivers/pinctrl/pinctrl-gemini.c:arch_initcall(gemini_pmx_init);
drivers/pinctrl/pinctrl-ingenic.c:postcore_initcall(ingenic_pinctrl_drv_reg=
ister);
drivers/pinctrl/pinctrl-mcp23s08.c:subsys_initcall(mcp23s08_init);
drivers/pinctrl/pinctrl-oxnas.c:arch_initcall(oxnas_gpio_register);
drivers/pinctrl/pinctrl-oxnas.c:arch_initcall(oxnas_pinctrl_register);
drivers/pinctrl/pinctrl-pic32.c:arch_initcall(pic32_gpio_register);
drivers/pinctrl/pinctrl-pic32.c:arch_initcall(pic32_pinctrl_register);
drivers/pinctrl/pinctrl-pistachio.c:arch_initcall(pistachio_pinctrl_registe=
r);
drivers/pinctrl/pinctrl-rockchip.c:postcore_initcall(rockchip_pinctrl_drv_r=
egister);
drivers/pinctrl/pinctrl-rza1.c:core_initcall(rza1_pinctrl_init);
drivers/pinctrl/pinctrl-st.c:arch_initcall(st_pctl_init);
drivers/pinctrl/pinctrl-sx150x.c:subsys_initcall(sx150x_init);
drivers/pinctrl/pinctrl-u300.c:arch_initcall(u300_pmx_init);
drivers/pinctrl/pinctrl-xway.c:core_initcall_sync(pinmux_xway_init);
drivers/pinctrl/pinctrl-zynq.c:arch_initcall(zynq_pinctrl_init);


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3WZE0ACgkQMOfwapXb+vL5mACbBj3tNHrHKrlOMv9UzJAyBrY9
qZ0Anjx91B7Ocm4dgdbKAStYIEJkDsdr
=NoOf
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
