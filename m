Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1911178F66
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 12:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387688AbgCDLLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 06:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387488AbgCDLLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 06:11:46 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41F6520709;
        Wed,  4 Mar 2020 11:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583320305;
        bh=6QGmwW91nEJvgxEq+40qvnflN5tJsMSuNiAE6L04isA=;
        h=From:To:Cc:Subject:Date:From;
        b=CQKgD6CQPxw+O3Y3MLwSfh7ElCLjT18osaxje158rq6UtfnVF+Xj0GmwvRoitv2Hv
         fYaxSDobn4YRorkPEW5a8eWk6X9VbJQM/liqcf0rQFLiOqr7kjaLEEAxxtbvIV1CQ0
         oBTWpTNEtELu72smIlmu02oZceuEvNkfsyooD/rI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j9RwF-009yDa-GB; Wed, 04 Mar 2020 11:11:43 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Eric Auger <eric.auger@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] iommu/dma: Fix MSI reservation allocation
Date:   Wed,  4 Mar 2020 11:11:17 +0000
Message-Id: <20200304111117.3540-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, eric.auger@redhat.com, robin.murphy@arm.com, jroedel@suse.de, will@kernel.org, stable@vger.kernel.org
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
when the base granule size is 4kB.

This leads to a nice slab corruption on teardown, which is easily
observable by simply creating a VF on a SRIOV-capable device, and
tearing it down immediately (no need to even make use of it).
Fortunately, this only affects systems where the ITS isn't translated
by the SMMU, which are both rare and non-standard.

Fix it by allocating iommu_dma_msi_page structures one at a time.

Fixes: 7c1b058c8b5a3 ("iommu/dma: Handle IOMMU API reserved regions")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
---
* From v1:
  - Got rid of the superfluous error handling (Robin)
  - Clarified that it only affects a very small set of systems
  - Added Eric's RB (which I assume still stands)

 drivers/iommu/dma-iommu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index a2e96a5fd9a7..ba128d1cdaee 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -177,15 +177,15 @@ static int cookie_init_hw_msi_region(struct iommu_dma_cookie *cookie,
 	start -= iova_offset(iovad, start);
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
+		if (!msi_page)
+			return -ENOMEM;
+
+		msi_page->phys = start;
+		msi_page->iova = start;
+		INIT_LIST_HEAD(&msi_page->list);
+		list_add(&msi_page->list, &cookie->msi_page_list);
 		start += iovad->granule;
 	}
 
-- 
2.20.1

