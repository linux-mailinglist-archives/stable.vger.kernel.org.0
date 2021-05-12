Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1129537C31E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhELPR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233924AbhELPP3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:15:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BEC26197E;
        Wed, 12 May 2021 15:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831904;
        bh=MxxLblIPlIaA7ECDznkr6BQOrwrtXxVtLwPjoYCHk/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jJlljP7D0aVxadY0jP/1KzL0X5B5SLOhViBPiBh9TLE13oB8io9tvcUH6VU4Qo2v
         k42ymbPTHd1k7RoGfqFysBPuLBMbegJoW7OWi0bScjT7tLWl+5VgnmXJGCI7dc3Y/Z
         Eyt5hLCsZxrE5zP/5Ko5V1Dd2Yk8qyj8FOUrqBfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.10 061/530] drm/qxl: use ttm bo priorities
Date:   Wed, 12 May 2021 16:42:51 +0200
Message-Id: <20210512144821.751005247@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
@@ -791,8 +791,8 @@ static int qxl_plane_prepare_fb(struct d
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
 
 	qxl_ttm_placement_from_domain(bo, domain, pinned);
 
+	bo->tbo.priority = priority;
 	r = ttm_bo_init(&qdev->mman.bdev, &bo->tbo, size, type,
 			&bo->placement, 0, !kernel, size,
 			NULL, NULL, &qxl_ttm_bo_destroy);
--- a/drivers/gpu/drm/qxl/qxl_object.h
+++ b/drivers/gpu/drm/qxl/qxl_object.h
@@ -84,6 +84,7 @@ static inline int qxl_bo_wait(struct qxl
 extern int qxl_bo_create(struct qxl_device *qdev,
 			 unsigned long size,
 			 bool kernel, bool pinned, u32 domain,
+			 u32 priority,
 			 struct qxl_surface *surf,
 			 struct qxl_bo **bo_ptr);
 extern int qxl_bo_kmap(struct qxl_bo *bo, void **ptr);
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


