Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58E23215F0
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhBVMPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:15:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230254AbhBVMOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:14:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4AF264ED6;
        Mon, 22 Feb 2021 12:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996027;
        bh=0mMGKhEDAr9OIPZnQBvRr/inkg5UGmmw36O2OhHpYkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jz4qHx98kj+qEay2CkZxMccxMmL8yFvnFxeHMImn6WXI4qSeDsFUav4XmPFL9RV/v
         dlYqo14o6xgLxJ5qqIwN+rxjAcTdfTtvTMhNshVMAUz5op4CBDgQ7K6h+FMYo2ttKo
         bi51LO3ss9VUdnpULMcVgEHcj6rjuUpoHZbvYbP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.10 01/29] vdpa_sim: remove hard-coded virtq count
Date:   Mon, 22 Feb 2021 13:12:55 +0100
Message-Id: <20210222121019.633363493@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

commit 423248d60d2b655321fc49eca1545f95a1bc9d6c upstream.

Add a new attribute that will define the number of virt queues to be
created for the vdpasim device.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
[sgarzare: replace kmalloc_array() with kcalloc()]
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20201215144256.155342-4-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -70,7 +70,7 @@ static u64 vdpasim_features = (1ULL << V
 /* State of each vdpasim device */
 struct vdpasim {
 	struct vdpa_device vdpa;
-	struct vdpasim_virtqueue vqs[VDPASIM_VQ_NUM];
+	struct vdpasim_virtqueue *vqs;
 	struct work_struct work;
 	/* spinlock to synchronize virtqueue state */
 	spinlock_t lock;
@@ -80,6 +80,7 @@ struct vdpasim {
 	u32 status;
 	u32 generation;
 	u64 features;
+	int nvqs;
 	/* spinlock to synchronize iommu table */
 	spinlock_t iommu_lock;
 };
@@ -144,7 +145,7 @@ static void vdpasim_reset(struct vdpasim
 {
 	int i;
 
-	for (i = 0; i < VDPASIM_VQ_NUM; i++)
+	for (i = 0; i < vdpasim->nvqs; i++)
 		vdpasim_vq_reset(&vdpasim->vqs[i]);
 
 	spin_lock(&vdpasim->iommu_lock);
@@ -350,7 +351,7 @@ static struct vdpasim *vdpasim_create(vo
 	const struct vdpa_config_ops *ops;
 	struct vdpasim *vdpasim;
 	struct device *dev;
-	int ret = -ENOMEM;
+	int i, ret = -ENOMEM;
 
 	if (batch_mapping)
 		ops = &vdpasim_net_batch_config_ops;
@@ -361,6 +362,7 @@ static struct vdpasim *vdpasim_create(vo
 	if (!vdpasim)
 		goto err_alloc;
 
+	vdpasim->nvqs = VDPASIM_VQ_NUM;
 	INIT_WORK(&vdpasim->work, vdpasim_work);
 	spin_lock_init(&vdpasim->lock);
 	spin_lock_init(&vdpasim->iommu_lock);
@@ -371,6 +373,11 @@ static struct vdpasim *vdpasim_create(vo
 		goto err_iommu;
 	set_dma_ops(dev, &vdpasim_dma_ops);
 
+	vdpasim->vqs = kcalloc(vdpasim->nvqs, sizeof(struct vdpasim_virtqueue),
+			       GFP_KERNEL);
+	if (!vdpasim->vqs)
+		goto err_iommu;
+
 	vdpasim->iommu = vhost_iotlb_alloc(2048, 0);
 	if (!vdpasim->iommu)
 		goto err_iommu;
@@ -389,8 +396,8 @@ static struct vdpasim *vdpasim_create(vo
 		eth_random_addr(vdpasim->config.mac);
 	}
 
-	vringh_set_iotlb(&vdpasim->vqs[0].vring, vdpasim->iommu);
-	vringh_set_iotlb(&vdpasim->vqs[1].vring, vdpasim->iommu);
+	for (i = 0; i < vdpasim->nvqs; i++)
+		vringh_set_iotlb(&vdpasim->vqs[i].vring, vdpasim->iommu);
 
 	vdpasim->vdpa.dma_dev = dev;
 	ret = vdpa_register_device(&vdpasim->vdpa);
@@ -659,6 +666,7 @@ static void vdpasim_free(struct vdpa_dev
 	kfree(vdpasim->buffer);
 	if (vdpasim->iommu)
 		vhost_iotlb_free(vdpasim->iommu);
+	kfree(vdpasim->vqs);
 }
 
 static const struct vdpa_config_ops vdpasim_net_config_ops = {


