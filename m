Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9267E3F6964
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 21:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhHXTAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 15:00:55 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:40948 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhHXTAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 15:00:54 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7DF9A1C0B7C; Tue, 24 Aug 2021 21:00:09 +0200 (CEST)
Date:   Tue, 24 Aug 2021 21:00:09 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Saravana Kannan <saravanak@google.com>,
        Andrew Lunn <andrew@lunn.ch>, Marc Zyngier <maz@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 64/98] net: mdio-mux: Handle -EPROBE_DEFER correctly
Message-ID: <20210824190009.GA16752@duo.ucw.cz>
References: <20210824165908.709932-1-sashal@kernel.org>
 <20210824165908.709932-65-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20210824165908.709932-65-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi1

> When registering mdiobus children, if we get an -EPROBE_DEFER, we shouldn=
't
> ignore it and continue registering the rest of the mdiobus children. This
> would permanently prevent the deferring child mdiobus from working instead
> of reattempting it in the future. So, if a child mdiobus needs to be
> reattempted in the future, defer the entire mdio-mux initialization.
>=20
> This fixes the issue where PHYs sitting under the mdio-mux aren't
> initialized correctly if the PHY's interrupt controller is not yet ready
> when the mdio-mux is being probed. Additional context in the link
> below.

I don't believe this is quite right. AFAICT it leaks memory in the
EPROBE_DEFER case. Could someone double-check? Suggested fix is below.

> +++ b/drivers/net/mdio/mdio-mux.c
> @@ -175,11 +175,15 @@ int mdio_mux_init(struct device *dev,
>  		cb->mii_bus->write =3D mdio_mux_write;
>  		r =3D of_mdiobus_register(cb->mii_bus, child_bus_node);
>  		if (r) {
> +			mdiobus_free(cb->mii_bus);
> +			if (r =3D=3D -EPROBE_DEFER) {
> +				ret_val =3D r;
> +				goto err_loop;
> +			}
> +			devm_kfree(dev, cb);
>  			dev_err(dev,
>  				"Error: Failed to register MDIO bus for child %pOF\n",
>  				child_bus_node);
> -			mdiobus_free(cb->mii_bus);
> -			devm_kfree(dev, cb);
>  		} else {
>  			cb->next =3D pb->children;
>  			pb->children =3D cb;


Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/net/mdio/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
index ccb3ee704eb1..6d0e505343c5 100644
--- a/drivers/net/mdio/mdio-mux.c
+++ b/drivers/net/mdio/mdio-mux.c
@@ -163,6 +163,7 @@ int mdio_mux_init(struct device *dev,
 		cb->mii_bus =3D mdiobus_alloc();
 		if (!cb->mii_bus) {
 			ret_val =3D -ENOMEM;
+			devm_kfree(dev, cb);
 			goto err_loop;
 		}
 		cb->mii_bus->priv =3D cb;
@@ -176,11 +177,11 @@ int mdio_mux_init(struct device *dev,
 		r =3D of_mdiobus_register(cb->mii_bus, child_bus_node);
 		if (r) {
 			mdiobus_free(cb->mii_bus);
+			devm_kfree(dev, cb);
 			if (r =3D=3D -EPROBE_DEFER) {
 				ret_val =3D r;
 				goto err_loop;
 			}
-			devm_kfree(dev, cb);
 			dev_err(dev,
 				"Error: Failed to register MDIO bus for child %pOF\n",
 				child_bus_node);


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYSVBuQAKCRAw5/Bqldv6
8tfRAKCWghPzFCsPyYpMEcstMJGD5kGI/ACgoPniAAEgJTGINK3sjHXpEvyqCx4=
=eArL
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
