Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9766DBC3
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731848AbfGSELW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbfGSELW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:11:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3991121873;
        Fri, 19 Jul 2019 04:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509481;
        bh=lTpd3BwJntjvisbyb/KkUvM8RQIScLiS5UOe+xKdDrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IK5y7uGNwssdy/6IMIpU1xh/iUIngh849+YaD94uVrjPS8aMcKCIWlgO8lykg+VF2
         1g3zSWOa9apHjCxADf7uNsxdLBP/7c+KIdv5uN1mbIAM+iKa+37cedi8d1bLGsJfsw
         5pStqknUABx0rz8M3SJoYXLKJ1WMV80HckPej+yo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/60] PCI: Return error if cannot probe VF
Date:   Fri, 19 Jul 2019 00:10:16 -0400
Message-Id: <20190719041109.18262-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041109.18262-1-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 76002d8b48c4b08c9bd414517dd295e132ad910b ]

Commit 0e7df22401a3 ("PCI: Add sysfs sriov_drivers_autoprobe to control
VF driver binding") allows the user to specify that drivers for VFs of
a PF should not be probed, but it actually causes pci_device_probe() to
return success back to the driver core in this case.  Therefore by all
sysfs appearances the device is bound to a driver, the driver link from
the device exists as does the device link back from the driver, yet the
driver's probe function is never called on the device.  We also fail to
do any sort of cleanup when we're prohibited from probing the device,
the IRQ setup remains in place and we even hold a device reference.

Instead, abort with errno before any setup or references are taken when
pci_device_can_probe() prevents us from trying to probe the device.

Link: https://lore.kernel.org/lkml/155672991496.20698.4279330795743262888.stgit@gimli.home
Fixes: 0e7df22401a3 ("PCI: Add sysfs sriov_drivers_autoprobe to control VF driver binding")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index ea69b4dbab66..e5a8bf2c9b37 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -415,6 +415,9 @@ static int pci_device_probe(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = to_pci_driver(dev->driver);
 
+	if (!pci_device_can_probe(pci_dev))
+		return -ENODEV;
+
 	pci_assign_irq(pci_dev);
 
 	error = pcibios_alloc_irq(pci_dev);
@@ -422,12 +425,10 @@ static int pci_device_probe(struct device *dev)
 		return error;
 
 	pci_dev_get(pci_dev);
-	if (pci_device_can_probe(pci_dev)) {
-		error = __pci_device_probe(drv, pci_dev);
-		if (error) {
-			pcibios_free_irq(pci_dev);
-			pci_dev_put(pci_dev);
-		}
+	error = __pci_device_probe(drv, pci_dev);
+	if (error) {
+		pcibios_free_irq(pci_dev);
+		pci_dev_put(pci_dev);
 	}
 
 	return error;
-- 
2.20.1

