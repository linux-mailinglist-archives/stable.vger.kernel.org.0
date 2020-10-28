Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF73129E2EA
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 03:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgJ1Vdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:33:31 -0400
Received: from mga03.intel.com ([134.134.136.65]:44639 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgJ1VdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 17:33:19 -0400
IronPort-SDR: WWBH5O8v8CYXUns7dXSpcexJ0VURWOB7b3Huie9MIWTt9Lx+SpuJusVTJktKB3KqKfEEQ0H50I
 DS0Z/RnA2oMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9788"; a="168432576"
X-IronPort-AV: E=Sophos;i="5.77,428,1596524400"; 
   d="scan'208";a="168432576"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2020 13:30:06 -0700
IronPort-SDR: sPi8l1Pu+Wzuww4eNKfwbtJ+KGlavjQFFWFeEJJtYsIzyWnMm3q9FrCXnPuJOWjoOR+ttuOJdZ
 8++KmUPG7hvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,428,1596524400"; 
   d="scan'208";a="323467805"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga006.jf.intel.com with ESMTP; 28 Oct 2020 13:30:04 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Sandeep Singh <sandeep.singh@amd.com>,
        Sanket Goswami <Sanket.Goswami@amd.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 2/3] usb: xhci: Workaround for S3 issue on AMD SNPS 3.0 xHC
Date:   Wed, 28 Oct 2020 22:31:23 +0200
Message-Id: <20201028203124.375344-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201028203124.375344-1-mathias.nyman@linux.intel.com>
References: <20201028203124.375344-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandeep Singh <sandeep.singh@amd.com>

On some platform of AMD, S3 fails with HCE and SRE errors. To fix this,
need to disable a bit which is enable in sparse controller.

Signed-off-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Sandeep Singh <sandeep.singh@amd.com>
Cc: stable@vger.kernel.org#v4.19+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c | 17 +++++++++++++++++
 drivers/usb/host/xhci.h     |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index c26c06e5c88c..bf89172c43ca 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -23,6 +23,8 @@
 #define SSIC_PORT_CFG2_OFFSET	0x30
 #define PROG_DONE		(1 << 30)
 #define SSIC_PORT_UNUSED	(1 << 31)
+#define SPARSE_DISABLE_BIT	17
+#define SPARSE_CNTL_ENABLE	0xC12C
 
 /* Device for a quirk */
 #define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
@@ -161,6 +163,9 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	    (pdev->device == 0x15e0 || pdev->device == 0x15e1))
 		xhci->quirks |= XHCI_SNPS_BROKEN_SUSPEND;
 
+	if (pdev->vendor == PCI_VENDOR_ID_AMD && pdev->device == 0x15e5)
+		xhci->quirks |= XHCI_DISABLE_SPARSE;
+
 	if (pdev->vendor == PCI_VENDOR_ID_AMD)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 
@@ -498,6 +503,15 @@ static void xhci_pme_quirk(struct usb_hcd *hcd)
 	readl(reg);
 }
 
+static void xhci_sparse_control_quirk(struct usb_hcd *hcd)
+{
+	u32 reg;
+
+	reg = readl(hcd->regs + SPARSE_CNTL_ENABLE);
+	reg &= ~BIT(SPARSE_DISABLE_BIT);
+	writel(reg, hcd->regs + SPARSE_CNTL_ENABLE);
+}
+
 static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
@@ -517,6 +531,9 @@ static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 	if (xhci->quirks & XHCI_SSIC_PORT_UNUSED)
 		xhci_ssic_port_unused_quirk(hcd, true);
 
+	if (xhci->quirks & XHCI_DISABLE_SPARSE)
+		xhci_sparse_control_quirk(hcd);
+
 	ret = xhci_suspend(xhci, do_wakeup);
 	if (ret && (xhci->quirks & XHCI_SSIC_PORT_UNUSED))
 		xhci_ssic_port_unused_quirk(hcd, false);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 8be88379c0fb..ebb359ebb261 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1877,6 +1877,7 @@ struct xhci_hcd {
 #define XHCI_SNPS_BROKEN_SUSPEND    BIT_ULL(35)
 #define XHCI_RENESAS_FW_QUIRK	BIT_ULL(36)
 #define XHCI_SKIP_PHY_INIT	BIT_ULL(37)
+#define XHCI_DISABLE_SPARSE	BIT_ULL(38)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.25.1

