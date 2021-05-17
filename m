Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E725383272
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240557AbhEQOsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241776AbhEQOqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:46:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23E8461965;
        Mon, 17 May 2021 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261284;
        bh=ljpqIVKiHbJo/PLt8SWRlqsfImtXPYOLTR7zHuMruQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6DDoUoFuZ0iIH5hpozxBi0AAX6ioG/p5yAZGudKWT7BtBlG6afjmMkb9F8p7aNAq
         4uA9uUOMGFjh5W1SHcNEz9o2uNxlMmUDhEssCatzbhqYhVxIf3jH7URvsEPjU8Gftf
         PulaPuytKJHQebcC2yVcYbiqjn2xwmFBHqECNWrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Tj (Elloe Linux)" <ml.linux@elloe.vision>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Alexander Monakov <amonakov@ispras.ru>,
        David Coe <david.coe@live.co.uk>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/141] iommu/amd: Remove performance counter pre-initialization test
Date:   Mon, 17 May 2021 16:01:21 +0200
Message-Id: <20210517140243.745600595@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit 994d6608efe4a4c8834bdc5014c86f4bc6aceea6 ]

In early AMD desktop/mobile platforms (during 2013), when the IOMMU
Performance Counter (PMC) support was first introduced in
commit 30861ddc9cca ("perf/x86/amd: Add IOMMU Performance Counter
resource management"), there was a HW bug where the counters could not
be accessed. The result was reading of the counter always return zero.

At the time, the suggested workaround was to add a test logic prior
to initializing the PMC feature to check if the counters can be programmed
and read back the same value. This has been working fine until the more
recent desktop/mobile platforms start enabling power gating for the PMC,
which prevents access to the counters. This results in the PMC support
being disabled unnecesarily.

Unfortunatly, there is no documentation of since which generation
of hardware the original PMC HW bug was fixed. Although, it was fixed
soon after the first introduction of the PMC. Base on this, we assume
that the buggy platforms are less likely to be in used, and it should
be relatively safe to remove this legacy logic.

Link: https://lore.kernel.org/linux-iommu/alpine.LNX.3.20.13.2006030935570.3181@monopod.intra.ispras.ru/
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201753
Cc: Tj (Elloe Linux) <ml.linux@elloe.vision>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Alexander Monakov <amonakov@ispras.ru>
Cc: David Coe <david.coe@live.co.uk>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20210409085848.3908-3-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_init.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 31d7e2d4f304..692401e941a7 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1672,33 +1672,16 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	return 0;
 }
 
-static int iommu_pc_get_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr,
-				u8 fxn, u64 *value, bool is_write);
-
 static void init_iommu_perf_ctr(struct amd_iommu *iommu)
 {
+	u64 val;
 	struct pci_dev *pdev = iommu->dev;
-	u64 val = 0xabcd, val2 = 0, save_reg = 0;
 
 	if (!iommu_feature(iommu, FEATURE_PC))
 		return;
 
 	amd_iommu_pc_present = true;
 
-	/* save the value to restore, if writable */
-	if (iommu_pc_get_set_reg(iommu, 0, 0, 0, &save_reg, false))
-		goto pc_false;
-
-	/* Check if the performance counters can be written to */
-	if ((iommu_pc_get_set_reg(iommu, 0, 0, 0, &val, true)) ||
-	    (iommu_pc_get_set_reg(iommu, 0, 0, 0, &val2, false)) ||
-	    (val != val2))
-		goto pc_false;
-
-	/* restore */
-	if (iommu_pc_get_set_reg(iommu, 0, 0, 0, &save_reg, true))
-		goto pc_false;
-
 	pci_info(pdev, "IOMMU performance counters supported\n");
 
 	val = readl(iommu->mmio_base + MMIO_CNTR_CONF_OFFSET);
@@ -1706,11 +1689,6 @@ static void init_iommu_perf_ctr(struct amd_iommu *iommu)
 	iommu->max_counters = (u8) ((val >> 7) & 0xf);
 
 	return;
-
-pc_false:
-	pci_err(pdev, "Unable to read/write to IOMMU perf counter.\n");
-	amd_iommu_pc_present = false;
-	return;
 }
 
 static ssize_t amd_iommu_show_cap(struct device *dev,
-- 
2.30.2



