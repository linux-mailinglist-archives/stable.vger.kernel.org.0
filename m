Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C9A33B8AB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhCOOEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233094AbhCOOAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFFF464F6C;
        Mon, 15 Mar 2021 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816825;
        bh=U5cMJotNJXpC3v6PATpeGfYfsNOLP3ELGYUfgo9TaFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYpAwApSQ6B1m3wGbtKgHgyB99R6OzVNiSsU4GXMyn+hk4eJTSsihJZfdn2FkXg6T
         6d6SbeIsHYpsf5nkMuthP2BTwOXYOo+TYmbvKukhJL8r0HIn3vH5Ods/MNxv8CJMlg
         vbVbAIF24vUFPtp1i23K6FskTS94kXD7utadoEvs=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/290] iommu/vt-d: Clear PRQ overflow only when PRQ is empty
Date:   Mon, 15 Mar 2021 14:53:48 +0100
Message-Id: <20210315135546.470729126@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -1079,8 +1079,17 @@ static irqreturn_t prq_event_thread(int irq, void *d)
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



