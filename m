Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E80E1A6083
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 22:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgDLUby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 16:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbgDLUbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 16:31:53 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375A1C0A3BF0;
        Sun, 12 Apr 2020 13:31:54 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EA82A1C69A1; Sun, 12 Apr 2020 22:31:51 +0200 (CEST)
Date:   Sun, 12 Apr 2020 22:31:49 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH 4.19 19/54] extcon: axp288: Add wakeup support
Message-ID: <20200412203149.GA5796@duo.ucw.cz>
References: <20200411115508.284500414@linuxfoundation.org>
 <20200411115510.401693544@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20200411115510.401693544@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 9c94553099efb2ba873cbdddfd416a8a09d0e5f1 upstream.
>=20
> On devices with an AXP288, we need to wakeup from suspend when a charger
> is plugged in, so that we can do charger-type detection and so that the
> axp288-charger driver, which listens for our extcon events, can configure
> the input-current-limit accordingly.

Will it do the same on charger disconnect?

Is that a tiny bit anti-social? I suspend a machine, unplug a charger,
put it into a bag.. but machine is now running.

On some machines (sharp zaurus) we catch such wakeups, do whatever
charging magic we need to do, and put machine back to sleep, so that
user does not see the wakeups (and so that we don't drain the
battery).

Best regards,
								Pavel
> --- a/drivers/extcon/extcon-axp288.c
> +++ b/drivers/extcon/extcon-axp288.c
> @@ -428,9 +428,40 @@ static int axp288_extcon_probe(struct pl
>  	/* Start charger cable type detection */
>  	axp288_extcon_enable(info);
> =20
> +	device_init_wakeup(dev, true);
> +	platform_set_drvdata(pdev, info);
> +
> +	return 0;
> +}
> +
> +static int __maybe_unused axp288_extcon_suspend(struct device *dev)
> +{
> +	struct axp288_extcon_info *info =3D dev_get_drvdata(dev);
> +
> +	if (device_may_wakeup(dev))
> +		enable_irq_wake(info->irq[VBUS_RISING_IRQ]);
> +
>  	return 0;
>  }
> =20
> +static int __maybe_unused axp288_extcon_resume(struct device *dev)
> +{
> +	struct axp288_extcon_info *info =3D dev_get_drvdata(dev);
> +
> +	/*
> +	 * Wakeup when a charger is connected to do charger-type
> +	 * connection and generate an extcon event which makes the
> +	 * axp288 charger driver set the input current limit.
> +	 */
> +	if (device_may_wakeup(dev))
> +		disable_irq_wake(info->irq[VBUS_RISING_IRQ]);
> +
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(axp288_extcon_pm_ops, axp288_extcon_suspend,
> +			 axp288_extcon_resume);
> +
>  static const struct platform_device_id axp288_extcon_table[] =3D {
>  	{ .name =3D "axp288_extcon" },
>  	{},
> @@ -442,6 +473,7 @@ static struct platform_driver axp288_ext
>  	.id_table =3D axp288_extcon_table,
>  	.driver =3D {
>  		.name =3D "axp288_extcon",
> +		.pm =3D &axp288_extcon_pm_ops,
>  	},
>  };
> =20
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXpN6tQAKCRAw5/Bqldv6
8mQNAKCv3VYC7uDA3wGHsGu5GV/42kSFkwCgnAyBHBoLuyz8NmDgVV8sFCBsCfI=
=86ue
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
