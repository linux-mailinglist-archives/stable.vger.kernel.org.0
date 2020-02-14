Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6BB15F497
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgBNPtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:49:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729987AbgBNPtc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC609217F4;
        Fri, 14 Feb 2020 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695371;
        bh=EH0AaaBxidM6w52kyxw8SmOZ2SPi6FAU5ED1YOkX3CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xT3U7hlF8bRC0E5nM/2LiJ1VcEu4lk+OgFs0VaVjn116fykb84BI3/r3c+PMC0c1Z
         WDjFK6qMzoFAu9cbXBDKKU0nfahX6fzRmXpNiiSy0MZnTxjV/javZbfJzKBnJeT914
         cHGKEhTiVZwDlv3R9uvETbhT6fEKBNkvKMVBuWYs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Sewart <jamessewart@arista.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 028/542] PCI: Fix pci_add_dma_alias() bitmask size
Date:   Fri, 14 Feb 2020 10:40:20 -0500
Message-Id: <20200214154854.6746-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Sewart <jamessewart@arista.com>

[ Upstream commit f8bf2aeb651b3460a4b36fd7ba1ba1d31777d35c ]

The number of possible devfns is 256, but pci_add_dma_alias() allocated a
bitmap of size 255.  Fix this off-by-one error.

This fixes commits 338c3149a221 ("PCI: Add support for multiple DMA
aliases") and c6635792737b ("PCI: Allocate dma_alias_mask with
bitmap_zalloc()"), but I doubt it was possible to see a problem because
it takes 4 64-bit longs (or 8 32-bit longs) to hold 255 bits, and
bitmap_zalloc() doesn't save the 255-bit size anywhere.

[bhelgaas: commit log, move #define to drivers/pci/pci.h, include loop
limit fix from Qian Cai:
https://lore.kernel.org/r/20191218170004.5297-1-cai@lca.pw]
Signed-off-by: James Sewart <jamessewart@arista.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c    | 2 +-
 drivers/pci/pci.h    | 3 +++
 drivers/pci/search.c | 4 ++--
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e87196cc1a7fb..7b5fa2eabe095 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6017,7 +6017,7 @@ EXPORT_SYMBOL_GPL(pci_pr3_present);
 void pci_add_dma_alias(struct pci_dev *dev, u8 devfn)
 {
 	if (!dev->dma_alias_mask)
-		dev->dma_alias_mask = bitmap_zalloc(U8_MAX, GFP_KERNEL);
+		dev->dma_alias_mask = bitmap_zalloc(MAX_NR_DEVFNS, GFP_KERNEL);
 	if (!dev->dma_alias_mask) {
 		pci_warn(dev, "Unable to allocate DMA alias mask\n");
 		return;
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index a0a53bd05a0b8..6394e7746fb54 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -4,6 +4,9 @@
 
 #include <linux/pci.h>
 
+/* Number of possible devfns: 0.0 to 1f.7 inclusive */
+#define MAX_NR_DEVFNS 256
+
 #define PCI_FIND_CAP_TTL	48
 
 #define PCI_VSEC_ID_INTEL_TBT	0x1234	/* Thunderbolt */
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index bade14002fd8a..e4dbdef5aef05 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -41,9 +41,9 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 	 * DMA, iterate over that too.
 	 */
 	if (unlikely(pdev->dma_alias_mask)) {
-		u8 devfn;
+		unsigned int devfn;
 
-		for_each_set_bit(devfn, pdev->dma_alias_mask, U8_MAX) {
+		for_each_set_bit(devfn, pdev->dma_alias_mask, MAX_NR_DEVFNS) {
 			ret = fn(pdev, PCI_DEVID(pdev->bus->number, devfn),
 				 data);
 			if (ret)
-- 
2.20.1

