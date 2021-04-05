Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1373435437E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 17:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbhDEPhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 11:37:53 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48518 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238086AbhDEPhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 11:37:52 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 71B081C0B7D; Mon,  5 Apr 2021 17:37:44 +0200 (CEST)
Date:   Mon, 5 Apr 2021 17:37:43 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nathan Rossi <nathan.rossi@digi.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 048/126] net: ethernet: aquantia: Handle error
 cleanup of start on open
Message-ID: <20210405153743.GA305@amd>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085032.625044515@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20210405085032.625044515@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Nathan Rossi <nathan.rossi@digi.com>
>=20
> [ Upstream commit 8a28af7a3e85ddf358f8c41e401a33002f7a9587 ]
>=20
> The aq_nic_start function can fail in a variety of cases which leaves
> the device in broken state.
>=20
> An example case where the start function fails is the
> request_threaded_irq which can be interrupted, resulting in a EINTR
> result. This can be manually triggered by bringing the link up (e.g. ip
> link set up) and triggering a SIGINT on the initiating process (e.g.
> Ctrl+C). This would put the device into a half configured state.
> Subsequently bringing the link up again would cause the napi_enable to
> BUG.
>=20
> In order to correctly clean up the failed attempt to start a device call
> aq_nic_stop.

No.

> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
> @@ -71,8 +71,10 @@ static int aq_ndev_open(struct net_device *ndev)
>  		goto err_exit;
> =20
>  	err =3D aq_nic_start(aq_nic);
> -	if (err < 0)
> +	if (err < 0) {
> +		aq_nic_stop(aq_nic);
>  		goto err_exit;
> +	}
> =20
>  err_exit:
>  	if (err < 0)

First, take a look at the goto. Does not need to be there.

Second check the crazy calling convention. If nic_start() fails, it
should clean up after itself.

Then, check the code. nic_stop() undoes initialization that was not
even done in the nic_start().

This introduces more problems than it solves.

Best regards,
							Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBrLscACgkQMOfwapXb+vJaaQCeLCWHqYP6YA09DF4mZXy41bEv
fCQAn1h+otGje5XyHMhK0COV2koYdQyA
=+H7e
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
