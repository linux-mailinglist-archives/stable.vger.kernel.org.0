Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721CD42E920
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 08:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbhJOGja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 02:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234617AbhJOGj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 02:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E72A46058D;
        Fri, 15 Oct 2021 06:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634279843;
        bh=JmiGT66reC4YhBJAFi8EK4f/1zZWw8vnK6/niWJSLpc=;
        h=Subject:To:From:Date:From;
        b=StgUmNd7BxGZ2QTvu/2sscS902/UqLqkhPqv1qeruACmsm/txqcgg8wTOq7sbEkm6
         yQ0prgfexVaPpupkPVe9u8aq2pfevIcBNgyDQzNBPC3Tbl5Tene1DI8cR2GjhPZUk5
         Z8+aHhK5P6vBSperca4JgHgregGqlW26hNOzfwgM=
Subject: patch "usb: xhci: Enable runtime-pm by default on AMD Yellow Carp platform" added to usb-next
To:     Nehal-Bakulchandra.shah@amd.com, Basavaraj.Natikar@amd.com,
        Shyam-sundar.S-k@amd.com, gregkh@linuxfoundation.org,
        mario.limonciello@amd.com, mathias.nyman@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Oct 2021 08:37:20 +0200
Message-ID: <163427984018942@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: Enable runtime-pm by default on AMD Yellow Carp platform

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 660a92a59b9e831a0407e41ff62875656d30006e Mon Sep 17 00:00:00 2001
From: Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>
Date: Thu, 14 Oct 2021 15:12:00 +0300
Subject: usb: xhci: Enable runtime-pm by default on AMD Yellow Carp platform

AMD's Yellow Carp platform supports runtime power management for
XHCI Controllers, so enable the same by default for all XHCI Controllers.

[ regrouped and aligned the PCI_DEVICE_ID definitions -Mathias]

Cc: stable <stable@vger.kernel.org>
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211014121200.75433-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 2c9f25ca8edd..57f097cdd2e5 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -64,6 +64,13 @@
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_2			0x43bb
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_1			0x43bc
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_1		0x161a
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_2		0x161b
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_3		0x161d
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4		0x161e
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5		0x15d6
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6		0x15d7
+
 #define PCI_DEVICE_ID_ASMEDIA_1042_XHCI			0x1042
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
 #define PCI_DEVICE_ID_ASMEDIA_1142_XHCI			0x1242
@@ -313,6 +320,15 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_4))
 		xhci->quirks |= XHCI_NO_SOFT_RETRY;
 
+	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
+	    (pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_1 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_2 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_3 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6))
+		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
+
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"QUIRK: Resetting on resume");
-- 
2.33.0


