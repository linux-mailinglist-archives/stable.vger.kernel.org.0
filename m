Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E66848231D
	for <lists+stable@lfdr.de>; Fri, 31 Dec 2021 10:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhLaJwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Dec 2021 04:52:47 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:33490 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhLaJwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Dec 2021 04:52:46 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6C7551C0B77; Fri, 31 Dec 2021 10:52:45 +0100 (CET)
Date:   Fri, 31 Dec 2021 10:52:44 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Phil Elwell <phil@raspberrypi.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 29/76] pinctrl: bcm2835: Change init order for gpio
 hogs
Message-ID: <20211231095244.GA17525@amd>
References: <20211227151324.694661623@linuxfoundation.org>
 <20211227151325.694918163@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20211227151325.694918163@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Phil Elwell <phil@raspberrypi.com>
>=20
> [ Upstream commit 266423e60ea1b953fcc0cd97f3dad85857e434d1 ]
>=20
> ...and gpio-ranges
>=20
> pinctrl-bcm2835 is a combined pinctrl/gpio driver. Currently the gpio
> side is registered first, but this breaks gpio hogs (which are
> configured during gpiochip_add_data). Part of the hog initialisation
> is a call to pinctrl_gpio_request, and since the pinctrl driver hasn't
> yet been registered this results in an -EPROBE_DEFER from which it can
> never recover.
>=20
> Change the initialisation sequence to register the pinctrl driver
> first.

This does not get error handling right.

> diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/=
pinctrl-bcm2835.c
> index 1d21129f7751c..40ce18a0d0190 100644
> --- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
> +++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
> @@ -1244,6 +1244,18 @@ static int bcm2835_pinctrl_probe(struct platform_d=
evice *pdev)
>  		raw_spin_lock_init(&pc->irq_lock[i]);
>  	}
> =20
> +	pc->pctl_desc =3D *pdata->pctl_desc;
> +	pc->pctl_dev =3D devm_pinctrl_register(dev, &pc->pctl_desc, pc);
> +	if (IS_ERR(pc->pctl_dev)) {
> +		gpiochip_remove(&pc->gpio_chip);
> +		return PTR_ERR(pc->pctl_dev);
> +	}

You do gpiochip_remove(), even when it was not added.

> @@ -1251,8 +1263,10 @@ static int bcm2835_pinctrl_probe(struct platform_d=
evice *pdev)
>  	girq->parents =3D devm_kcalloc(dev, BCM2835_NUM_IRQS,
>  				     sizeof(*girq->parents),
>  				     GFP_KERNEL);
> -	if (!girq->parents)
> +	if (!girq->parents) {
> +		pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
>  		return -ENOMEM;
> +	}

And yes, adding the removes here makes sense, but it looks like some
are missing (in 5.10).

Something like this?

Best regards,
								Pavel
diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pi=
nctrl-bcm2835.c
index 40ce18a0d019..d605548de7df 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -1247,7 +1247,6 @@ static int bcm2835_pinctrl_probe(struct platform_devi=
ce *pdev)
 	pc->pctl_desc =3D *pdata->pctl_desc;
 	pc->pctl_dev =3D devm_pinctrl_register(dev, &pc->pctl_desc, pc);
 	if (IS_ERR(pc->pctl_dev)) {
-		gpiochip_remove(&pc->gpio_chip);
 		return PTR_ERR(pc->pctl_dev);
 	}
=20
@@ -1264,16 +1263,18 @@ static int bcm2835_pinctrl_probe(struct platform_de=
vice *pdev)
 				     sizeof(*girq->parents),
 				     GFP_KERNEL);
 	if (!girq->parents) {
-		pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
-		return -ENOMEM;
+		err =3D -ENOMEM;
+		goto remove_gpio;
 	}
=20
 	if (is_7211) {
 		pc->wake_irq =3D devm_kcalloc(dev, BCM2835_NUM_IRQS,
 					    sizeof(*pc->wake_irq),
 					    GFP_KERNEL);
-		if (!pc->wake_irq)
-			return -ENOMEM;
+		if (!pc->wake_irq) {
+			err =3D -ENOMEM;
+			goto remove_gpio;
+		}
 	}
=20
 	/*
@@ -1297,8 +1298,10 @@ static int bcm2835_pinctrl_probe(struct platform_dev=
ice *pdev)
=20
 		len =3D strlen(dev_name(pc->dev)) + 16;
 		name =3D devm_kzalloc(pc->dev, len, GFP_KERNEL);
-		if (!name)
-			return -ENOMEM;
+		if (!name) {
+			err =3D -ENOMEM;
+			goto remove_gpio;
+		}
=20
 		snprintf(name, len, "%s:bank%d", dev_name(pc->dev), i);
=20
@@ -1317,11 +1320,14 @@ static int bcm2835_pinctrl_probe(struct platform_de=
vice *pdev)
 	err =3D gpiochip_add_data(&pc->gpio_chip, pc);
 	if (err) {
 		dev_err(dev, "could not add GPIO chip\n");
-		pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
-		return err;
+		goto remove_gpio;
 	}
=20
 	return 0;
+
+remove_gpio:
+	pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
+	return err;
 }
=20
 static struct platform_driver bcm2835_pinctrl_driver =3D {


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmHO0uwACgkQMOfwapXb+vJNVACeKPWDpBMeNuuxZxvSqr3Nac/n
gBEAnRXIwuf5s40g1TZLNiX1jCR3fxwL
=Z4qv
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
