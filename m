Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D768237C709
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhELP55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232752AbhELPwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BD7461A11;
        Wed, 12 May 2021 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833213;
        bh=J3JH0c4UA5D/9o3pnL0rtYrcRaC80uhgWr5Jo92vZ5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ur7A43ix9iJOCOQ7DNPA1SvQF5n7jGWyIZzUKjp1cKZEjOzldxrvl1I0ntsKUDDYN
         qpDQVSy9hcVLgwZR3TcUI/H88ehikFD2OFiNmo9FskqztpH9Ane1ZfBo8aRw+OEKO9
         FYT9V/D+IXypuBYnK8SPISHqKXAGUlFg0rlDUjNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.11 062/601] drm/qxl: use ttm bo priorities
Date:   Wed, 12 May 2021 16:42:19 +0200
Message-Id: <20210512144829.854985865@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

commit 4fff19ae427548d8c37260c975a4b20d3c040ec6 upstream.

Allow to set priorities for buffer objects.  Use priority 1 for surface
and cursor command releases.  Use priority 0 for drawing command
releases.  That way the short-living drawing commands are first in line
when it comes to eviction, making it *much* less likely that
ttm_bo_mem_force_space() picks something which can't be evicted and
throws an error after waiting a while without success.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: http://patchwork.freedesktop.org/patch/msgid/20210217123213.2199186-4-kraxel@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/qxl/qxl_cmd.c     |    2 +-
 drivers/gpu/drm/qxl/qxl_display.c |    4 ++--
 drivers/gpu/drm/qxl/qxl_gem.c     |    2 +-
 drivers/gpu/drm/qxl/qxl_object.c  |    5 +++--
 drivers/gpu/drm/qxl/qxl_object.h  |    1 +
 drivers/gpu/drm/qxl/qxl_release.c |   18 ++++++++++++------
 6 files changed, 20 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -268,7 +268,7 @@ int qxl_alloc_bo_reserved(struct qxl_dev
 	int ret;
 
 	ret = qxl_bo_create(qdev, size, false /* not kernel - device */,
-			    false, QXL_GEM_DOMAIN_VRAM, NULL, &bo);
+			    false, QXL_GEM_DOMAIN_VRAM, 0, NULL, &bo);
 	if (ret) {
 		DRM_ERROR("failed to allocate VRAM BO\n");
 		return ret;
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -798,8 +798,8 @@ static int qxl_plane_prepare_fb(struct d
 				qdev->dumb_shadow_bo = NULL;
 			}
 			qxl_bo_create(qdev, surf.height * surf.stride,
-				      true, true, QXL_GEM_DOMAIN_SURFACE, &surf,
-				      &qdev->dumb_shadow_bo);
+				      true, true, QXL_GEM_DOMAIN_SURFACE, 0,
+				      &surf, &qdev->dumb_shadow_bo);
 		}
 		if (user_bo->shadow != qdev->dumb_shadow_bo) {
 			if (user_bo->shadow) {
--- a/drivers/gpu/drm/qxl/qxl_gem.c
+++ b/drivers/gpu/drm/qxl/qxl_gem.c
@@ -55,7 +55,7 @@ int qxl_gem_object_create(struct qxl_dev
 	/* At least align on page size */
 	if (alignment < PAGE_SIZE)
 		alignment = PAGE_SIZE;
-	r = qxl_bo_create(qdev, size, kernel, false, initial_domain, surf, &qbo);
+	r = qxl_bo_create(qdev, size, kernel, false, initial_domain, 0, surf, &qbo);
 	if (r) {
 		if (r != -ERESTARTSYS)
 			DRM_ERROR(
--- a/drivers/gpu/drm/qxl/qxl_object.c
+++ b/drivers/gpu/drm/qxl/qxl_object.c
@@ -103,8 +103,8 @@ static const struct drm_gem_object_funcs
 	.print_info = drm_gem_ttm_print_info,
 };
 
-int qxl_bo_create(struct qxl_device *qdev,
-		  unsigned long size, bool kernel, bool pinned, u32 domain,
+int qxl_bo_create(struct qxl_device *qdev, unsigned long size,
+		  bool kernel, bool pinned, u32 domain, u32 priority,
 		  struct qxl_surface *surf,
 		  struct qxl_bo **bo_ptr)
 {
@@ -137,6 +137,7 @@ int qxl_bo_create(struct qxl_device *qde
 
 	qxl_ttm_placement_from_domain(bo, domain);
 
+	bo->tbo.priority = priority;
 	r = ttm_bo_init_reserved(&qdev->mman.bdev, &bo->tbo, size, type,
 				 &bo->placement, 0, &ctx, size,
 				 NULL, NULL, &qxl_ttm_bo_destroy);
--- a/drivers/gpu/drm/qxl/qxl_object.h
+++ b/drivers/gpu/drm/qxl/qxl_object.h
@@ -61,6 +61,7 @@ static inline u64 qxl_bo_mmap_offset(str
 extern int qxl_bo_create(struct qxl_device *qdev,
 			 unsigned long size,
 			 bool kernel, bool pinned, u32 domain,
+			 u32 priority,
 			 struct qxl_surface *surf,
 			 struct qxl_bo **bo_ptr);
 extern int qxl_bo_kmap(struct qxl_bo *bo, struct dma_buf_map *map);
--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@ -199,11 +199,12 @@ qxl_release_free(struct qxl_device *qdev
 }
 
 static int qxl_release_bo_alloc(struct qxl_device *qdev,
-				struct qxl_bo **bo)
+				struct qxl_bo **bo,
+				u32 priority)
 {
 	/* pin releases bo's they are too messy to evict */
 	return qxl_bo_create(qdev, PAGE_SIZE, false, true,
-			     QXL_GEM_DOMAIN_VRAM, NULL, bo);
+			     QXL_GEM_DOMAIN_VRAM, priority, NULL, bo);
 }
 
 int qxl_release_list_add(struct qxl_release *release, struct qxl_bo *bo)
@@ -326,13 +327,18 @@ int qxl_alloc_release_reserved(struct qx
 	int ret = 0;
 	union qxl_release_info *info;
 	int cur_idx;
+	u32 priority;
 
-	if (type == QXL_RELEASE_DRAWABLE)
+	if (type == QXL_RELEASE_DRAWABLE) {
 		cur_idx = 0;
-	else if (type == QXL_RELEASE_SURFACE_CMD)
+		priority = 0;
+	} else if (type == QXL_RELEASE_SURFACE_CMD) {
 		cur_idx = 1;
-	else if (type == QXL_RELEASE_CURSOR_CMD)
+		priority = 1;
+	} else if (type == QXL_RELEASE_CURSOR_CMD) {
 		cur_idx = 2;
+		priority = 1;
+	}
 	else {
 		DRM_ERROR("got illegal type: %d\n", type);
 		return -EINVAL;
@@ -352,7 +358,7 @@ int qxl_alloc_release_reserved(struct qx
 		qdev->current_release_bo[cur_idx] = NULL;
 	}
 	if (!qdev->current_release_bo[cur_idx]) {
-		ret = qxl_release_bo_alloc(qdev, &qdev->current_release_bo[cur_idx]);
+		ret = qxl_release_bo_alloc(qdev, &qdev->current_release_bo[cur_idx], priority);
 		if (ret) {
 			mutex_unlock(&qdev->release_mutex);
 			qxl_release_free(qdev, *release);


