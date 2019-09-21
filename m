Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19954B9FA7
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 22:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfIUUWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 16:22:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54553 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfIUUWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 16:22:14 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 47D1480315; Sat, 21 Sep 2019 22:21:56 +0200 (CEST)
Date:   Sat, 21 Sep 2019 22:22:10 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Yossi Itigin <yosefe@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>
Subject: Re: [PATCH 4.19 03/79] RDMA/restrack: Release task struct which was
 hold by CM_ID object
Message-ID: <20190921202209.GA14868@amd>
References: <20190919214807.612593061@linuxfoundation.org>
 <20190919214808.101726182@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20190919214808.101726182@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit ed7a01fd3fd77f40b4ef2562b966a5decd8928d2 upstream.
>=20
> Tracking CM_ID resource is performed in two stages: creation of cm_id
> and connecting it to the cma_dev. It is needed because rdma-cm protocol
> exports two separate user-visible calls rdma_create_id and
> rdma_accept.
=2E..

Mainline says this needs additional fix, fe9bc1644918aa1d, see below.

> --- a/drivers/infiniband/core/restrack.c
> +++ b/drivers/infiniband/core/restrack.c
> @@ -209,7 +209,7 @@ void rdma_restrack_del(struct rdma_restr
>  	struct ib_device *dev;
> =20
>  	if (!res->valid)
> -		return;
> +		goto out;
> =20
>  	dev =3D res_to_dev(res);
>  	if (!dev)
#                 return;

This test does return, does it need to go through 'goto out', too? (I
see it should not happen, but...)

> @@ -222,8 +222,10 @@ void rdma_restrack_del(struct rdma_restr
>  	down_write(&dev->res.rwsem);
>  	hash_del(&res->node);
>  	res->valid =3D false;
> +	up_write(&dev->res.rwsem);
> +
> +out:
>  	if (res->task)
>  		put_task_struct(res->task);
> -	up_write(&dev->res.rwsem);
>  }

Mainline says res->task =3D NULL is needed there, see fe9bc1644918aa1d.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2GhnEACgkQMOfwapXb+vI1JQCgg8/N6Ipu7I1fdlTvtVIoGM/9
wGkAn0omzraV89eMjfMK7WXaKd2GibGn
=ayIv
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
