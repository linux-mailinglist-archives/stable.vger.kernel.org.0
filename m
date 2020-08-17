Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D8D24728F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388005AbgHQSoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388071AbgHQP4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:56:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 696CB208E4;
        Mon, 17 Aug 2020 15:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679783;
        bh=b11HqNpdArzBfb36qjl30UnIfQaDQAJ3CJtGITz78ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1OWw45dHesvNL/h7RSQkGuYz0kYg6kfsOYx0A98ZWKY/BNDqftm0iRkz0qKW+f37
         aIYBWKUvvsECx3j8WIE6VlTI6cYMt3go3vYMGCvQsfL4n5YjtT7VJbk2kQKvwG/1nh
         IruQ5neUi4P6S1ZWfgeTrd7fVpB50Ud7SSC1RZuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.7 333/393] vdpasim: protect concurrent access to iommu iotlb
Date:   Mon, 17 Aug 2020 17:16:23 +0200
Message-Id: <20200817143835.751584540@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

commit 0ea9ee430e74b16c6b17e70757d1c26d8d140e1f upstream.

Iommu iotlb can be accessed by different cores for performing IO using
multiple virt queues. Add a spinlock to synchronize iotlb accesses.

This could be easily reproduced when using more than 1 pktgen threads
to inject traffic to vdpa simulator.

Fixes: 2c53d0f64c06f("vdpasim: vDPA device simulator")
Cc: stable@vger.kernel.org
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20200731073822.13326-1-jasowang@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vdpa/vdpa_sim/vdpa_sim.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -70,6 +70,8 @@ struct vdpasim {
 	u32 status;
 	u32 generation;
 	u64 features;
+	/* spinlock to synchronize iommu table */
+	spinlock_t iommu_lock;
 };
 
 static struct vdpasim *vdpasim_dev;
@@ -118,7 +120,9 @@ static void vdpasim_reset(struct vdpasim
 	for (i = 0; i < VDPASIM_VQ_NUM; i++)
 		vdpasim_vq_reset(&vdpasim->vqs[i]);
 
+	spin_lock(&vdpasim->iommu_lock);
 	vhost_iotlb_reset(vdpasim->iommu);
+	spin_unlock(&vdpasim->iommu_lock);
 
 	vdpasim->features = 0;
 	vdpasim->status = 0;
@@ -235,8 +239,10 @@ static dma_addr_t vdpasim_map_page(struc
 	/* For simplicity, use identical mapping to avoid e.g iova
 	 * allocator.
 	 */
+	spin_lock(&vdpasim->iommu_lock);
 	ret = vhost_iotlb_add_range(iommu, pa, pa + size - 1,
 				    pa, dir_to_perm(dir));
+	spin_unlock(&vdpasim->iommu_lock);
 	if (ret)
 		return DMA_MAPPING_ERROR;
 
@@ -250,8 +256,10 @@ static void vdpasim_unmap_page(struct de
 	struct vdpasim *vdpasim = dev_to_sim(dev);
 	struct vhost_iotlb *iommu = vdpasim->iommu;
 
+	spin_lock(&vdpasim->iommu_lock);
 	vhost_iotlb_del_range(iommu, (u64)dma_addr,
 			      (u64)dma_addr + size - 1);
+	spin_unlock(&vdpasim->iommu_lock);
 }
 
 static void *vdpasim_alloc_coherent(struct device *dev, size_t size,
@@ -263,9 +271,10 @@ static void *vdpasim_alloc_coherent(stru
 	void *addr = kmalloc(size, flag);
 	int ret;
 
-	if (!addr)
+	spin_lock(&vdpasim->iommu_lock);
+	if (!addr) {
 		*dma_addr = DMA_MAPPING_ERROR;
-	else {
+	} else {
 		u64 pa = virt_to_phys(addr);
 
 		ret = vhost_iotlb_add_range(iommu, (u64)pa,
@@ -278,6 +287,7 @@ static void *vdpasim_alloc_coherent(stru
 		} else
 			*dma_addr = (dma_addr_t)pa;
 	}
+	spin_unlock(&vdpasim->iommu_lock);
 
 	return addr;
 }
@@ -289,8 +299,11 @@ static void vdpasim_free_coherent(struct
 	struct vdpasim *vdpasim = dev_to_sim(dev);
 	struct vhost_iotlb *iommu = vdpasim->iommu;
 
+	spin_lock(&vdpasim->iommu_lock);
 	vhost_iotlb_del_range(iommu, (u64)dma_addr,
 			      (u64)dma_addr + size - 1);
+	spin_unlock(&vdpasim->iommu_lock);
+
 	kfree(phys_to_virt((uintptr_t)dma_addr));
 }
 
@@ -531,6 +544,7 @@ static int vdpasim_set_map(struct vdpa_d
 	u64 start = 0ULL, last = 0ULL - 1;
 	int ret;
 
+	spin_lock(&vdpasim->iommu_lock);
 	vhost_iotlb_reset(vdpasim->iommu);
 
 	for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
@@ -540,10 +554,12 @@ static int vdpasim_set_map(struct vdpa_d
 		if (ret)
 			goto err;
 	}
+	spin_unlock(&vdpasim->iommu_lock);
 	return 0;
 
 err:
 	vhost_iotlb_reset(vdpasim->iommu);
+	spin_unlock(&vdpasim->iommu_lock);
 	return ret;
 }
 
@@ -551,16 +567,23 @@ static int vdpasim_dma_map(struct vdpa_d
 			   u64 pa, u32 perm)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+	int ret;
 
-	return vhost_iotlb_add_range(vdpasim->iommu, iova,
-				     iova + size - 1, pa, perm);
+	spin_lock(&vdpasim->iommu_lock);
+	ret = vhost_iotlb_add_range(vdpasim->iommu, iova, iova + size - 1, pa,
+				    perm);
+	spin_unlock(&vdpasim->iommu_lock);
+
+	return ret;
 }
 
 static int vdpasim_dma_unmap(struct vdpa_device *vdpa, u64 iova, u64 size)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
+	spin_lock(&vdpasim->iommu_lock);
 	vhost_iotlb_del_range(vdpasim->iommu, iova, iova + size - 1);
+	spin_unlock(&vdpasim->iommu_lock);
 
 	return 0;
 }


