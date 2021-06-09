Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7CC3A0ECD
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 10:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbhFIIiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 04:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232333AbhFIIiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 04:38:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C37861359;
        Wed,  9 Jun 2021 08:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623227776;
        bh=XLFTdEH0qXwCDdaPrb2gbBNbnkQItzLNAsXzfGipo8Q=;
        h=Subject:To:From:Date:From;
        b=lj4VQLthaIbxsY1DZaGMEMpCKSn4Yny7CgwHDitkUxntGnKlNCcFCuNHM6XSxfUxb
         XNqNQU376bOy2cbSKf25ph33NPl8SPNl1RktWny5Pa40Q1cjTx89wPlsZMnb+qdegA
         d4sTWB+KB/DnCMAC1GKsa4b1pprF4SllLgmWYYXQ=
Subject: patch "usb: pci-quirks: disable D3cold on xhci suspend for s2idle on AMD" added to usb-linus
To:     mario.limonciello@amd.com, Prike.Liang@amd.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Jun 2021 10:36:14 +0200
Message-ID: <1623227774103137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: pci-quirks: disable D3cold on xhci suspend for s2idle on AMD

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d1658268e43980c071dbffc3d894f6f6c4b6732a Mon Sep 17 00:00:00 2001
From: Mario Limonciello <mario.limonciello@amd.com>
Date: Thu, 27 May 2021 10:45:34 -0500
Subject: usb: pci-quirks: disable D3cold on xhci suspend for s2idle on AMD
 Renoir

The XHCI controller is required to enter D3hot rather than D3cold for AMD
s2idle on this hardware generation.

Otherwise, the 'Controller Not Ready' (CNR) bit is not being cleared by
host in resume and eventually this results in xhci resume failures during
the s2idle wakeup.

Link: https://lore.kernel.org/linux-usb/1612527609-7053-1-git-send-email-Prike.Liang@amd.com/
Suggested-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Cc: stable <stable@vger.kernel.org> # 5.11+
Link: https://lore.kernel.org/r/20210527154534.8900-1-mario.limonciello@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c | 7 ++++++-
 drivers/usb/host/xhci.h     | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 7bc18cf8042c..18c2bbddf080 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -59,6 +59,7 @@
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI		0x461e
 
+#define PCI_DEVICE_ID_AMD_RENOIR_XHCI			0x1639
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_2			0x43bb
@@ -182,6 +183,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		(pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_1)))
 		xhci->quirks |= XHCI_U2_DISABLE_WAKE;
 
+	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
+		pdev->device == PCI_DEVICE_ID_AMD_RENOIR_XHCI)
+		xhci->quirks |= XHCI_BROKEN_D3COLD;
+
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
 		xhci->quirks |= XHCI_LPM_SUPPORT;
 		xhci->quirks |= XHCI_INTEL_HOST;
@@ -539,7 +544,7 @@ static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 	 * Systems with the TI redriver that loses port status change events
 	 * need to have the registers polled during D3, so avoid D3cold.
 	 */
-	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
+	if (xhci->quirks & (XHCI_COMP_MODE_QUIRK | XHCI_BROKEN_D3COLD))
 		pci_d3cold_disable(pdev);
 
 	if (xhci->quirks & XHCI_PME_STUCK_QUIRK)
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 2595a8f057c4..e417f5ce13d1 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1892,6 +1892,7 @@ struct xhci_hcd {
 #define XHCI_DISABLE_SPARSE	BIT_ULL(38)
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
+#define XHCI_BROKEN_D3COLD	BIT_ULL(41)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.32.0


