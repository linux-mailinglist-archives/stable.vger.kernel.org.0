Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDBC42D964
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 14:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhJNMic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 08:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230126AbhJNMic (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 08:38:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 016C6610D2;
        Thu, 14 Oct 2021 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634214987;
        bh=JTNPaq5CE53JFM13gyMDjYP0vyC3uPEwYX0Cn5AosSw=;
        h=Subject:To:From:Date:From;
        b=h7ZuVXArchf0IEXW+6H6+t2SLX0CFJRFx6Jz9qrYDrf+eLvM0K7fSmsIQqmRklTy5
         QEl7W3QMDuH1b4duhoVnAVDZyN4bffzPX6I/sYe3JQW8zw9QSNmz+Eb2jfxU5UNOIt
         0pgGtPYNJHfG2U0uWk1jkcuD78r/b7LKtji+N5c0=
Subject: patch "usb: xhci: Enable runtime-pm by default on AMD Yellow Carp platform" added to usb-testing
To:     Nehal-Bakulchandra.shah@amd.com, Basavaraj.Natikar@amd.com,
        Shyam-sundar.S-k@amd.com, gregkh@linuxfoundation.org,
        mario.limonciello@amd.com, mathias.nyman@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 14 Oct 2021 14:36:25 +0200
Message-ID: <163421498535123@kroah.com>
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
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

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


