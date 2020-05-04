Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0461C43A1
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbgEDSAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730921AbgEDSAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:00:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A47C820707;
        Mon,  4 May 2020 18:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615202;
        bh=v0t4xSectOQpTQZlghGbLv7g9vjKTSwNQDaT/pg9gRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irZczGmDbiQeymXZhJJ4rhp+pNOmAbwJzT/L/d8XKlNJKWywIrG0adEaDUA9/GO2Y
         UMCMK0iTSxNs/G9M/0jTFpRhtp/387BYjLRjjIM2WjBN1fWnvurVl4NX45A4YWu8yd
         pjKOo9n5g6QuTUVqk6mQmrO7jJ1z4GOKgWpAcI/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 4.9 18/18] drm/qxl: qxl_release use after free
Date:   Mon,  4 May 2020 19:57:28 +0200
Message-Id: <20200504165445.977315153@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165442.028485341@linuxfoundation.org>
References: <20200504165442.028485341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[backported to v4.9-stable]
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/qxl/qxl_cmd.c     |    5 ++---
 drivers/gpu/drm/qxl/qxl_display.c |    8 ++++----
 drivers/gpu/drm/qxl/qxl_draw.c    |    8 ++++----
 drivers/gpu/drm/qxl/qxl_ioctl.c   |    5 +----
 4 files changed, 11 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -529,8 +529,8 @@ int qxl_hw_surface_alloc(struct qxl_devi
 	/* no need to add a release to the fence for this surface bo,
 	   since it is only released when we ask to destroy the surface
 	   and it would never signal otherwise */
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
 
 	surf->hw_surf_alloc = true;
 	spin_lock(&qdev->surf_id_idr_lock);
@@ -572,9 +572,8 @@ int qxl_hw_surface_dealloc(struct qxl_de
 	cmd->surface_id = id;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
-
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
 
 	return 0;
 }
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -292,8 +292,8 @@ qxl_hide_cursor(struct qxl_device *qdev)
 	cmd->type = QXL_CURSOR_HIDE;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	return 0;
 }
 
@@ -333,8 +333,8 @@ static int qxl_crtc_apply_cursor(struct
 	cmd->u.set.visible = 1;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 
 	return ret;
 
@@ -436,8 +436,8 @@ static int qxl_crtc_cursor_set2(struct d
 	cmd->u.set.visible = 1;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 
 	/* finish with the userspace bo */
 	ret = qxl_bo_reserve(user_bo, false);
@@ -497,8 +497,8 @@ static int qxl_crtc_cursor_move(struct d
 	cmd->u.position.y = qcrtc->cur_y + qcrtc->hot_spot_y;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 
 	return 0;
 }
--- a/drivers/gpu/drm/qxl/qxl_draw.c
+++ b/drivers/gpu/drm/qxl/qxl_draw.c
@@ -241,8 +241,8 @@ void qxl_draw_opaque_fb(const struct qxl
 		qxl_bo_physical_address(qdev, dimage->bo, 0);
 	qxl_release_unmap(qdev, release, &drawable->release_info);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 
 out_free_palette:
 	if (palette_bo)
@@ -382,8 +382,8 @@ void qxl_draw_dirty_fb(struct qxl_device
 	}
 	qxl_bo_kunmap(clips_bo);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 
 out_release_backoff:
 	if (ret)
@@ -433,8 +433,8 @@ void qxl_draw_copyarea(struct qxl_device
 	drawable->u.copy_bits.src_pos.y = sy;
 	qxl_release_unmap(qdev, release, &drawable->release_info);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 
 out_free_release:
 	if (ret)
@@ -477,8 +477,8 @@ void qxl_draw_fill(struct qxl_draw_fill
 
 	qxl_release_unmap(qdev, release, &drawable->release_info);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 
 out_free_release:
 	if (ret)
--- a/drivers/gpu/drm/qxl/qxl_ioctl.c
+++ b/drivers/gpu/drm/qxl/qxl_ioctl.c
@@ -256,11 +256,8 @@ static int qxl_process_single_command(st
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


