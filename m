Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64062406134
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhIJAmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230503AbhIJARo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D4D6611EE;
        Fri, 10 Sep 2021 00:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232994;
        bh=pO3cZk/qu+va4WOknDmg62hwhItUv5OQI6cSR4L3bA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfLqT8JOnyZxQ6JIEho2d1y4P2vsx036z6+Bh3+XlPnCp+cSrzbPN1m629R4duuDv
         UymSYmH0raa6fRCHFxI8W1BibqLlF47NkU07VaofwPSmTIA6p2Cx6wqpMNaOeQvTvQ
         itSmMLmcOXdafwh2XzR6whsLftGi+Zip/60FOHEKt10y510NvZ91Sc63PlgaRXWSU6
         JyNOegRYR2Yw1BdESyql4uhOJUXf3a4/lMHXMp52jE+s31cbqz7cWJD3q5Z9UtQIZx
         D3DQewlRdBz8c4x+gWRUHBwSJq9GO95EUYp5dUPiHssWxla/kcj31lwKJ9zL3RcXIq
         IcQTlWje05EAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Jiajun Cao <caojiajun@vmware.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 26/99] iommu/amd: Sync once for scatter-gather operations
Date:   Thu,  9 Sep 2021 20:14:45 -0400
Message-Id: <20210910001558.173296-26-sashal@kernel.org>
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

From: Nadav Amit <namit@vmware.com>

[ Upstream commit 3b122a5666cb7c0bb9a439fba0c9a6cf59f999c3 ]

On virtual machines, software must flush the IOTLB after each page table
entry update.

The iommu_map_sg() code iterates through the given scatter-gather list
and invokes iommu_map() for each element in the scatter-gather list,
which calls into the vendor IOMMU driver through iommu_ops callback. As
the result, a single sg mapping may lead to multiple IOTLB flushes.

Fix this by adding amd_iotlb_sync_map() callback and flushing at this
point after all sg mappings we set.

This commit is followed and inspired by commit 933fcd01e97e2
("iommu/vt-d: Add iotlb_sync_map callback").

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Jiajun Cao <caojiajun@vmware.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Nadav Amit <namit@vmware.com>
Link: https://lore.kernel.org/r/20210723093209.714328-7-namit@vmware.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a7d6d78147b7..e0cd6e42d349 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2028,6 +2028,16 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	return ret;
 }
 
+static void amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
+				     unsigned long iova, size_t size)
+{
+	struct protection_domain *domain = to_pdomain(dom);
+	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
+
+	if (ops->map)
+		domain_flush_np_cache(domain, iova, size);
+}
+
 static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
 			 phys_addr_t paddr, size_t page_size, int iommu_prot,
 			 gfp_t gfp)
@@ -2046,10 +2056,8 @@ static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
 	if (iommu_prot & IOMMU_WRITE)
 		prot |= IOMMU_PROT_IW;
 
-	if (ops->map) {
+	if (ops->map)
 		ret = ops->map(ops, iova, paddr, page_size, prot, gfp);
-		domain_flush_np_cache(domain, iova, page_size);
-	}
 
 	return ret;
 }
@@ -2197,6 +2205,7 @@ const struct iommu_ops amd_iommu_ops = {
 	.attach_dev = amd_iommu_attach_device,
 	.detach_dev = amd_iommu_detach_device,
 	.map = amd_iommu_map,
+	.iotlb_sync_map	= amd_iommu_iotlb_sync_map,
 	.unmap = amd_iommu_unmap,
 	.iova_to_phys = amd_iommu_iova_to_phys,
 	.probe_device = amd_iommu_probe_device,
-- 
2.30.2

