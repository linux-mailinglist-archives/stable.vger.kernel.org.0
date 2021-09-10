Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875AF4061A3
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240930AbhIJAnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232659AbhIJATD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A076611CB;
        Fri, 10 Sep 2021 00:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233067;
        bh=b5h1dwTTieFwPf786YZtojqkIfHbdY83JOwPANYLZSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JN6ExhPxw3/HxdnHGhVAWraSAdHEUG0cr5VQ7qA8Z0dZjuSDXbMJRq5QOLp1O2bkc
         212l9u41eBHLQRvio7MlOkjw2Ry+9G8joPEMqKPiU0q+LZ/nlohB2Ioyjq26vpSMKo
         o0y2IAt7lw/+3t2fgLWr/gaEyxVtp2aVzz8gCg8MPNk70GjizYQtJsTI8ZkvmR8zOD
         xyyyJqp7d047904ltUsJvBcN2JDWI5He8j2z7CUZjay1BYjM+lqSy/Da93Ad7gJb76
         ABiIha6io0mW88u9mt917nyYaqbvxamvQRLAD7UB0bbRmJfxPeWFrqQy/sFQ4VlsMW
         HOP7DaC0EwXWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonardo Bras <leobras.c@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.14 78/99] powerpc/pseries/iommu: Allow DDW windows starting at 0x00
Date:   Thu,  9 Sep 2021 20:15:37 -0400
Message-Id: <20210910001558.173296-78-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonardo Bras <leobras.c@gmail.com>

[ Upstream commit 2ca73c54ce24489518a56d816331b774044c2445 ]

enable_ddw() currently returns the address of the DMA window, which is
considered invalid if has the value 0x00.

Also, it only considers valid an address returned from find_existing_ddw
if it's not 0x00.

Changing this behavior makes sense, given the users of enable_ddw() only
need to know if direct mapping is possible. It can also allow a DMA window
starting at 0x00 to be used.

This will be helpful for using a DDW with indirect mapping, as the window
address will be different than 0x00, but it will not map the whole
partition.

Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210817063929.38701-6-leobras.c@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/iommu.c | 36 +++++++++++++-------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 0c55b991f665..a189178ca8e0 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -843,25 +843,26 @@ static void remove_ddw(struct device_node *np, bool remove_prop)
 			np, ret);
 }
 
-static u64 find_existing_ddw(struct device_node *pdn, int *window_shift)
+static bool find_existing_ddw(struct device_node *pdn, u64 *dma_addr, int *window_shift)
 {
 	struct direct_window *window;
 	const struct dynamic_dma_window_prop *direct64;
-	u64 dma_addr = 0;
+	bool found = false;
 
 	spin_lock(&direct_window_list_lock);
 	/* check if we already created a window and dupe that config if so */
 	list_for_each_entry(window, &direct_window_list, list) {
 		if (window->device == pdn) {
 			direct64 = window->prop;
-			dma_addr = be64_to_cpu(direct64->dma_base);
+			*dma_addr = be64_to_cpu(direct64->dma_base);
 			*window_shift = be32_to_cpu(direct64->window_shift);
+			found = true;
 			break;
 		}
 	}
 	spin_unlock(&direct_window_list_lock);
 
-	return dma_addr;
+	return found;
 }
 
 static int find_existing_ddw_windows(void)
@@ -1139,20 +1140,20 @@ static int iommu_get_page_shift(u32 query_page_size)
  * pdn: the parent pe node with the ibm,dma_window property
  * Future: also check if we can remap the base window for our base page size
  *
- * returns the dma offset for use by the direct mapped DMA code.
+ * returns true if can map all pages (direct mapping), false otherwise..
  */
-static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
+static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 {
 	int len = 0, ret;
 	int max_ram_len = order_base_2(ddw_memory_hotplug_max());
 	struct ddw_query_response query;
 	struct ddw_create_response create;
 	int page_shift;
-	u64 dma_addr;
 	struct device_node *dn;
 	u32 ddw_avail[DDW_APPLICABLE_SIZE];
 	struct direct_window *window;
 	struct property *win64;
+	bool ddw_enabled = false;
 	struct dynamic_dma_window_prop *ddwprop;
 	struct failed_ddw_pdn *fpdn;
 	bool default_win_removed = false;
@@ -1164,9 +1165,10 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 
 	mutex_lock(&direct_window_init_mutex);
 
-	dma_addr = find_existing_ddw(pdn, &len);
-	if (dma_addr != 0)
+	if (find_existing_ddw(pdn, &dev->dev.archdata.dma_offset, &len)) {
+		ddw_enabled = true;
 		goto out_unlock;
+	}
 
 	/*
 	 * If we already went through this for a previous function of
@@ -1322,7 +1324,8 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	list_add(&window->list, &direct_window_list);
 	spin_unlock(&direct_window_list_lock);
 
-	dma_addr = be64_to_cpu(ddwprop->dma_base);
+	dev->dev.archdata.dma_offset = be64_to_cpu(ddwprop->dma_base);
+	ddw_enabled = true;
 	goto out_unlock;
 
 out_free_window:
@@ -1354,10 +1357,10 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	 * as RAM, then we failed to create a window to cover persistent
 	 * memory and need to set the DMA limit.
 	 */
-	if (pmem_present && dma_addr && (len == max_ram_len))
-		dev->dev.bus_dma_limit = dma_addr + (1ULL << len);
+	if (pmem_present && ddw_enabled && (len == max_ram_len))
+		dev->dev.bus_dma_limit = dev->dev.archdata.dma_offset + (1ULL << len);
 
-	return dma_addr;
+	return ddw_enabled;
 }
 
 static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
@@ -1436,11 +1439,8 @@ static bool iommu_bypass_supported_pSeriesLP(struct pci_dev *pdev, u64 dma_mask)
 			break;
 	}
 
-	if (pdn && PCI_DN(pdn)) {
-		pdev->dev.archdata.dma_offset = enable_ddw(pdev, pdn);
-		if (pdev->dev.archdata.dma_offset)
-			return true;
-	}
+	if (pdn && PCI_DN(pdn))
+		return enable_ddw(pdev, pdn);
 
 	return false;
 }
-- 
2.30.2

