Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96025EA210
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiIZLBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbiIZK7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:59:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A4E5D0E1;
        Mon, 26 Sep 2022 03:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2706060C56;
        Mon, 26 Sep 2022 10:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181C9C433B5;
        Mon, 26 Sep 2022 10:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188211;
        bh=CLQPjKouo+szHiGZCx0e3LIfv9sflmYRz1esK47oiKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJ0tVWyjw/3CqpXMIwUHDEoAnN4GVcKKDTr+fRSjhCABAP734FXTNEkRqiZ+NVQmz
         gKuPMV23HW6+n8FK1Y04JJV99S4IZAw/rmubX+52UemPVA4t/DhMzLzxVmZnDsQGnO
         osMBp8pEmQqphZEM5V2HZB7nSx6jmQFJd38lEznc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/141] scsi: mpt3sas: Force PCIe scatterlist allocations to be within same 4 GB region
Date:   Mon, 26 Sep 2022 12:11:42 +0200
Message-Id: <20220926100757.195193965@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

[ Upstream commit d6adc251dd2fede6aaaf6c39f7e4ad799eda3758 ]

According to the MPI specification, PCIe SGL buffers can not cross a 4 GB
boundary.

While allocating, if any buffer crosses the 4 GB boundary, then:

 - Release the already allocated memory pools; and

 - Reallocate them by changing the DMA coherent mask to 32-bit

Link: https://lore.kernel.org/r/20210305102904.7560-2-suganath-prabu.subramani@broadcom.com
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: e0e0747de0ea ("scsi: mpt3sas: Fix return value check of dma_get_required_mask()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 159 ++++++++++++++++++++--------
 drivers/scsi/mpt3sas/mpt3sas_base.h |   1 +
 2 files changed, 113 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 3153f164554a..18f85c963944 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2822,23 +2822,22 @@ static int
 _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 {
 	struct sysinfo s;
-	int dma_mask;
 
 	if (ioc->is_mcpu_endpoint ||
 	    sizeof(dma_addr_t) == 4 || ioc->use_32bit_dma ||
 	    dma_get_required_mask(&pdev->dev) <= 32)
-		dma_mask = 32;
+		ioc->dma_mask = 32;
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
 	else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)
-		dma_mask = 63;
+		ioc->dma_mask = 63;
 	else
-		dma_mask = 64;
+		ioc->dma_mask = 64;
 
-	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(dma_mask)) ||
-	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(dma_mask)))
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(ioc->dma_mask)) ||
+	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(ioc->dma_mask)))
 		return -ENODEV;
 
-	if (dma_mask > 32) {
+	if (ioc->dma_mask > 32) {
 		ioc->base_add_sg_single = &_base_add_sg_single_64;
 		ioc->sge_size = sizeof(Mpi2SGESimple64_t);
 	} else {
@@ -2848,7 +2847,7 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 
 	si_meminfo(&s);
 	ioc_info(ioc, "%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
-		dma_mask, convert_to_kb(s.totalram));
+		ioc->dma_mask, convert_to_kb(s.totalram));
 
 	return 0;
 }
@@ -4902,10 +4901,10 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 			dma_pool_free(ioc->pcie_sgl_dma_pool,
 					ioc->pcie_sg_lookup[i].pcie_sgl,
 					ioc->pcie_sg_lookup[i].pcie_sgl_dma);
+			ioc->pcie_sg_lookup[i].pcie_sgl = NULL;
 		}
 		dma_pool_destroy(ioc->pcie_sgl_dma_pool);
 	}
-
 	if (ioc->config_page) {
 		dexitprintk(ioc,
 			    ioc_info(ioc, "config_page(0x%p): free\n",
@@ -4960,6 +4959,89 @@ mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
 		return 0;
 }
 
+/**
+ * _base_reduce_hba_queue_depth- Retry with reduced queue depth
+ * @ioc: Adapter object
+ *
+ * Return: 0 for success, non-zero for failure.
+ **/
+static inline int
+_base_reduce_hba_queue_depth(struct MPT3SAS_ADAPTER *ioc)
+{
+	int reduce_sz = 64;
+
+	if ((ioc->hba_queue_depth - reduce_sz) >
+	    (ioc->internal_depth + INTERNAL_SCSIIO_CMDS_COUNT)) {
+		ioc->hba_queue_depth -= reduce_sz;
+		return 0;
+	} else
+		return -ENOMEM;
+}
+
+/**
+ * _base_allocate_pcie_sgl_pool - Allocating DMA'able memory
+ *			for pcie sgl pools.
+ * @ioc: Adapter object
+ * @sz: DMA Pool size
+ * @ct: Chain tracker
+ * Return: 0 for success, non-zero for failure.
+ */
+
+static int
+_base_allocate_pcie_sgl_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
+{
+	int i = 0, j = 0;
+	struct chain_tracker *ct;
+
+	ioc->pcie_sgl_dma_pool =
+	    dma_pool_create("PCIe SGL pool", &ioc->pdev->dev, sz,
+	    ioc->page_size, 0);
+	if (!ioc->pcie_sgl_dma_pool) {
+		ioc_err(ioc, "PCIe SGL pool: dma_pool_create failed\n");
+		return -ENOMEM;
+	}
+
+	ioc->chains_per_prp_buffer = sz/ioc->chain_segment_sz;
+	ioc->chains_per_prp_buffer =
+	    min(ioc->chains_per_prp_buffer, ioc->chains_needed_per_io);
+	for (i = 0; i < ioc->scsiio_depth; i++) {
+		ioc->pcie_sg_lookup[i].pcie_sgl =
+		    dma_pool_alloc(ioc->pcie_sgl_dma_pool, GFP_KERNEL,
+		    &ioc->pcie_sg_lookup[i].pcie_sgl_dma);
+		if (!ioc->pcie_sg_lookup[i].pcie_sgl) {
+			ioc_err(ioc, "PCIe SGL pool: dma_pool_alloc failed\n");
+			return -EAGAIN;
+		}
+
+		if (!mpt3sas_check_same_4gb_region(
+		    (long)ioc->pcie_sg_lookup[i].pcie_sgl, sz)) {
+			ioc_err(ioc, "PCIE SGLs are not in same 4G !! pcie sgl (0x%p) dma = (0x%llx)\n",
+			    ioc->pcie_sg_lookup[i].pcie_sgl,
+			    (unsigned long long)
+			    ioc->pcie_sg_lookup[i].pcie_sgl_dma);
+			ioc->use_32bit_dma = true;
+			return -EAGAIN;
+		}
+
+		for (j = 0; j < ioc->chains_per_prp_buffer; j++) {
+			ct = &ioc->chain_lookup[i].chains_per_smid[j];
+			ct->chain_buffer =
+			    ioc->pcie_sg_lookup[i].pcie_sgl +
+			    (j * ioc->chain_segment_sz);
+			ct->chain_buffer_dma =
+			    ioc->pcie_sg_lookup[i].pcie_sgl_dma +
+			    (j * ioc->chain_segment_sz);
+		}
+	}
+	dinitprintk(ioc, ioc_info(ioc,
+	    "PCIe sgl pool depth(%d), element_size(%d), pool_size(%d kB)\n",
+	    ioc->scsiio_depth, sz, (sz * ioc->scsiio_depth)/1024));
+	dinitprintk(ioc, ioc_info(ioc,
+	    "Number of chains can fit in a PRP page(%d)\n",
+	    ioc->chains_per_prp_buffer));
+	return 0;
+}
+
 /**
  * base_alloc_rdpq_dma_pool - Allocating DMA'able memory
  *                     for reply queues.
@@ -5058,7 +5140,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	unsigned short sg_tablesize;
 	u16 sge_size;
 	int i, j;
-	int ret = 0;
+	int ret = 0, rc = 0;
 	struct chain_tracker *ct;
 
 	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
@@ -5357,6 +5439,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	 * be required for NVMe PRP's, only each set of NVMe blocks will be
 	 * contiguous, so a new set is allocated for each possible I/O.
 	 */
+
 	ioc->chains_per_prp_buffer = 0;
 	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_NVME_DEVICES) {
 		nvme_blocks_needed =
@@ -5371,43 +5454,11 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 			goto out;
 		}
 		sz = nvme_blocks_needed * ioc->page_size;
-		ioc->pcie_sgl_dma_pool =
-			dma_pool_create("PCIe SGL pool", &ioc->pdev->dev, sz, 16, 0);
-		if (!ioc->pcie_sgl_dma_pool) {
-			ioc_info(ioc, "PCIe SGL pool: dma_pool_create failed\n");
-			goto out;
-		}
-
-		ioc->chains_per_prp_buffer = sz/ioc->chain_segment_sz;
-		ioc->chains_per_prp_buffer = min(ioc->chains_per_prp_buffer,
-						ioc->chains_needed_per_io);
-
-		for (i = 0; i < ioc->scsiio_depth; i++) {
-			ioc->pcie_sg_lookup[i].pcie_sgl = dma_pool_alloc(
-				ioc->pcie_sgl_dma_pool, GFP_KERNEL,
-				&ioc->pcie_sg_lookup[i].pcie_sgl_dma);
-			if (!ioc->pcie_sg_lookup[i].pcie_sgl) {
-				ioc_info(ioc, "PCIe SGL pool: dma_pool_alloc failed\n");
-				goto out;
-			}
-			for (j = 0; j < ioc->chains_per_prp_buffer; j++) {
-				ct = &ioc->chain_lookup[i].chains_per_smid[j];
-				ct->chain_buffer =
-				    ioc->pcie_sg_lookup[i].pcie_sgl +
-				    (j * ioc->chain_segment_sz);
-				ct->chain_buffer_dma =
-				    ioc->pcie_sg_lookup[i].pcie_sgl_dma +
-				    (j * ioc->chain_segment_sz);
-			}
-		}
-
-		dinitprintk(ioc,
-			    ioc_info(ioc, "PCIe sgl pool depth(%d), element_size(%d), pool_size(%d kB)\n",
-				     ioc->scsiio_depth, sz,
-				     (sz * ioc->scsiio_depth) / 1024));
-		dinitprintk(ioc,
-			    ioc_info(ioc, "Number of chains can fit in a PRP page(%d)\n",
-				     ioc->chains_per_prp_buffer));
+		rc = _base_allocate_pcie_sgl_pool(ioc, sz);
+		if (rc == -ENOMEM)
+			return -ENOMEM;
+		else if (rc == -EAGAIN)
+			goto try_32bit_dma;
 		total_sz += sz * ioc->scsiio_depth;
 	}
 
@@ -5577,6 +5628,19 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		 ioc->shost->sg_tablesize);
 	return 0;
 
+try_32bit_dma:
+	_base_release_memory_pools(ioc);
+	if (ioc->use_32bit_dma && (ioc->dma_mask > 32)) {
+		/* Change dma coherent mask to 32 bit and reallocate */
+		if (_base_config_dma_addressing(ioc, ioc->pdev) != 0) {
+			pr_err("Setting 32 bit coherent DMA mask Failed %s\n",
+			    pci_name(ioc->pdev));
+			return -ENODEV;
+		}
+	} else if (_base_reduce_hba_queue_depth(ioc) != 0)
+		return -ENOMEM;
+	goto retry_allocation;
+
  out:
 	return -ENOMEM;
 }
@@ -7239,6 +7303,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 
 	ioc->rdpq_array_enable_assigned = 0;
 	ioc->use_32bit_dma = false;
+	ioc->dma_mask = 64;
 	if (ioc->is_aero_ioc)
 		ioc->base_readl = &_base_readl_aero;
 	else
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index bc8beb10f3fc..823bbe64a477 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1257,6 +1257,7 @@ struct MPT3SAS_ADAPTER {
 	u16		thresh_hold;
 	u8		high_iops_queues;
 	u32		drv_support_bitmap;
+	u32             dma_mask;
 	bool		enable_sdev_max_qd;
 	bool		use_32bit_dma;
 
-- 
2.35.1



