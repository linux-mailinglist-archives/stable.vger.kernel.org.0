Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1164E6810A5
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236993AbjA3OFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237060AbjA3OFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:05:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2742D27999
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:05:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B56B161049
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA210C433EF;
        Mon, 30 Jan 2023 14:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087520;
        bh=IQsu13b3t6jWLILa8J93eMa3pjIvJq/R/Awrsr3saN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNJjIg+QqIUnhfbiE2vjQ39PTIbryLSXmMvvPoYo3BzN++ptVdC6O6kkeCCoj6wKw
         S9S6Ilddg37jXIGMa0vemqDqlzouZaKTDGlmpcickUf/Zs+T1gw5bBZJERJIWVHPbR
         5NNS+gu1SZVVGJUGXA0m9SyHI4QeNoq31BGRJuSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Niklas Schnelle <schnelle@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/313] vfio/type1: Respect IOMMU reserved regions in vfio_test_domain_fgsp()
Date:   Mon, 30 Jan 2023 14:50:41 +0100
Message-Id: <20230130134346.282994490@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 895c0747f726bb50c9b7a805613a61d1b6f9fa06 ]

Since commit cbf7827bc5dc ("iommu/s390: Fix potential s390_domain
aperture shrinking") the s390 IOMMU driver uses reserved regions for the
system provided DMA ranges of PCI devices. Previously it reduced the
size of the IOMMU aperture and checked it on each mapping operation.
On current machines the system denies use of DMA addresses below 2^32 for
all PCI devices.

Usually mapping IOVAs in a reserved regions is harmless until a DMA
actually tries to utilize the mapping. However on s390 there is
a virtual PCI device called ISM which is implemented in firmware and
used for cross LPAR communication. Unlike real PCI devices this device
does not use the hardware IOMMU but inspects IOMMU translation tables
directly on IOTLB flush (s390 RPCIT instruction). If it detects IOVA
mappings outside the allowed ranges it goes into an error state. This
error state then causes the device to be unavailable to the KVM guest.

Analysing this we found that vfio_test_domain_fgsp() maps 2 pages at DMA
address 0 irrespective of the IOMMUs reserved regions. Even if usually
harmless this seems wrong in the general case so instead go through the
freshly updated IOVA list and try to find a range that isn't reserved,
and fits 2 pages, is PAGE_SIZE * 2 aligned. If found use that for
testing for fine grained super pages.

Fixes: af029169b8fd ("vfio/type1: Check reserved region conflict and update iova list")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20230110164427.4051938-2-schnelle@linux.ibm.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00..2209372f236d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1856,24 +1856,33 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
  * significantly boosts non-hugetlbfs mappings and doesn't seem to hurt when
  * hugetlbfs is in use.
  */
-static void vfio_test_domain_fgsp(struct vfio_domain *domain)
+static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *regions)
 {
-	struct page *pages;
 	int ret, order = get_order(PAGE_SIZE * 2);
+	struct vfio_iova *region;
+	struct page *pages;
+	dma_addr_t start;
 
 	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!pages)
 		return;
 
-	ret = iommu_map(domain->domain, 0, page_to_phys(pages), PAGE_SIZE * 2,
-			IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
-	if (!ret) {
-		size_t unmapped = iommu_unmap(domain->domain, 0, PAGE_SIZE);
+	list_for_each_entry(region, regions, list) {
+		start = ALIGN(region->start, PAGE_SIZE * 2);
+		if (start >= region->end || (region->end - start < PAGE_SIZE * 2))
+			continue;
 
-		if (unmapped == PAGE_SIZE)
-			iommu_unmap(domain->domain, PAGE_SIZE, PAGE_SIZE);
-		else
-			domain->fgsp = true;
+		ret = iommu_map(domain->domain, start, page_to_phys(pages), PAGE_SIZE * 2,
+				IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
+		if (!ret) {
+			size_t unmapped = iommu_unmap(domain->domain, start, PAGE_SIZE);
+
+			if (unmapped == PAGE_SIZE)
+				iommu_unmap(domain->domain, start + PAGE_SIZE, PAGE_SIZE);
+			else
+				domain->fgsp = true;
+		}
+		break;
 	}
 
 	__free_pages(pages, order);
@@ -2326,7 +2335,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		}
 	}
 
-	vfio_test_domain_fgsp(domain);
+	vfio_test_domain_fgsp(domain, &iova_copy);
 
 	/* replay mappings on new domains */
 	ret = vfio_iommu_replay(iommu, domain);
-- 
2.39.0



