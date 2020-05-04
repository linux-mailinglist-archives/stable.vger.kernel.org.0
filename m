Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77461C385D
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 13:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgEDLiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 07:38:22 -0400
Received: from relay.sw.ru ([185.231.240.75]:48014 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728698AbgEDLiW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 07:38:22 -0400
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1jVZQQ-0002SH-QA; Mon, 04 May 2020 14:38:18 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 4.14] drm/qxl: qxl_release use after free
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Gerd Hoffmann <kraxel@redhat.com>
Message-ID: <050bf096-986a-6ee8-7bef-37a532cc1fcd@virtuozzo.com>
Date:   Mon, 4 May 2020 14:38:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>From 933db73351d359f74b14f4af095808260aff11f9 Mon Sep 17 00:00:00 2001
From: Vasily Averin <vvs@virtuozzo.com>
Date: Wed, 29 Apr 2020 12:01:24 +0300
Subject: drm/qxl: qxl_release use after free

From: Vasily Averin <vvs@virtuozzo.com>

commit 933db73351d359f74b14f4af095808260aff11f9 upstream.
qxl_release should not be accesses after qxl_push_*_ring_release() calls:
userspace driver can process submitted command quickly, move qxl_release
into release_ring, generate interrupt and trigger garbage collector.

It can lead to crashes in qxl driver or trigger memory corruption
in some kmalloc-192 slab object

Gerd Hoffmann proposes to swap the qxl_release_fence_buffer_objects() +
qxl_push_{cursor,command}_ring_release() calls to close that race window.

cc: stable@vger.kernel.org
Fixes: f64122c1f6ad ("drm: add new QXL driver. (v1.4)")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Link: http://patchwork.freedesktop.org/patch/msgid/fa17b338-66ae-f299-68fe-8d32419d9071@virtuozzo.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

backported to v4.14-stable

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 drivers/gpu/drm/qxl/qxl_cmd.c     | 5 ++---
 drivers/gpu/drm/qxl/qxl_display.c | 6 +++---
 drivers/gpu/drm/qxl/qxl_draw.c    | 8 ++++----
 drivers/gpu/drm/qxl/qxl_ioctl.c   | 5 +----
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_cmd.c b/drivers/gpu/drm/qxl/qxl_cmd.c
index 3eb920851141..31fbeba1494d 100644
--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -532,8 +532,8 @@ int qxl_hw_surface_alloc(struct qxl_device *qdev,
 	/* no need to add a release to the fence for this surface bo,
 	   since it is only released when we ask to destroy the surface
 	   and it would never signal otherwise */
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
 
 	surf->hw_surf_alloc = true;
 	spin_lock(&qdev->surf_id_idr_lock);
@@ -575,9 +575,8 @@ int qxl_hw_surface_dealloc(struct qxl_device *qdev,
 	cmd->surface_id = id;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
-
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/qxl/qxl_display.c b/drivers/gpu/drm/qxl/qxl_display.c
index 573bab222123..b209a25e307d 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -533,8 +533,8 @@ static int qxl_primary_apply_cursor(struct drm_plane *plane)
 	cmd->u.set.visible = 1;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 
 	return ret;
 
@@ -701,8 +701,8 @@ static void qxl_cursor_atomic_update(struct drm_plane *plane,
 	cmd->u.position.y = plane->state->crtc_y + fb->hot_y;
 
 	qxl_release_unmap(qdev, release, &cmd->release_info);
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 
 	if (old_cursor_bo)
 		qxl_bo_unref(&old_cursor_bo);
@@ -747,8 +747,8 @@ static void qxl_cursor_atomic_disable(struct drm_plane *plane,
 	cmd->type = QXL_CURSOR_HIDE;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 }
 
 static int qxl_plane_prepare_fb(struct drm_plane *plane,
diff --git a/drivers/gpu/drm/qxl/qxl_draw.c b/drivers/gpu/drm/qxl/qxl_draw.c
index 4d8681e84e68..958d0d870c99 100644
--- a/drivers/gpu/drm/qxl/qxl_draw.c
+++ b/drivers/gpu/drm/qxl/qxl_draw.c
@@ -241,8 +241,8 @@ void qxl_draw_opaque_fb(const struct qxl_fb_image *qxl_fb_image,
 		qxl_bo_physical_address(qdev, dimage->bo, 0);
 	qxl_release_unmap(qdev, release, &drawable->release_info);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 
 out_free_palette:
 	if (palette_bo)
@@ -381,8 +381,8 @@ void qxl_draw_dirty_fb(struct qxl_device *qdev,
 	}
 	qxl_bo_kunmap(clips_bo);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 
 out_release_backoff:
 	if (ret)
@@ -432,8 +432,8 @@ void qxl_draw_copyarea(struct qxl_device *qdev,
 	drawable->u.copy_bits.src_pos.y = sy;
 	qxl_release_unmap(qdev, release, &drawable->release_info);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 
 out_free_release:
 	if (ret)
@@ -476,8 +476,8 @@ void qxl_draw_fill(struct qxl_draw_fill *qxl_draw_fill_rec)
 
 	qxl_release_unmap(qdev, release, &drawable->release_info);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 
 out_free_release:
 	if (ret)
diff --git a/drivers/gpu/drm/qxl/qxl_ioctl.c b/drivers/gpu/drm/qxl/qxl_ioctl.c
index 31effed4a3c8..cede17585525 100644
--- a/drivers/gpu/drm/qxl/qxl_ioctl.c
+++ b/drivers/gpu/drm/qxl/qxl_ioctl.c
@@ -257,11 +257,8 @@ static int qxl_process_single_command(struct qxl_device *qdev,
 			apply_surf_reloc(qdev, &reloc_info[i]);
 	}
 
+	qxl_release_fence_buffer_objects(release);
 	ret = qxl_push_command_ring_release(qdev, release, cmd->type, true);
-	if (ret)
-		qxl_release_backoff_reserve_list(release);
-	else
-		qxl_release_fence_buffer_objects(release);
 
 out_free_bos:
 out_free_release:
-- 
2.17.1

