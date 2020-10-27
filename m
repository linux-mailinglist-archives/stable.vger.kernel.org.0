Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EB429BA50
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796456AbgJ0P7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1804132AbgJ0Pxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:53:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 895F1204EF;
        Tue, 27 Oct 2020 15:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603814030;
        bh=ZVJjWqt/gLGBfV8vE0SwTTeHC7oOKwAYG59kYQ8fiZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ouLK3VKpBLuAEj8IRSYqqA3Ad2HjTKCJrglnUQQUiedmKczwIr3aIfDdDzjHO5hW
         /9OuTjkt+zUHOWwNEOFVlMQFG3jn6tH/7Kh2rCHJh9SAie5/JzN5Z49dEPDLaqnr7i
         qxQWorJdrX+mfCRaRTl0MWYk9E2FVhwN6xfufOes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tian Tao <tiantao6@hisilicon.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 744/757] drm/hisilicon: Code refactoring for hibmc_drv_de
Date:   Tue, 27 Oct 2020 14:56:34 +0100
Message-Id: <20201027135525.406462190@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tian Tao <tiantao6@hisilicon.com>

[ Upstream commit 13b0d4a9ae0c2d650993c48be797992eaf621332 ]

The memory used to be allocated with devres helpers and released
automatically. In rare circumstances, the memory's release could
have happened before the DRM device got released, which would have
caused memory corruption of some kind. Now we're embedding the data
structures in struct hibmc_drm_private. The whole release problem
has been resolved, because struct hibmc_drm_private is allocated
with drmm_kzalloc and always released with the DRM device.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/1597218179-3938-3-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/hisilicon/hibmc/hibmc_drm_de.c    | 55 +++++--------------
 .../gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h   |  2 +
 2 files changed, 15 insertions(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c
index cc70e836522f0..8758958e16893 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c
@@ -160,37 +160,6 @@ static const struct drm_plane_helper_funcs hibmc_plane_helper_funcs = {
 	.atomic_update = hibmc_plane_atomic_update,
 };
 
-static struct drm_plane *hibmc_plane_init(struct hibmc_drm_private *priv)
-{
-	struct drm_device *dev = priv->dev;
-	struct drm_plane *plane;
-	int ret = 0;
-
-	plane = devm_kzalloc(dev->dev, sizeof(*plane), GFP_KERNEL);
-	if (!plane) {
-		DRM_ERROR("failed to alloc memory when init plane\n");
-		return ERR_PTR(-ENOMEM);
-	}
-	/*
-	 * plane init
-	 * TODO: Now only support primary plane, overlay planes
-	 * need to do.
-	 */
-	ret = drm_universal_plane_init(dev, plane, 1, &hibmc_plane_funcs,
-				       channel_formats1,
-				       ARRAY_SIZE(channel_formats1),
-				       NULL,
-				       DRM_PLANE_TYPE_PRIMARY,
-				       NULL);
-	if (ret) {
-		DRM_ERROR("failed to init plane: %d\n", ret);
-		return ERR_PTR(ret);
-	}
-
-	drm_plane_helper_add(plane, &hibmc_plane_helper_funcs);
-	return plane;
-}
-
 static void hibmc_crtc_dpms(struct drm_crtc *crtc, int dpms)
 {
 	struct hibmc_drm_private *priv = crtc->dev->dev_private;
@@ -537,22 +506,24 @@ static const struct drm_crtc_helper_funcs hibmc_crtc_helper_funcs = {
 int hibmc_de_init(struct hibmc_drm_private *priv)
 {
 	struct drm_device *dev = priv->dev;
-	struct drm_crtc *crtc;
-	struct drm_plane *plane;
+	struct drm_crtc *crtc = &priv->crtc;
+	struct drm_plane *plane = &priv->primary_plane;
 	int ret;
 
-	plane = hibmc_plane_init(priv);
-	if (IS_ERR(plane)) {
-		DRM_ERROR("failed to create plane: %ld\n", PTR_ERR(plane));
-		return PTR_ERR(plane);
-	}
+	ret = drm_universal_plane_init(dev, plane, 1, &hibmc_plane_funcs,
+				       channel_formats1,
+				       ARRAY_SIZE(channel_formats1),
+				       NULL,
+				       DRM_PLANE_TYPE_PRIMARY,
+				       NULL);
 
-	crtc = devm_kzalloc(dev->dev, sizeof(*crtc), GFP_KERNEL);
-	if (!crtc) {
-		DRM_ERROR("failed to alloc memory when init crtc\n");
-		return -ENOMEM;
+	if (ret) {
+		DRM_ERROR("failed to init plane: %d\n", ret);
+		return ret;
 	}
 
+	drm_plane_helper_add(plane, &hibmc_plane_helper_funcs);
+
 	ret = drm_crtc_init_with_planes(dev, crtc, plane,
 					NULL, &hibmc_crtc_funcs, NULL);
 	if (ret) {
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h
index 609768748de65..0a74ba220cac5 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h
@@ -29,6 +29,8 @@ struct hibmc_drm_private {
 
 	/* drm */
 	struct drm_device  *dev;
+	struct drm_plane primary_plane;
+	struct drm_crtc crtc;
 	struct drm_encoder encoder;
 	struct drm_connector connector;
 	bool mode_config_initialized;
-- 
2.25.1



