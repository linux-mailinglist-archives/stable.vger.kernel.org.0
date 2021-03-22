Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C454C34411F
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhCVMbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230357AbhCVMad (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:30:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 143D7619CA;
        Mon, 22 Mar 2021 12:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416231;
        bh=nugPyNUMDkdt/fH6GUHIwQhF5AC2nqWt3VfotsUcTXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTV/lo9Iv/eFfHn5Bg20NwEh35u7VdizVvDlbmyS/lmytR/d500pPrEz4C402MnJc
         TOen4jg3uDJY0H5pSf9ANAjePK+p3f0f9K097EYdCuQQdv8bzigPwcS2hPwoJ3zmMN
         YeXtSajTN1meXUDqjXTmaZBDkUsKH+I23+FAvMp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.11 028/120] iommu/amd: Move Stoney Ridge check to detect_ivrs()
Date:   Mon, 22 Mar 2021 13:26:51 +0100
Message-Id: <20210322121930.596334252@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 072a03e0a0b1bc22eb5970727877264657c61fd3 upstream.

The AMD IOMMU will not be enabled on AMD Stoney Ridge systems. Bail
out even earlier and refuse to even detect the IOMMU there.

Cc: stable@vger.kernel.org # v5.11
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20210317091037.31374-2-joro@8bytes.org
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2712,7 +2712,6 @@ static int __init early_amd_iommu_init(v
 	struct acpi_table_header *ivrs_base;
 	acpi_status status;
 	int i, remap_cache_sz, ret = 0;
-	u32 pci_id;
 
 	if (!amd_iommu_detected)
 		return -ENODEV;
@@ -2802,16 +2801,6 @@ static int __init early_amd_iommu_init(v
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
@@ -2879,6 +2868,7 @@ static bool detect_ivrs(void)
 {
 	struct acpi_table_header *ivrs_base;
 	acpi_status status;
+	int i;
 
 	status = acpi_get_table("IVRS", 0, &ivrs_base);
 	if (status == AE_NOT_FOUND)
@@ -2891,6 +2881,17 @@ static bool detect_ivrs(void)
 
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
 


