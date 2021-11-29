Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F1F46252A
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbhK2Wfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbhK2WfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:35:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D21C07E5E7;
        Mon, 29 Nov 2021 10:37:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DD0AB815E9;
        Mon, 29 Nov 2021 18:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7987BC53FCD;
        Mon, 29 Nov 2021 18:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211054;
        bh=zIjCyc1kS/b4lLwo65L3w4WxbzbbCA/14vNk1T1rc+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrHO+rB0xckGg0eX7q2nojyEpdITtWo2ALWpd1PxXIN/MHxAS7WkH4AMiV5GZt7ni
         2PNCF/ElqLpQv1hgtF/ygIJRCSprES48tprA727oPTBcE8TIBeQxigNJJV6bBXTPVL
         rC7ruz9Ut5uWOJyX30qpFu9mNyBAvvTFGnkbR94I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/179] drm/nouveau/acr: fix a couple NULL vs IS_ERR() checks
Date:   Mon, 29 Nov 2021 19:18:00 +0100
Message-Id: <20211129181721.774485526@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index cdb1ead26d84f..82b4c8e1457c2 100644
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
index fb9132a39bb1a..fd97a935a380e 100644
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



