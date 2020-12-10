Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F038A2D55DC
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 09:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbgLJI4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 03:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388426AbgLJIz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 03:55:58 -0500
Subject: patch "xhci-pci: Allow host runtime PM as default for Intel Alpine Ridge LP" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607590517;
        bh=vo5TjZD3JcFPde70yCKmHCgw3B1vZQ1MHjGVK5VB+RQ=;
        h=To:From:Date:From;
        b=UXwX/1pnGBbz1k0Ny+vuD0TA75KrzA3yuYejuIlBHlp1JzvoKs15R+V5kUT+dYHOI
         Tt+HDSWv4zGTnbMws52x/So1Wmk9OuDaVHX/6yDBUkl6BOq3CjbO1wlWt+GeHgQ604
         5Wdwb4g4ppjwYmpVX4JO1YqP5HJZuQUVRu5FIPYo=
To:     hdegoede@redhat.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Dec 2020 09:56:28 +0100
Message-ID: <160759058888231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci-pci: Allow host runtime PM as default for Intel Alpine Ridge LP

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From c4d1ca05b8e68a4b5a3c4455cb6ec25b3df6d9dd Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Tue, 8 Dec 2020 11:29:10 +0200
Subject: xhci-pci: Allow host runtime PM as default for Intel Alpine Ridge LP

The xHCI controller on Alpine Ridge LP keeps the whole Thunderbolt
controller awake if the host controller is not allowed to sleep.
This is the case even if no USB devices are connected to the host.

Add the Intel Alpine Ridge LP product-id to the list of product-ids
for which we allow runtime PM by default.

Fixes: 2815ef7fe4d4 ("xhci-pci: allow host runtime PM as default for Intel Alpine and Titan Ridge")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20201208092912.1773650-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index bf89172c43ca..5f94d7edeb37 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -47,6 +47,7 @@
 #define PCI_DEVICE_ID_INTEL_DNV_XHCI			0x19d0
 #define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_2C_XHCI	0x15b5
 #define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_4C_XHCI	0x15b6
+#define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_LP_XHCI	0x15c1
 #define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_C_2C_XHCI	0x15db
 #define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_C_4C_XHCI	0x15d4
 #define PCI_DEVICE_ID_INTEL_TITAN_RIDGE_2C_XHCI		0x15e9
@@ -232,6 +233,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 	    (pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_2C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_4C_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_LP_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_C_2C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_C_4C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_TITAN_RIDGE_2C_XHCI ||
-- 
2.29.2


