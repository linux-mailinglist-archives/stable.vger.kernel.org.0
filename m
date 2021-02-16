Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEE231CBE9
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 15:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhBPO1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 09:27:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33591 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230265AbhBPO1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 09:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613485570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SEYfYar2Z34JEmg9fNkxOlKxP8XDPywN5twdNpU8D+A=;
        b=efc9zbtyn8LGgEag76t4lm8sBWTKCkpXgI+70V+PStpeOkynABkcbi7PW0+wo6TnNLglHO
        UUGa1E5LkWEgG8kXjiqBdSSBNxG5D3uTApp+1GY9kQuXJvyQ/NFXWZsoqoXloVpg1BhxzB
        ikxvzFDeFRDMxpRJDJ9AyIVxlIGodJ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-0aJ7DoZmMcqyZ513nuUJfw-1; Tue, 16 Feb 2021 09:26:06 -0500
X-MC-Unique: 0aJ7DoZmMcqyZ513nuUJfw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C12AF3E759;
        Tue, 16 Feb 2021 14:25:37 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44F055B4BC;
        Tue, 16 Feb 2021 14:25:36 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH for 5.10 v2 4/5] vdpa_sim: make 'config' generic and usable for any device type
Date:   Tue, 16 Feb 2021 15:24:38 +0100
Message-Id: <20210216142439.258713-5-sgarzare@redhat.com>
In-Reply-To: <20210216142439.258713-1-sgarzare@redhat.com>
References: <20210216142439.258713-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f37cbbc65178e0a45823d281d290c4c02da9631c upstream.

Add new 'config_size' attribute in 'vdpasim_dev_attr' and allocates
'config' dynamically to support any device types.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20201215144256.155342-12-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index bc27fa485c3e..d9c494455156 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -70,6 +70,7 @@ static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
 			      (1ULL << VIRTIO_NET_F_MAC);
 
 struct vdpasim_dev_attr {
+	size_t config_size;
 	int nvqs;
 };
 
@@ -81,7 +82,8 @@ struct vdpasim {
 	struct vdpasim_dev_attr dev_attr;
 	/* spinlock to synchronize virtqueue state */
 	spinlock_t lock;
-	struct virtio_net_config config;
+	/* virtio config according to device type */
+	void *config;
 	struct vhost_iotlb *iommu;
 	void *buffer;
 	u32 status;
@@ -380,6 +382,10 @@ static struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 		goto err_iommu;
 	set_dma_ops(dev, &vdpasim_dma_ops);
 
+	vdpasim->config = kzalloc(dev_attr->config_size, GFP_KERNEL);
+	if (!vdpasim->config)
+		goto err_iommu;
+
 	vdpasim->vqs = kcalloc(dev_attr->nvqs, sizeof(struct vdpasim_virtqueue),
 			       GFP_KERNEL);
 	if (!vdpasim->vqs)
@@ -518,7 +524,8 @@ static u64 vdpasim_get_features(struct vdpa_device *vdpa)
 static int vdpasim_set_features(struct vdpa_device *vdpa, u64 features)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
-	struct virtio_net_config *config = &vdpasim->config;
+	struct virtio_net_config *config =
+		(struct virtio_net_config *)vdpasim->config;
 
 	/* DMA mapping must be done by driver */
 	if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
@@ -588,8 +595,8 @@ static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
-	if (offset + len < sizeof(struct virtio_net_config))
-		memcpy(buf, (u8 *)&vdpasim->config + offset, len);
+	if (offset + len < vdpasim->dev_attr.config_size)
+		memcpy(buf, vdpasim->config + offset, len);
 }
 
 static void vdpasim_set_config(struct vdpa_device *vdpa, unsigned int offset,
@@ -676,6 +683,7 @@ static void vdpasim_free(struct vdpa_device *vdpa)
 	if (vdpasim->iommu)
 		vhost_iotlb_free(vdpasim->iommu);
 	kfree(vdpasim->vqs);
+	kfree(vdpasim->config);
 }
 
 static const struct vdpa_config_ops vdpasim_net_config_ops = {
@@ -736,6 +744,7 @@ static int __init vdpasim_dev_init(void)
 	struct vdpasim_dev_attr dev_attr = {};
 
 	dev_attr.nvqs = VDPASIM_VQ_NUM;
+	dev_attr.config_size = sizeof(struct virtio_net_config);
 
 	vdpasim_dev = vdpasim_create(&dev_attr);
 
-- 
2.29.2

