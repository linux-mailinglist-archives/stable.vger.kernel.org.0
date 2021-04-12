Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0656135D1FE
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 22:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245749AbhDLU3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 16:29:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38540 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244334AbhDLU3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 16:29:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CKOP34169282;
        Mon, 12 Apr 2021 20:28:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=/Xwvsmvmt/0asfYePGq/z1BYP2CpGRhQ6wWueeodpK4=;
 b=gvdWcv/nAYJbAcZNbFtrDq0ws8hUYuVfpDe0+B7UDw43Bmo356oXvko162VWrHEsRGC1
 V0d40cUOdVnicEEUNamuXn2iMkdwBkawgdMPToWf9mY5KA+11MFFeFjZ40PlNAZE3zmO
 6xlP8xuLc1KPFH5ytLoVYQ+qRTeyx90ltcXTBLum/1WKXuh4tizFe109TIEEkKIWj91j
 gvPpmGa6x7+fxNY3//+wD62UXe4+PbGagjQyN2lhHRM3LpDNbdyzXFLltKpxhd0nFB7t
 tJ8jfG8kbNbpmuKck3j33MzDq+MqfsF9cuHNsovCyEfeDxBa8WW+tdZ+WrfckoGvyIzd QA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37u3ymcywn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 20:28:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CKPcVl122218;
        Mon, 12 Apr 2021 20:28:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 37unwxu8w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 20:28:24 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 13CKSNoH129700;
        Mon, 12 Apr 2021 20:28:23 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by aserp3020.oracle.com with ESMTP id 37unwxu8vh-1;
        Mon, 12 Apr 2021 20:28:23 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     saeed.mirzamohammadi@oracle.com, stable@vger.kernel.org,
        Camille Lu <camille.lu@hpe.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5.4 v3 1/1] iommu/vt-d: Fix agaw for a supported 48 bit guest address width
Date:   Mon, 12 Apr 2021 13:27:35 -0700
Message-Id: <20210412202736.70765-1-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: FMQZKLXguiDeGYKpsD4VEXmaph966jqm
X-Proofpoint-ORIG-GUID: FMQZKLXguiDeGYKpsD4VEXmaph966jqm
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120131
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Tested-by: Camille Lu <camille.lu@hpe.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

---

Change in v2:
- Added cap_width to calculate AGAW based on the minimum value of MGAW and AGAW.

Changes in v3:
- Added Lu's Reviewed-by.
- Added stable list.
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
2.27.0

