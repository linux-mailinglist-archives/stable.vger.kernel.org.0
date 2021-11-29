Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC6D461E5B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379380AbhK2Sfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:35:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51878 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379560AbhK2Sdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:33:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8F303CE13E6;
        Mon, 29 Nov 2021 18:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C37AC53FC7;
        Mon, 29 Nov 2021 18:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210611;
        bh=XGlUXYXy3K96WhsClmBBLC7qMuOoPBKUV48Z4lAjupE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4Ryle0CA7kJLzyYbmVDSpUjoJa+xNL+WDkQIIH5vNMAr1yQt69tdeXr44dHrrZ/a
         Gsnr8dQ0yEzt8v51jPABqYEb+XAqFfmN9kYIWF9oorDPnDNqAhJWQRwQatZnLA+LWk
         0t3PovMfL6Pu+Um18pyoXAMYfxS4PwwKoAxi+RYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/121] drm/nouveau/acr: fix a couple NULL vs IS_ERR() checks
Date:   Mon, 29 Nov 2021 19:18:07 +0100
Message-Id: <20211129181713.530291752@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b371fd131fcec59f6165c80778bdc2cd1abd616b ]

The nvkm_acr_lsfw_add() function never returns NULL.  It returns error
pointers on error.

Fixes: 22dcda45a3d1 ("drm/nouveau/acr: implement new subdev to replace "secure boot"")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211118111314.GB1147@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/gm200.c | 6 ++++--
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/gp102.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/acr/gm200.c b/drivers/gpu/drm/nouveau/nvkm/subdev/acr/gm200.c
index cd41b2e6cc879..18502fd6ebaa0 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/acr/gm200.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/acr/gm200.c
@@ -207,11 +207,13 @@ int
 gm200_acr_wpr_parse(struct nvkm_acr *acr)
 {
 	const struct wpr_header *hdr = (void *)acr->wpr_fw->data;
+	struct nvkm_acr_lsfw *lsfw;
 
 	while (hdr->falcon_id != WPR_HEADER_V0_FALCON_ID_INVALID) {
 		wpr_header_dump(&acr->subdev, hdr);
-		if (!nvkm_acr_lsfw_add(NULL, acr, NULL, (hdr++)->falcon_id))
-			return -ENOMEM;
+		lsfw = nvkm_acr_lsfw_add(NULL, acr, NULL, (hdr++)->falcon_id);
+		if (IS_ERR(lsfw))
+			return PTR_ERR(lsfw);
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/acr/gp102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/acr/gp102.c
index 80eb9d8dbc803..e5c8303a5b7b7 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/acr/gp102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/acr/gp102.c
@@ -161,11 +161,13 @@ int
 gp102_acr_wpr_parse(struct nvkm_acr *acr)
 {
 	const struct wpr_header_v1 *hdr = (void *)acr->wpr_fw->data;
+	struct nvkm_acr_lsfw *lsfw;
 
 	while (hdr->falcon_id != WPR_HEADER_V1_FALCON_ID_INVALID) {
 		wpr_header_v1_dump(&acr->subdev, hdr);
-		if (!nvkm_acr_lsfw_add(NULL, acr, NULL, (hdr++)->falcon_id))
-			return -ENOMEM;
+		lsfw = nvkm_acr_lsfw_add(NULL, acr, NULL, (hdr++)->falcon_id);
+		if (IS_ERR(lsfw))
+			return PTR_ERR(lsfw);
 	}
 
 	return 0;
-- 
2.33.0



