Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C74C31CBDF
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 15:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhBPO1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 09:27:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230236AbhBPO0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 09:26:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613485528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2TmF7w7sfqEh73AzXaJTZ6JMBnR+00kT4c+R/HZJ+Y=;
        b=G5RaYhdICS/vK4JC9Iif4zpCMHlyBvJ7tuxjvlFEuXYie5LmsT59p3w1ZSoD9+jFhKI39z
        RQo37SHiABEemmeEwprobFuyhh8qnO1pbCj4p2lSFIZOjbivBAwowoRFaAAi6eriOG91W/
        oHzZZWvUmZgJslZ1b26GkXeZgyUyECc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-xn5VBPITOyiS8_Ol-9h-8A-1; Tue, 16 Feb 2021 09:25:24 -0500
X-MC-Unique: xn5VBPITOyiS8_Ol-9h-8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0A781E571;
        Tue, 16 Feb 2021 14:25:12 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A469D101E251;
        Tue, 16 Feb 2021 14:25:10 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH for 5.10 v2 2/5] vdpa_sim: add struct vdpasim_dev_attr for device attributes
Date:   Tue, 16 Feb 2021 15:24:36 +0100
Message-Id: <20210216142439.258713-3-sgarzare@redhat.com>
In-Reply-To: <20210216142439.258713-1-sgarzare@redhat.com>
References: <20210216142439.258713-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6c6e28fe45794054410ad8cd2770af69fbe0338d upstream.

vdpasim_dev_attr will contain device specific attributes. We starting
moving the number of virtqueues (i.e. nvqs) to vdpasim_dev_attr.

vdpasim_create() creates a new vDPA simulator following the device
attributes defined in the vdpasim_dev_attr parameter.

Co-developed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20201215144256.155342-7-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index ee8f24a4643b..6a5603f9d24c 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -67,11 +67,16 @@ static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
 			      (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
 			      (1ULL << VIRTIO_NET_F_MAC);
 
+struct vdpasim_dev_attr {
+	int nvqs;
+};
+
 /* State of each vdpasim device */
 struct vdpasim {
 	struct vdpa_device vdpa;
 	struct vdpasim_virtqueue *vqs;
 	struct work_struct work;
+	struct vdpasim_dev_attr dev_attr;
 	/* spinlock to synchronize virtqueue state */
 	spinlock_t lock;
 	struct virtio_net_config config;
@@ -80,7 +85,6 @@ struct vdpasim {
 	u32 status;
 	u32 generation;
 	u64 features;
-	int nvqs;
 	/* spinlock to synchronize iommu table */
 	spinlock_t iommu_lock;
 };
@@ -145,7 +149,7 @@ static void vdpasim_reset(struct vdpasim *vdpasim)
 {
 	int i;
 
-	for (i = 0; i < vdpasim->nvqs; i++)
+	for (i = 0; i < vdpasim->dev_attr.nvqs; i++)
 		vdpasim_vq_reset(&vdpasim->vqs[i]);
 
 	spin_lock(&vdpasim->iommu_lock);
@@ -346,7 +350,7 @@ static const struct dma_map_ops vdpasim_dma_ops = {
 static const struct vdpa_config_ops vdpasim_net_config_ops;
 static const struct vdpa_config_ops vdpasim_net_batch_config_ops;
 
-static struct vdpasim *vdpasim_create(void)
+static struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 {
 	const struct vdpa_config_ops *ops;
 	struct vdpasim *vdpasim;
@@ -358,11 +362,12 @@ static struct vdpasim *vdpasim_create(void)
 	else
 		ops = &vdpasim_net_config_ops;
 
-	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, VDPASIM_VQ_NUM);
+	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
+				    dev_attr->nvqs);
 	if (!vdpasim)
 		goto err_alloc;
 
-	vdpasim->nvqs = VDPASIM_VQ_NUM;
+	vdpasim->dev_attr = *dev_attr;
 	INIT_WORK(&vdpasim->work, vdpasim_work);
 	spin_lock_init(&vdpasim->lock);
 	spin_lock_init(&vdpasim->iommu_lock);
@@ -373,7 +378,7 @@ static struct vdpasim *vdpasim_create(void)
 		goto err_iommu;
 	set_dma_ops(dev, &vdpasim_dma_ops);
 
-	vdpasim->vqs = kcalloc(vdpasim->nvqs, sizeof(struct vdpasim_virtqueue),
+	vdpasim->vqs = kcalloc(dev_attr->nvqs, sizeof(struct vdpasim_virtqueue),
 			       GFP_KERNEL);
 	if (!vdpasim->vqs)
 		goto err_iommu;
@@ -396,7 +401,7 @@ static struct vdpasim *vdpasim_create(void)
 		eth_random_addr(vdpasim->config.mac);
 	}
 
-	for (i = 0; i < vdpasim->nvqs; i++)
+	for (i = 0; i < dev_attr->nvqs; i++)
 		vringh_set_iotlb(&vdpasim->vqs[i].vring, vdpasim->iommu);
 
 	vdpasim->vdpa.dma_dev = dev;
@@ -724,7 +729,11 @@ static const struct vdpa_config_ops vdpasim_net_batch_config_ops = {
 
 static int __init vdpasim_dev_init(void)
 {
-	vdpasim_dev = vdpasim_create();
+	struct vdpasim_dev_attr dev_attr = {};
+
+	dev_attr.nvqs = VDPASIM_VQ_NUM;
+
+	vdpasim_dev = vdpasim_create(&dev_attr);
 
 	if (!IS_ERR(vdpasim_dev))
 		return 0;
-- 
2.29.2

