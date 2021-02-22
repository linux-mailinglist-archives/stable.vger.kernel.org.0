Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE7932161C
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhBVMRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:17:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230390AbhBVMPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 577A764E2F;
        Mon, 22 Feb 2021 12:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996053;
        bh=XapuARKSu/55qVejNis/FYLooEqZ7DjU/+g4BHktcR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKcEm6sjPkiSmOKWbIVoRAk9FTprhF0bLJgHtVwxERdHjKJb7/dHfh7yFrAG9Xs2y
         WHc6Ggcpf19Fs77qAg6t5VHscOxn4jhy98S99TMeC4BNBqEZuFjq53JmNDue050I/X
         5/7v6YbRdcxcQU8Tj5N9FrhJRmf5xLJbQcCjBxEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.10 04/29] vdpa_sim: make config generic and usable for any device type
Date:   Mon, 22 Feb 2021 13:12:58 +0100
Message-Id: <20210222121020.930173241@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit f37cbbc65178e0a45823d281d290c4c02da9631c upstream.

Add new 'config_size' attribute in 'vdpasim_dev_attr' and allocates
'config' dynamically to support any device types.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20201215144256.155342-12-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -70,6 +70,7 @@ static u64 vdpasim_features = (1ULL << V
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
@@ -380,6 +382,10 @@ static struct vdpasim *vdpasim_create(st
 		goto err_iommu;
 	set_dma_ops(dev, &vdpasim_dma_ops);
 
+	vdpasim->config = kzalloc(dev_attr->config_size, GFP_KERNEL);
+	if (!vdpasim->config)
+		goto err_iommu;
+
 	vdpasim->vqs = kcalloc(dev_attr->nvqs, sizeof(struct vdpasim_virtqueue),
 			       GFP_KERNEL);
 	if (!vdpasim->vqs)
@@ -518,7 +524,8 @@ static u64 vdpasim_get_features(struct v
 static int vdpasim_set_features(struct vdpa_device *vdpa, u64 features)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
-	struct virtio_net_config *config = &vdpasim->config;
+	struct virtio_net_config *config =
+		(struct virtio_net_config *)vdpasim->config;
 
 	/* DMA mapping must be done by driver */
 	if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
@@ -588,8 +595,8 @@ static void vdpasim_get_config(struct vd
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
-	if (offset + len < sizeof(struct virtio_net_config))
-		memcpy(buf, (u8 *)&vdpasim->config + offset, len);
+	if (offset + len < vdpasim->dev_attr.config_size)
+		memcpy(buf, vdpasim->config + offset, len);
 }
 
 static void vdpasim_set_config(struct vdpa_device *vdpa, unsigned int offset,
@@ -676,6 +683,7 @@ static void vdpasim_free(struct vdpa_dev
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
 


