Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2766230CAA5
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbhBBS4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:56:20 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:38536 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239109AbhBBSyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 13:54:16 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E21E11C0B7A; Tue,  2 Feb 2021 19:53:17 +0100 (CET)
Date:   Tue, 2 Feb 2021 19:53:17 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 24/28] can: dev: prevent potential information leak
 in can_fill_info()
Message-ID: <20210202185317.GB6964@duo.ucw.cz>
References: <20210202132941.180062901@linuxfoundation.org>
 <20210202132942.158736432@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <20210202132942.158736432@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> [ Upstream commit b552766c872f5b0d90323b24e4c9e8fa67486dd5 ]
>=20
> The "bec" struct isn't necessarily always initialized. For example, the
> mcp251xfd_get_berr_counter() function doesn't initialize anything if the
> interface is down.

Well, yes... and =3D {} does not neccessarily initialize all of the
structure... for example padding.

It is really simple

struct can_berr_counter {
	__u16 txerr;
	__u16 rxerr;
};

but maybe something like alpha uses padding in such case, and memset
would be better?

Best regards,
								Pavel
							=09
> +++ b/drivers/net/can/dev.c
> @@ -987,7 +987,7 @@ static int can_fill_info(struct sk_buff *skb, const s=
truct net_device *dev)
>  {
>  	struct can_priv *priv =3D netdev_priv(dev);
>  	struct can_ctrlmode cm =3D {.flags =3D priv->ctrlmode};
> -	struct can_berr_counter bec;
> +	struct can_berr_counter bec =3D { };
>  	enum can_state state =3D priv->state;
> =20
>  	if (priv->do_get_state)

--=20
http://www.livejournal.com/~pavelmachek

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYBmfnQAKCRAw5/Bqldv6
8l+nAKCXX2HX1zDQVMwPfg4kQfgvTPa2MACdFZcCo092ceOgDfdTEFoHc2wmi10=
=Ol11
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
