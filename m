Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 213A0190F0C
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgCXNRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbgCXNRD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:17:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98EA4208CA;
        Tue, 24 Mar 2020 13:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055822;
        bh=EfynZ2r+tu0Bi5hPFBx1U/emhKKCOtF0JEBjFuUVq5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iO35KHpQxuyaYSUXHlo2qo9ejldTp4yNZtOtYEDmRZ65vRYVFNnYWpYZw+Ik62XyO
         xcqp8eaMf0yRy1MraqJGKRWDlXnlV6F3iw6jk6upZwLrp9rPxSh2qJTTUVx19HpMgl
         g4OxtvTV1969l5VNuvQ6aRpoxDzwHJdepU/A+CX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Benn <evanbenn@chromium.org>,
        Sean Paul <seanpaul@chromium.org>, CK Hu <ck.hu@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/102] drm/mediatek: Find the cursor plane instead of hard coding it
Date:   Tue, 24 Mar 2020 14:09:56 +0100
Message-Id: <20200324130806.941240400@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Benn <evanbenn@chromium.org>

[ Upstream commit 318caac7c81cdf5806df30c3d72385659a5f0f53 ]

The cursor and primary planes were hard coded.
Now search for them for passing to drm_crtc_init_with_planes

Signed-off-by: Evan Benn <evanbenn@chromium.org>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index e6c049f4f08bb..f9455f2724d23 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -496,10 +496,18 @@ static const struct drm_crtc_helper_funcs mtk_crtc_helper_funcs = {
 
 static int mtk_drm_crtc_init(struct drm_device *drm,
 			     struct mtk_drm_crtc *mtk_crtc,
-			     struct drm_plane *primary,
-			     struct drm_plane *cursor, unsigned int pipe)
+			     unsigned int pipe)
 {
-	int ret;
+	struct drm_plane *primary = NULL;
+	struct drm_plane *cursor = NULL;
+	int i, ret;
+
+	for (i = 0; i < mtk_crtc->layer_nr; i++) {
+		if (mtk_crtc->planes[i].type == DRM_PLANE_TYPE_PRIMARY)
+			primary = &mtk_crtc->planes[i];
+		else if (mtk_crtc->planes[i].type == DRM_PLANE_TYPE_CURSOR)
+			cursor = &mtk_crtc->planes[i];
+	}
 
 	ret = drm_crtc_init_with_planes(drm, &mtk_crtc->base, primary, cursor,
 					&mtk_crtc_funcs, NULL);
@@ -608,9 +616,7 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 			return ret;
 	}
 
-	ret = mtk_drm_crtc_init(drm_dev, mtk_crtc, &mtk_crtc->planes[0],
-				mtk_crtc->layer_nr > 1 ? &mtk_crtc->planes[1] :
-				NULL, pipe);
+	ret = mtk_drm_crtc_init(drm_dev, mtk_crtc, pipe);
 	if (ret < 0)
 		return ret;
 
-- 
2.20.1



