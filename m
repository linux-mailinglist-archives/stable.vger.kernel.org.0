Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBE9476607
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 23:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhLOWjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 17:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhLOWjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 17:39:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1F3C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 14:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1350CB82211
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 22:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7768CC36AE2;
        Wed, 15 Dec 2021 22:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639607944;
        bh=uTTkZ3g4oM1pkSFZEcbYMPKgaWmtOT/0zd0vPe/Vv8U=;
        h=Subject:To:From:Date:From;
        b=KDwtThl2UN5TIlv1uUJT009gBuvhropm0eRRfxPe/g+FRmJFdpt+JMgnDeGjawrtk
         jDlvsfL9qtt8RUloZouxUsqOAaatSrPYseOWwZP73sD1h8fHucLYiDIsxMwx8YIXbO
         covAovXwWXjcf7qlwPXtefPJwl8Z6tHneKQMbJ+A=
Subject: patch "usb: xhci: Extend support for runtime power management for AMD's" added to usb-linus
To:     Nehal-Bakulchandra.shah@amd.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Dec 2021 23:39:02 +0100
Message-ID: <163960794223892@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: Extend support for runtime power management for AMD's

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f886d4fbb7c97b8f5f447c92d2dab99c841803c0 Mon Sep 17 00:00:00 2001
From: Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>
Date: Wed, 15 Dec 2021 15:02:16 +0530
Subject: usb: xhci: Extend support for runtime power management for AMD's
 Yellow carp.

AMD's Yellow Carp platform has few more XHCI controllers,
enable the runtime power management support for the same.

Signed-off-by: Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211215093216.1839065-1-Nehal-Bakulchandra.shah@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 92adf6107864..3af017883231 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -71,6 +71,8 @@
 #define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4		0x161e
 #define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5		0x15d6
 #define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6		0x15d7
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_7		0x161c
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_8		0x161f
 
 #define PCI_DEVICE_ID_ASMEDIA_1042_XHCI			0x1042
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
@@ -330,7 +332,9 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_3 ||
 	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4 ||
 	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6))
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_7 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_8))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
-- 
2.34.1


