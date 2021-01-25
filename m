Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D01304A67
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbhAZFF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731197AbhAYSzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 609762083E;
        Mon, 25 Jan 2021 18:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600895;
        bh=X5IxGU+IQ+S/Gbrs/YQ1+mIW3CpgFlKdrE3C2eg/RcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcbXfWJ/MCJJyE7gLZF1HVM25TvjuEC34MSt61nMKT6UOiv3XBuEQ5I5YpJ6FvVqG
         acpLvS+A6V47ZcA+lR6JyqQjFb6JJaUeziT3K5Gv8169StgtSLKO5Jj7UgzBhXXj+x
         RQZWt5h2rhHsCpTNoVdYUxEhdRh0328qW7oJ9xt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, Marc Orr <marcorr@google.com>
Subject: [PATCH 5.10 162/199] nvme-pci: refactor nvme_unmap_data
Date:   Mon, 25 Jan 2021 19:39:44 +0100
Message-Id: <20210125183223.038107852@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/pci.c |   77 ++++++++++++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 28 deletions(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -542,50 +542,71 @@ static inline bool nvme_pci_use_sgls(str
 	return true;
 }
 
-static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
+static void nvme_free_prps(struct nvme_dev *dev, struct request *req)
 {
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	const int last_prp = NVME_CTRL_PAGE_SIZE / sizeof(__le64) - 1;
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
 


