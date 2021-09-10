Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AC34062E0
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242063AbhIJAqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233981AbhIJAWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 797906023D;
        Fri, 10 Sep 2021 00:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233266;
        bh=7FOxNf5YMak7zbZhc0MqOflrvjvMfHs+ogfjcMnl1Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2KWjTrUTsIvYnt4FTUNoN2uJUx90s1LSNaem0slgoMxH9tHLB3vOvGWsUhAmji0G
         V5PQMnmzdFq6oi+iP6ldyDB0o0CzHrTFd8Tn56s2DYRBOigrlvwmwKf2bOX8nFE0R5
         Ha+8y3ShFaUb6VdU7nZplbetUdc1Xk56DmljBq01QjSZ6CQKpSpvng1vgSNZjVgBP1
         xhRh8p0Zn4hOMFl5bPhi+OD51NFh3b/PQ5RzZk+gc9nBGI1GHdsHSpEvo3sd8/e9xG
         kC+wUKP0F7toVkUst9y5df2+NZw9AFoW7koyPz8gDLgPGE0Zbgo2l0HQwUhRrQxp2k
         7HfVRooURVcmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Yi L <yi.l.liu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 27/53] iommu/vt-d: Add present bit check in pasid entry setup helpers
Date:   Thu,  9 Sep 2021 20:20:02 -0400
Message-Id: <20210910002028.175174-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
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
index fb911b6c418f..6db3400df484 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -523,6 +523,10 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 		devtlb_invalidation_with_pasid(iommu, dev, pasid);
 }
 
+/*
+ * This function flushes cache for a newly setup pasid table entry.
+ * Caller of it should not modify the in-use pasid table entries.
+ */
 static void pasid_flush_caches(struct intel_iommu *iommu,
 				struct pasid_entry *pte,
 			       u32 pasid, u16 did)
@@ -558,6 +562,10 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 	if (WARN_ON(!pte))
 		return -EINVAL;
 
+	/* Caller must ensure PASID entry is not in use. */
+	if (pasid_pte_is_present(pte))
+		return -EBUSY;
+
 	pasid_clear_entry(pte);
 
 	/* Setup the first level page table pointer: */
@@ -654,6 +662,10 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 		return -ENODEV;
 	}
 
+	/* Caller must ensure PASID entry is not in use. */
+	if (pasid_pte_is_present(pte))
+		return -EBUSY;
+
 	pasid_clear_entry(pte);
 	pasid_set_domain_id(pte, did);
 	pasid_set_slptr(pte, pgd_val);
@@ -693,6 +705,10 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
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

