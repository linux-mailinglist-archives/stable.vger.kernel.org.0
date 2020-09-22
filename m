Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D35274548
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 17:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgIVP3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 11:29:22 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46134 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgIVP3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 11:29:22 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 157FC1C0B76; Tue, 22 Sep 2020 17:29:20 +0200 (CEST)
Date:   Tue, 22 Sep 2020 17:29:19 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 10/49] scsi: pm8001: Fix memleak in
 pm8001_exec_internal_task_abort
Message-ID: <20200922152919.GA18907@duo.ucw.cz>
References: <20200921162034.660953761@linuxfoundation.org>
 <20200921162035.126920567@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20200921162035.126920567@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Dinghao Liu <dinghao.liu@zju.edu.cn>
>=20
> [ Upstream commit ea403fde7552bd61bad6ea45e3feb99db77cb31e ]
>=20
> When pm8001_tag_alloc() fails, task should be freed just like it is done =
in
> the subsequent error paths.

Does the timer also need to be deleted, as in the next error return?
Or better, can we move tag_alloc before add_timer()?=20

Best regards,

										Pavel

> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
> index 5be4212312cb0..ba79b37d8cf7e 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -794,7 +794,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_inf=
o *pm8001_ha,
> =20
>  		res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);
>  		if (res)
> -			return res;
> +			goto ex_err;
>  		ccb =3D &pm8001_ha->ccb_info[ccb_tag];
>  		ccb->device =3D pm8001_dev;
>  		ccb->ccb_tag =3D ccb_tag;
> --=20
> 2.25.1
>=20
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2oYTwAKCRAw5/Bqldv6
8qh5AJ0YNzJYso7DCFOzS+H339KoFT1AWQCeNIq+dbDC9rASrFmRbv2lYSGwzdw=
=aSlV
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
