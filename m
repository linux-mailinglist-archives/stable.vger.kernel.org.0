Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D973637CDCA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbhELQ6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244201AbhELQmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 737E561040;
        Wed, 12 May 2021 16:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835898;
        bh=/mfnOEZScKr430mTfPPVF8A9WpZ30nigDey2yN4XNWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xrn046kXqSQ5fGeW+HJk9ipx7X2RITSadj7ypZPmx9QlMTs49XOMAbh3TlBTmKMLn
         zGW2wZDTjjiSZO9XyAXwjy2fMeBQ2fsAj2Wjz+UnNit6cW/QK1l/IvHcv4vsJmaq+F
         5IOBgONBDNIA5IWP3yQ8pJ4q1XK9QRTf1rvXExqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rajesh Sankaran <rajesh.sankaran@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 493/677] iommu/vt-d: Report right snoop capability when using FL for IOVA
Date:   Wed, 12 May 2021 16:48:59 +0200
Message-Id: <20210512144853.764437351@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 6c00612d0cba10f7d0917cf1f73c945003ed4cd7 ]

The Intel VT-d driver checks wrong register to report snoop capablility
when using first level page table for GPA to HPA translation. This might
lead the IOMMU driver to say that it supports snooping control, but in
reality, it does not. Fix this by always setting PASID-table-entry.PGSNP
whenever a pasid entry is setting up for GPA to HPA translation so that
the IOMMU driver could report snoop capability as long as it runs in the
scalable mode.

Fixes: b802d070a52a1 ("iommu/vt-d: Use iova over first level")
Suggested-by: Rajesh Sankaran <rajesh.sankaran@intel.com>
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Suggested-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210330021145.13824-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 12 +++++++++++-
 drivers/iommu/intel/pasid.c | 16 ++++++++++++++++
 drivers/iommu/intel/pasid.h |  1 +
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 66fab7944b39..b5d3301b2700 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -657,7 +657,14 @@ static int domain_update_iommu_snooping(struct intel_iommu *skip)
 	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd) {
 		if (iommu != skip) {
-			if (!ecap_sc_support(iommu->ecap)) {
+			/*
+			 * If the hardware is operating in the scalable mode,
+			 * the snooping control is always supported since we
+			 * always set PASID-table-entry.PGSNP bit if the domain
+			 * is managed outside (UNMANAGED).
+			 */
+			if (!sm_supported(iommu) &&
+			    !ecap_sc_support(iommu->ecap)) {
 				ret = 0;
 				break;
 			}
@@ -2528,6 +2535,9 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 
 	flags |= (level == 5) ? PASID_FLAG_FL5LP : 0;
 
+	if (domain->domain.type == IOMMU_DOMAIN_UNMANAGED)
+		flags |= PASID_FLAG_PAGE_SNOOP;
+
 	return intel_pasid_setup_first_level(iommu, dev, (pgd_t *)pgd, pasid,
 					     domain->iommu_did[iommu->seq_id],
 					     flags);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index f26cb6195b2c..5093d317ff1a 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -411,6 +411,16 @@ static inline void pasid_set_page_snoop(struct pasid_entry *pe, bool value)
 	pasid_set_bits(&pe->val[1], 1 << 23, value << 23);
 }
 
+/*
+ * Setup the Page Snoop (PGSNP) field (Bit 88) of a scalable mode
+ * PASID entry.
+ */
+static inline void
+pasid_set_pgsnp(struct pasid_entry *pe)
+{
+	pasid_set_bits(&pe->val[1], 1ULL << 24, 1ULL << 24);
+}
+
 /*
  * Setup the First Level Page table Pointer field (Bit 140~191)
  * of a scalable mode PASID entry.
@@ -565,6 +575,9 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 		}
 	}
 
+	if (flags & PASID_FLAG_PAGE_SNOOP)
+		pasid_set_pgsnp(pte);
+
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, iommu->agaw);
 	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
@@ -643,6 +656,9 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	pasid_set_fault_enable(pte);
 	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
 
+	if (domain->domain.type == IOMMU_DOMAIN_UNMANAGED)
+		pasid_set_pgsnp(pte);
+
 	/*
 	 * Since it is a second level only translation setup, we should
 	 * set SRE bit as well (addresses are expected to be GPAs).
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 444c0bec221a..086ebd697319 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -48,6 +48,7 @@
  */
 #define PASID_FLAG_SUPERVISOR_MODE	BIT(0)
 #define PASID_FLAG_NESTED		BIT(1)
+#define PASID_FLAG_PAGE_SNOOP		BIT(2)
 
 /*
  * The PASID_FLAG_FL5LP flag Indicates using 5-level paging for first-
-- 
2.30.2



