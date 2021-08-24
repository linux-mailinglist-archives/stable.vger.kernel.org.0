Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27753F65B6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238541AbhHXRPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240021AbhHXROE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:14:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 302E5615A6;
        Tue, 24 Aug 2021 17:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824495;
        bh=Nc8/jTXkjwBthD88iKBzAiyH9Fo3M7QOwHVJFQ7ifgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1fw9/hmegT4qBDrVBKh1Fg+241hfwL2QKyQhM8/S7IodwyM+koi0Y44Rs3DddUg6
         O0U+tLCMZGeq0S2m1hgciHx05ylFzZ5IhsChaJStrufsxjYdVafntrvxJw1B8L01RV
         3/kxXB2v5rkInbz3iMpnsBIKdnOVCiMhEfWoGxpiPn04X/iqPF6lb5ABLOG6KAzxbc
         Nn9Y1iWVXuRUGglHh12zRN0OZpHekUFu1PCzYUfgKpnCNI1hlR+L1BDMXmZFfVoSzG
         EPjlj03HOB+zKaef0DqwKKCa1bsXpYZmIY5TFIsv6vy5of8TA+GMSuQ4HHssxcvXE+
         ATCd+LmCVvEmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/61] virtio: Protect vqs list access
Date:   Tue, 24 Aug 2021 13:00:33 -0400
Message-Id: <20210824170106.710221-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 0e566c8f0f2e8325e35f6f97e13cde5356b41814 ]

VQs may be accessed to mark the device broken while they are
created/destroyed. Hence protect the access to the vqs list.

Fixes: e2dcdfe95c0b ("virtio: virtio_break_device() to mark all virtqueues broken.")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Link: https://lore.kernel.org/r/20210721142648.1525924-4-parav@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c      | 1 +
 drivers/virtio/virtio_ring.c | 8 ++++++++
 include/linux/virtio.h       | 1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index a977e32a88f2..59a05f1b8105 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -342,6 +342,7 @@ int register_virtio_device(struct virtio_device *dev)
 	virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
 
 	INIT_LIST_HEAD(&dev->vqs);
+	spin_lock_init(&dev->vqs_list_lock);
 
 	/*
 	 * device_add() causes the bus infrastructure to look for a matching
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 97e8a195e18f..f6011c9ed32f 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1668,7 +1668,9 @@ static struct virtqueue *vring_create_virtqueue_packed(
 			cpu_to_le16(vq->packed.event_flags_shadow);
 	}
 
+	spin_lock(&vdev->vqs_list_lock);
 	list_add_tail(&vq->vq.list, &vdev->vqs);
+	spin_unlock(&vdev->vqs_list_lock);
 	return &vq->vq;
 
 err_desc_extra:
@@ -2126,7 +2128,9 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	memset(vq->split.desc_state, 0, vring.num *
 			sizeof(struct vring_desc_state_split));
 
+	spin_lock(&vdev->vqs_list_lock);
 	list_add_tail(&vq->vq.list, &vdev->vqs);
+	spin_unlock(&vdev->vqs_list_lock);
 	return &vq->vq;
 }
 EXPORT_SYMBOL_GPL(__vring_new_virtqueue);
@@ -2210,7 +2214,9 @@ void vring_del_virtqueue(struct virtqueue *_vq)
 	}
 	if (!vq->packed_ring)
 		kfree(vq->split.desc_state);
+	spin_lock(&vq->vq.vdev->vqs_list_lock);
 	list_del(&_vq->list);
+	spin_unlock(&vq->vq.vdev->vqs_list_lock);
 	kfree(vq);
 }
 EXPORT_SYMBOL_GPL(vring_del_virtqueue);
@@ -2274,10 +2280,12 @@ void virtio_break_device(struct virtio_device *dev)
 {
 	struct virtqueue *_vq;
 
+	spin_lock(&dev->vqs_list_lock);
 	list_for_each_entry(_vq, &dev->vqs, list) {
 		struct vring_virtqueue *vq = to_vvq(_vq);
 		vq->broken = true;
 	}
+	spin_unlock(&dev->vqs_list_lock);
 }
 EXPORT_SYMBOL_GPL(virtio_break_device);
 
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 15f906e4a748..7c075463c7f2 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -111,6 +111,7 @@ struct virtio_device {
 	bool config_enabled;
 	bool config_change_pending;
 	spinlock_t config_lock;
+	spinlock_t vqs_list_lock; /* Protects VQs list access */
 	struct device dev;
 	struct virtio_device_id id;
 	const struct virtio_config_ops *config;
-- 
2.30.2

