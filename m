Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E6B1192A3
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLJVEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:04:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfLJVEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 252F820828;
        Tue, 10 Dec 2019 21:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011846;
        bh=i9Qf3dkL+Sk4F1NH9W9U/zrqOPyWV6AW4NuExNBI0I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pct4bTmYJtTMY7Ugt+9I/IlYJy6tUvWkhldTlwPzFr0l2URDlzCsjSVA2V4du/iDk
         BsF2zLOiqOURKhYSo75rS/KrpB4/KaqvmNMB097c9mIourAgW/42X1mRrYyz6Y5UAM
         QQRJSJm/W5VgsNvFpXbtwUhnNYl24buXujJ0fBCw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chia-I Wu <olvaffe@gmail.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 002/350] drm/virtio: switch virtio_gpu_wait_ioctl() to gem helper.
Date:   Tue, 10 Dec 2019 15:58:14 -0500
Message-Id: <20191210210402.8367-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210402.8367-1-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 0a88ef11b9d3f..a662394f68921 100644
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

