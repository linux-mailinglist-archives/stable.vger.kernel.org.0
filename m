Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7456933B873
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhCOODd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231990AbhCOOAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 520F764F18;
        Mon, 15 Mar 2021 14:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816803;
        bh=enOh4DF4ELE20QCSde+JnHmzf2w8hW8NSNxMlRnX/uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZTwnIIq+XSLs2DKoxcjT2ZcPjDyVRMXXz0yWiPTRIa07Q5FTrMPlIG8xkq3N5C18
         wzw92TZ+oFZnv2YZjLQZleoB8CW0zDSzPry5MkULGqJYepGdAlQmCPf8ee7zNsPm8V
         Vf9+DrRw4+qmR1qC4bnZt0Ii1dZdg0F+ruaBz3xg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 134/306] platform/x86: amd-pmc: put device on error paths
Date:   Mon, 15 Mar 2021 14:53:17 +0100
Message-Id: <20210315135512.178419088@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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



