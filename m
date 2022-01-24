Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7817049839F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbiAXPee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:34:34 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42184 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiAXPed (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:34:33 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC1MW-0006sV-E4; Mon, 24 Jan 2022 16:34:32 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC1MV-009y29-Sd;
        Mon, 24 Jan 2022 16:34:31 +0100
Date:   Mon, 24 Jan 2022 16:34:31 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 4.9,4.14] drm/ttm/nouveau: don't call tt destroy callback on
 alloc failure.
Message-ID: <Ye7HB4Zsdbdwgt4T@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dbUWkUEaTr2nYdGV"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dbUWkUEaTr2nYdGV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Dave Airlie <airlied@redhat.com>

commit 5de5b6ecf97a021f29403aa272cb4e03318ef586 upstream.

This is confusing, and from my reading of all the drivers only
nouveau got this right.

Just make the API act under driver control of it's own allocation
failing, and don't call destroy, if the page table fails to
create there is nothing to cleanup here.

(I'm willing to believe I've missed something here, so please
review deeply).

Reviewed-by: Christian K=F6nig <christian.koenig@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200728041736.20689-1-=
airlied@gmail.com
[bwh: Backported to 4.14:
 - Drop change in ttm_sg_tt_init()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c | 9 +++------
 drivers/gpu/drm/ttm/ttm_tt.c            | 2 --
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouv=
eau/nouveau_sgdma.c
index fde11ce466e4..495c4043467e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -106,12 +106,9 @@ nouveau_sgdma_create_ttm(struct ttm_bo_device *bdev,
 	else
 		nvbe->ttm.ttm.func =3D &nv50_sgdma_backend;
=20
-	if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags, dummy_read_page))
-		/*
-		 * A failing ttm_dma_tt_init() will call ttm_tt_destroy()
-		 * and thus our nouveau_sgdma_destroy() hook, so we don't need
-		 * to free nvbe here.
-		 */
+	if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags, dummy_read_page))=
 {
+		kfree(nvbe);
 		return NULL;
+	}
 	return &nvbe->ttm.ttm;
 }
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 8ebc8d3560c3..fc8bdcc1541b 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -199,7 +199,6 @@ int ttm_tt_init(struct ttm_tt *ttm, struct ttm_bo_devic=
e *bdev,
=20
 	ttm_tt_alloc_page_directory(ttm);
 	if (!ttm->pages) {
-		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
 	}
@@ -232,7 +231,6 @@ int ttm_dma_tt_init(struct ttm_dma_tt *ttm_dma, struct =
ttm_bo_device *bdev,
 	INIT_LIST_HEAD(&ttm_dma->pages_list);
 	ttm_dma_tt_alloc_page_directory(ttm_dma);
 	if (!ttm->pages) {
-		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
 	}

--dbUWkUEaTr2nYdGV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHuxwMACgkQ57/I7JWG
EQnViBAAgXV/uMIu8Iu5skKefRsFnkEYUdbukBqnaGc/5N9v16tWuUd5ZUztu77j
aByfluFobnqi3BUEcxQCmuuTMC6kmgUFeZyUd1SpJvZcOs8+q/+LqQDFunIi0uWv
k2u+JuF7cpMYzO8bfPUR+z3/oYZp5O6jjqAcSV0kcEDD++DdxJL4jC2qOtvZCd+g
co4SVhOXOLu7ajhkFclm60/82tBXsgoHiFeWZ3jUGWRSU4bmKMZUgxbgvVIEsUHo
DSi7kR225wrWAC076MLf7DMomrvKSq+pntncttVwcZyUVdZfjeYOuThYzikedgC3
bSiOEtmud45FHpZICfldjizYKOSKhsnYIl6pN/OSQpjpZy/IkF77l1biIq25RP94
lrWpOFeuNdL21eRU//4ocDCCKOeLqCV/a3wvF5jwX+QpHFKKGr879agzZ8wj7XF9
smrWp7AZck/kkE70Nb3jarzq8O2x5GdCjz0Uq/UVgWIZFm4frPJiDLogjyp52YeJ
OwxGgBWZVt96wKLP5lLN5uSmDHrZkbfgrvIyTyTkwb19CbxxvqRHkrPHps1z4Fye
zKllt7OU3gitGUZbtZ+domG6AzvAkkeDmYZYhfmOoGt9Ie8WjWbl6z+oUZuZpZ97
4SV9Kw7VB4hONbVXpyzIO+1gpH+HP+ockWn+Og4bXDddEIu4aOI=
=gDQy
-----END PGP SIGNATURE-----

--dbUWkUEaTr2nYdGV--
