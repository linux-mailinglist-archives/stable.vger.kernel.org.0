Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D362ACD5F
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733129AbgKJDzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:55:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733113AbgKJDzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:55:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC9A5221F1;
        Tue, 10 Nov 2020 03:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980521;
        bh=NUTZyNioEXke4Hr4cRd0ILcwsd3Nj7fg0IyQ+JFoBVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoDsqMfOdQD8PYgIx/hLXLXXHvCA+votRyjgDUOKmii1xbow0kCXSSHlwe7O+2TI5
         P9dSs3Nr6tDKy14RFax69n9cwDL1aMmoqLvmBERSTUyCELt03UiGnGbp3iUQIHpw5w
         08LTHNZQ8fqj9kX0Z1/ZbfyCCuXmbTDCgM7Jn6AU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 29/42] iommu/amd: Increase interrupt remapping table limit to 512 entries
Date:   Mon,  9 Nov 2020 22:54:27 -0500
Message-Id: <20201110035440.424258-29-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit 73db2fc595f358460ce32bcaa3be1f0cce4a2db1 ]

Certain device drivers allocate IO queues on a per-cpu basis.
On AMD EPYC platform, which can support up-to 256 cpu threads,
this can exceed the current MAX_IRQ_PER_TABLE limit of 256,
and result in the error message:

    AMD-Vi: Failed to allocate IRTE

This has been observed with certain NVME devices.

AMD IOMMU hardware can actually support upto 512 interrupt
remapping table entries. Therefore, update the driver to
match the hardware limit.

Please note that this also increases the size of interrupt remapping
table to 8KB per device when using the 128-bit IRTE format.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20201015025002.87997-1-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_types.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 0679896b9e2e1..3ec090adcdae7 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -406,7 +406,11 @@ extern bool amd_iommu_np_cache;
 /* Only true if all IOMMUs support device IOTLBs */
 extern bool amd_iommu_iotlb_sup;
 
-#define MAX_IRQS_PER_TABLE	256
+/*
+ * AMD IOMMU hardware only support 512 IRTEs despite
+ * the architectural limitation of 2048 entries.
+ */
+#define MAX_IRQS_PER_TABLE	512
 #define IRQ_TABLE_ALIGNMENT	128
 
 struct irq_remap_table {
-- 
2.27.0

