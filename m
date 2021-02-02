Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4AB30B3C3
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 01:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhBBABg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 19:01:36 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:53156 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhBBABg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 19:01:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1612224096; x=1643760096;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=6p9sC7OznRE22vf7PBQKgzgdtSRrOgLUqfWXjd4Jf3o=;
  b=UPOC2P3YME7+Y6ah3I0eVlITMEa4WT0vB0NtdOotnLAqkY5Van1U4Fw4
   agW0EV0Df/GSJ3YJOE7R9l7ADMtlvH+hJod4Wic4jX1xKvFKk4LCZg07w
   Wp24vHTAIWf3CwMFbvElbNiTeRBbybkdnHL48sQFYWxntDZbUCV2jMahn
   0=;
X-IronPort-AV: E=Sophos;i="5.79,393,1602547200"; 
   d="scan'208";a="115041009"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Feb 2021 00:00:49 +0000
Received: from EX13D02EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id 5D630A509F;
        Tue,  2 Feb 2021 00:00:48 +0000 (UTC)
Received: from u2196cf9297dc59.ant.amazon.com (10.43.160.67) by
 EX13D02EUC001.ant.amazon.com (10.43.164.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 2 Feb 2021 00:00:44 +0000
From:   Filippo Sironi <sironi@amazon.de>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <samjonas@amazon.com>,
        <dwmw@amazon.co.uk>, <sironi@amazon.de>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/2 for Linux 5.4] iommu/vt-d: Gracefully handle DMAR units with no supported address widths
Date:   Tue, 2 Feb 2021 01:00:08 +0100
Message-ID: <20210202000009.31392-1-sironi@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.67]
X-ClientProxiedBy: EX13D21UWA001.ant.amazon.com (10.43.160.154) To
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
[ context change due to moving drivers/iommu/dmar.c to
  drivers/iommu/intel/dmar.c ]
Signed-off-by: Filippo Sironi <sironi@amazon.de>
---
 drivers/iommu/dmar.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 30ac0ba55864..a5f69d9bb0b8 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1020,8 +1020,8 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 {
 	struct intel_iommu *iommu;
 	u32 ver, sts;
-	int agaw = 0;
-	int msagaw = 0;
+	int agaw = -1;
+	int msagaw = -1;
 	int err;
 
 	if (!drhd->reg_base_addr) {
@@ -1046,17 +1046,28 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
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
@@ -1083,7 +1094,12 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 	raw_spin_lock_init(&iommu->register_lock);
 
-	if (intel_iommu_enabled) {
+	/*
+	 * This is only for hotplug; at boot time intel_iommu_enabled won't
+	 * be set yet. When intel_iommu_init() runs, it registers the units
+	 * present at boot time, then sets intel_iommu_enabled.
+	 */
+	if (intel_iommu_enabled && !drhd->ignored) {
 		err = iommu_device_sysfs_add(&iommu->iommu, NULL,
 					     intel_iommu_groups,
 					     "%s", iommu->name);
@@ -1112,7 +1128,7 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 static void free_iommu(struct intel_iommu *iommu)
 {
-	if (intel_iommu_enabled) {
+	if (intel_iommu_enabled && iommu->iommu.ops) {
 		iommu_device_unregister(&iommu->iommu);
 		iommu_device_sysfs_remove(&iommu->iommu);
 	}
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



