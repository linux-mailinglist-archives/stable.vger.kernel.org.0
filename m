Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E0933EC3D
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 10:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCQJLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 05:11:17 -0400
Received: from 8bytes.org ([81.169.241.247]:59408 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhCQJKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 05:10:48 -0400
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 27EBE3A4;
        Wed, 17 Mar 2021 10:10:42 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     iommu@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Xiaojian Du <xiaojian.du@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: [PATCH 1/3] iommu/amd: Move Stoney Ridge check to detect_ivrs()
Date:   Wed, 17 Mar 2021 10:10:35 +0100
Message-Id: <20210317091037.31374-2-joro@8bytes.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210317091037.31374-1-joro@8bytes.org>
References: <20210317091037.31374-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The AMD IOMMU will not be enabled on AMD Stoney Ridge systems. Bail
out even earlier and refuse to even detect the IOMMU there.

References: https://bugzilla.kernel.org/show_bug.cgi?id=212133
References: https://bugzilla.suse.com/show_bug.cgi?id=1183132
Cc: stable@vger.kernel.org # v5.11
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd/init.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 9126efcbaf2c..3280e6f5b720 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2714,7 +2714,6 @@ static int __init early_amd_iommu_init(void)
 	struct acpi_table_header *ivrs_base;
 	int i, remap_cache_sz, ret;
 	acpi_status status;
-	u32 pci_id;
 
 	if (!amd_iommu_detected)
 		return -ENODEV;
@@ -2804,16 +2803,6 @@ static int __init early_amd_iommu_init(void)
 	if (ret)
 		goto out;
 
-	/* Disable IOMMU if there's Stoney Ridge graphics */
-	for (i = 0; i < 32; i++) {
-		pci_id = read_pci_config(0, i, 0, 0);
-		if ((pci_id & 0xffff) == 0x1002 && (pci_id >> 16) == 0x98e4) {
-			pr_info("Disable IOMMU on Stoney Ridge\n");
-			amd_iommu_disabled = true;
-			break;
-		}
-	}
-
 	/* Disable any previously enabled IOMMUs */
 	if (!is_kdump_kernel() || amd_iommu_disabled)
 		disable_iommus();
@@ -2880,6 +2869,7 @@ static bool detect_ivrs(void)
 {
 	struct acpi_table_header *ivrs_base;
 	acpi_status status;
+	int i;
 
 	status = acpi_get_table("IVRS", 0, &ivrs_base);
 	if (status == AE_NOT_FOUND)
@@ -2892,6 +2882,17 @@ static bool detect_ivrs(void)
 
 	acpi_put_table(ivrs_base);
 
+	/* Don't use IOMMU if there is Stoney Ridge graphics */
+	for (i = 0; i < 32; i++) {
+		u32 pci_id;
+
+		pci_id = read_pci_config(0, i, 0, 0);
+		if ((pci_id & 0xffff) == 0x1002 && (pci_id >> 16) == 0x98e4) {
+			pr_info("Disable IOMMU on Stoney Ridge\n");
+			return false;
+		}
+	}
+
 	/* Make sure ACS will be enabled during PCI probe */
 	pci_request_acs();
 
-- 
2.30.2

