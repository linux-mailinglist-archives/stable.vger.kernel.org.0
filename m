Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F97F10D5EF
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 14:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfK2NA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 08:00:26 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:51850 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfK2NA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 08:00:26 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 370921C2463; Fri, 29 Nov 2019 14:00:24 +0100 (CET)
Date:   Fri, 29 Nov 2019 14:00:23 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 223/306] net: dsa: bcm_sf2: Turn on PHY to allow
 successful registration
Message-ID: <20191129130023.GA7809@amd>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203131.347612884@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20191127203131.347612884@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Florian Fainelli <f.fainelli@gmail.com>
>=20
> [ Upstream commit c04a17d2a9ccf1eaba1c5a56f83e997540a70556 ]
>=20
> We are binding to the PHY using the SF2 slave MDIO bus that we create,
> binding involves reading the PHY's MII_PHYSID1/2 which won't be possible
> if the PHY is turned off. Temporarily turn it on/off for the bus probing
> to succeeed. This fixes unbind/bind problems where the port connecting
> to that PHY would be in error since it could not connect to it.
>=20
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/dsa/bcm_sf2.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index ca3655d28e00f..17cec68e56b4f 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -1099,12 +1099,16 @@ static int bcm_sf2_sw_probe(struct platform_devic=
e *pdev)
>  		return ret;
>  	}
> =20
> +	bcm_sf2_gphy_enable_set(priv->dev->ds, true);
> +
>  	ret =3D bcm_sf2_mdio_register(ds);
>  	if (ret) {
>  		pr_err("failed to register MDIO bus\n");
>  		return ret;
>  	}
> =20
> +	bcm_sf2_gphy_enable_set(priv->dev->ds, false);
> +

This fails to turn off the PHY in the error case. Reordering like this
should fix it:

  	ret =3D bcm_sf2_mdio_register(ds);
 +	bcm_sf2_gphy_enable_set(priv->dev->ds, false);
  	if (ret) {
  		pr_err("failed to register MDIO bus\n");
  		return ret;
  	}
 =20
Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3hFmcACgkQMOfwapXb+vKB0ACgn7bNTsp42GpDv+r0VLMRWvJy
VZ4AnjyFzFilf9D4/DNFpG9q8Xf0B7N5
=Tao/
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
