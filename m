Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C88337F826
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 14:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhEMMtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 08:49:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233916AbhEMMtS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 08:49:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8644861396;
        Thu, 13 May 2021 12:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620910089;
        bh=HrvC9MOlEzzz6AOZZPQsThUWDpdVzbvkSkXMgQcxXQw=;
        h=Subject:To:From:Date:From;
        b=PGLTAESyGJx3g1mfJ8KL5Ry5NrSPNItNsE6dlKye5BKmY+Y+8El2JfA/IkTNuFSF+
         rmVkwj517MZb3NLyOWgvEsIziiGPextAso7nLCl714vbNEVtouJOND9i32kNKKSt3d
         Tu2L/nN5XyGwbgbP2BTn/vBrrt23IlzcRbBYbhzY=
Subject: patch "xhci: Add reset resume quirk for AMD xhci controller." added to usb-linus
To:     sandeep.singh@amd.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 14:47:55 +0200
Message-ID: <162091007579176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Add reset resume quirk for AMD xhci controller.

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3c128781d8da463761495aaf8898c9ecb4e71528 Mon Sep 17 00:00:00 2001
From: Sandeep Singh <sandeep.singh@amd.com>
Date: Wed, 12 May 2021 11:08:16 +0300
Subject: xhci: Add reset resume quirk for AMD xhci controller.

One of AMD xhci controller require reset on resume.
Occasionally AMD xhci controller does not respond to
Stop endpoint command.
Once the issue happens controller goes into bad state
and in that case controller needs to be reset.

Cc: <stable@vger.kernel.org>
Signed-off-by: Sandeep Singh <sandeep.singh@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210512080816.866037-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index a858add8436c..7bc18cf8042c 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -167,8 +167,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	    (pdev->device == 0x15e0 || pdev->device == 0x15e1))
 		xhci->quirks |= XHCI_SNPS_BROKEN_SUSPEND;
 
-	if (pdev->vendor == PCI_VENDOR_ID_AMD && pdev->device == 0x15e5)
+	if (pdev->vendor == PCI_VENDOR_ID_AMD && pdev->device == 0x15e5) {
 		xhci->quirks |= XHCI_DISABLE_SPARSE;
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
+	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_AMD)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
-- 
2.31.1


