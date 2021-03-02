Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4B732AF0B
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhCCAOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240163AbhCBL7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 06:59:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFF4D64F1F;
        Tue,  2 Mar 2021 11:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686153;
        bh=bTF6eS8rQHKgs/nfkztSQV06/8ZuGnFy2R703xIO9VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7pss65dsrCaJQwUq1RV8ZFd+SkPdm9d0HaSvziIchicV1cl11Ok3Iw4pc4lrYZiG
         QPJ7UOOj99u66N1Nl/I5n1psjHqqjKdjzOW4kEP+b+817rjP9hQNJhVskzR7PBt+GC
         Av6LjvtObpT59R94P70SlCkklIBliOT3d9fF+ZCG9vVxuNiGiKisZXREMebCLFfdA3
         nv3AYNR6ai5hhPAoifeUyEEOA3ZW+Mj+6OKocx5qq0Qzm3ovRyYHRA+E/h5+e0GfI5
         UzJRYYEH+MhFlUsYTNe/iGCOTVizEOgyY8yhiA2mrb3JgWVdY5gotGAWrZTCv4555E
         TSdC/dnbuonKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 14/52] platform/x86: amd-pmc: put device on error paths
Date:   Tue,  2 Mar 2021 06:54:55 -0500
Message-Id: <20210302115534.61800-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 745ed17a04f966406c8c27c8f992544336c06013 ]

Put the PCI device rdev on error paths to fix potential reference count
leaks.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210121045005.73342-1-bianpan2016@163.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd-pmc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index ef8342572463..b9da58ee9b1e 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -210,31 +210,39 @@ static int amd_pmc_probe(struct platform_device *pdev)
 	dev->dev = &pdev->dev;
 
 	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
-	if (!rdev || !pci_match_id(pmc_pci_ids, rdev))
+	if (!rdev || !pci_match_id(pmc_pci_ids, rdev)) {
+		pci_dev_put(rdev);
 		return -ENODEV;
+	}
 
 	dev->cpu_id = rdev->device;
 	err = pci_write_config_dword(rdev, AMD_PMC_SMU_INDEX_ADDRESS, AMD_PMC_BASE_ADDR_LO);
 	if (err) {
 		dev_err(dev->dev, "error writing to 0x%x\n", AMD_PMC_SMU_INDEX_ADDRESS);
+		pci_dev_put(rdev);
 		return pcibios_err_to_errno(err);
 	}
 
 	err = pci_read_config_dword(rdev, AMD_PMC_SMU_INDEX_DATA, &val);
-	if (err)
+	if (err) {
+		pci_dev_put(rdev);
 		return pcibios_err_to_errno(err);
+	}
 
 	base_addr_lo = val & AMD_PMC_BASE_ADDR_HI_MASK;
 
 	err = pci_write_config_dword(rdev, AMD_PMC_SMU_INDEX_ADDRESS, AMD_PMC_BASE_ADDR_HI);
 	if (err) {
 		dev_err(dev->dev, "error writing to 0x%x\n", AMD_PMC_SMU_INDEX_ADDRESS);
+		pci_dev_put(rdev);
 		return pcibios_err_to_errno(err);
 	}
 
 	err = pci_read_config_dword(rdev, AMD_PMC_SMU_INDEX_DATA, &val);
-	if (err)
+	if (err) {
+		pci_dev_put(rdev);
 		return pcibios_err_to_errno(err);
+	}
 
 	base_addr_hi = val & AMD_PMC_BASE_ADDR_LO_MASK;
 	pci_dev_put(rdev);
-- 
2.30.1

