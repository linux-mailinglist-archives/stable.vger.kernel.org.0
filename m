Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BB2406169
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhIJAmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhIJASj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AFB26121E;
        Fri, 10 Sep 2021 00:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233028;
        bh=1zAsTmc/vJugNTEDqc1y5VUxzqIYX1Skj8p08T3ERBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I70wlbsWxyWVeE8IUmX1iNA+xTmf8JCBKsvRJUZ3IfiuQrKhyNslBcz9eOEWDRUcN
         IJI0Oc9ZV0GWzufWe2CQFTcGMOmkcEf+0Vm8bQPOYhhRCDplZHBrBh1xKaQXW79hv7
         eKeRxuDp8AXxqe33PNt/fWyiEccRg35Yn3mjscs3W5s8W9UrZ2sfSMe0pqWSDszH1y
         nf8CPdNTR67/pHmxvd7cOtIYVwalBdxPk/pRZHY1z9/JSyKyphGjIlP8bYC4K/cmNP
         E+acB5f9lpwbl9p27qogCwQPWZhC2ULm5wL3fSzUktf2TJFjr0My2ycLRsSyufv9U8
         SzmUxbGUb3r/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Yi L <yi.l.liu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.14 50/99] iommu/vt-d: Add present bit check in pasid entry setup helpers
Date:   Thu,  9 Sep 2021 20:15:09 -0400
Message-Id: <20210910001558.173296-50-sashal@kernel.org>
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

From: Liu Yi L <yi.l.liu@intel.com>

[ Upstream commit 423d39d8518c1bba12e0889a92beeddbb1502392 ]

The helper functions should not modify the pasid entries which are still
in use. Add a check against present bit.

Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Link: https://lore.kernel.org/r/20210817042425.1784279-1-yi.l.liu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210818134852.1847070-10-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 9ec374e17469..60c07050f6a7 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -540,6 +540,10 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 		devtlb_invalidation_with_pasid(iommu, dev, pasid);
 }
 
+/*
+ * This function flushes cache for a newly setup pasid table entry.
+ * Caller of it should not modify the in-use pasid table entries.
+ */
 static void pasid_flush_caches(struct intel_iommu *iommu,
 				struct pasid_entry *pte,
 			       u32 pasid, u16 did)
@@ -591,6 +595,10 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 	if (WARN_ON(!pte))
 		return -EINVAL;
 
+	/* Caller must ensure PASID entry is not in use. */
+	if (pasid_pte_is_present(pte))
+		return -EBUSY;
+
 	pasid_clear_entry(pte);
 
 	/* Setup the first level page table pointer: */
@@ -690,6 +698,10 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 		return -ENODEV;
 	}
 
+	/* Caller must ensure PASID entry is not in use. */
+	if (pasid_pte_is_present(pte))
+		return -EBUSY;
+
 	pasid_clear_entry(pte);
 	pasid_set_domain_id(pte, did);
 	pasid_set_slptr(pte, pgd_val);
@@ -729,6 +741,10 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 		return -ENODEV;
 	}
 
+	/* Caller must ensure PASID entry is not in use. */
+	if (pasid_pte_is_present(pte))
+		return -EBUSY;
+
 	pasid_clear_entry(pte);
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, iommu->agaw);
-- 
2.30.2

