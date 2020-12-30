Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2242E799B
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgL3NRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:17:20 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:35782 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgL3NRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 08:17:20 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E062B1C0B85; Wed, 30 Dec 2020 14:16:35 +0100 (CET)
Date:   Wed, 30 Dec 2020 14:16:35 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 154/346] crypto: omap-aes - Fix PM disable depth
 imbalance in omap_aes_probe
Message-ID: <20201230131635.GA15217@duo.ucw.cz>
References: <20201228124919.745526410@linuxfoundation.org>
 <20201228124927.229346776@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20201228124927.229346776@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Zhang Qilong <zhangqilong3@huawei.com>
>=20
> [ Upstream commit ff8107200367f4abe0e5bce66a245e8d0f2d229e ]
>=20
> The pm_runtime_enable will increase power disable depth.
> Thus a pairing decrement is needed on the error handling
> path to keep it balanced according to context.

Oops, this is complex.

First, same bug exist in 4.4, but is not fixed there, and there is
missing pm_runtime_put() there and elsewhere.

4.4 needs these two fixes + backport of ff81072003.

4.19 needs fixes similar to these, at three places.

mainline is okay, afaict.

Best regards,
								Pavel

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index eba23147c0ee..48370711c794 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -801,6 +801,7 @@ static int omap_aes_cra_init(struct crypto_tfm *tfm)
=20
 	err =3D pm_runtime_get_sync(dd->dev);
 	if (err < 0) {
+		pm_runtime_put_sync(dd->dev);
 		dev_err(dd->dev, "%s: failed to get_sync(%d)\n",
 			__func__, err);
 		return err;
@@ -1195,6 +1196,7 @@ static int omap_aes_probe(struct platform_device *pde=
v)
 	pm_runtime_enable(dev);
 	err =3D pm_runtime_get_sync(dev);
 	if (err < 0) {
+		pm_runtime_put_sync(dev);	 =20
 		dev_err(dev, "%s: failed to get_sync(%d)\n",
 			__func__, err);
 		goto err_res;


--=20
http://www.livejournal.com/~pavelmachek

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX+x9swAKCRAw5/Bqldv6
8scpAJ9emRTflGff3LWkeo863xBUxdeqHgCfaTTdjzeMb4e7fsxY/GZcS424FHU=
=DHbF
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
