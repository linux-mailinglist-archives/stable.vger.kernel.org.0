Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B7D6E01F
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfGSD6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbfGSD6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:58:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67DA921851;
        Fri, 19 Jul 2019 03:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508680;
        bh=Wr3x8ZZZZHuF7Y+/WDvHqqDNEqTCWfNjBXxp0WKNg4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVs33hqaaBQokpT314lcFB7Gb50iHuRJGcJ4u/BWvg/MMNnea+hNsJGJfeOgFotza
         85x/o82uRWsio4RzlnMNnHiVvuPNeUNTLrrhbXviqSy+V+oJzmLqXIK1JnabLLqCLW
         w8EqvPNIOmqMp5fngiJB5s4inc+jog0A5zQQ57Qk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 031/171] PCI: Return error if cannot probe VF
Date:   Thu, 18 Jul 2019 23:54:22 -0400
Message-Id: <20190719035643.14300-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
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
index ca3793002e2f..74c3df250d9c 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -414,6 +414,9 @@ static int pci_device_probe(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = to_pci_driver(dev->driver);
 
+	if (!pci_device_can_probe(pci_dev))
+		return -ENODEV;
+
 	pci_assign_irq(pci_dev);
 
 	error = pcibios_alloc_irq(pci_dev);
@@ -421,12 +424,10 @@ static int pci_device_probe(struct device *dev)
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

