Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E10A14B6A7
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgA1OED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:04:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbgA1OEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:04:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73C4124683;
        Tue, 28 Jan 2020 14:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220242;
        bh=hw6VUbMIkXnUvUwxwEKXR4DH0FlJ/jYXMi4EMMPRASg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CS/zbQ+84avg1+CNcVCMMRhRN5MooH9AiYJgt5S5KKTS81thsPP9PlSEOcbsn/LUK
         9kJZ/lsVGUepVv6Adhq9MHJjddU0Qh1LyTSgxXq5jReuFZifGqzPpa6O09NBg4WT2r
         WVNzY1V8Fj5/ZJYWW+P0wDKVc252dyaoOfv9u06k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 072/104] iommu/amd: Fix IOMMU perf counter clobbering during init
Date:   Tue, 28 Jan 2020 15:00:33 +0100
Message-Id: <20200128135827.267393392@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 8c17bbf6c8f70058a66305f2e1982552e6ea7f47 upstream.

init_iommu_perf_ctr() clobbers the register when it checks write access
to IOMMU perf counters and fails to restore when they are writable.

Add save and restore to fix it.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Fixes: 30861ddc9cca4 ("perf/x86/amd: Add IOMMU Performance Counter resource management")
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu_init.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1655,27 +1655,39 @@ static int iommu_pc_get_set_reg(struct a
 static void init_iommu_perf_ctr(struct amd_iommu *iommu)
 {
 	struct pci_dev *pdev = iommu->dev;
-	u64 val = 0xabcd, val2 = 0;
+	u64 val = 0xabcd, val2 = 0, save_reg = 0;
 
 	if (!iommu_feature(iommu, FEATURE_PC))
 		return;
 
 	amd_iommu_pc_present = true;
 
+	/* save the value to restore, if writable */
+	if (iommu_pc_get_set_reg(iommu, 0, 0, 0, &save_reg, false))
+		goto pc_false;
+
 	/* Check if the performance counters can be written to */
 	if ((iommu_pc_get_set_reg(iommu, 0, 0, 0, &val, true)) ||
 	    (iommu_pc_get_set_reg(iommu, 0, 0, 0, &val2, false)) ||
-	    (val != val2)) {
-		pci_err(pdev, "Unable to write to IOMMU perf counter.\n");
-		amd_iommu_pc_present = false;
-		return;
-	}
+	    (val != val2))
+		goto pc_false;
+
+	/* restore */
+	if (iommu_pc_get_set_reg(iommu, 0, 0, 0, &save_reg, true))
+		goto pc_false;
 
 	pci_info(pdev, "IOMMU performance counters supported\n");
 
 	val = readl(iommu->mmio_base + MMIO_CNTR_CONF_OFFSET);
 	iommu->max_banks = (u8) ((val >> 12) & 0x3f);
 	iommu->max_counters = (u8) ((val >> 7) & 0xf);
+
+	return;
+
+pc_false:
+	pci_err(pdev, "Unable to read/write to IOMMU perf counter.\n");
+	amd_iommu_pc_present = false;
+	return;
 }
 
 static ssize_t amd_iommu_show_cap(struct device *dev,


