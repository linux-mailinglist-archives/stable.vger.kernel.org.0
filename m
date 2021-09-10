Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EDB40621A
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhIJAop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233653AbhIJAUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1D3F610E9;
        Fri, 10 Sep 2021 00:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233163;
        bh=pP259nBXSIQ7eGjknv8BKsTAJEFR6SACGFYof+psmU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7bBnWPQXQTj9esbi5jnKf2JOJuZjW4qAGAQMz8SExpD9ring6cvt71Y7SYBP5/7t
         C9MEvq362zQmU6OztT7i9HoPmxy5+rtfE/rRU0ff+L4PJJMJBXX20FYhDUpM5Ypm7+
         VQgfA6E0hAM9t1gTs01htxLKYZMZ1grxUMxQSnb+gK3cOrjBI7nnqb6aWR1mlR3ER9
         n4KMZrxBVAB2/hw4vDd8Kaq4zSeCGuy/mLMQ11th9ioe0DAqqzG1YT3Ri3R7+4SjOS
         vSdoa80SLR4m94Q1XmjVPJ40udTl77ZpfjTsJTzn4bQcC1XxZJRauy+r6S22Ntk8oq
         Vuee7INKCOyiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Yi L <yi.l.liu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.13 44/88] iommu/vt-d: Add present bit check in pasid entry setup helpers
Date:   Thu,  9 Sep 2021 20:17:36 -0400
Message-Id: <20210910001820.174272-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
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
index 581c694b7cf4..a4e79d52be27 100644
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

