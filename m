Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935872FC1E5
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 22:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387746AbhASStF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 13:49:05 -0500
Received: from verein.lst.de ([213.95.11.211]:52920 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390680AbhASSBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 13:01:09 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8D84068B02; Tue, 19 Jan 2021 19:00:24 +0100 (CET)
Date:   Tue, 19 Jan 2021 19:00:24 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Marc Orr <marcorr@google.com>
Cc:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        jxgao@google.com, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] nvme: fix handling mapping failure
Message-ID: <20210119180024.GA28024@lst.de>
References: <20210119175336.4016923-1-marcorr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119175336.4016923-1-marcorr@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 09:53:36AM -0800, Marc Orr wrote:
> This patch ensures that when `nvme_map_data()` fails to map the
> addresses in a scatter/gather list:
> 
> * The addresses are not incorrectly unmapped. The underlying
> scatter/gather code unmaps the addresses after detecting a failure.
> Thus, unmapping them again in the driver is a bug.
> * The DMA pool allocations are not deallocated when they were never
> allocated.
> 
> The bug that motivated this patch was the following sequence, which
> occurred within the NVMe driver, with the kernel flag `swiotlb=force`.
> 
> * NVMe driver calls dma_direct_map_sg()
> * dma_direct_map_sg() fails part way through the scatter gather/list
> * dma_direct_map_sg() calls dma_direct_unmap_sg() to unmap any entries
>   succeeded.
> * NVMe driver calls dma_direct_unmap_sg(), redundantly, leading to a
>   double unmap, which is a bug.
> 
> Before this patch, I observed intermittent application- and VM-level
> failures when running a benchmark, fio, in an AMD SEV guest. This patch
> resolves the failures.

I think the right way to fix this is to just do a proper unwind insted
of calling a catchall function.  Can you try this patch?

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 25456d02eddb8c..47d7075053b6b2 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -842,7 +842,7 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 	sg_init_table(iod->sg, blk_rq_nr_phys_segments(req));
 	iod->nents = blk_rq_map_sg(req->q, req, iod->sg);
 	if (!iod->nents)
-		goto out;
+		goto out_free_sg;
 
 	if (is_pci_p2pdma_page(sg_page(iod->sg)))
 		nr_mapped = pci_p2pdma_map_sg_attrs(dev->dev, iod->sg,
@@ -851,16 +851,25 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 		nr_mapped = dma_map_sg_attrs(dev->dev, iod->sg, iod->nents,
 					     rq_dma_dir(req), DMA_ATTR_NO_WARN);
 	if (!nr_mapped)
-		goto out;
+		goto out_free_sg;
 
 	iod->use_sgl = nvme_pci_use_sgls(dev, req);
 	if (iod->use_sgl)
 		ret = nvme_pci_setup_sgls(dev, req, &cmnd->rw, nr_mapped);
 	else
 		ret = nvme_pci_setup_prps(dev, req, &cmnd->rw);
-out:
 	if (ret != BLK_STS_OK)
-		nvme_unmap_data(dev, req);
+		goto out_dma_unmap;
+	return BLK_STS_OK;
+
+out_dma_unmap:
+	if (is_pci_p2pdma_page(sg_page(iod->sg)))
+		pci_p2pdma_unmap_sg(dev->dev, iod->sg, iod->nents,
+				    rq_dma_dir(req));
+	else
+		dma_unmap_sg(dev->dev, iod->sg, iod->nents, rq_dma_dir(req));
+out_free_sg:
+	mempool_free(iod->sg, dev->iod_mempool);
 	return ret;
 }
 
