Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2889200FF9
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392609AbgFSPXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392740AbgFSPXx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:23:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF6942186A;
        Fri, 19 Jun 2020 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580231;
        bh=m23dLoyLhJjCU66alnaUcLHfXVkJjzbVDLW3x6HWfMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zg06QBlL4clJ2i5cPBsg//eZBYBi42SSNZ/QRHwXqahbwqESeVXN9gCVwkthfSL+X
         1FgKqp1uu5c43GbZm/XoLqHV1dFxCSqt2We9o+6LZ3K+E+ZvjRBw0X3/EozM84LZnZ
         o54V2XM/vJT0BXnXnHDwyMgnfs7/3YJQVQvnvi5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Weiping Zhang <zhangweiping@didiglobal.com>,
        Keith Busch <kbusch@kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 171/376] nvme-pci: align io queue count with allocted nvme_queue in nvme_probe
Date:   Fri, 19 Jun 2020 16:31:29 +0200
Message-Id: <20200619141718.416881218@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weiping Zhang <zhangweiping@didiglobal.com>

[ Upstream commit 2a5bcfdd41d68559567cec3c124a75e093506cc1 ]

Since commit 147b27e4bd08 ("nvme-pci: allocate device queues storage
space at probe"), nvme_alloc_queue does not alloc the nvme queues
itself anymore.

If the write/poll_queues module parameters are changed at runtime to
values larger than the number of allocated queues in nvme_probe,
nvme_alloc_queue will access unallocated memory.

Add a new nr_allocated_queues member to struct nvme_dev to record how
many queues were alloctated in nvme_probe to avoid using more than the
allocated queues after a reset following a change to the
write/poll_queues module parameters.

Also add nr_write_queues and nr_poll_queues members to allow refreshing
the number of write and poll queues based on a change to the module
parameters when resetting the controller.

Fixes: 147b27e4bd08 ("nvme-pci: allocate device queues storage space at probe")
Signed-off-by: Weiping Zhang <zhangweiping@didiglobal.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
[hch: add nvme_max_io_queues, update the commit message]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 57 ++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index cc46e250fcac..dcf597fbafad 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -128,6 +128,9 @@ struct nvme_dev {
 	dma_addr_t host_mem_descs_dma;
 	struct nvme_host_mem_buf_desc *host_mem_descs;
 	void **host_mem_desc_bufs;
+	unsigned int nr_allocated_queues;
+	unsigned int nr_write_queues;
+	unsigned int nr_poll_queues;
 };
 
 static int io_queue_depth_set(const char *val, const struct kernel_param *kp)
@@ -209,25 +212,14 @@ struct nvme_iod {
 	struct scatterlist *sg;
 };
 
-static unsigned int max_io_queues(void)
+static inline unsigned int nvme_dbbuf_size(struct nvme_dev *dev)
 {
-	return num_possible_cpus() + write_queues + poll_queues;
-}
-
-static unsigned int max_queue_count(void)
-{
-	/* IO queues + admin queue */
-	return 1 + max_io_queues();
-}
-
-static inline unsigned int nvme_dbbuf_size(u32 stride)
-{
-	return (max_queue_count() * 8 * stride);
+	return dev->nr_allocated_queues * 8 * dev->db_stride;
 }
 
 static int nvme_dbbuf_dma_alloc(struct nvme_dev *dev)
 {
-	unsigned int mem_size = nvme_dbbuf_size(dev->db_stride);
+	unsigned int mem_size = nvme_dbbuf_size(dev);
 
 	if (dev->dbbuf_dbs)
 		return 0;
@@ -252,7 +244,7 @@ static int nvme_dbbuf_dma_alloc(struct nvme_dev *dev)
 
 static void nvme_dbbuf_dma_free(struct nvme_dev *dev)
 {
-	unsigned int mem_size = nvme_dbbuf_size(dev->db_stride);
+	unsigned int mem_size = nvme_dbbuf_size(dev);
 
 	if (dev->dbbuf_dbs) {
 		dma_free_coherent(dev->dev, mem_size,
@@ -2003,7 +1995,7 @@ static int nvme_setup_host_mem(struct nvme_dev *dev)
 static void nvme_calc_irq_sets(struct irq_affinity *affd, unsigned int nrirqs)
 {
 	struct nvme_dev *dev = affd->priv;
-	unsigned int nr_read_queues;
+	unsigned int nr_read_queues, nr_write_queues = dev->nr_write_queues;
 
 	/*
 	 * If there is no interupt available for queues, ensure that
@@ -2019,12 +2011,12 @@ static void nvme_calc_irq_sets(struct irq_affinity *affd, unsigned int nrirqs)
 	if (!nrirqs) {
 		nrirqs = 1;
 		nr_read_queues = 0;
-	} else if (nrirqs == 1 || !write_queues) {
+	} else if (nrirqs == 1 || !nr_write_queues) {
 		nr_read_queues = 0;
-	} else if (write_queues >= nrirqs) {
+	} else if (nr_write_queues >= nrirqs) {
 		nr_read_queues = 1;
 	} else {
-		nr_read_queues = nrirqs - write_queues;
+		nr_read_queues = nrirqs - nr_write_queues;
 	}
 
 	dev->io_queues[HCTX_TYPE_DEFAULT] = nrirqs - nr_read_queues;
@@ -2048,7 +2040,7 @@ static int nvme_setup_irqs(struct nvme_dev *dev, unsigned int nr_io_queues)
 	 * Poll queues don't need interrupts, but we need at least one IO
 	 * queue left over for non-polled IO.
 	 */
-	this_p_queues = poll_queues;
+	this_p_queues = dev->nr_poll_queues;
 	if (this_p_queues >= nr_io_queues) {
 		this_p_queues = nr_io_queues - 1;
 		irq_queues = 1;
@@ -2078,14 +2070,25 @@ static void nvme_disable_io_queues(struct nvme_dev *dev)
 		__nvme_disable_io_queues(dev, nvme_admin_delete_cq);
 }
 
+static unsigned int nvme_max_io_queues(struct nvme_dev *dev)
+{
+	return num_possible_cpus() + dev->nr_write_queues + dev->nr_poll_queues;
+}
+
 static int nvme_setup_io_queues(struct nvme_dev *dev)
 {
 	struct nvme_queue *adminq = &dev->queues[0];
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
-	int result, nr_io_queues;
+	unsigned int nr_io_queues;
 	unsigned long size;
+	int result;
 
-	nr_io_queues = max_io_queues();
+	/*
+	 * Sample the module parameters once at reset time so that we have
+	 * stable values to work with.
+	 */
+	dev->nr_write_queues = write_queues;
+	dev->nr_poll_queues = poll_queues;
 
 	/*
 	 * If tags are shared with admin queue (Apple bug), then
@@ -2093,6 +2096,9 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	 */
 	if (dev->ctrl.quirks & NVME_QUIRK_SHARED_TAGS)
 		nr_io_queues = 1;
+	else
+		nr_io_queues = min(nvme_max_io_queues(dev),
+				   dev->nr_allocated_queues - 1);
 
 	result = nvme_set_queue_count(&dev->ctrl, &nr_io_queues);
 	if (result < 0)
@@ -2767,8 +2773,11 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!dev)
 		return -ENOMEM;
 
-	dev->queues = kcalloc_node(max_queue_count(), sizeof(struct nvme_queue),
-					GFP_KERNEL, node);
+	dev->nr_write_queues = write_queues;
+	dev->nr_poll_queues = poll_queues;
+	dev->nr_allocated_queues = nvme_max_io_queues(dev) + 1;
+	dev->queues = kcalloc_node(dev->nr_allocated_queues,
+			sizeof(struct nvme_queue), GFP_KERNEL, node);
 	if (!dev->queues)
 		goto free;
 
-- 
2.25.1



