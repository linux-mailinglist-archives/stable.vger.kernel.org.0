Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7921218A0
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfLPR5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:57:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727344AbfLPR5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:57:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D30A320733;
        Mon, 16 Dec 2019 17:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519039;
        bh=79lURdrE0UlnzKSZK6JLWN+3FhI4rYtU1zPTMjzb8FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phUbMAXRthCQPKLs3YPPVlU5j0051RLhNSVjOYqSkGKFF/CNelH00uCk+ajT3Jd64
         rTJVjuhMrM/TSqPG4OYmEal0opg7NQ8K0Rk+NwI6BZNNfuSp07NrXQRClqCgOSqkJM
         ZgyhKdr1xsjTVuJHYm9a6pFleF1ETaRHOFVAeRVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Lin <henryl@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.14 170/267] usb: xhci: only set D3hot for pci device
Date:   Mon, 16 Dec 2019 18:48:16 +0100
Message-Id: <20191216174911.815331190@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Lin <henryl@nvidia.com>

commit f2c710f7dca8457e88b4ac9de2060f011254f9dd upstream.

Xhci driver cannot call pci_set_power_state() on non-pci xhci host
controllers. For example, NVIDIA Tegra XHCI host controller which acts
as platform device with XHCI_SPURIOUS_WAKEUP quirk set in some platform
hits this issue during shutdown.

Cc: <stable@vger.kernel.org>
Fixes: 638298dc66ea ("xhci: Fix spurious wakeups after S5 on Haswell")
Signed-off-by: Henry Lin <henryl@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20191211142007.8847-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |   13 +++++++++++++
 drivers/usb/host/xhci.c     |    7 ++-----
 drivers/usb/host/xhci.h     |    1 +
 3 files changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -499,6 +499,18 @@ static int xhci_pci_resume(struct usb_hc
 }
 #endif /* CONFIG_PM */
 
+static void xhci_pci_shutdown(struct usb_hcd *hcd)
+{
+	struct xhci_hcd		*xhci = hcd_to_xhci(hcd);
+	struct pci_dev		*pdev = to_pci_dev(hcd->self.controller);
+
+	xhci_shutdown(hcd);
+
+	/* Yet another workaround for spurious wakeups at shutdown with HSW */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+		pci_set_power_state(pdev, PCI_D3hot);
+}
+
 /*-------------------------------------------------------------------------*/
 
 /* PCI driver selection metadata; PCI hotplugging uses this */
@@ -534,6 +546,7 @@ static int __init xhci_pci_init(void)
 #ifdef CONFIG_PM
 	xhci_pci_hc_driver.pci_suspend = xhci_pci_suspend;
 	xhci_pci_hc_driver.pci_resume = xhci_pci_resume;
+	xhci_pci_hc_driver.shutdown = xhci_pci_shutdown;
 #endif
 	return pci_register_driver(&xhci_pci_driver);
 }
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -717,7 +717,7 @@ static void xhci_stop(struct usb_hcd *hc
  *
  * This will only ever be called with the main usb_hcd (the USB3 roothub).
  */
-static void xhci_shutdown(struct usb_hcd *hcd)
+void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 
@@ -736,11 +736,8 @@ static void xhci_shutdown(struct usb_hcd
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"xhci_shutdown completed - status = %x",
 			readl(&xhci->op_regs->status));
-
-	/* Yet another workaround for spurious wakeups at shutdown with HSW */
-	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
-		pci_set_power_state(to_pci_dev(hcd->self.sysdev), PCI_D3hot);
 }
+EXPORT_SYMBOL_GPL(xhci_shutdown);
 
 #ifdef CONFIG_PM
 static void xhci_save_registers(struct xhci_hcd *xhci)
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2022,6 +2022,7 @@ int xhci_start(struct xhci_hcd *xhci);
 int xhci_reset(struct xhci_hcd *xhci);
 int xhci_run(struct usb_hcd *hcd);
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
+void xhci_shutdown(struct usb_hcd *hcd);
 void xhci_init_driver(struct hc_driver *drv,
 		      const struct xhci_driver_overrides *over);
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id);


