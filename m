Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519903ED341
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 13:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhHPLnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 07:43:10 -0400
Received: from mga17.intel.com ([192.55.52.151]:18542 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236236AbhHPLnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 07:43:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="196110467"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="196110467"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 04:42:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="462026804"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga007.jf.intel.com with ESMTP; 16 Aug 2021 04:42:35 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Camille Lu <camille.lu@hpe.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 1/1] iommu/vt-d: Fix agaw for a supported 48 bit guest address width
Date:   Mon, 16 Aug 2021 19:39:32 +0800
Message-Id: <20210816113932.1210581-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>

[ Upstream commit 327d5b2fee91c404a3956c324193892cf2cc9528 ]

The IOMMU driver calculates the guest addressability for a DMA request
based on the value of the mgaw reported from the IOMMU. However, this
is a fused value and as mentioned in the spec, the guest width
should be calculated based on the minimum of supported adjusted guest
address width (SAGAW) and MGAW.

This is from specification:
"Guest addressability for a given DMA request is limited to the
minimum of the value reported through this field and the adjusted
guest address width of the corresponding page-table structure.
(Adjusted guest address widths supported by hardware are reported
through the SAGAW field)."

This causes domain initialization to fail and following
errors appear for EHCI PCI driver:

[    2.486393] ehci-pci 0000:01:00.4: EHCI Host Controller
[    2.486624] ehci-pci 0000:01:00.4: new USB bus registered, assigned bus
number 1
[    2.489127] ehci-pci 0000:01:00.4: DMAR: Allocating domain failed
[    2.489350] ehci-pci 0000:01:00.4: DMAR: 32bit DMA uses non-identity
mapping
[    2.489359] ehci-pci 0000:01:00.4: can't setup: -12
[    2.489531] ehci-pci 0000:01:00.4: USB bus 1 deregistered
[    2.490023] ehci-pci 0000:01:00.4: init 0000:01:00.4 fail, -12
[    2.490358] ehci-pci: probe of 0000:01:00.4 failed with error -12

This issue happens when the value of the sagaw corresponds to a
48-bit agaw. This fix updates the calculation of the agaw based on
the minimum of IOMMU's sagaw value and MGAW.

This issue happens on the code path of getting a private domain for a
device. A private domain was needed when the domain of an iommu group
couldn't meet the requirement of a device. The IOMMU core has been
evolved to eliminate the need for private domain, hence this code path
has alreay been removed from the upstream since commit 327d5b2fee91c
("iommu/vt-d: Allow 32bit devices to uses DMA domain"). Instead of back
porting all patches that are required for removing the private domain,
this simply fixes it in the affected stable kernel between v4.16 and v5.7.

[baolu: The orignal patch could be found here
 https://lore.kernel.org/linux-iommu/20210412202736.70765-1-saeed.mirzamohammadi@oracle.com/.
 I added commit message according to Greg's comments at
 https://lore.kernel.org/linux-iommu/YHZ%2FT9x7Xjf1r6fI@kroah.com/.]

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: stable@vger.kernel.org #v4.16+
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Tested-by: Camille Lu <camille.lu@hpe.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 953d86ca6d2b..a2a03df97704 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1853,7 +1853,7 @@ static inline int guestwidth_to_adjustwidth(int gaw)
 static int domain_init(struct dmar_domain *domain, struct intel_iommu *iommu,
 		       int guest_width)
 {
-	int adjust_width, agaw;
+	int adjust_width, agaw, cap_width;
 	unsigned long sagaw;
 	int err;
 
@@ -1867,8 +1867,9 @@ static int domain_init(struct dmar_domain *domain, struct intel_iommu *iommu,
 	domain_reserve_special_ranges(domain);
 
 	/* calculate AGAW */
-	if (guest_width > cap_mgaw(iommu->cap))
-		guest_width = cap_mgaw(iommu->cap);
+	cap_width = min_t(int, cap_mgaw(iommu->cap), agaw_to_width(iommu->agaw));
+	if (guest_width > cap_width)
+		guest_width = cap_width;
 	domain->gaw = guest_width;
 	adjust_width = guestwidth_to_adjustwidth(guest_width);
 	agaw = width_to_agaw(adjust_width);
-- 
2.25.1

