Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE0F1C44CD
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731235AbgEDSFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731774AbgEDSFK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:05:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C535F206B8;
        Mon,  4 May 2020 18:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615509;
        bh=z4cqvnk6Rzpi/NGSkK4ma/fkQPm9mS7DduXFNAfNqs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHxDf6W8IyfFcW0bVNZdG6eXqBzw2adGcYUGWDZ+JvG9bF9zAvzj2oW1Z+7t5m03k
         XimQKM8x6MMBmBc7pudA/k7ppNy29neRNymD/9RAhoGZ25dy5pi0VqNWvJ7Wn1mRKn
         wmH4QBOCK36EfkFihvIWvd8Ilt8ja0vw8TsOuk8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 5.6 10/73] drm/qxl: qxl_release use after free
Date:   Mon,  4 May 2020 19:57:13 +0200
Message-Id: <20200504165503.838845588@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/qxl/qxl_cmd.c     |    5 ++---
 drivers/gpu/drm/qxl/qxl_display.c |    6 +++---
 drivers/gpu/drm/qxl/qxl_draw.c    |    2 +-
 drivers/gpu/drm/qxl/qxl_ioctl.c   |    5 +----
 4 files changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -500,8 +500,8 @@ int qxl_hw_surface_alloc(struct qxl_devi
 	/* no need to add a release to the fence for this surface bo,
 	   since it is only released when we ask to destroy the surface
 	   and it would never signal otherwise */
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
 
 	surf->hw_surf_alloc = true;
 	spin_lock(&qdev->surf_id_idr_lock);
@@ -543,9 +543,8 @@ int qxl_hw_surface_dealloc(struct qxl_de
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
@@ -523,8 +523,8 @@ static int qxl_primary_apply_cursor(stru
 	cmd->u.set.visible = 1;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 
 	return ret;
 
@@ -665,8 +665,8 @@ static void qxl_cursor_atomic_update(str
 	cmd->u.position.y = plane->state->crtc_y + fb->hot_y;
 
 	qxl_release_unmap(qdev, release, &cmd->release_info);
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 
 	if (old_cursor_bo != NULL)
 		qxl_bo_unpin(old_cursor_bo);
@@ -713,8 +713,8 @@ static void qxl_cursor_atomic_disable(st
 	cmd->type = QXL_CURSOR_HIDE;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 }
 
 static void qxl_update_dumb_head(struct qxl_device *qdev,
--- a/drivers/gpu/drm/qxl/qxl_draw.c
+++ b/drivers/gpu/drm/qxl/qxl_draw.c
@@ -243,8 +243,8 @@ void qxl_draw_dirty_fb(struct qxl_device
 	}
 	qxl_bo_kunmap(clips_bo);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 
 out_release_backoff:
 	if (ret)
--- a/drivers/gpu/drm/qxl/qxl_ioctl.c
+++ b/drivers/gpu/drm/qxl/qxl_ioctl.c
@@ -261,11 +261,8 @@ static int qxl_process_single_command(st
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


