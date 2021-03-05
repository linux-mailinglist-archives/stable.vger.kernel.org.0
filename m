Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B7732E9A5
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhCEMd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:33:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232284AbhCEMdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:33:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E539F65031;
        Fri,  5 Mar 2021 12:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947617;
        bh=BJ47TRwlWXvFhRCoo7kohcLGde2zATmuhBKPLUtphMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HF2A8667LIBkgygSPF5YKyVI/ZV68kiu2jxf/b7+MRftEatnZmFxd+JxHNkcIL52R
         rXYduDmmby1+FwF3VhsYY5TulggbhhUJyJoAZrreCt19+nSLyR8vEILl+tEB+FJZyo
         M7YkSVYy3IoGZwBMsiJJJQ4xJ3FCsR/CIAnwrVcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, Marc Orr <marcorr@google.com>
Subject: [PATCH 5.4 03/72] nvme-pci: refactor nvme_unmap_data
Date:   Fri,  5 Mar 2021 13:21:05 +0100
Message-Id: <20210305120857.514738570@linuxfoundation.org>
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

commit 9275c206f88e5c49cb3e71932c81c8561083db9e upstream.

Split out three helpers from nvme_unmap_data that will allow finer grained
unwinding from nvme_map_data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |   77 ++++++++++++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 28 deletions(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -528,50 +528,71 @@ static inline bool nvme_pci_use_sgls(str
 	return true;
 }
 
-static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
+static void nvme_free_prps(struct nvme_dev *dev, struct request *req)
 {
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	const int last_prp = dev->ctrl.page_size / sizeof(__le64) - 1;
-	dma_addr_t dma_addr = iod->first_dma, next_dma_addr;
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	dma_addr_t dma_addr = iod->first_dma;
 	int i;
 
-	if (iod->dma_len) {
-		dma_unmap_page(dev->dev, dma_addr, iod->dma_len,
-			       rq_dma_dir(req));
-		return;
+	for (i = 0; i < iod->npages; i++) {
+		__le64 *prp_list = nvme_pci_iod_list(req)[i];
+		dma_addr_t next_dma_addr = le64_to_cpu(prp_list[last_prp]);
+
+		dma_pool_free(dev->prp_page_pool, prp_list, dma_addr);
+		dma_addr = next_dma_addr;
 	}
 
-	WARN_ON_ONCE(!iod->nents);
+}
 
-	if (is_pci_p2pdma_page(sg_page(iod->sg)))
-		pci_p2pdma_unmap_sg(dev->dev, iod->sg, iod->nents,
-				    rq_dma_dir(req));
-	else
-		dma_unmap_sg(dev->dev, iod->sg, iod->nents, rq_dma_dir(req));
+static void nvme_free_sgls(struct nvme_dev *dev, struct request *req)
+{
+	const int last_sg = SGES_PER_PAGE - 1;
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	dma_addr_t dma_addr = iod->first_dma;
+	int i;
 
+	for (i = 0; i < iod->npages; i++) {
+		struct nvme_sgl_desc *sg_list = nvme_pci_iod_list(req)[i];
+		dma_addr_t next_dma_addr = le64_to_cpu((sg_list[last_sg]).addr);
 
-	if (iod->npages == 0)
-		dma_pool_free(dev->prp_small_pool, nvme_pci_iod_list(req)[0],
-			dma_addr);
+		dma_pool_free(dev->prp_page_pool, sg_list, dma_addr);
+		dma_addr = next_dma_addr;
+	}
 
-	for (i = 0; i < iod->npages; i++) {
-		void *addr = nvme_pci_iod_list(req)[i];
+}
 
-		if (iod->use_sgl) {
-			struct nvme_sgl_desc *sg_list = addr;
+static void nvme_unmap_sg(struct nvme_dev *dev, struct request *req)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
-			next_dma_addr =
-			    le64_to_cpu((sg_list[SGES_PER_PAGE - 1]).addr);
-		} else {
-			__le64 *prp_list = addr;
+	if (is_pci_p2pdma_page(sg_page(iod->sg)))
+		pci_p2pdma_unmap_sg(dev->dev, iod->sg, iod->nents,
+				    rq_dma_dir(req));
+	else
+		dma_unmap_sg(dev->dev, iod->sg, iod->nents, rq_dma_dir(req));
+}
 
-			next_dma_addr = le64_to_cpu(prp_list[last_prp]);
-		}
+static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
-		dma_pool_free(dev->prp_page_pool, addr, dma_addr);
-		dma_addr = next_dma_addr;
+	if (iod->dma_len) {
+		dma_unmap_page(dev->dev, iod->first_dma, iod->dma_len,
+			       rq_dma_dir(req));
+		return;
 	}
 
+	WARN_ON_ONCE(!iod->nents);
+
+	nvme_unmap_sg(dev, req);
+	if (iod->npages == 0)
+		dma_pool_free(dev->prp_small_pool, nvme_pci_iod_list(req)[0],
+			      iod->first_dma);
+	else if (iod->use_sgl)
+		nvme_free_sgls(dev, req);
+	else
+		nvme_free_prps(dev, req);
 	mempool_free(iod->sg, dev->iod_mempool);
 }
 


