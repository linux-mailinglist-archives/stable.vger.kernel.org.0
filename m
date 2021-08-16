Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6D03ED4ED
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237434AbhHPNGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237545AbhHPNFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:05:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 436DE6328D;
        Mon, 16 Aug 2021 13:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119121;
        bh=zoSqKRO1qgJGNXZqpZAIvDj7q09XrjhVlZIw4wfQf2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qy7TBxTx3fnGCRdRUd1WviRe3YQZeYs1vsO4mMNiJBNepr/NB3xxW0OqN3+kDzL8o
         qJtxQVmefX2U/NCs4Vqe2mwULELt5SMQUA7L8ChdSw92gNsiST/aw740zgbB5LrQ3I
         lnoxISx/TlVmmivghVB4tCKYERCsCKOvY4I88RNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Camille Lu <camille.lu@hpe.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 5.4 62/62] iommu/vt-d: Fix agaw for a supported 48 bit guest address width
Date:   Mon, 16 Aug 2021 15:02:34 +0200
Message-Id: <20210816125430.346492066@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/iommu/intel-iommu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1853,7 +1853,7 @@ static inline int guestwidth_to_adjustwi
 static int domain_init(struct dmar_domain *domain, struct intel_iommu *iommu,
 		       int guest_width)
 {
-	int adjust_width, agaw;
+	int adjust_width, agaw, cap_width;
 	unsigned long sagaw;
 	int err;
 
@@ -1867,8 +1867,9 @@ static int domain_init(struct dmar_domai
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


