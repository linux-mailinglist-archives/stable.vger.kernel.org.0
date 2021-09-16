Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A5840E2DD
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343560AbhIPQma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245439AbhIPQk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:40:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 037CA61A2A;
        Thu, 16 Sep 2021 16:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809424;
        bh=pwAd2PsMoekzDJkxhzFxwpXSoO+urj7Sr1DFVU276sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ib+rqkzTgqmfkEVH3TFGT6Guj8Y51XOwE/R4ca47Be8+RWflxP/ISEN2IeGTedKhr
         lzem2tG/dQBxJlhDhjdA5+1+nim6zD4jVue7cn8FbJYgfA34Jwq28RW8VAjH8e3Ukx
         mGidNuWRsMgp3OYXrbrXIwyXcnh7CUfKuGtd9pf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Melissa Wen <melissa.srw@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 150/380] drm/vkms: Let shadow-plane helpers prepare the planes FB
Date:   Thu, 16 Sep 2021 17:58:27 +0200
Message-Id: <20210916155809.162639538@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit b43e2ec03b0de040d536591713ea9c875ff34ba9 ]

Replace vkms' prepare_fb and cleanup_fb functions with the generic
code for shadow-buffered planes. No functional changes.

This change also fixes a problem where IGT kms_flip tests would
create a segmentation fault within vkms. The driver's prepare_fb
function did not report an error if a BO's vmap operation failed.
The kernel later tried to operate on the non-mapped memory areas.
The shared shadow-plane helpers handle errors correctly, so that
the driver now avoids the segmantation fault.

v2:
	* include paragraph about IGT tests in commit message (Melissa)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Melissa Wen <melissa.srw@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210705074633.9425-4-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_plane.c | 38 +------------------------------
 1 file changed, 1 insertion(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/vkms/vkms_plane.c b/drivers/gpu/drm/vkms/vkms_plane.c
index 6d310d31b75d..1b10ab2b80a3 100644
--- a/drivers/gpu/drm/vkms/vkms_plane.c
+++ b/drivers/gpu/drm/vkms/vkms_plane.c
@@ -8,7 +8,6 @@
 #include <drm/drm_gem_atomic_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_plane_helper.h>
-#include <drm/drm_gem_shmem_helper.h>
 
 #include "vkms_drv.h"
 
@@ -150,45 +149,10 @@ static int vkms_plane_atomic_check(struct drm_plane *plane,
 	return 0;
 }
 
-static int vkms_prepare_fb(struct drm_plane *plane,
-			   struct drm_plane_state *state)
-{
-	struct drm_gem_object *gem_obj;
-	struct dma_buf_map map;
-	int ret;
-
-	if (!state->fb)
-		return 0;
-
-	gem_obj = drm_gem_fb_get_obj(state->fb, 0);
-	ret = drm_gem_shmem_vmap(gem_obj, &map);
-	if (ret)
-		DRM_ERROR("vmap failed: %d\n", ret);
-
-	return drm_gem_plane_helper_prepare_fb(plane, state);
-}
-
-static void vkms_cleanup_fb(struct drm_plane *plane,
-			    struct drm_plane_state *old_state)
-{
-	struct drm_gem_object *gem_obj;
-	struct drm_gem_shmem_object *shmem_obj;
-	struct dma_buf_map map;
-
-	if (!old_state->fb)
-		return;
-
-	gem_obj = drm_gem_fb_get_obj(old_state->fb, 0);
-	shmem_obj = to_drm_gem_shmem_obj(drm_gem_fb_get_obj(old_state->fb, 0));
-	dma_buf_map_set_vaddr(&map, shmem_obj->vaddr);
-	drm_gem_shmem_vunmap(gem_obj, &map);
-}
-
 static const struct drm_plane_helper_funcs vkms_primary_helper_funcs = {
 	.atomic_update		= vkms_plane_atomic_update,
 	.atomic_check		= vkms_plane_atomic_check,
-	.prepare_fb		= vkms_prepare_fb,
-	.cleanup_fb		= vkms_cleanup_fb,
+	DRM_GEM_SHADOW_PLANE_HELPER_FUNCS,
 };
 
 struct drm_plane *vkms_plane_init(struct vkms_device *vkmsdev,
-- 
2.30.2



