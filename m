Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2926316770E
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbgBUICA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:02:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731289AbgBUICA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:02:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C76E2073A;
        Fri, 21 Feb 2020 08:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272119;
        bh=ZcUzQxygeVJz1o5yxME7aj3M2UwDiUg43GIMxLnHJpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uy1CT9BLBXGu7qxVq/n/+/IrumgCjgAatdKk5SSyBPFiZ6QwDCV9dea5+PDC5U9re
         vRj4wFBQxDfymT67UXi3Z8QcsKJwgf97eXaxTpZGOqqeO+StVaMFGQeagBFr5DsCC4
         Zi/eUWdJay3fd8DhoKwDPMfh5fJGRgYxuDBmQqaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Sewart <jamessewart@arista.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/344] PCI: Fix pci_add_dma_alias() bitmask size
Date:   Fri, 21 Feb 2020 08:37:02 +0100
Message-Id: <20200221072351.297453692@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fcfaadc774eef..cbf3d3889874c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5894,7 +5894,7 @@ EXPORT_SYMBOL_GPL(pci_pr3_present);
 void pci_add_dma_alias(struct pci_dev *dev, u8 devfn)
 {
 	if (!dev->dma_alias_mask)
-		dev->dma_alias_mask = bitmap_zalloc(U8_MAX, GFP_KERNEL);
+		dev->dma_alias_mask = bitmap_zalloc(MAX_NR_DEVFNS, GFP_KERNEL);
 	if (!dev->dma_alias_mask) {
 		pci_warn(dev, "Unable to allocate DMA alias mask\n");
 		return;
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 3f6947ee3324a..273d60cb0762d 100644
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



