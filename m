Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63EFDAD8E7
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 14:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfIIMXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 08:23:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44529 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfIIMXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 08:23:14 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 206C6808A9; Mon,  9 Sep 2019 14:22:59 +0200 (CEST)
Date:   Mon, 9 Sep 2019 14:23:12 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 21/57] gpio: Fix build error of function redefinition
Message-ID: <20190909122312.GB18869@amd>
References: <20190908121125.608195329@linuxfoundation.org>
 <20190908121134.504042593@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <20190908121134.504042593@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-09-08 13:41:45, Greg Kroah-Hartman wrote:
> [ Upstream commit 68e03b85474a51ec1921b4d13204782594ef7223 ]
>=20
> when do randbuilding, I got this error:
>=20
> In file included from drivers/hwmon/pmbus/ucd9000.c:19:0:
> ./include/linux/gpio/driver.h:576:1: error: redefinition of gpiochip_add_=
pin_range
>  gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
>  ^~~~~~~~~~~~~~~~~~~~~~
> In file included from drivers/hwmon/pmbus/ucd9000.c:18:0:
> ./include/linux/gpio.h:245:1: note: previous definition of gpiochip_add_p=
in_range was here
>  gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
>  ^~~~~~~~~~~~~~~~~~~~~~
>

I'm pretty sure this will cause problems.

driver.h versions return zero and are conditional on !CONFIG_PINCTRL.

gpio.h versions did return error and did warn... and are conditional
on !CONFIG_GPIOLIB.

So this introduces error in !CONFIG_PINCTRL && !CONFIG_GPIOLIB case.

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl12RDAACgkQMOfwapXb+vKZ5ACeJt2t4fTSAaWT+mQXU4LL/XUg
BIoAnRgC42Bj6kxvyiOtAGtggTKSoTit
=Rgfb
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
