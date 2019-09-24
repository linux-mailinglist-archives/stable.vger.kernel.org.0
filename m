Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E464BD01D
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391549AbfIXQmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391438AbfIXQlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:41:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AF9D21655;
        Tue, 24 Sep 2019 16:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343314;
        bh=Ob27+E4eC9e4EOmHsNkIjTO/u2afna2463aw4+0ENzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlMEfzZLXhP9uHXNfIQ1aiVM38pAVpNKz/J+FbEWdWKoQP/u5FfEsVUVbQz857arE
         IksptxVg2JU9CCbQaz1L2zTqc/qBYpIAmU7e74PVa/3waRlTCUzWwl0v/m+FnQYsa2
         jEu9LKzppOdNAMiTknDaOt7oUskhuhI6+OAsmeuA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 06/87] drm/vkms: Avoid assigning 0 for possible_crtc
Date:   Tue, 24 Sep 2019 12:40:22 -0400
Message-Id: <20190924164144.25591-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
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
index 2b37eb1062d34..2fee10a00051e 100644
--- a/drivers/gpu/drm/vkms/vkms_drv.h
+++ b/drivers/gpu/drm/vkms/vkms_drv.h
@@ -107,10 +107,10 @@ bool vkms_get_vblank_timestamp(struct drm_device *dev, unsigned int pipe,
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
index 56fb5c2a2315c..fb1941a6522cf 100644
--- a/drivers/gpu/drm/vkms/vkms_output.c
+++ b/drivers/gpu/drm/vkms/vkms_output.c
@@ -35,7 +35,7 @@ static const struct drm_connector_helper_funcs vkms_conn_helper_funcs = {
 	.get_modes    = vkms_conn_get_modes,
 };
 
-int vkms_output_init(struct vkms_device *vkmsdev)
+int vkms_output_init(struct vkms_device *vkmsdev, int index)
 {
 	struct vkms_output *output = &vkmsdev->output;
 	struct drm_device *dev = &vkmsdev->drm;
@@ -45,12 +45,12 @@ int vkms_output_init(struct vkms_device *vkmsdev)
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
index 0fceb62584225..18c630cfc485a 100644
--- a/drivers/gpu/drm/vkms/vkms_plane.c
+++ b/drivers/gpu/drm/vkms/vkms_plane.c
@@ -176,7 +176,7 @@ static const struct drm_plane_helper_funcs vkms_primary_helper_funcs = {
 };
 
 struct drm_plane *vkms_plane_init(struct vkms_device *vkmsdev,
-				  enum drm_plane_type type)
+				  enum drm_plane_type type, int index)
 {
 	struct drm_device *dev = &vkmsdev->drm;
 	const struct drm_plane_helper_funcs *funcs;
@@ -198,7 +198,7 @@ struct drm_plane *vkms_plane_init(struct vkms_device *vkmsdev,
 		funcs = &vkms_primary_helper_funcs;
 	}
 
-	ret = drm_universal_plane_init(dev, plane, 0,
+	ret = drm_universal_plane_init(dev, plane, 1 << index,
 				       &vkms_plane_funcs,
 				       formats, nformats,
 				       NULL, type, NULL);
-- 
2.20.1

