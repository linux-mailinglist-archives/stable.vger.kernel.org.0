Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0C2A90EC
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390517AbfIDSMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390511AbfIDSMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:12:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A510B2341D;
        Wed,  4 Sep 2019 18:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620750;
        bh=YhZYuhnmS9tdig3xXuI3dsas3LT8WuW+r+Q0IcMXP2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRXsV58I6UZ63X59QLT0TwYXq5XrTRUJhKtYVdLVkKJMauXe/NmGqGxeKioJfJZlZ
         F7FyzqBEbPEsF0sNYYopMRWZJ5GZeX83NvRo/v5043op4Fy0BPCI6psKJNWsFHMo/J
         /hIjA2juLDbm+J5F5pvDCLZjPZv5NrA/4i8JErI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carsten Schmid <carsten_schmid@mentor.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.2 081/143] usb: hcd: use managed device resources
Date:   Wed,  4 Sep 2019 19:53:44 +0200
Message-Id: <20190904175317.230745302@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Schmid, Carsten <Carsten_Schmid@mentor.com>

commit 76da906ad727048a74bb8067031ee99fc070c7da upstream.

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
 drivers/usb/core/hcd-pci.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -216,17 +216,18 @@ int usb_hcd_pci_probe(struct pci_dev *de
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
@@ -240,8 +241,8 @@ int usb_hcd_pci_probe(struct pci_dev *de
 
 			hcd->rsrc_start = pci_resource_start(dev, region);
 			hcd->rsrc_len = pci_resource_len(dev, region);
-			if (request_region(hcd->rsrc_start, hcd->rsrc_len,
-					driver->description))
+			if (devm_request_region(&dev->dev, hcd->rsrc_start,
+					hcd->rsrc_len, driver->description))
 				break;
 		}
 		if (region == PCI_ROM_RESOURCE) {
@@ -275,20 +276,13 @@ int usb_hcd_pci_probe(struct pci_dev *de
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
@@ -347,14 +341,6 @@ void usb_hcd_pci_remove(struct pci_dev *
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


