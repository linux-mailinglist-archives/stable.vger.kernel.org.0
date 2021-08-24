Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDD43F63FD
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbhHXRAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238599AbhHXQ63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC7FB61502;
        Tue, 24 Aug 2021 16:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824237;
        bh=vqC4VUAwnvzLia+9zXhaTAQbkgiY8pUmBUtetdUqzSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhHLGQxsBVNjnjMDG5k3vA1gXdYIXxQfyueGvb48E6fIuSnDGOmpC9SpZQzJWNRrE
         wssb4+ZZ/ENZ1N3OZdxTgai5/5WRCXfmDXJhT+8lTcd+4/VA47EUqTayC2poY9e5Rr
         7jYEXm/fcKJRcyzxdTt9bSP9YdqbN31/gAjTo0/mmHBW6gX6r2kfov7EXaj4/glrKH
         n9kzK+R5fdOnptB00tsURr69Qb20CO498+LLpbCsKnKVAHx/eUWZsYhMOSG12kGV0g
         Y1Oq9XVbumecRFWvzinsX9f9aENoqG3gFSPhhwMIiIZXX454b/vKJgSVUWlSPkBTgX
         ER6CEh07j80Qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Yi L <yi.l.liu@intel.com>,
        Kumar Sanjay K <sanjay.k.kumar@intel.com>,
        Yi Sun <yi.y.sun@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 070/127] iommu/vt-d: Fix incomplete cache flush in intel_pasid_tear_down_entry()
Date:   Tue, 24 Aug 2021 12:55:10 -0400
Message-Id: <20210824165607.709387-71-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

[ Upstream commit 8798d36411196da86e70b994725349c16c1119f6 ]

This fixes improper iotlb invalidation in intel_pasid_tear_down_entry().
When a PASID was used as nested mode, released and reused, the following
error message will appear:

[  180.187556] Unexpected page request in Privilege Mode
[  180.187565] Unexpected page request in Privilege Mode
[  180.279933] Unexpected page request in Privilege Mode
[  180.279937] Unexpected page request in Privilege Mode

Per chapter 6.5.3.3 of VT-d spec 3.3, when tear down a pasid entry, the
software should use Domain selective IOTLB flush if the PGTT of the pasid
entry is SL only or Nested, while for the pasid entries whose PGTT is FL
only or PT using PASID-based IOTLB flush is enough.

Fixes: 2cd1311a26673 ("iommu/vt-d: Add set domain DOMAIN_ATTR_NESTING attr")
Signed-off-by: Kumar Sanjay K <sanjay.k.kumar@intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Tested-by: Yi Sun <yi.y.sun@intel.com>
Link: https://lore.kernel.org/r/20210817042425.1784279-1-yi.l.liu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210817124321.1517985-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 10 ++++++++--
 drivers/iommu/intel/pasid.h |  6 ++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 72dc84821dad..581c694b7cf4 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -511,7 +511,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 				 u32 pasid, bool fault_ignore)
 {
 	struct pasid_entry *pte;
-	u16 did;
+	u16 did, pgtt;
 
 	pte = intel_pasid_get_entry(dev, pasid);
 	if (WARN_ON(!pte))
@@ -521,13 +521,19 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 		return;
 
 	did = pasid_get_domain_id(pte);
+	pgtt = pasid_pte_get_pgtt(pte);
+
 	intel_pasid_clear_entry(dev, pasid, fault_ignore);
 
 	if (!ecap_coherent(iommu->ecap))
 		clflush_cache_range(pte, sizeof(*pte));
 
 	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
-	qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
+
+	if (pgtt == PASID_ENTRY_PGTT_PT || pgtt == PASID_ENTRY_PGTT_FL_ONLY)
+		qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
+	else
+		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
 
 	/* Device IOTLB doesn't need to be flushed in caching mode. */
 	if (!cap_caching_mode(iommu->cap))
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 5ff61c3d401f..c11bc8b833b8 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -99,6 +99,12 @@ static inline bool pasid_pte_is_present(struct pasid_entry *pte)
 	return READ_ONCE(pte->val[0]) & PASID_PTE_PRESENT;
 }
 
+/* Get PGTT field of a PASID table entry */
+static inline u16 pasid_pte_get_pgtt(struct pasid_entry *pte)
+{
+	return (u16)((READ_ONCE(pte->val[0]) >> 6) & 0x7);
+}
+
 extern unsigned int intel_pasid_max_id;
 int intel_pasid_alloc_table(struct device *dev);
 void intel_pasid_free_table(struct device *dev);
-- 
2.30.2

