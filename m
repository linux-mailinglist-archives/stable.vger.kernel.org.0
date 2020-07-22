Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C647722975D
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 13:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgGVL0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 07:26:32 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46958 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgGVL0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 07:26:31 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 43FD41C0BD8; Wed, 22 Jul 2020 13:26:30 +0200 (CEST)
Date:   Wed, 22 Jul 2020 13:26:29 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 4.19 031/133] iio: magnetometer: ak8974: Fix runtime PM
 imbalance on error
Message-ID: <20200722112629.GA22052@duo.ucw.cz>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152805.241721533@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20200720152805.241721533@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Dinghao Liu <dinghao.liu@zju.edu.cn>
>=20
> commit 0187294d227dfc42889e1da8f8ce1e44fc25f147 upstream.
>=20
> When devm_regmap_init_i2c() returns an error code, a pairing
> runtime PM usage counter decrement is needed to keep the
> counter balanced. For error paths after ak8974_set_power(),
> ak8974_detect() and ak8974_reset(), things are the same.
>=20
> However, When iio_triggered_buffer_setup() returns an error
> code, there will be two PM usgae counter decrements.
>=20
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> Fixes: 7c94a8b2ee8c ("iio: magn: add a driver for AK8974")
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Cc: <Stable@vger.kernel.org>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  drivers/iio/magnetometer/ak8974.c |   19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>=20
> --- a/drivers/iio/magnetometer/ak8974.c
> +++ b/drivers/iio/magnetometer/ak8974.c
> @@ -768,19 +768,21 @@ static int ak8974_probe(struct i2c_clien
>  	ak8974->map =3D devm_regmap_init_i2c(i2c, &ak8974_regmap_config);
>  	if (IS_ERR(ak8974->map)) {
>  		dev_err(&i2c->dev, "failed to allocate register map\n");
> +		pm_runtime_put_noidle(&i2c->dev);
> +		pm_runtime_disable(&i2c->dev);
>  		return PTR_ERR(ak8974->map);
>  	}

This misses regulator_bulk_disable(), afaict. I believe it can be
refactored to use common exit...?

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXxgiZQAKCRAw5/Bqldv6
8nCmAKCAwLPkZhthjcHlArt2YGMSNZGIPQCfTodsTJ8DOGk9TB/bKJR/xbFg0M4=
=vOA0
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
