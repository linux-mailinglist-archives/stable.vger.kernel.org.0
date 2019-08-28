Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A3BA0BD0
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 22:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfH1UtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 16:49:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbfH1UtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 16:49:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C78922CF8;
        Wed, 28 Aug 2019 20:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567025340;
        bh=0DAZRJbNZgpcJ/ZoMQMTJdyhQPxclpEiQMOFnTX8ZXs=;
        h=Subject:To:From:Date:From;
        b=LBk6dsCOPOgyw3RcTVLG+me/7DHe7ECoZkvsdUA5MiDKONc2WyEuLxhyUDF0niLOe
         oWpWeB2Bq04zGbbsiFOiPovDu4bF/tDIxrbpCWLoQX91Hh+bqaESmJ2mH51i532sV6
         JDg0lGje1+oXejy3At4++9pp2rt/1+5ZP4mjV4wc=
Subject: patch "usb: hcd: use managed device resources" added to usb-linus
To:     Carsten_Schmid@mentor.com, carsten_schmid@mentor.com,
        gregkh@linuxfoundation.org, mathias.nyman@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Aug 2019 22:48:56 +0200
Message-ID: <15670253368211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: hcd: use managed device resources

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 76da906ad727048a74bb8067031ee99fc070c7da Mon Sep 17 00:00:00 2001
From: "Schmid, Carsten" <Carsten_Schmid@mentor.com>
Date: Fri, 23 Aug 2019 14:11:28 +0000
Subject: usb: hcd: use managed device resources

Using managed device resources in usb_hcd_pci_probe() allows devm usage for
resource subranges, such as the mmio resource for the platform device
created to control host/device mode mux, which is a xhci extended
capability, and sits inside the xhci mmio region.

If managed device resources are not used then "parent" resource
is released before subrange at driver removal as .remove callback is
called before the devres list of resources for this device is walked
and released.

This has been observed with the xhci extended capability driver causing a
use-after-free which is now fixed.

An additional nice benefit is that error handling on driver initialisation
is simplified much.

Signed-off-by: Carsten Schmid <carsten_schmid@mentor.com>
Tested-by: Carsten Schmid <carsten_schmid@mentor.com>
Reviewed-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Fixes: fa31b3cb2ae1 ("xhci: Add Intel extended cap / otg phy mux handling")
Cc: <stable@vger.kernel.org> # v4.19+

Link: https://lore.kernel.org/r/1566569488679.31808@mentor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd-pci.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 03432467b05f..7537681355f6 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -216,17 +216,18 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		/* EHCI, OHCI */
 		hcd->rsrc_start = pci_resource_start(dev, 0);
 		hcd->rsrc_len = pci_resource_len(dev, 0);
-		if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
-				driver->description)) {
+		if (!devm_request_mem_region(&dev->dev, hcd->rsrc_start,
+				hcd->rsrc_len, driver->description)) {
 			dev_dbg(&dev->dev, "controller already in use\n");
 			retval = -EBUSY;
 			goto put_hcd;
 		}
-		hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
+		hcd->regs = devm_ioremap_nocache(&dev->dev, hcd->rsrc_start,
+				hcd->rsrc_len);
 		if (hcd->regs == NULL) {
 			dev_dbg(&dev->dev, "error mapping memory\n");
 			retval = -EFAULT;
-			goto release_mem_region;
+			goto put_hcd;
 		}
 
 	} else {
@@ -240,8 +241,8 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 			hcd->rsrc_start = pci_resource_start(dev, region);
 			hcd->rsrc_len = pci_resource_len(dev, region);
-			if (request_region(hcd->rsrc_start, hcd->rsrc_len,
-					driver->description))
+			if (devm_request_region(&dev->dev, hcd->rsrc_start,
+					hcd->rsrc_len, driver->description))
 				break;
 		}
 		if (region == PCI_ROM_RESOURCE) {
@@ -275,20 +276,13 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	}
 
 	if (retval != 0)
-		goto unmap_registers;
+		goto put_hcd;
 	device_wakeup_enable(hcd->self.controller);
 
 	if (pci_dev_run_wake(dev))
 		pm_runtime_put_noidle(&dev->dev);
 	return retval;
 
-unmap_registers:
-	if (driver->flags & HCD_MEMORY) {
-		iounmap(hcd->regs);
-release_mem_region:
-		release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-	} else
-		release_region(hcd->rsrc_start, hcd->rsrc_len);
 put_hcd:
 	usb_put_hcd(hcd);
 disable_pci:
@@ -347,14 +341,6 @@ void usb_hcd_pci_remove(struct pci_dev *dev)
 		dev_set_drvdata(&dev->dev, NULL);
 		up_read(&companions_rwsem);
 	}
-
-	if (hcd->driver->flags & HCD_MEMORY) {
-		iounmap(hcd->regs);
-		release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-	} else {
-		release_region(hcd->rsrc_start, hcd->rsrc_len);
-	}
-
 	usb_put_hcd(hcd);
 	pci_disable_device(dev);
 }
-- 
2.23.0


