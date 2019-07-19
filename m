Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B88F6DF4D
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfGSEBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729409AbfGSEBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:01:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 579B921873;
        Fri, 19 Jul 2019 04:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508884;
        bh=I17DrcFi7+urAICnpGho+Udc/SRWzTgx9Ys7b2roMz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tI87Xu24wtfN0JlayL0WoI+Ox7SvC9i+8npqGZ47T9MHdRQTf9+UJSQZZr7WUwP76
         7sSGMN5WQYwOtLym0WtD7GKZAeujPFvHpbk9oGnHrGwfSFJ3tREMmWrVmaUsoSjSuP
         WONVyeY94r9yPT20eV9yGEgj+6jdVMY8WbkjL4o4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Mikhak <alan.mikhak@sifive.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-nvme@lists.infradead.org, linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 135/171] nvme-pci: check for NULL return from pci_alloc_p2pmem()
Date:   Thu, 18 Jul 2019 23:56:06 -0400
Message-Id: <20190719035643.14300-135-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Mikhak <alan.mikhak@sifive.com>

[ Upstream commit bfac8e9f55cf62a000b643a0081488badbe92d96 ]

Modify nvme_alloc_sq_cmds() to call pci_free_p2pmem() to free the memory
it allocated using pci_alloc_p2pmem() in case pci_p2pmem_virt_to_bus()
returns null.

Makes sure not to call pci_free_p2pmem() if pci_alloc_p2pmem() returned
NULL, which can happen if CONFIG_PCI_P2PDMA is not configured.

The current implementation is not expected to leak since
pci_p2pmem_virt_to_bus() is expected to fail only if pci_alloc_p2pmem()
returns null. However, checking the return value of pci_alloc_p2pmem()
is more explicit.

Signed-off-by: Alan Mikhak <alan.mikhak@sifive.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 524d6bd6d095..5dfa067f6506 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1456,11 +1456,15 @@ static int nvme_alloc_sq_cmds(struct nvme_dev *dev, struct nvme_queue *nvmeq,
 
 	if (qid && dev->cmb_use_sqes && (dev->cmbsz & NVME_CMBSZ_SQS)) {
 		nvmeq->sq_cmds = pci_alloc_p2pmem(pdev, SQ_SIZE(depth));
-		nvmeq->sq_dma_addr = pci_p2pmem_virt_to_bus(pdev,
-						nvmeq->sq_cmds);
-		if (nvmeq->sq_dma_addr) {
-			set_bit(NVMEQ_SQ_CMB, &nvmeq->flags);
-			return 0; 
+		if (nvmeq->sq_cmds) {
+			nvmeq->sq_dma_addr = pci_p2pmem_virt_to_bus(pdev,
+							nvmeq->sq_cmds);
+			if (nvmeq->sq_dma_addr) {
+				set_bit(NVMEQ_SQ_CMB, &nvmeq->flags);
+				return 0;
+			}
+
+			pci_free_p2pmem(pdev, nvmeq->sq_cmds, SQ_SIZE(depth));
 		}
 	}
 
-- 
2.20.1

