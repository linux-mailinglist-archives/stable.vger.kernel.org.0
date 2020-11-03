Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7383E2A558C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbgKCVT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:19:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388333AbgKCVHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:07:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0E4C206B5;
        Tue,  3 Nov 2020 21:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437665;
        bh=b94DmLd450vt+pBvT5UGc7AA8irrNqbgUy5zOaANnK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejyp0nE+6GaT7LnXXl4lhK7B3SBU4qQ/sQAnDf8y7tQP50rIeX++M3lA9J5W8qd4/
         6WdHSyoaz/BvOv5OWkk+tQ6tuF9cmX2SWtxPNROomvmxeSwXW/NVtp3p7pG9vhw1um
         kmowghBZPpprjlGvZZZEbRC7iG30ZeU+XIN5wgEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanket Goswami <Sanket.Goswami@amd.com>,
        Sandeep Singh <sandeep.singh@amd.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 135/191] usb: xhci: Workaround for S3 issue on AMD SNPS 3.0 xHC
Date:   Tue,  3 Nov 2020 21:37:07 +0100
Message-Id: <20201103203245.628715605@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandeep Singh <sandeep.singh@amd.com>

commit 2a632815683d2d34df52b701a36fe5ac6654e719 upstream.

On some platform of AMD, S3 fails with HCE and SRE errors. To fix this,
need to disable a bit which is enable in sparse controller.

Cc: stable@vger.kernel.org #v4.19+
Signed-off-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Sandeep Singh <sandeep.singh@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20201028203124.375344-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |   17 +++++++++++++++++
 drivers/usb/host/xhci.h     |    1 +
 2 files changed, 18 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -21,6 +21,8 @@
 #define SSIC_PORT_CFG2_OFFSET	0x30
 #define PROG_DONE		(1 << 30)
 #define SSIC_PORT_UNUSED	(1 << 31)
+#define SPARSE_DISABLE_BIT	17
+#define SPARSE_CNTL_ENABLE	0xC12C
 
 /* Device for a quirk */
 #define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
@@ -141,6 +143,9 @@ static void xhci_pci_quirks(struct devic
 	    (pdev->device == 0x15e0 || pdev->device == 0x15e1))
 		xhci->quirks |= XHCI_SNPS_BROKEN_SUSPEND;
 
+	if (pdev->vendor == PCI_VENDOR_ID_AMD && pdev->device == 0x15e5)
+		xhci->quirks |= XHCI_DISABLE_SPARSE;
+
 	if (pdev->vendor == PCI_VENDOR_ID_AMD)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 
@@ -441,6 +446,15 @@ static void xhci_pme_quirk(struct usb_hc
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
@@ -460,6 +474,9 @@ static int xhci_pci_suspend(struct usb_h
 	if (xhci->quirks & XHCI_SSIC_PORT_UNUSED)
 		xhci_ssic_port_unused_quirk(hcd, true);
 
+	if (xhci->quirks & XHCI_DISABLE_SPARSE)
+		xhci_sparse_control_quirk(hcd);
+
 	ret = xhci_suspend(xhci, do_wakeup);
 	if (ret && (xhci->quirks & XHCI_SSIC_PORT_UNUSED))
 		xhci_ssic_port_unused_quirk(hcd, false);
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1872,6 +1872,7 @@ struct xhci_hcd {
 #define XHCI_ZERO_64B_REGS	BIT_ULL(32)
 #define XHCI_RESET_PLL_ON_DISCONNECT	BIT_ULL(34)
 #define XHCI_SNPS_BROKEN_SUSPEND    BIT_ULL(35)
+#define XHCI_DISABLE_SPARSE	BIT_ULL(38)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;


