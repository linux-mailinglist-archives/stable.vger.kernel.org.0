Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5697912C92B
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbfL2SBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:01:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732744AbfL2R4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACC65208C4;
        Sun, 29 Dec 2019 17:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642170;
        bh=eaOVxwg3RCtRaz2V+Ymf6ZImkfdTDGSZ7nuZByTpowA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUT7pZUziTZnSMgghuTo9Udu3moigBXzK6/jFyhlO2HP5aBS1qaf5LbdQpJyVx98+
         kg5gTp82dOpg0mtpUxKS52toGJqRkbQNq/JUK7uQzYdruaprcEz373h6Rz4vDZsQJv
         4QCxBg2zMsEPKTJwb3Um2Ixy7HND/3nvBn42BrMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 369/434] iommu/vt-d: Fix dmar pte read access not set error
Date:   Sun, 29 Dec 2019 18:27:02 +0100
Message-Id: <20191229172726.487422938@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 75d18385394f56db76845d91a192532aba421875 upstream.

If the default DMA domain of a group doesn't fit a device, it
will still sit in the group but use a private identity domain.
When map/unmap/iova_to_phys come through iommu API, the driver
should still serve them, otherwise, other devices in the same
group will be impacted. Since identity domain has been mapped
with the whole available memory space and RMRRs, we don't need
to worry about the impact on it.

Link: https://www.spinics.net/lists/iommu/msg40416.html
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Fixes: 942067f1b6b97 ("iommu/vt-d: Identify default domains replaced with private")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Tested-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5447,9 +5447,6 @@ static int intel_iommu_map(struct iommu_
 	int prot = 0;
 	int ret;
 
-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
-		return -EINVAL;
-
 	if (iommu_prot & IOMMU_READ)
 		prot |= DMA_PTE_READ;
 	if (iommu_prot & IOMMU_WRITE)
@@ -5492,8 +5489,6 @@ static size_t intel_iommu_unmap(struct i
 	/* Cope with horrid API which requires us to unmap more than the
 	   size argument if it happens to be a large-page mapping. */
 	BUG_ON(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level));
-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
-		return 0;
 
 	if (size < VTD_PAGE_SIZE << level_to_offset_bits(level))
 		size = VTD_PAGE_SIZE << level_to_offset_bits(level);
@@ -5525,9 +5520,6 @@ static phys_addr_t intel_iommu_iova_to_p
 	int level = 0;
 	u64 phys = 0;
 
-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
-		return 0;
-
 	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level);
 	if (pte)
 		phys = dma_pte_addr(pte);


