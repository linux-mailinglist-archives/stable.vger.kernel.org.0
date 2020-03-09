Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA35B17DD07
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 11:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgCIKON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 06:14:13 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35016 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIKOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 06:14:12 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E99FF1C0315; Mon,  9 Mar 2020 11:14:10 +0100 (CET)
Date:   Mon, 9 Mar 2020 11:14:10 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Rob Clark <robdclark@gmail.com>,
        Sean Paul <seanpaul@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH] drm/msm: fix leaks if initialization fails
Message-ID: <20200309101410.GA18031@duo.ucw.cz>
References: <20200303174349.075101355@linuxfoundation.org>
 <20200303174349.401386271@linuxfoundation.org>
 <20200304151316.GA2367@duo.ucw.cz>
 <20200304171817.GC1852712@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20200304171817.GC1852712@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

We should free resources in unlikely case of allocation failure.
   =20
Signed-off-by: Pavel Machek <pavel@denx.de>

---

> Can you submit a patch to fix it?

Here it is.

Best regards,
								Pavel


diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 83a0000eecb3..f5c1495cc4b9 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -444,8 +444,10 @@ static int msm_drm_init(struct device *dev, struct drm=
_driver *drv)
 	if (!dev->dma_parms) {
 		dev->dma_parms =3D devm_kzalloc(dev, sizeof(*dev->dma_parms),
 					      GFP_KERNEL);
-		if (!dev->dma_parms)
-			return -ENOMEM;
+		if (!dev->dma_parms) {
+			ret =3D -ENOMEM;
+			goto err_msm_uninit;
+		}
 	}
 	dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
=20


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXmYW8gAKCRAw5/Bqldv6
8vTyAJ9j5qi1hnGXenm+CeEf+zuJFm5kZgCgjZ8StyWOIXnu0jDTp0t54iUheaA=
=mv+L
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
