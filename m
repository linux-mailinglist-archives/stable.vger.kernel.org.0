Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1471732E9A4
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhCEMd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:33:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232303AbhCEMdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:33:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E059E64FF0;
        Fri,  5 Mar 2021 12:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947620;
        bh=AYD7lT8NOqoxSWvQRSKkgHmHefTvjStFX2wP4KVh2Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wtq28COBgqp96eDeR+XNJcQ5Fjs8BcvKCMBrAT7EusDpEt1rJYKO+En3PSfzVv+ev
         Ofv7vpsc1igsnlxf6adlUwnhjQjB1Jw9tT1OQ6eyZqTTwi2Db36beYyvNB/VYCmVz0
         TZ6rz5ppkLYMmCC8dCCnoEueWF/qdl+zvq6ZQiqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Orr <marcorr@google.com>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.4 04/72] nvme-pci: fix error unwind in nvme_map_data
Date:   Fri,  5 Mar 2021 13:21:06 +0100
Message-Id: <20210305120857.565404685@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit fa0732168fa1369dd089e5b06d6158a68229f7b7 upstream.

Properly unwind step by step using refactored helpers from nvme_unmap_data
to avoid a potential double dma_unmap on a mapping failure.

Fixes: 7fe07d14f71f ("nvme-pci: merge nvme_free_iod into nvme_unmap_data")
Reported-by: Marc Orr <marcorr@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -669,7 +669,7 @@ static blk_status_t nvme_pci_setup_prps(
 			__le64 *old_prp_list = prp_list;
 			prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
 			if (!prp_list)
-				return BLK_STS_RESOURCE;
+				goto free_prps;
 			list[iod->npages++] = prp_list;
 			prp_list[0] = old_prp_list[i - 1];
 			old_prp_list[i - 1] = cpu_to_le64(prp_dma);
@@ -689,14 +689,14 @@ static blk_status_t nvme_pci_setup_prps(
 		dma_addr = sg_dma_address(sg);
 		dma_len = sg_dma_len(sg);
 	}
-
 done:
 	cmnd->dptr.prp1 = cpu_to_le64(sg_dma_address(iod->sg));
 	cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma);
-
 	return BLK_STS_OK;
-
- bad_sgl:
+free_prps:
+	nvme_free_prps(dev, req);
+	return BLK_STS_RESOURCE;
+bad_sgl:
 	WARN(DO_ONCE(nvme_print_sgl, iod->sg, iod->nents),
 			"Invalid SGL for payload:%d nents:%d\n",
 			blk_rq_payload_bytes(req), iod->nents);
@@ -768,7 +768,7 @@ static blk_status_t nvme_pci_setup_sgls(
 
 			sg_list = dma_pool_alloc(pool, GFP_ATOMIC, &sgl_dma);
 			if (!sg_list)
-				return BLK_STS_RESOURCE;
+				goto free_sgls;
 
 			i = 0;
 			nvme_pci_iod_list(req)[iod->npages++] = sg_list;
@@ -781,6 +781,9 @@ static blk_status_t nvme_pci_setup_sgls(
 	} while (--entries > 0);
 
 	return BLK_STS_OK;
+free_sgls:
+	nvme_free_sgls(dev, req);
+	return BLK_STS_RESOURCE;
 }
 
 static blk_status_t nvme_setup_prp_simple(struct nvme_dev *dev,
@@ -849,7 +852,7 @@ static blk_status_t nvme_map_data(struct
 	sg_init_table(iod->sg, blk_rq_nr_phys_segments(req));
 	iod->nents = blk_rq_map_sg(req->q, req, iod->sg);
 	if (!iod->nents)
-		goto out;
+		goto out_free_sg;
 
 	if (is_pci_p2pdma_page(sg_page(iod->sg)))
 		nr_mapped = pci_p2pdma_map_sg_attrs(dev->dev, iod->sg,
@@ -858,16 +861,21 @@ static blk_status_t nvme_map_data(struct
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
+		goto out_unmap_sg;
+	return BLK_STS_OK;
+
+out_unmap_sg:
+	nvme_unmap_sg(dev, req);
+out_free_sg:
+	mempool_free(iod->sg, dev->iod_mempool);
 	return ret;
 }
 


