Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E8220E7F1
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387988AbgF2WBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbgF2SfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22A94246F0;
        Mon, 29 Jun 2020 15:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444036;
        bh=N0ijplVvcF9uZZu2JhVQaZooxRDw2w5dSphqSIH3Ues=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNwePhBpU7mCNWm7uy37TKScrR1Rq/UbL0seA4C0ye0H3Rif3r4Ph+SUavBAMQHIl
         HmA+odM3qR8GpOqOFsMYsvJxjzT4BWQUmGzB7IOjB5rhSAj+NugXgZVdRaSJ8IflTL
         rBUAuouNF7xUqWqFTM6o/IU1PvvmnXUAhgbV6oR8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Lalithambika Krishnakumar <lalithambika.krishnakumar@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 143/265] iommu/vt-d: Enable PCI ACS for platform opt in hint
Date:   Mon, 29 Jun 2020 11:16:16 -0400
Message-Id: <20200629151818.2493727-144-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 50310600ebda74b9988467e2e6128711c7ba56fc ]

PCI ACS is disabled if Intel IOMMU is off by default or intel_iommu=off
is used in command line. Unfortunately, Intel IOMMU will be forced on if
there're devices sitting on an external facing PCI port that is marked
as untrusted (for example, thunderbolt peripherals). That means, PCI ACS
is disabled while Intel IOMMU is forced on to isolate those devices. As
the result, the devices of an MFD will be grouped by a single group even
the ACS is supported on device.

[    0.691263] pci 0000:00:07.1: Adding to iommu group 3
[    0.691277] pci 0000:00:07.2: Adding to iommu group 3
[    0.691292] pci 0000:00:07.3: Adding to iommu group 3

Fix it by requesting PCI ACS when Intel IOMMU is detected with platform
opt in hint.

Fixes: 89a6079df791a ("iommu/vt-d: Force IOMMU on for platform opt in hint")
Co-developed-by: Lalithambika Krishnakumar <lalithambika.krishnakumar@intel.com>
Signed-off-by: Lalithambika Krishnakumar <lalithambika.krishnakumar@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Link: https://lore.kernel.org/r/20200622231345.29722-5-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dmar.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index f77dae7ba7d40..7df5621bba8de 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -898,7 +898,8 @@ int __init detect_intel_iommu(void)
 	if (!ret)
 		ret = dmar_walk_dmar_table((struct acpi_table_dmar *)dmar_tbl,
 					   &validate_drhd_cb);
-	if (!ret && !no_iommu && !iommu_detected && !dmar_disabled) {
+	if (!ret && !no_iommu && !iommu_detected &&
+	    (!dmar_disabled || dmar_platform_optin())) {
 		iommu_detected = 1;
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
-- 
2.25.1

