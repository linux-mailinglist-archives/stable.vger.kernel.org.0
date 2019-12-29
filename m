Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E828612C999
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbfL2SL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:11:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730405AbfL2RnH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A81D321744;
        Sun, 29 Dec 2019 17:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641387;
        bh=w+vHMWWBPEDgNlWv+B8/qbQJZcT7bi4XD7FJH4FTy5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSwamtEqLGY0wkMG0Q0vgEHuEqGsk0W3PbQzDtR2g4FuOWdXQwuTxJn4E2skHcSTY
         s0QeyFyZgRYtR3qps14V9HCF5EdW1JwsZSFv6Ee+tETTRhokWCnHmIQ1VH6sqHa2jS
         9TzJhUAdjxMUA0UP1QPchU+BdXkPJITxulCZnJJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chia-I Wu <olvaffe@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/434] drm/virtio: switch virtio_gpu_wait_ioctl() to gem helper.
Date:   Sun, 29 Dec 2019 18:21:37 +0100
Message-Id: <20191229172704.939671668@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

[ Upstream commit 29cf12394c0565d7eb1685bf0c1b4749aa6a8b66 ]

Use drm_gem_reservation_object_wait() in virtio_gpu_wait_ioctl().
This also makes the ioctl run lockless.

v9: fix return value.
v5: handle lookup failure.
v2: use reservation_object_test_signaled_rcu for VIRTGPU_WAIT_NOWAIT.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20190829103301.3539-3-kraxel@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 28 +++++++++++++++-----------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 0a88ef11b9d3..a662394f6892 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -463,25 +463,29 @@ out:
 }
 
 static int virtio_gpu_wait_ioctl(struct drm_device *dev, void *data,
-			    struct drm_file *file)
+				 struct drm_file *file)
 {
 	struct drm_virtgpu_3d_wait *args = data;
-	struct drm_gem_object *gobj = NULL;
-	struct virtio_gpu_object *qobj = NULL;
+	struct drm_gem_object *obj;
+	long timeout = 15 * HZ;
 	int ret;
-	bool nowait = false;
 
-	gobj = drm_gem_object_lookup(file, args->handle);
-	if (gobj == NULL)
+	obj = drm_gem_object_lookup(file, args->handle);
+	if (obj == NULL)
 		return -ENOENT;
 
-	qobj = gem_to_virtio_gpu_obj(gobj);
-
-	if (args->flags & VIRTGPU_WAIT_NOWAIT)
-		nowait = true;
-	ret = virtio_gpu_object_wait(qobj, nowait);
+	if (args->flags & VIRTGPU_WAIT_NOWAIT) {
+		ret = dma_resv_test_signaled_rcu(obj->resv, true);
+	} else {
+		ret = dma_resv_wait_timeout_rcu(obj->resv, true, true,
+						timeout);
+	}
+	if (ret == 0)
+		ret = -EBUSY;
+	else if (ret > 0)
+		ret = 0;
 
-	drm_gem_object_put_unlocked(gobj);
+	drm_gem_object_put_unlocked(obj);
 	return ret;
 }
 
-- 
2.20.1



