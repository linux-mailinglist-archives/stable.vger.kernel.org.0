Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22A2330E7C
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhCHMhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:37:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232575AbhCHMgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0544F651FF;
        Mon,  8 Mar 2021 12:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615207012;
        bh=nSwkGtqXxbaNJzl3yMxK22rFxlDcWC5cI9liDwoGRO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtoKoQ1hGwNrLWcRA8JP5i40JyAuaRwmVkhpRubRPQC637Skh8ZHCVEZniW7YVcWM
         0UfIRG9ZmPVfDVr1MYrVKKNzc/Nouq7kHf5hAO9BZIomwifcA0fpmfplD7Ylxeie9x
         4TfRyv0CqBYfv152ac+8FKi6C9T3/idFLeL1GcOc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 40/44] iommu: Dont use lazy flush for untrusted device
Date:   Mon,  8 Mar 2021 13:35:18 +0100
Message-Id: <20210308122720.509647152@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 82c3cefb9f1652e7470f442ff96c613e8c8ed8f4 ]

The lazy IOTLB flushing setup leaves a time window, in which the device
can still access some system memory, which has already been unmapped by
the device driver. It's not suitable for untrusted devices. A malicious
device might use this to attack the system by obtaining data that it
shouldn't obtain.

Fixes: c588072bba6b5 ("iommu/vt-d: Convert intel iommu driver to the iommu ops")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210225061454.2864009-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 4078358ed66e..00fbc591a142 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -309,6 +309,11 @@ static void iommu_dma_flush_iotlb_all(struct iova_domain *iovad)
 	domain->ops->flush_iotlb_all(domain);
 }
 
+static bool dev_is_untrusted(struct device *dev)
+{
+	return dev_is_pci(dev) && to_pci_dev(dev)->untrusted;
+}
+
 /**
  * iommu_dma_init_domain - Initialise a DMA mapping domain
  * @domain: IOMMU domain previously prepared by iommu_get_dma_cookie()
@@ -363,8 +368,9 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, dma_addr_t base,
 
 	init_iova_domain(iovad, 1UL << order, base_pfn);
 
-	if (!cookie->fq_domain && !iommu_domain_get_attr(domain,
-			DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE, &attr) && attr) {
+	if (!cookie->fq_domain && (!dev || !dev_is_untrusted(dev)) &&
+	    !iommu_domain_get_attr(domain, DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE, &attr) &&
+	    attr) {
 		if (init_iova_flush_queue(iovad, iommu_dma_flush_iotlb_all,
 					  iommu_dma_entry_dtor))
 			pr_warn("iova flush queue initialization failed\n");
@@ -521,11 +527,6 @@ static void __iommu_dma_unmap_swiotlb(struct device *dev, dma_addr_t dma_addr,
 				iova_align(iovad, size), dir, attrs);
 }
 
-static bool dev_is_untrusted(struct device *dev)
-{
-	return dev_is_pci(dev) && to_pci_dev(dev)->untrusted;
-}
-
 static dma_addr_t __iommu_dma_map(struct device *dev, phys_addr_t phys,
 		size_t size, int prot, u64 dma_mask)
 {
-- 
2.30.1



