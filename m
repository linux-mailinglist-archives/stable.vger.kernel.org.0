Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C662849D4BE
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 22:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbiAZV7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 16:59:40 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:41952 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiAZV7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 16:59:39 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4CADB1C0B98; Wed, 26 Jan 2022 22:59:38 +0100 (CET)
Date:   Wed, 26 Jan 2022 22:59:37 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Antony Antony <antony.antony@secunet.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 173/563] xfrm: interface with if_id 0 should return
 error
Message-ID: <20220126215937.GA31158@duo.ucw.cz>
References: <20220124184024.407936072@linuxfoundation.org>
 <20220124184030.397155595@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20220124184030.397155595@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 8dce43919566f06e865f7e8949f5c10d8c2493f5 ]
>=20
> xfrm interface if_id =3D 0 would cause xfrm policy lookup errors since
> Commit 9f8550e4bd9d.
>=20
> Now explicitly fail to create an xfrm interface when if_id =3D 0

This will break changelink completely, AFAICT.

> @@ -672,7 +677,12 @@ static int xfrmi_changelink(struct net_device *dev, =
struct nlattr *tb[],
>  {
>  	struct xfrm_if *xi =3D netdev_priv(dev);
>  	struct net *net =3D xi->net;
> -	struct xfrm_if_parms p;
> +	struct xfrm_if_parms p =3D {};
> +
> +	if (!p.if_id) {
> +		NL_SET_ERR_MSG(extack, "if_id must be non zero");
> +		return -EINVAL;
> +	}
> =20
>  	xfrmi_netlink_parms(data, &p);
>  	xi =3D xfrmi_locate(net, &p);

if_id will be always 0, because it was not yet initialized.

Best regards,
									Pavel

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 57448fc519fc..eb028b835f70 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -673,12 +673,11 @@ static int xfrmi_changelink(struct net_device *dev, s=
truct nlattr *tb[],
 	struct net *net =3D xi->net;
 	struct xfrm_if_parms p =3D {};
=20
+	xfrmi_netlink_parms(data, &p);
 	if (!p.if_id) {
 		NL_SET_ERR_MSG(extack, "if_id must be non zero");
 		return -EINVAL;
 	}
-
-	xfrmi_netlink_parms(data, &p);
 	xi =3D xfrmi_locate(net, &p);
 	if (!xi) {
 		xi =3D netdev_priv(dev);


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYfHESQAKCRAw5/Bqldv6
8t5TAJsEGF0qY9QcY/GNpfFLwJQ91+ICoACeNt8NupmC26i4gJ4iEQGDalXODyA=
=IEDm
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
