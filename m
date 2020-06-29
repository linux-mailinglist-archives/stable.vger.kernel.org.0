Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C6420D96B
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388130AbgF2TrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387786AbgF2Tkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81A07248BA;
        Mon, 29 Jun 2020 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444413;
        bh=HBXY920oo0pacrv3V9t54CQyy7bpNG+4WV0uWzGTL84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIOsk5RPNmZH++/GnW9j9Ma9aEXOarIGPsuSV7Pihhtl+/7dH5yXIl4atkcArqfjO
         L8Ys0rq6YWH/3u5iFSiFlW31ZeoQi4uVecylkQ3HR4lQzWUihSQlsY3Sip1jCQTGg2
         RGB98aCPJ6ScuQ3ybJcwmtg1Oo58Un1l6xgROe50=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/178] iommu/vt-d: Update scalable mode paging structure coherency
Date:   Mon, 29 Jun 2020 11:23:56 -0400
Message-Id: <20200629152523.2494198-92-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 04c00956ee3cd138fd38560a91452a804a8c5550 ]

The Scalable-mode Page-walk Coherency (SMPWC) field in the VT-d extended
capability register indicates the hardware coherency behavior on paging
structures accessed through the pasid table entry. This is ignored in
current code and using ECAP.C instead which is only valid in legacy mode.
Fix this so that paging structure updates could be manually flushed from
the cache line if hardware page walking is not snooped.

Fixes: 765b6a98c1de3 ("iommu/vt-d: Enumerate the scalable mode capability")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Link: https://lore.kernel.org/r/20200622231345.29722-6-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-iommu.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 773ac2b0d6068..6366b5fbb3a46 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -611,6 +611,12 @@ struct intel_iommu *domain_get_iommu(struct dmar_domain *domain)
 	return g_iommus[iommu_id];
 }
 
+static inline bool iommu_paging_structure_coherency(struct intel_iommu *iommu)
+{
+	return sm_supported(iommu) ?
+			ecap_smpwc(iommu->ecap) : ecap_coherent(iommu->ecap);
+}
+
 static void domain_update_iommu_coherency(struct dmar_domain *domain)
 {
 	struct dmar_drhd_unit *drhd;
@@ -622,7 +628,7 @@ static void domain_update_iommu_coherency(struct dmar_domain *domain)
 
 	for_each_domain_iommu(i, domain) {
 		found = true;
-		if (!ecap_coherent(g_iommus[i]->ecap)) {
+		if (!iommu_paging_structure_coherency(g_iommus[i])) {
 			domain->iommu_coherency = 0;
 			break;
 		}
@@ -633,7 +639,7 @@ static void domain_update_iommu_coherency(struct dmar_domain *domain)
 	/* No hardware attached; use lowest common denominator */
 	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd) {
-		if (!ecap_coherent(iommu->ecap)) {
+		if (!iommu_paging_structure_coherency(iommu)) {
 			domain->iommu_coherency = 0;
 			break;
 		}
@@ -2090,7 +2096,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 
 	context_set_fault_enable(context);
 	context_set_present(context);
-	domain_flush_cache(domain, context, sizeof(*context));
+	if (!ecap_coherent(iommu->ecap))
+		clflush_cache_range(context, sizeof(*context));
 
 	/*
 	 * It's a non-present to present mapping. If hardware doesn't cache
-- 
2.25.1

