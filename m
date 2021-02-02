Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6097630B3E6
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 01:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhBBAKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 19:10:51 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:32894 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhBBAKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 19:10:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1612224646; x=1643760646;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=c3z6bOLhUO6Sn0p3wYMNRFyAM8UM/yO9Lmsgc3/5IIw=;
  b=MdoR2yw576aZteT4J/lYU35+idHHiCa2WoMWnPrt6+HwHiQRrK2DdDME
   TYzzRW8hMB/3vCsBHStWVfDh8eVyd1Jr6jOGDGa6NXN2MXPICQMkil4BP
   6TObOlUv6LT4wG8r366mDNm11C0kpGWkD/A2f6doWkiZMgHi2VFhVfuq8
   c=;
X-IronPort-AV: E=Sophos;i="5.79,393,1602547200"; 
   d="scan'208";a="107970407"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 02 Feb 2021 00:10:00 +0000
Received: from EX13D02EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 16E57A1D5C;
        Tue,  2 Feb 2021 00:09:58 +0000 (UTC)
Received: from u2196cf9297dc59.ant.amazon.com (10.43.160.244) by
 EX13D02EUC001.ant.amazon.com (10.43.164.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 2 Feb 2021 00:09:54 +0000
From:   Filippo Sironi <sironi@amazon.de>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <samjonas@amazon.com>,
        <dwmw@amazon.co.uk>, <sironi@amazon.de>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/2 for Linux 4.4] iommu/vt-d: Gracefully handle DMAR units with no supported address widths
Date:   Tue, 2 Feb 2021 01:09:36 +0100
Message-ID: <20210202000937.2151-1-sironi@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.244]
X-ClientProxiedBy: EX13D06UWC003.ant.amazon.com (10.43.162.86) To
 EX13D02EUC001.ant.amazon.com (10.43.164.92)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

commit c40aaaac1018ff1382f2d35df5129a6bcea3df6b upstream.

Instead of bailing out completely, such a unit can still be used for
interrupt remapping.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/linux-iommu/549928db2de6532117f36c9c810373c14cf76f51.camel@infradead.org/
Signed-off-by: Joerg Roedel <jroedel@suse.de>
[ - context change due to moving drivers/iommu/dmar.c to
    drivers/iommu/intel/dmar.c
  - remove the unused err_unmap label
  - use iommu->iommu_dev instead of iommu->iommu.ops to decide whether
    when freeing ]
Signed-off-by: Filippo Sironi <sironi@amazon.de>
---
 drivers/iommu/dmar.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 00169c9eb3ee..095022923258 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1012,8 +1012,8 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 {
 	struct intel_iommu *iommu;
 	u32 ver, sts;
-	int agaw = 0;
-	int msagaw = 0;
+	int agaw = -1;
+	int msagaw = -1;
 	int err;
 
 	if (!drhd->reg_base_addr) {
@@ -1038,17 +1038,28 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 	}
 
 	err = -EINVAL;
-	agaw = iommu_calculate_agaw(iommu);
-	if (agaw < 0) {
-		pr_err("Cannot get a valid agaw for iommu (seq_id = %d)\n",
-			iommu->seq_id);
-		goto err_unmap;
+	if (cap_sagaw(iommu->cap) == 0) {
+		pr_info("%s: No supported address widths. Not attempting DMA translation.\n",
+			iommu->name);
+		drhd->ignored = 1;
 	}
-	msagaw = iommu_calculate_max_sagaw(iommu);
-	if (msagaw < 0) {
-		pr_err("Cannot get a valid max agaw for iommu (seq_id = %d)\n",
-			iommu->seq_id);
-		goto err_unmap;
+
+	if (!drhd->ignored) {
+		agaw = iommu_calculate_agaw(iommu);
+		if (agaw < 0) {
+			pr_err("Cannot get a valid agaw for iommu (seq_id = %d)\n",
+			       iommu->seq_id);
+			drhd->ignored = 1;
+		}
+	}
+	if (!drhd->ignored) {
+		msagaw = iommu_calculate_max_sagaw(iommu);
+		if (msagaw < 0) {
+			pr_err("Cannot get a valid max agaw for iommu (seq_id = %d)\n",
+			       iommu->seq_id);
+			drhd->ignored = 1;
+			agaw = -1;
+		}
 	}
 	iommu->agaw = agaw;
 	iommu->msagaw = msagaw;
@@ -1077,15 +1088,13 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 	drhd->iommu = iommu;
 
-	if (intel_iommu_enabled)
+	if (intel_iommu_enabled && !drhd->ignored)
 		iommu->iommu_dev = iommu_device_create(NULL, iommu,
 						       intel_iommu_groups,
 						       "%s", iommu->name);
 
 	return 0;
 
-err_unmap:
-	unmap_iommu(iommu);
 error_free_seq_id:
 	dmar_free_seq_id(iommu);
 error:
@@ -1095,7 +1104,8 @@ error:
 
 static void free_iommu(struct intel_iommu *iommu)
 {
-	iommu_device_destroy(iommu->iommu_dev);
+	if (intel_iommu_enabled && iommu->iommu_dev)
+		iommu_device_destroy(iommu->iommu_dev);
 
 	if (iommu->irq) {
 		if (iommu->pr_irq) {
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



