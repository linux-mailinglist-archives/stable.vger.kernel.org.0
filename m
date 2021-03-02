Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8207832B21E
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241191AbhCCAwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343978AbhCBRkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 12:40:11 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5953AC06121D
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 09:39:30 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id q77so23415111ybq.0
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 09:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=2kGfAvKyVkw+dh3SbBOor4fSKz60nTkeOupR2omHaQY=;
        b=H/pVjHNX6DHeY2l7ihNS7/gAAV93fdgM9k+ezvRFKDASCvfKexsfMS5E0FRRWp8Lvc
         Bv2udFF3eMCd3O0VrTVmO4qh3mkjqIdZJ+vRj3rmpL/R5D7IWUOYTldxjnyPbTQaNgQH
         ZWsdZm5cMS6EtBMwQMAOt8FrOzYOhiMOnxanXDlfh5X1br45KDUOYyyZyX84IQkn2zxW
         iLJSBYktAWcbPYJFNN6Eu8OnDLts+sOb8YCXJK6c/tE30v4SE14korlXFd2zdv4e1Frb
         o03GxlVD0MiVImdnIp7FXn+Tv27/YnyesZqfo3X1WT7mxLmKAa9MmdJz/WPWVWrLRyss
         HAdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=2kGfAvKyVkw+dh3SbBOor4fSKz60nTkeOupR2omHaQY=;
        b=VVCWMJrGuHlrxe5FGktvifpHnGOedFPnAfyO2fcVty10cTVnCOP0lftQD9T3AvABm8
         sUKFx0APJG4Cd6z+SYkkR3BuG3wn1ihPPeJqR0WeurngUDnXkfW9rG+u6uS1Ef/AeXLl
         0VFZZKeD+Pu1QpeooSKNG9RVdWnwgawHk/2ZC0JhrpEC8tNyZdsnlHhzGMOWJV5OHU9H
         bevsw/OKjUGwCpUPLJX+OCk4QG0TFBNphYEmx8VYqEq4hG3lgqO+e/+SC6C0oJUcR/N4
         C1nqxlJ+V416ymy0SXZ1Cg2G18G720EWcrs4nyNN+i6mdIh7SihpJQ+6pHoetz99DtvH
         Oxkw==
X-Gm-Message-State: AOAM532gTFlsXcUeegOJpz2gm1oTYnbPlvvdGgzhquslHVIYyudk3uzv
        eD27mjrhxF5OweW9S25ntvKmLT/4P6fUmVcjGzrUFBJRfKPtt7vm5pQ8+LxHVhgrgv4nGfa1J7V
        ta+m9vPKaPrkZQZXBLefaaYJFfylXkCIBhuFZ9KyYkJah4wvkns71YybKQFOjY57u
X-Google-Smtp-Source: ABdhPJw09GA87fJB5L1me8I8jtPf4Zdlt3PDHmKOl3t3WpzqxEnow1ol/HmWDOBEcsrRpTnWB1alziK3CzOi
Sender: "marcorr via sendgmr" <marcorr@marcorr-sp.c.googlers.com>
X-Received: from marcorr-sp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:e50])
 (user=marcorr job=sendgmr) by 2002:a25:34d2:: with SMTP id
 b201mr34717490yba.149.1614706769546; Tue, 02 Mar 2021 09:39:29 -0800 (PST)
Date:   Tue,  2 Mar 2021 17:39:10 +0000
Message-Id: <20210302173911.12044-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 5.4 1/2] nvme-pci: refactor nvme_unmap_data
From:   Marc Orr <marcorr@google.com>
To:     stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
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
---
 drivers/nvme/host/pci.c | 77 ++++++++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 28 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 19e375b59f40..90dc86132007 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -528,50 +528,71 @@ static inline bool nvme_pci_use_sgls(struct nvme_dev *dev, struct request *req)
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
 
-- 
2.30.1.766.gb4fecdf3b7-goog

