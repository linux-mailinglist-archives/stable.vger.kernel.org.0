Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C0611373B
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 22:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfLDVsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 16:48:03 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:58288 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbfLDVsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 16:48:03 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 95D231C2462; Wed,  4 Dec 2019 22:48:01 +0100 (CET)
Date:   Wed, 4 Dec 2019 22:48:00 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 084/321] scsi: qla2xxx: Fix NPIV handling for FC-NVMe
Message-ID: <20191204214800.GD7678@amd>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223431.527072152@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Content-Disposition: inline
In-Reply-To: <20191203223431.527072152@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Himanshu Madhani <hmadhani@marvell.com>
>=20
> [ Upstream commit 5e6803b409ba3c18434de6693062d98a470bcb1e ]
>=20
> This patch fixes issues with NPIV port with FC-NVMe. Clean up code for
> remoteport delete and also call nvme_delete when deleting VPs.

> @@ -564,7 +554,7 @@ static void qla_nvme_remoteport_delete(struct nvme_fc=
_remote_port *rport)
>  		schedule_work(&fcport->free_work);
>  	}
> =20
> -	fcport->nvme_flag &=3D ~(NVME_FLAG_REGISTERED | NVME_FLAG_DELETING);
> +	fcport->nvme_flag &=3D ~NVME_FLAG_DELETING;
>  	ql_log(ql_log_info, fcport->vha, 0x2110,
>  	    "remoteport_delete of %p completed.\n", fcport);
>  }

Current -next-20191204 contains

 fcport->nvme_flag &=3D ~NVME_FLAG_REGISTERED;
 fcport->nvme_flag &=3D ~NVME_FLAG_DELETING;

=2E.. and there's no explanation in changelog why removing
NVME_FLAG_REGISTERED is good idea.

Are you sure this change is correct and suitable for -stable?
 								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3oKZAACgkQMOfwapXb+vI1bwCfV96dejmfg0seyu7LfFUDgFS/
GJYAoJCX2OXH1ib1MwztFkpJxihfZMhw
=jQOd
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
