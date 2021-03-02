Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDAA32AF2F
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhCCAPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1443537AbhCBMLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:11:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F9D764F60;
        Tue,  2 Mar 2021 11:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686233;
        bh=YzbiNQhdh942VLjsdediUsjqpUuko2qfgVUPR6Cn+aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNFTxbBwoO6gwDasHbmzw8rCob/OqC7Pyra1hJRRnWM8B3fOR4VojbYvmwqJJI7L1
         xG4evv1nYqwpA5AsMkSMpSIlXywONeYs1UbZOG2nI8/5xjWagaqa5JvnW8ECtc0zpa
         IZkJ6xsD1ALKPhW+3DgnrtQDoqn9lbMWSeWWe+zr/4TKDNRxJp5Y58aWs2M1AZPr7R
         DAmeFhsOi4iOqgmFfkeCx5CdjzooWlxTq9bDhdx09S1ZznXKl4pfr8V6eCeF+2oPxU
         4IBCmbM/rV680xxdDQPkH6s2s4VnZBrPtSNDnRV39G2lhPOtwwRcGLn2zGxHufVKTr
         JNQ14e8eCk3vA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tj <ml.linux@elloe.vision>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 21/47] iommu/amd: Fix performance counter initialization
Date:   Tue,  2 Mar 2021 06:56:20 -0500
Message-Id: <20210302115646.62291-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit 6778ff5b21bd8e78c8bd547fd66437cf2657fd9b ]

Certain AMD platforms enable power gating feature for IOMMU PMC,
which prevents the IOMMU driver from updating the counter while
trying to validate the PMC functionality in the init_iommu_perf_ctr().
This results in disabling PMC support and the following error message:

    "AMD-Vi: Unable to read/write to IOMMU perf counter"

To workaround this issue, disable power gating temporarily by programming
the counter source to non-zero value while validating the counter,
and restore the prior state afterward.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Tj (Elloe Linux) <ml.linux@elloe.vision>
Link: https://lore.kernel.org/r/20210208122712.5048-1-suravee.suthikulpanit@amd.com
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201753
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 45 ++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index c842545368fd..3c215f0a6052 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -12,6 +12,7 @@
 #include <linux/acpi.h>
 #include <linux/list.h>
 #include <linux/bitmap.h>
+#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
@@ -254,6 +255,8 @@ static enum iommu_init_state init_state = IOMMU_START_STATE;
 static int amd_iommu_enable_interrupts(void);
 static int __init iommu_go_to_state(enum iommu_init_state state);
 static void init_device_table_dma(void);
+static int iommu_pc_get_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr,
+				u8 fxn, u64 *value, bool is_write);
 
 static bool amd_iommu_pre_enabled = true;
 
@@ -1717,13 +1720,11 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	return 0;
 }
 
-static int iommu_pc_get_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr,
-				u8 fxn, u64 *value, bool is_write);
-
-static void init_iommu_perf_ctr(struct amd_iommu *iommu)
+static void __init init_iommu_perf_ctr(struct amd_iommu *iommu)
 {
+	int retry;
 	struct pci_dev *pdev = iommu->dev;
-	u64 val = 0xabcd, val2 = 0, save_reg = 0;
+	u64 val = 0xabcd, val2 = 0, save_reg, save_src;
 
 	if (!iommu_feature(iommu, FEATURE_PC))
 		return;
@@ -1731,17 +1732,39 @@ static void init_iommu_perf_ctr(struct amd_iommu *iommu)
 	amd_iommu_pc_present = true;
 
 	/* save the value to restore, if writable */
-	if (iommu_pc_get_set_reg(iommu, 0, 0, 0, &save_reg, false))
+	if (iommu_pc_get_set_reg(iommu, 0, 0, 0, &save_reg, false) ||
+	    iommu_pc_get_set_reg(iommu, 0, 0, 8, &save_src, false))
 		goto pc_false;
 
-	/* Check if the performance counters can be written to */
-	if ((iommu_pc_get_set_reg(iommu, 0, 0, 0, &val, true)) ||
-	    (iommu_pc_get_set_reg(iommu, 0, 0, 0, &val2, false)) ||
-	    (val != val2))
+	/*
+	 * Disable power gating by programing the performance counter
+	 * source to 20 (i.e. counts the reads and writes from/to IOMMU
+	 * Reserved Register [MMIO Offset 1FF8h] that are ignored.),
+	 * which never get incremented during this init phase.
+	 * (Note: The event is also deprecated.)
+	 */
+	val = 20;
+	if (iommu_pc_get_set_reg(iommu, 0, 0, 8, &val, true))
 		goto pc_false;
 
+	/* Check if the performance counters can be written to */
+	val = 0xabcd;
+	for (retry = 5; retry; retry--) {
+		if (iommu_pc_get_set_reg(iommu, 0, 0, 0, &val, true) ||
+		    iommu_pc_get_set_reg(iommu, 0, 0, 0, &val2, false) ||
+		    val2)
+			break;
+
+		/* Wait about 20 msec for power gating to disable and retry. */
+		msleep(20);
+	}
+
 	/* restore */
-	if (iommu_pc_get_set_reg(iommu, 0, 0, 0, &save_reg, true))
+	if (iommu_pc_get_set_reg(iommu, 0, 0, 0, &save_reg, true) ||
+	    iommu_pc_get_set_reg(iommu, 0, 0, 8, &save_src, true))
+		goto pc_false;
+
+	if (val != val2)
 		goto pc_false;
 
 	pci_info(pdev, "IOMMU performance counters supported\n");
-- 
2.30.1

