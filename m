Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18BE6DA89
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbfGSEC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730165AbfGSEC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:02:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 432E7218A3;
        Fri, 19 Jul 2019 04:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508975;
        bh=vIgo9o8osNZccOtEaXlUgkZmiia18kjNAQFNzwMFsPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGLNTw5Iq87AtHDHrKo7Vmw1vYDDRP2TtuG87dC0xre/i8y9Y7hNZT+f+FvlpD0z+
         o/oGxtsD6zPNlAIbyJJk9/l3oiSrDRMbTz2mv/uwQfzu4fxovncE9PtYd53ZdLWpGO
         8sha5n0i8VDnFPcNkn1DfXtYFs2mnj2Y92U3T3Qg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chia-I Wu <olvaffe@gmail.com>,
        Emil Velikov <emil.velikov@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.1 004/141] drm/virtio: set seqno for dma-fence
Date:   Fri, 19 Jul 2019 00:00:29 -0400
Message-Id: <20190719040246.15945-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit efe2bf965522bf0796d413b47a2abbf81d471d6f ]

This is motivated by having meaningful ftrace events, but it also
fixes use cases where dma_fence_is_later is called, such as in
sync_file_merge.

In other drivers, fence creation and cmdbuf submission normally
happen atomically,

  mutex_lock();
  fence = dma_fence_create(..., ++timeline->seqno);
  submit_cmdbuf();
  mutex_unlock();

and have no such issue.  But in our driver, because most ioctls
queue commands into ctrlq, we do not want to grab a lock.  Instead,
we set seqno to 0 when a fence is created, and update it when the
command is finally queued and the seqno is known.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Reviewed-by: Emil Velikov <emil.velikov@collabora.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20190429220825.156644-1-olvaffe@gmail.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_drv.h   |  1 -
 drivers/gpu/drm/virtio/virtgpu_fence.c | 17 ++++++++++-------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.h b/drivers/gpu/drm/virtio/virtgpu_drv.h
index d577cb76f5ad..eaa19c338f68 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -85,7 +85,6 @@ struct virtio_gpu_fence {
 	struct dma_fence f;
 	struct virtio_gpu_fence_driver *drv;
 	struct list_head node;
-	uint64_t seq;
 };
 #define to_virtio_fence(x) \
 	container_of(x, struct virtio_gpu_fence, f)
diff --git a/drivers/gpu/drm/virtio/virtgpu_fence.c b/drivers/gpu/drm/virtio/virtgpu_fence.c
index 21bd4c4a32d1..216ab005e224 100644
--- a/drivers/gpu/drm/virtio/virtgpu_fence.c
+++ b/drivers/gpu/drm/virtio/virtgpu_fence.c
@@ -40,16 +40,14 @@ static bool virtio_signaled(struct dma_fence *f)
 {
 	struct virtio_gpu_fence *fence = to_virtio_fence(f);
 
-	if (atomic64_read(&fence->drv->last_seq) >= fence->seq)
+	if (atomic64_read(&fence->drv->last_seq) >= fence->f.seqno)
 		return true;
 	return false;
 }
 
 static void virtio_fence_value_str(struct dma_fence *f, char *str, int size)
 {
-	struct virtio_gpu_fence *fence = to_virtio_fence(f);
-
-	snprintf(str, size, "%llu", fence->seq);
+	snprintf(str, size, "%llu", f->seqno);
 }
 
 static void virtio_timeline_value_str(struct dma_fence *f, char *str, int size)
@@ -76,6 +74,11 @@ struct virtio_gpu_fence *virtio_gpu_fence_alloc(struct virtio_gpu_device *vgdev)
 		return fence;
 
 	fence->drv = drv;
+
+	/* This only partially initializes the fence because the seqno is
+	 * unknown yet.  The fence must not be used outside of the driver
+	 * until virtio_gpu_fence_emit is called.
+	 */
 	dma_fence_init(&fence->f, &virtio_fence_ops, &drv->lock, drv->context, 0);
 
 	return fence;
@@ -89,13 +92,13 @@ int virtio_gpu_fence_emit(struct virtio_gpu_device *vgdev,
 	unsigned long irq_flags;
 
 	spin_lock_irqsave(&drv->lock, irq_flags);
-	fence->seq = ++drv->sync_seq;
+	fence->f.seqno = ++drv->sync_seq;
 	dma_fence_get(&fence->f);
 	list_add_tail(&fence->node, &drv->fences);
 	spin_unlock_irqrestore(&drv->lock, irq_flags);
 
 	cmd_hdr->flags |= cpu_to_le32(VIRTIO_GPU_FLAG_FENCE);
-	cmd_hdr->fence_id = cpu_to_le64(fence->seq);
+	cmd_hdr->fence_id = cpu_to_le64(fence->f.seqno);
 	return 0;
 }
 
@@ -109,7 +112,7 @@ void virtio_gpu_fence_event_process(struct virtio_gpu_device *vgdev,
 	spin_lock_irqsave(&drv->lock, irq_flags);
 	atomic64_set(&vgdev->fence_drv.last_seq, last_seq);
 	list_for_each_entry_safe(fence, tmp, &drv->fences, node) {
-		if (last_seq < fence->seq)
+		if (last_seq < fence->f.seqno)
 			continue;
 		dma_fence_signal_locked(&fence->f);
 		list_del(&fence->node);
-- 
2.20.1

