Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652BC17757E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 12:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgCCLwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 06:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgCCLwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 06:52:05 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B87B206E6;
        Tue,  3 Mar 2020 11:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583236324;
        bh=bqw6gnhe8DaJUx8gH+mJ8ulDLAoF7VExRZOOBVm+YKs=;
        h=From:To:Cc:Subject:Date:From;
        b=JXF0uiz3jtCtvEfEVSqRNYIHGXTV5VZNnZ6EJWoeHcnrED/zkBjXc76Dram1Y0K5p
         m0MnsWtFgIg4xvHwJ4kC8++CU/FgIrZvv0NF6an83SPnbX5U95/g87cnuPyqKE05de
         GX98dfLrD4jns48F0p2vzD5A/5kYkpCqykMUKNrE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j965i-009exf-61; Tue, 03 Mar 2020 11:52:02 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Eric Auger <eric.auger@redhat.com>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] iommu/dma: Fix MSI reservation allocation
Date:   Tue,  3 Mar 2020 11:51:54 +0000
Message-Id: <20200303115154.32263-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, robin.murphy@arm.com, jroedel@suse.de, eric.auger@redhat.com, will@kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The way cookie_init_hw_msi_region() allocates the iommu_dma_msi_page
structures doesn't match the way iommu_put_dma_cookie() frees them.

The former performs a single allocation of all the required structures,
while the latter tries to free them one at a time. It doesn't quite
work for the main use case (the GICv3 ITS where the range is 64kB)
when the base ganule size is 4kB.

This leads to a nice slab corruption on teardown, which is easily
observable by simply creating a VF on a SRIOV-capable device, and
tearing it down immediately (no need to even make use of it).

Fix it by allocating iommu_dma_msi_page structures one at a time.

Fixes: 7c1b058c8b5a3 ("iommu/dma: Handle IOMMU API reserved regions")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/iommu/dma-iommu.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index a2e96a5fd9a7..01fa64856c12 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -171,25 +171,37 @@ static int cookie_init_hw_msi_region(struct iommu_dma_cookie *cookie,
 		phys_addr_t start, phys_addr_t end)
 {
 	struct iova_domain *iovad = &cookie->iovad;
-	struct iommu_dma_msi_page *msi_page;
-	int i, num_pages;
+	struct iommu_dma_msi_page *msi_page, *tmp;
+	int i, num_pages, ret = 0;
+	phys_addr_t base;
 
-	start -= iova_offset(iovad, start);
+	base = start -= iova_offset(iovad, start);
 	num_pages = iova_align(iovad, end - start) >> iova_shift(iovad);
 
-	msi_page = kcalloc(num_pages, sizeof(*msi_page), GFP_KERNEL);
-	if (!msi_page)
-		return -ENOMEM;
-
 	for (i = 0; i < num_pages; i++) {
-		msi_page[i].phys = start;
-		msi_page[i].iova = start;
-		INIT_LIST_HEAD(&msi_page[i].list);
-		list_add(&msi_page[i].list, &cookie->msi_page_list);
+		msi_page = kmalloc(sizeof(*msi_page), GFP_KERNEL);
+		if (!msi_page) {
+			ret = -ENOMEM;
+			break;
+		}
+		msi_page->phys = start;
+		msi_page->iova = start;
+		INIT_LIST_HEAD(&msi_page->list);
+		list_add(&msi_page->list, &cookie->msi_page_list);
 		start += iovad->granule;
 	}
 
-	return 0;
+	if (ret) {
+		list_for_each_entry_safe(msi_page, tmp,
+					 &cookie->msi_page_list, list) {
+			if (msi_page->phys >= base && msi_page->phys < start) {
+				list_del(&msi_page->list);
+				kfree(msi_page);
+			}
+		}
+	}
+
+	return ret;
 }
 
 static int iova_reserve_pci_windows(struct pci_dev *dev,
-- 
2.20.1

