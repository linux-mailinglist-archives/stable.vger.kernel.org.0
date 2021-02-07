Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2A7312330
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 10:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhBGJ0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 04:26:14 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40816 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhBGJ0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 04:26:10 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1C51D1C0B77; Sun,  7 Feb 2021 10:25:28 +0100 (CET)
Date:   Sun, 7 Feb 2021 10:25:27 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.4 01/32] net: dsa: bcm_sf2: put device node before
 return
Message-ID: <20210207092527.GB32297@amd>
References: <20210205140652.348864025@linuxfoundation.org>
 <20210205140652.414435105@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <20210205140652.414435105@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Pan Bian <bianpan2016@163.com>
>=20
> commit cf3c46631e1637582f517a574c77cd6c05793817 upstream.
>=20
> Put the device node dn before return error code on failure path.

This fixes one resource leak, but exposes next one: get_device() is
not undone in the second error path and in the end of function.

Best regards,
							Pavel

> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -421,15 +421,19 @@ static int bcm_sf2_mdio_register(struct
>  	/* Find our integrated MDIO bus node */
>  	dn =3D of_find_compatible_node(NULL, NULL, "brcm,unimac-mdio");
>  	priv->master_mii_bus =3D of_mdio_find_bus(dn);
> -	if (!priv->master_mii_bus)
> +	if (!priv->master_mii_bus) {
> +		of_node_put(dn);
>  		return -EPROBE_DEFER;
> +	}
> =20
>  	get_device(&priv->master_mii_bus->dev);
>  	priv->master_mii_dn =3D dn;
> =20
>  	priv->slave_mii_bus =3D devm_mdiobus_alloc(ds->dev);
> -	if (!priv->slave_mii_bus)
> +	if (!priv->slave_mii_bus) {
> +		of_node_put(dn);
>  		return -ENOMEM;
> +	}
> =20
>  	priv->slave_mii_bus->priv =3D priv;
>  	priv->slave_mii_bus->name =3D "sf2 slave mii";
>=20

--=20
http://www.livejournal.com/~pavelmachek

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAfsgcACgkQMOfwapXb+vKFfQCeJ3svL4kIy6zxFrOZoIvwQv27
jxsAoKdfe3FnCslEBpZLL3R87KpwUGE4
=LJc7
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
