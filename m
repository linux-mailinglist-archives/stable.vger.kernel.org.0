Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC6724F978
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgHXJpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbgHXImj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:42:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27D262074D;
        Mon, 24 Aug 2020 08:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258558;
        bh=8F8FTkw1me5mQVKEojIkOg3nYF6zXiP47ek1mH2mp4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1Q4AMz/J+t+HXR7rASFne3M+xJoxHnEuZ5xBxsDJfFmKIJO0nJawHoVzRngHqHU/
         aPltXRsvAgXaKw0kzThvdmrXIf5Sm3wUT+A1pmQ/j8UrzedD96HxPqeA08QBD+PHoF
         xMXVgPXXG0cF8weliylL2QK7cgeXAMPWr7uNfFbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhiyi Guo <zhguo@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 088/124] vfio/type1: Add proper error unwind for vfio_iommu_replay()
Date:   Mon, 24 Aug 2020 10:30:22 +0200
Message-Id: <20200824082413.745072744@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit aae7a75a821a793ed6b8ad502a5890fb8e8f172d ]

The vfio_iommu_replay() function does not currently unwind on error,
yet it does pin pages, perform IOMMU mapping, and modify the vfio_dma
structure to indicate IOMMU mapping.  The IOMMU mappings are torn down
when the domain is destroyed, but the other actions go on to cause
trouble later.  For example, the iommu->domain_list can be empty if we
only have a non-IOMMU backed mdev attached.  We don't currently check
if the list is empty before getting the first entry in the list, which
leads to a bogus domain pointer.  If a vfio_dma entry is erroneously
marked as iommu_mapped, we'll attempt to use that bogus pointer to
retrieve the existing physical page addresses.

This is the scenario that uncovered this issue, attempting to hot-add
a vfio-pci device to a container with an existing mdev device and DMA
mappings, one of which could not be pinned, causing a failure adding
the new group to the existing container and setting the conditions
for a subsequent attempt to explode.

To resolve this, we can first check if the domain_list is empty so
that we can reject replay of a bogus domain, should we ever encounter
this inconsistent state again in the future.  The real fix though is
to add the necessary unwind support, which means cleaning up the
current pinning if an IOMMU mapping fails, then walking back through
the r-b tree of DMA entries, reading from the IOMMU which ranges are
mapped, and unmapping and unpinning those ranges.  To be able to do
this, we also defer marking the DMA entry as IOMMU mapped until all
entries are processed, in order to allow the unwind to know the
disposition of each entry.

Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
Reported-by: Zhiyi Guo <zhguo@redhat.com>
Tested-by: Zhiyi Guo <zhguo@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 71 ++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index cc1d64765ce79..c244e0ecf9f42 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1149,13 +1149,16 @@ static int vfio_bus_type(struct device *dev, void *data)
 static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			     struct vfio_domain *domain)
 {
-	struct vfio_domain *d;
+	struct vfio_domain *d = NULL;
 	struct rb_node *n;
 	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	int ret;
 
 	/* Arbitrarily pick the first domain in the list for lookups */
-	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
+	if (!list_empty(&iommu->domain_list))
+		d = list_first_entry(&iommu->domain_list,
+				     struct vfio_domain, next);
+
 	n = rb_first(&iommu->dma_list);
 
 	for (; n; n = rb_next(n)) {
@@ -1173,6 +1176,11 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				phys_addr_t p;
 				dma_addr_t i;
 
+				if (WARN_ON(!d)) { /* mapped w/o a domain?! */
+					ret = -EINVAL;
+					goto unwind;
+				}
+
 				phys = iommu_iova_to_phys(d->domain, iova);
 
 				if (WARN_ON(!phys)) {
@@ -1202,7 +1210,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				if (npage <= 0) {
 					WARN_ON(!npage);
 					ret = (int)npage;
-					return ret;
+					goto unwind;
 				}
 
 				phys = pfn << PAGE_SHIFT;
@@ -1211,14 +1219,67 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 
 			ret = iommu_map(domain->domain, iova, phys,
 					size, dma->prot | domain->prot);
-			if (ret)
-				return ret;
+			if (ret) {
+				if (!dma->iommu_mapped)
+					vfio_unpin_pages_remote(dma, iova,
+							phys >> PAGE_SHIFT,
+							size >> PAGE_SHIFT,
+							true);
+				goto unwind;
+			}
 
 			iova += size;
 		}
+	}
+
+	/* All dmas are now mapped, defer to second tree walk for unwind */
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+
 		dma->iommu_mapped = true;
 	}
+
 	return 0;
+
+unwind:
+	for (; n; n = rb_prev(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+		dma_addr_t iova;
+
+		if (dma->iommu_mapped) {
+			iommu_unmap(domain->domain, dma->iova, dma->size);
+			continue;
+		}
+
+		iova = dma->iova;
+		while (iova < dma->iova + dma->size) {
+			phys_addr_t phys, p;
+			size_t size;
+			dma_addr_t i;
+
+			phys = iommu_iova_to_phys(domain->domain, iova);
+			if (!phys) {
+				iova += PAGE_SIZE;
+				continue;
+			}
+
+			size = PAGE_SIZE;
+			p = phys + size;
+			i = iova + size;
+			while (i < dma->iova + dma->size &&
+			       p == iommu_iova_to_phys(domain->domain, i)) {
+				size += PAGE_SIZE;
+				p += PAGE_SIZE;
+				i += PAGE_SIZE;
+			}
+
+			iommu_unmap(domain->domain, iova, size);
+			vfio_unpin_pages_remote(dma, iova, phys >> PAGE_SHIFT,
+						size >> PAGE_SHIFT, true);
+		}
+	}
+
+	return ret;
 }
 
 /*
-- 
2.25.1



