Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CE43F6677
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240160AbhHXRYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240464AbhHXRV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:21:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28E03615E4;
        Tue, 24 Aug 2021 17:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824611;
        bh=S0u4x/U3+YMUcRBgT739kt2cRDt76+iOkNeQiQlnVZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldIbxKzH8ltQMhZ11uJyxBWXG4Hw5Db/zmso0rsYvPX8i9cTQKWreiZSuT1SupPho
         sZ3fXKcs74UBbpccHTKoRp5kznQyLlrhiyor/fFo/HgmBk15Qi7jKc3Bu72v+OzsDc
         69iRNcLBStZ2sFumTP5+JFcmgTdROTkRf9uvzNBkhftlMIizkHcC6VbRW4jOCLNtxX
         KRo8vfV9UGTmmf54N9t7PQMMcpEk0WMhyGFIGwIgvEF5J0rXXaHi8WTQcMVoTnwaVM
         yhRHuJI6VxxH33zN2kdP+buo+ic0Gu9tJa0XaQo/BUfvoWkCc7f/Dr4uB2fnN8TAyy
         Mi7r8ii+9Cjmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Camille Lu <camille.lu@hpe.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 40/84] iommu/vt-d: Fix agaw for a supported 48 bit guest address width
Date:   Tue, 24 Aug 2021 13:02:06 -0400
Message-Id: <20210824170250.710392-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel-iommu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d2166dfc8b3f..dcb865d19309 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1928,7 +1928,7 @@ static inline int guestwidth_to_adjustwidth(int gaw)
 static int domain_init(struct dmar_domain *domain, struct intel_iommu *iommu,
 		       int guest_width)
 {
-	int adjust_width, agaw;
+	int adjust_width, agaw, cap_width;
 	unsigned long sagaw;
 	int err;
 
@@ -1942,8 +1942,9 @@ static int domain_init(struct dmar_domain *domain, struct intel_iommu *iommu,
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
2.30.2

