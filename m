Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D7E795DE
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390218AbfG2Tqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389037AbfG2Tqm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:46:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D63F20C01;
        Mon, 29 Jul 2019 19:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429601;
        bh=PPZQgTgydBKLbD9HzAWcC2b7i9IBBOzN72htreEJiFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wkAvyhFBEISQuwP/pQuDV/dtSa/tq9WZm4Z2MK8Ki2QwTBoZKKXzH1HZzsbWLRAqA
         c1oBxxdbbFfxu973pP6ApMqrcGXlSCaQOxqrhgjD+OZK1f8XQCPdkzlrx/2ma9C8XA
         wDB1Gu3Z3Eo9CSWgleg/ZnRbZp0gQ90X6EUmRSNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chia-I Wu <olvaffe@gmail.com>,
        Emil Velikov <emil.velikov@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 008/215] drm/virtio: set seqno for dma-fence
Date:   Mon, 29 Jul 2019 21:20:04 +0200
Message-Id: <20190729190741.064813214@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index b69ae10ca238..d724fb3de44e 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -102,7 +102,6 @@ struct virtio_gpu_fence {
 	struct dma_fence f;
 	struct virtio_gpu_fence_driver *drv;
 	struct list_head node;
-	uint64_t seq;
 };
 #define to_virtio_fence(x) \
 	container_of(x, struct virtio_gpu_fence, f)
diff --git a/drivers/gpu/drm/virtio/virtgpu_fence.c b/drivers/gpu/drm/virtio/virtgpu_fence.c
index 87d1966192f4..72b4f7561432 100644
--- a/drivers/gpu/drm/virtio/virtgpu_fence.c
+++ b/drivers/gpu/drm/virtio/virtgpu_fence.c
@@ -40,16 +40,14 @@ bool virtio_fence_signaled(struct dma_fence *f)
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



