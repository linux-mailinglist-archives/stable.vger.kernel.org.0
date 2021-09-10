Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C66406268
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241899AbhIJApt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233812AbhIJAVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0F91611AF;
        Fri, 10 Sep 2021 00:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233237;
        bh=TNeNuau0moeDepANayCoJV//GuLUT65NteR36ZD76H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4AFMlWB7zGElZUKHZ8cdSxj8BoY25AIngkoqsaVylF81TnYIKoIiWKmBYUJHkeO4
         a8SNUpobwNlUF9sry4LeMeeL9PZTj4S3y2zr4WiesU7mbNY66aRsdWUZXya4Wur4Ru
         yi7HyRswm6BgroDI6c0kx5yw296HNvNqHUy5Cm1fxwOWYu+ouMMQh6dntgY45Jakhu
         ukGUqRTyPLD0pet3kUQovXYtOO0zQ8FsO3JG6JkvqdgraR70+bxRqTCg0eOd/oB2TK
         vuHCkO4YxNJsyldCdt5wDyb2pnlHmgL4soBl/lc1e4unt3IWB2mWtYtyQtLwei5ObD
         nBqi7Xr+HlDlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 06/53] iommu/amd: Fix printing of IOMMU events when rate limiting kicks in
Date:   Thu,  9 Sep 2021 20:19:41 -0400
Message-Id: <20210910002028.175174-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lennert Buytenhek <buytenh@wantstofly.org>

[ Upstream commit ee974d9625c405977ef5d9aedc476be1d0362ebf ]

For the printing of RMP_HW_ERROR / RMP_PAGE_FAULT / IO_PAGE_FAULT
events, the AMD IOMMU code uses such logic:

	if (pdev)
		dev_data = dev_iommu_priv_get(&pdev->dev);

	if (dev_data && __ratelimit(&dev_data->rs)) {
		pci_err(pdev, ...
	} else {
		printk_ratelimit() / pr_err{,_ratelimited}(...
	}

This means that if we receive an event for a PCI devid which actually
does have a struct pci_dev and an attached struct iommu_dev_data, but
rate limiting kicks in, we'll fall back to the non-PCI branch of the
test, and print the event in a different format.

Fix this by changing the logic to:

	if (dev_data) {
		if (__ratelimit(&dev_data->rs)) {
			pci_err(pdev, ...
		}
	} else {
		pr_err_ratelimited(...
	}

Suggested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/YPgk1dD1gPMhJXgY@wantstofly.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 5f1195791cb1..4c97aa81b836 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -502,9 +502,11 @@ static void amd_iommu_report_rmp_hw_error(volatile u32 *event)
 	if (pdev)
 		dev_data = dev_iommu_priv_get(&pdev->dev);
 
-	if (dev_data && __ratelimit(&dev_data->rs)) {
-		pci_err(pdev, "Event logged [RMP_HW_ERROR vmg_tag=0x%04x, spa=0x%llx, flags=0x%04x]\n",
-			vmg_tag, spa, flags);
+	if (dev_data) {
+		if (__ratelimit(&dev_data->rs)) {
+			pci_err(pdev, "Event logged [RMP_HW_ERROR vmg_tag=0x%04x, spa=0x%llx, flags=0x%04x]\n",
+				vmg_tag, spa, flags);
+		}
 	} else {
 		pr_err_ratelimited("Event logged [RMP_HW_ERROR device=%02x:%02x.%x, vmg_tag=0x%04x, spa=0x%llx, flags=0x%04x]\n",
 			PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
@@ -533,9 +535,11 @@ static void amd_iommu_report_rmp_fault(volatile u32 *event)
 	if (pdev)
 		dev_data = dev_iommu_priv_get(&pdev->dev);
 
-	if (dev_data && __ratelimit(&dev_data->rs)) {
-		pci_err(pdev, "Event logged [RMP_PAGE_FAULT vmg_tag=0x%04x, gpa=0x%llx, flags_rmp=0x%04x, flags=0x%04x]\n",
-			vmg_tag, gpa, flags_rmp, flags);
+	if (dev_data) {
+		if (__ratelimit(&dev_data->rs)) {
+			pci_err(pdev, "Event logged [RMP_PAGE_FAULT vmg_tag=0x%04x, gpa=0x%llx, flags_rmp=0x%04x, flags=0x%04x]\n",
+				vmg_tag, gpa, flags_rmp, flags);
+		}
 	} else {
 		pr_err_ratelimited("Event logged [RMP_PAGE_FAULT device=%02x:%02x.%x, vmg_tag=0x%04x, gpa=0x%llx, flags_rmp=0x%04x, flags=0x%04x]\n",
 			PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
@@ -557,11 +561,13 @@ static void amd_iommu_report_page_fault(u16 devid, u16 domain_id,
 	if (pdev)
 		dev_data = dev_iommu_priv_get(&pdev->dev);
 
-	if (dev_data && __ratelimit(&dev_data->rs)) {
-		pci_err(pdev, "Event logged [IO_PAGE_FAULT domain=0x%04x address=0x%llx flags=0x%04x]\n",
-			domain_id, address, flags);
-	} else if (printk_ratelimit()) {
-		pr_err("Event logged [IO_PAGE_FAULT device=%02x:%02x.%x domain=0x%04x address=0x%llx flags=0x%04x]\n",
+	if (dev_data) {
+		if (__ratelimit(&dev_data->rs)) {
+			pci_err(pdev, "Event logged [IO_PAGE_FAULT domain=0x%04x address=0x%llx flags=0x%04x]\n",
+				domain_id, address, flags);
+		}
+	} else {
+		pr_err_ratelimited("Event logged [IO_PAGE_FAULT device=%02x:%02x.%x domain=0x%04x address=0x%llx flags=0x%04x]\n",
 			PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 			domain_id, address, flags);
 	}
-- 
2.30.2

