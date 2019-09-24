Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAABFBCD77
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410071AbfIXQqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391417AbfIXQqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:46:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DF6C21783;
        Tue, 24 Sep 2019 16:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343559;
        bh=I/gA4q9CIaxKXPKZAn9zp6oLBe04zM00DICPM9pXiPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJCsbMyjR/TIUMi8TYkVsiWBzeZ0vy3utumUX0Blw0/d9EbQWSJ3Mz/sBCjGLC9dI
         x7cUmj1Apq9IPKrcRUV233VOb2l+lxDTWQAYqkekfIeKxHE83kLYyCRSisHYmC065x
         KST9cqAVRTvjqwEIiyjgD3mTEL8XF175HhKeTIoU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 05/70] drm/vkms: Avoid assigning 0 for possible_crtc
Date:   Tue, 24 Sep 2019 12:44:44 -0400
Message-Id: <20190924164549.27058-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164549.27058-1-sashal@kernel.org>
References: <20190924164549.27058-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>

[ Upstream commit e9d85f731de06a35d2ae6cdcf7d0e037c98ef41a ]

When vkms invoke drm_universal_plane_init(), it sets 0 for
possible_crtcs parameter which means that planes can't be attached to
any CRTC. It currently works due to some safeguard in the drm_crtc file;
however, it is possible to identify the problem by trying to append a
second connector. This patch fixes this issue by modifying
vkms_plane_init() to accept an index parameter which makes the code a
little bit more flexible and avoid set zero to possible_crtcs.

Signed-off-by: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/d67849c62a8d8ace1a0af455998b588798a4c45f.1561491964.git.rodrigosiqueiramelo@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_drv.c    | 2 +-
 drivers/gpu/drm/vkms/vkms_drv.h    | 4 ++--
 drivers/gpu/drm/vkms/vkms_output.c | 6 +++---
 drivers/gpu/drm/vkms/vkms_plane.c  | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/vkms/vkms_drv.c b/drivers/gpu/drm/vkms/vkms_drv.c
index 738dd6206d85b..92296bd8f6233 100644
--- a/drivers/gpu/drm/vkms/vkms_drv.c
+++ b/drivers/gpu/drm/vkms/vkms_drv.c
@@ -92,7 +92,7 @@ static int vkms_modeset_init(struct vkms_device *vkmsdev)
 	dev->mode_config.max_height = YRES_MAX;
 	dev->mode_config.preferred_depth = 24;
 
-	return vkms_output_init(vkmsdev);
+	return vkms_output_init(vkmsdev, 0);
 }
 
 static int __init vkms_init(void)
diff --git a/drivers/gpu/drm/vkms/vkms_drv.h b/drivers/gpu/drm/vkms/vkms_drv.h
index 3c7e06b19efd5..a0adcc86079f5 100644
--- a/drivers/gpu/drm/vkms/vkms_drv.h
+++ b/drivers/gpu/drm/vkms/vkms_drv.h
@@ -115,10 +115,10 @@ bool vkms_get_vblank_timestamp(struct drm_device *dev, unsigned int pipe,
 			       int *max_error, ktime_t *vblank_time,
 			       bool in_vblank_irq);
 
-int vkms_output_init(struct vkms_device *vkmsdev);
+int vkms_output_init(struct vkms_device *vkmsdev, int index);
 
 struct drm_plane *vkms_plane_init(struct vkms_device *vkmsdev,
-				  enum drm_plane_type type);
+				  enum drm_plane_type type, int index);
 
 /* Gem stuff */
 struct drm_gem_object *vkms_gem_create(struct drm_device *dev,
diff --git a/drivers/gpu/drm/vkms/vkms_output.c b/drivers/gpu/drm/vkms/vkms_output.c
index 3b162b25312ec..1442b447c7070 100644
--- a/drivers/gpu/drm/vkms/vkms_output.c
+++ b/drivers/gpu/drm/vkms/vkms_output.c
@@ -36,7 +36,7 @@ static const struct drm_connector_helper_funcs vkms_conn_helper_funcs = {
 	.get_modes    = vkms_conn_get_modes,
 };
 
-int vkms_output_init(struct vkms_device *vkmsdev)
+int vkms_output_init(struct vkms_device *vkmsdev, int index)
 {
 	struct vkms_output *output = &vkmsdev->output;
 	struct drm_device *dev = &vkmsdev->drm;
@@ -46,12 +46,12 @@ int vkms_output_init(struct vkms_device *vkmsdev)
 	struct drm_plane *primary, *cursor = NULL;
 	int ret;
 
-	primary = vkms_plane_init(vkmsdev, DRM_PLANE_TYPE_PRIMARY);
+	primary = vkms_plane_init(vkmsdev, DRM_PLANE_TYPE_PRIMARY, index);
 	if (IS_ERR(primary))
 		return PTR_ERR(primary);
 
 	if (enable_cursor) {
-		cursor = vkms_plane_init(vkmsdev, DRM_PLANE_TYPE_CURSOR);
+		cursor = vkms_plane_init(vkmsdev, DRM_PLANE_TYPE_CURSOR, index);
 		if (IS_ERR(cursor)) {
 			ret = PTR_ERR(cursor);
 			goto err_cursor;
diff --git a/drivers/gpu/drm/vkms/vkms_plane.c b/drivers/gpu/drm/vkms/vkms_plane.c
index 0e67d2d42f0cc..20ffc52f91940 100644
--- a/drivers/gpu/drm/vkms/vkms_plane.c
+++ b/drivers/gpu/drm/vkms/vkms_plane.c
@@ -168,7 +168,7 @@ static const struct drm_plane_helper_funcs vkms_primary_helper_funcs = {
 };
 
 struct drm_plane *vkms_plane_init(struct vkms_device *vkmsdev,
-				  enum drm_plane_type type)
+				  enum drm_plane_type type, int index)
 {
 	struct drm_device *dev = &vkmsdev->drm;
 	const struct drm_plane_helper_funcs *funcs;
@@ -190,7 +190,7 @@ struct drm_plane *vkms_plane_init(struct vkms_device *vkmsdev,
 		funcs = &vkms_primary_helper_funcs;
 	}
 
-	ret = drm_universal_plane_init(dev, plane, 0,
+	ret = drm_universal_plane_init(dev, plane, 1 << index,
 				       &vkms_plane_funcs,
 				       formats, nformats,
 				       NULL, type, NULL);
-- 
2.20.1

