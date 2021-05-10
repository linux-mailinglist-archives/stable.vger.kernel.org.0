Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52630378F20
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhEJN2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:28:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346916AbhEJMdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 08:33:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620649915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OzXgoi91kkjg0iDmQl0pH7Eo/tgHHTrwDnUOt/nBVvE=;
        b=D1WnexVGLBrWxc80lPPnytbgHhcziFrY+tqEGKH1+bQ9pOadXNUCM1LoFvlAAMVdm8jH5K
        BD31BHJypDvnLypfBg2agYDCqVU7UIxojQDJ9+tn4i+9atm6Iitfp2/c7+e2ZHZVjJtre7
        e+hNBBDW0ZGmgUKH033ECdIgpbo5YCA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-yZK-lsp2PhCt1jDljdTn8g-1; Mon, 10 May 2021 08:31:51 -0400
X-MC-Unique: yZK-lsp2PhCt1jDljdTn8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47D1F8015DB
        for <stable@vger.kernel.org>; Mon, 10 May 2021 12:31:50 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-112-11.ams2.redhat.com [10.36.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD47F5F707
        for <stable@vger.kernel.org>; Mon, 10 May 2021 12:31:49 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 34AE218000B9; Mon, 10 May 2021 14:31:48 +0200 (CEST)
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     stable@vger.kernel.org
Subject: [[PATCH for 5.10]] drm/qxl: use ttm bo priorities
Date:   Mon, 10 May 2021 14:31:40 +0200
Message-Id: <20210510123140.2200366-1-kraxel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allow to set priorities for buffer objects.  Use priority 1 for surface
and cursor command releases.  Use priority 0 for drawing command
releases.  That way the short-living drawing commands are first in line
when it comes to eviction, making it *much* less likely that
ttm_bo_mem_force_space() picks something which can't be evicted and
throws an error after waiting a while without success.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: http://patchwork.freedesktop.org/patch/msgid/20210217123213.2199186-4-kraxel@redhat.com
(cherry-picked from 4fff19ae427548d8c37260c975a4b20d3c040ec6)
---
 drivers/gpu/drm/qxl/qxl_object.h  |  1 +
 drivers/gpu/drm/qxl/qxl_cmd.c     |  2 +-
 drivers/gpu/drm/qxl/qxl_display.c |  4 ++--
 drivers/gpu/drm/qxl/qxl_gem.c     |  2 +-
 drivers/gpu/drm/qxl/qxl_object.c  |  5 +++--
 drivers/gpu/drm/qxl/qxl_release.c | 18 ++++++++++++------
 6 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_object.h b/drivers/gpu/drm/qxl/qxl_object.h
index 6b434e5ef795..5762ea40d047 100644
--- a/drivers/gpu/drm/qxl/qxl_object.h
+++ b/drivers/gpu/drm/qxl/qxl_object.h
@@ -84,6 +84,7 @@ static inline int qxl_bo_wait(struct qxl_bo *bo, u32 *mem_type,
 extern int qxl_bo_create(struct qxl_device *qdev,
 			 unsigned long size,
 			 bool kernel, bool pinned, u32 domain,
+			 u32 priority,
 			 struct qxl_surface *surf,
 			 struct qxl_bo **bo_ptr);
 extern int qxl_bo_kmap(struct qxl_bo *bo, void **ptr);
diff --git a/drivers/gpu/drm/qxl/qxl_cmd.c b/drivers/gpu/drm/qxl/qxl_cmd.c
index 54e3c3a97440..741cc983daf1 100644
--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -268,7 +268,7 @@ int qxl_alloc_bo_reserved(struct qxl_device *qdev,
 	int ret;
 
 	ret = qxl_bo_create(qdev, size, false /* not kernel - device */,
-			    false, QXL_GEM_DOMAIN_VRAM, NULL, &bo);
+			    false, QXL_GEM_DOMAIN_VRAM, 0, NULL, &bo);
 	if (ret) {
 		DRM_ERROR("failed to allocate VRAM BO\n");
 		return ret;
diff --git a/drivers/gpu/drm/qxl/qxl_display.c b/drivers/gpu/drm/qxl/qxl_display.c
index 6063f3a15329..3da41a91bb74 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -790,8 +790,8 @@ static int qxl_plane_prepare_fb(struct drm_plane *plane,
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
diff --git a/drivers/gpu/drm/qxl/qxl_gem.c b/drivers/gpu/drm/qxl/qxl_gem.c
index 48e096285b4c..a08da0bd9098 100644
--- a/drivers/gpu/drm/qxl/qxl_gem.c
+++ b/drivers/gpu/drm/qxl/qxl_gem.c
@@ -55,7 +55,7 @@ int qxl_gem_object_create(struct qxl_device *qdev, int size,
 	/* At least align on page size */
 	if (alignment < PAGE_SIZE)
 		alignment = PAGE_SIZE;
-	r = qxl_bo_create(qdev, size, kernel, false, initial_domain, surf, &qbo);
+	r = qxl_bo_create(qdev, size, kernel, false, initial_domain, 0, surf, &qbo);
 	if (r) {
 		if (r != -ERESTARTSYS)
 			DRM_ERROR(
diff --git a/drivers/gpu/drm/qxl/qxl_object.c b/drivers/gpu/drm/qxl/qxl_object.c
index 2bc364412e8b..544a9e4df2a8 100644
--- a/drivers/gpu/drm/qxl/qxl_object.c
+++ b/drivers/gpu/drm/qxl/qxl_object.c
@@ -103,8 +103,8 @@ static const struct drm_gem_object_funcs qxl_object_funcs = {
 	.print_info = drm_gem_ttm_print_info,
 };
 
-int qxl_bo_create(struct qxl_device *qdev,
-		  unsigned long size, bool kernel, bool pinned, u32 domain,
+int qxl_bo_create(struct qxl_device *qdev, unsigned long size,
+		  bool kernel, bool pinned, u32 domain, u32 priority,
 		  struct qxl_surface *surf,
 		  struct qxl_bo **bo_ptr)
 {
@@ -137,6 +137,7 @@ int qxl_bo_create(struct qxl_device *qdev,
 
 	qxl_ttm_placement_from_domain(bo, domain, pinned);
 
+	bo->tbo.priority = priority;
 	r = ttm_bo_init(&qdev->mman.bdev, &bo->tbo, size, type,
 			&bo->placement, 0, !kernel, size,
 			NULL, NULL, &qxl_ttm_bo_destroy);
diff --git a/drivers/gpu/drm/qxl/qxl_release.c b/drivers/gpu/drm/qxl/qxl_release.c
index 4fae3e393da1..b2a475a0ca4a 100644
--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@ -199,11 +199,12 @@ qxl_release_free(struct qxl_device *qdev,
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
@@ -326,13 +327,18 @@ int qxl_alloc_release_reserved(struct qxl_device *qdev, unsigned long size,
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
@@ -352,7 +358,7 @@ int qxl_alloc_release_reserved(struct qxl_device *qdev, unsigned long size,
 		qdev->current_release_bo[cur_idx] = NULL;
 	}
 	if (!qdev->current_release_bo[cur_idx]) {
-		ret = qxl_release_bo_alloc(qdev, &qdev->current_release_bo[cur_idx]);
+		ret = qxl_release_bo_alloc(qdev, &qdev->current_release_bo[cur_idx], priority);
 		if (ret) {
 			mutex_unlock(&qdev->release_mutex);
 			qxl_release_free(qdev, *release);
-- 
2.31.1

