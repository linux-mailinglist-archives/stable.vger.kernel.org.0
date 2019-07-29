Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 606B479607
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390404AbfG2TsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389865AbfG2TsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:48:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B7A72054F;
        Mon, 29 Jul 2019 19:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429680;
        bh=jXlO8j8Fx+efNlMQQgDG1iYRyDnfliVXH8C6VZT2Y20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Km8nzHituFUtq360yjd8Gf7D7UxHvqkZxSRZHBBIilYldAjwh2h9zzRVFJDOqhQy
         W4zgXlfIedmGAj4Cr+wJECkCZba2MaBmnWUdjTw11FR3mbJq95z7Ncht1r9jY33T3w
         QDvupsVaCA8pVfA1OL29SOPg2uUy+iNEtFNQNGQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 033/215] PCI: Return error if cannot probe VF
Date:   Mon, 29 Jul 2019 21:20:29 +0200
Message-Id: <20190729190746.003481454@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



