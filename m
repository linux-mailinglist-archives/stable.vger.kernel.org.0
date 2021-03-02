Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6336F32AF0E
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhCCAOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238436AbhCBL7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 06:59:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9985D64F1A;
        Tue,  2 Mar 2021 11:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686147;
        bh=vjK9Yoh09+V3t6zi3JGagRb0lPiPc42XU6p6uKAzd8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klS+3w7TISHCQGPsY0uKCIsw6AU3RSkfbs9c6yzYRCoYaQ6XMAolL4n5LnYGOSDTl
         lb2gwBZ1BJ47f8tYLD0z0v+QAXAMN9EAHRdL5hhdAD85JH+lU5CTqDtKtLbNCEXM+Z
         NPZgjm8uaSgpsjPButMMpAJwGqOKdBioiBFyZ8QOYOZgWzCU8jRD8g07cbIgdVgGmB
         g38u+Y2Gis9Tq0+FLp8C9qC3u7ygogQpaVe8AES6IqMs50Ufz54wZqToEQPoO2zj8t
         gYo0TLAP9IBxfpBS+DZkzcrjwHN4BM6ve0aZY8TpKv3J2gvQEMJUZPyNbl4jPz+BHc
         pM9+tF4+mIneQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.11 09/52] iommu/vt-d: Clear PRQ overflow only when PRQ is empty
Date:   Tue,  2 Mar 2021 06:54:50 -0500
Message-Id: <20210302115534.61800-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
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
index 18a9f05df407..b3bcd6dec93e 100644
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

