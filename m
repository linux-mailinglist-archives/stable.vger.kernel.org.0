Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648BF32AFD7
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbhCCA3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345670AbhCBMgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:36:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA8964F51;
        Tue,  2 Mar 2021 11:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686216;
        bh=gHCNSIIJBpDDyHuxZ94L+MAHMGyBEwM33M/mylZiORs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WFdgLGGV+QL8pvSAPKHii4jUCUSimpqoIrACdhNQHZAStnsCuxnHJarSZNOlAeIk4
         +YAcrX3shcA64ogxve0ShiRvgNf2lpdihNhato9zFVUmW7iL30tJuuZYaWJH98uVtV
         OjtmB9sbN5mKN2P9/HQy43I7f2ecmm/DjuAGEMn6JwhZgYUbHRqqaXRws/3LByj5/b
         nvgl7jgcXTBlZ9YO1heww9qsuQ5E548HVEGRT3qoNbIm4vTEtrxYRUHiVgw7u2X4fG
         XIkJa0sg6Mv6hsr5K7nj1l3dkotQg6a3Y9495x6w4kO55tk+2nQ4GcLL86kiiAXrSe
         JtWVC7yyMo67Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 07/47] iommu/vt-d: Clear PRQ overflow only when PRQ is empty
Date:   Tue,  2 Mar 2021 06:56:06 -0500
Message-Id: <20210302115646.62291-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 28a77185f1cd0650b664f54614143aaaa3a7a615 ]

It is incorrect to always clear PRO when it's set w/o first checking
whether the overflow condition has been cleared. Current code assumes
that if an overflow condition occurs it must have been cleared by earlier
loop. However since the code runs in a threaded context, the overflow
condition could occur even after setting the head to the tail under some
extreme condition. To be sane, we should read both head/tail again when
seeing a pending PRO and only clear PRO after all pending PRs have been
handled.

Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/linux-iommu/MWHPR11MB18862D2EA5BD432BF22D99A48CA09@MWHPR11MB1886.namprd11.prod.outlook.com/
Link: https://lore.kernel.org/r/20210126080730.2232859-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/svm.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 43f392d27d31..b200a3acc6ed 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -1079,8 +1079,17 @@ prq_advance:
 	 * Clear the page request overflow bit and wake up all threads that
 	 * are waiting for the completion of this handling.
 	 */
-	if (readl(iommu->reg + DMAR_PRS_REG) & DMA_PRS_PRO)
-		writel(DMA_PRS_PRO, iommu->reg + DMAR_PRS_REG);
+	if (readl(iommu->reg + DMAR_PRS_REG) & DMA_PRS_PRO) {
+		pr_info_ratelimited("IOMMU: %s: PRQ overflow detected\n",
+				    iommu->name);
+		head = dmar_readq(iommu->reg + DMAR_PQH_REG) & PRQ_RING_MASK;
+		tail = dmar_readq(iommu->reg + DMAR_PQT_REG) & PRQ_RING_MASK;
+		if (head == tail) {
+			writel(DMA_PRS_PRO, iommu->reg + DMAR_PRS_REG);
+			pr_info_ratelimited("IOMMU: %s: PRQ overflow cleared",
+					    iommu->name);
+		}
+	}
 
 	if (!completion_done(&iommu->prq_complete))
 		complete(&iommu->prq_complete);
-- 
2.30.1

