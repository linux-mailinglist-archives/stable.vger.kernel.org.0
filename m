Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB37103A23
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 13:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfKTMgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 07:36:06 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59546 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbfKTMgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 07:36:06 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AFACD1C1A4F; Wed, 20 Nov 2019 13:36:04 +0100 (CET)
Date:   Wed, 20 Nov 2019 13:36:03 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 353/422] slimbus: ngd: return proper error code
 instead of zero
Message-ID: <20191120123603.GE4495@amd>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051421.892624663@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3O1VwFp74L81IIeR"
Content-Disposition: inline
In-Reply-To: <20191119051421.892624663@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3O1VwFp74L81IIeR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-11-19 06:19:10, Greg Kroah-Hartman wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>=20
> [ Upstream commit 9652e6aa62a1836494ebb8dbd402587c083b568c ]
>=20
> It looks like there is a typo in probe return. Fix it.
>=20
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/slimbus/qcom-ngd-ctrl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-c=
trl.c
> index a9abde2f4088b..e587be9064e74 100644
> --- a/drivers/slimbus/qcom-ngd-ctrl.c
> +++ b/drivers/slimbus/qcom-ngd-ctrl.c
> @@ -1393,7 +1393,7 @@ wq_err:
>  	if (ctrl->mwq)
>  		destroy_workqueue(ctrl->mwq);
> =20
> -	return 0;
> +	return ret;
>  }

The code makes no sense, even after the fix. Only way to enter wq_err
is with via if !ctrl->mwq... but it proceeds to test it for zero.

IOW... this.

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctr=
l.c
index d72f8eed2e8b..5a327d45dc2d 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1385,17 +1385,11 @@ static int qcom_slim_ngd_probe(struct platform_devi=
ce *pdev)
 	ctrl->mwq =3D create_singlethread_workqueue("ngd_master");
 	if (!ctrl->mwq) {
 		dev_err(&pdev->dev, "Failed to start master worker\n");
-		ret =3D -ENOMEM;
-		goto wq_err;
+		qcom_slim_ngd_qmi_svc_event_deinit(&ctrl->qmi);
+		return -ENOMEM;
 	}
=20
 	return 0;
-wq_err:
-	qcom_slim_ngd_qmi_svc_event_deinit(&ctrl->qmi);
-	if (ctrl->mwq)
-		destroy_workqueue(ctrl->mwq);
-
-	return ret;
 }
=20
 static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3O1VwFp74L81IIeR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3VMzMACgkQMOfwapXb+vJQgwCfSGjdcexIlukpEKCcNJC530hV
840An2uz4mfrnPH/0rDurYaHg6o2p2TT
=fapK
-----END PGP SIGNATURE-----

--3O1VwFp74L81IIeR--
