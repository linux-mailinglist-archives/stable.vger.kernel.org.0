Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7998C32B228
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbhCCAwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344052AbhCBRkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 12:40:53 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AB7C06121E
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 09:39:33 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 6so23403336ybq.7
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 09:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IvcU72kyzl+dTsNEe1dtDRtwfa+sANJ7uN/5rgWi+VE=;
        b=tanWmZ0daUkhnlFd1Wz2mvpSifJBQ77dqOX267qv7NxfpALcFmrdmSeVXidrLCJcIk
         vLxIIOagBZoCOlbyGDAoD+dwDiB8SOhHjh7qhQkvpTQZ657I8EbmgKQP7aqPQdsy46YQ
         1AJprK1Nr51MMBdgHTTtThlte/1gHHwV+sz4zTEsj8b8petSG/gF7RE6q3OqsMu+lAwo
         KMQ2abixt7x8DN6JLiW6HCYXkATqcekTL8sOfX14UGOsou08l/x8l7cFn+pQBFISCKFW
         XPd+ojktOuW8polM4u8Crnq+KwEyjsgyYANao8G9lkvOzolQjLoIR1AZjLLc7t3EqOzl
         8KLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IvcU72kyzl+dTsNEe1dtDRtwfa+sANJ7uN/5rgWi+VE=;
        b=hiIoCBhaXLal5Ru8gVq1L4+Rw/yMmjZ1P5mc3Y3tbz3MTPd4YhUPbOSol/fi2Ctn6E
         F5U19dfNxgE5ctCyzhrcnVMCZXLV8UIrizx4Lsvj0p5oI3V5SWZtwecXi+NZoVveHEgf
         avzuaSZJxil1LbNHftsictf/lvZGDoV8gX62rRItg8/D2dUAe30IZcWBtVeNIn4IMXcK
         HxrPaL08uRoCnuXj6QG5zcp5+Ib6WBrYk660m7VQDM0fYPKoN7mGcePsryBcmN3YlKoD
         4mhYZWRla1cnqqDYeJQ2Y0/GmYkzkPNA3xp1MZR/5j1t9iwShQ+o01hdmiVVnRF7EAiu
         FHqw==
X-Gm-Message-State: AOAM533I+aUI9+BD2QMOr72s4TUWkROa5R5sDPbCWknZeUJlG4C3RJS0
        CEJg5RJBc2exMoENDm8M7dpic+fGBF+mJujAIm4JUf0c85vaWGcPqX+yETmdbRXoZQdQbHZd2og
        HKQZLKXPq2Dx6Xnl9OCJeD4GlabocXENZmhIgeWts350xaHDVSHNsy540cAHCujkg
X-Google-Smtp-Source: ABdhPJzwr2ny8gEk95WMzLEYwQflj/RX4f9B06UXOqJ/UGy0UpLBMfD+8vwi6SEhfBWbS6lTCk1pJqdbKMc0
Sender: "marcorr via sendgmr" <marcorr@marcorr-sp.c.googlers.com>
X-Received: from marcorr-sp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:e50])
 (user=marcorr job=sendgmr) by 2002:a25:2389:: with SMTP id
 j131mr33642338ybj.67.1614706773044; Tue, 02 Mar 2021 09:39:33 -0800 (PST)
Date:   Tue,  2 Mar 2021 17:39:11 +0000
In-Reply-To: <20210302173911.12044-1-marcorr@google.com>
Message-Id: <20210302173911.12044-2-marcorr@google.com>
Mime-Version: 1.0
References: <20210302173911.12044-1-marcorr@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 5.4 2/2] nvme-pci: fix error unwind in nvme_map_data
From:   Marc Orr <marcorr@google.com>
To:     stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Marc Orr <marcorr@google.com>,
        Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
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
---
 drivers/nvme/host/pci.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 90dc86132007..abc342db3b33 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -669,7 +669,7 @@ static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
 			__le64 *old_prp_list = prp_list;
 			prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
 			if (!prp_list)
-				return BLK_STS_RESOURCE;
+				goto free_prps;
 			list[iod->npages++] = prp_list;
 			prp_list[0] = old_prp_list[i - 1];
 			old_prp_list[i - 1] = cpu_to_le64(prp_dma);
@@ -689,14 +689,14 @@ static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
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
@@ -768,7 +768,7 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 
 			sg_list = dma_pool_alloc(pool, GFP_ATOMIC, &sgl_dma);
 			if (!sg_list)
-				return BLK_STS_RESOURCE;
+				goto free_sgls;
 
 			i = 0;
 			nvme_pci_iod_list(req)[iod->npages++] = sg_list;
@@ -781,6 +781,9 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 	} while (--entries > 0);
 
 	return BLK_STS_OK;
+free_sgls:
+	nvme_free_sgls(dev, req);
+	return BLK_STS_RESOURCE;
 }
 
 static blk_status_t nvme_setup_prp_simple(struct nvme_dev *dev,
@@ -849,7 +852,7 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 	sg_init_table(iod->sg, blk_rq_nr_phys_segments(req));
 	iod->nents = blk_rq_map_sg(req->q, req, iod->sg);
 	if (!iod->nents)
-		goto out;
+		goto out_free_sg;
 
 	if (is_pci_p2pdma_page(sg_page(iod->sg)))
 		nr_mapped = pci_p2pdma_map_sg_attrs(dev->dev, iod->sg,
@@ -858,16 +861,21 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
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
 
-- 
2.30.1.766.gb4fecdf3b7-goog

