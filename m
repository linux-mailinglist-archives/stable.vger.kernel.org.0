Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1101733B74D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbhCOOAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232578AbhCON7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A177564F36;
        Mon, 15 Mar 2021 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816733;
        bh=E6L1ViRChtkXMTUfLP3efK4P2ULEUCJV6xETP+6GhfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdnUejqysKVg2gFnI1NdVIytd2GAcbtTP9NCZAfWjLggzMr6FhwUeF5/D1BvgJCV+
         3clWtrvz5H6C7tK7PnyAFA/jy5OChbNrN6g42+v5zadH4BqieHfNREfQGhT8hOShLm
         mZ/wJ33PhonSVhHFNa3ZFcsVCBcSWmL90DFXXdgc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "Tj (Elloe Linux)" <ml.linux@elloe.vision>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/168] iommu/amd: Fix performance counter initialization
Date:   Mon, 15 Mar 2021 14:55:06 +0100
Message-Id: <20210315135552.819844141@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 drivers/iommu/amd_iommu_init.c | 45 +++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 31d7e2d4f304..ad714ff375f8 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -12,6 +12,7 @@
 #include <linux/acpi.h>
 #include <linux/list.h>
 #include <linux/bitmap.h>
+#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
@@ -253,6 +254,8 @@ static enum iommu_init_state init_state = IOMMU_START_STATE;
 static int amd_iommu_enable_interrupts(void);
 static int __init iommu_go_to_state(enum iommu_init_state state);
 static void init_device_table_dma(void);
+static int iommu_pc_get_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr,
+				u8 fxn, u64 *value, bool is_write);
 
 static bool amd_iommu_pre_enabled = true;
 
@@ -1672,13 +1675,11 @@ static int __init init_iommu_all(struct acpi_table_header *table)
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
@@ -1686,17 +1687,39 @@ static void init_iommu_perf_ctr(struct amd_iommu *iommu)
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



