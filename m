Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340522841D8
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 22:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgJEU6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 16:58:07 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:56558 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgJEU6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 16:58:06 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 431AF1C0B77; Mon,  5 Oct 2020 22:58:04 +0200 (CEST)
Date:   Mon, 5 Oct 2020 22:58:03 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 17/38] nvme-core: get/put ctrl and transport module
 in nvme_dev_open/release()
Message-ID: <20201005205803.GA27782@amd>
References: <20201005142108.650363140@linuxfoundation.org>
 <20201005142109.502047700@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20201005142109.502047700@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 33dad9774da01..9ea3d8e611005 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2605,10 +2605,24 @@ static int nvme_dev_open(struct inode *inode, str=
uct file *file)
>  		return -EWOULDBLOCK;
>  	}
> =20
> +	nvme_get_ctrl(ctrl);
> +	if (!try_module_get(ctrl->ops->module))
> +		return -EINVAL;

This needs to do nvme_put_ctrl(ctrl); before returning, right?

Otherwise we leak the reference.

Plus, I'm not sure EINVAL is right error return. EBUSY?

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9ea3d8e61100..01c36f3dd87f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2606,8 +2606,10 @@ static int nvme_dev_open(struct inode *inode, struct=
 file *file)
 	}
=20
 	nvme_get_ctrl(ctrl);
-	if (!try_module_get(ctrl->ops->module))
-		return -EINVAL;
+	if (!try_module_get(ctrl->ops->module)) {
+		nvme_put_ctrl(ctrl);
+		return -EBUSY;
+	}
=20
 	file->private_data =3D ctrl;
 	return 0;


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl97iNsACgkQMOfwapXb+vKY/QCgu5iFjb5Q6+5DJ8nYlcpQ2Vxh
TKcAnA3yoyqzy8hUN9+Jbz4D7BUaMUzF
=T7Kw
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
