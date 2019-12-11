Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6180F11AD89
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbfLKOdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:33:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfLKOdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 09:33:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92D2720836;
        Wed, 11 Dec 2019 14:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576074799;
        bh=8uqbx4HthD6YCBwHJvf75ao3ysJ2wzgTeFwdYQdw8NA=;
        h=Subject:To:From:Date:From;
        b=RpIhAGIAxXYJZikLBJb+nb2KZOlW4UV06PeLL4berY0zXrykfbasfILFppjhr+qLs
         BjBhrMkJ21YSayL82sSBC/aX+j0viPwvHbPaJZLBX+DkGkfxgDOtWoss67SrFpil2y
         W72IaKaDoqG4q9PJ4PjNSWtfCydXzO6EDpmAHMrA=
Subject: patch "usb: xhci: only set D3hot for pci device" added to usb-linus
To:     henryl@nvidia.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 11 Dec 2019 15:33:10 +0100
Message-ID: <157607479082136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: only set D3hot for pci device

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f2c710f7dca8457e88b4ac9de2060f011254f9dd Mon Sep 17 00:00:00 2001
From: Henry Lin <henryl@nvidia.com>
Date: Wed, 11 Dec 2019 16:20:04 +0200
Subject: usb: xhci: only set D3hot for pci device

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
 drivers/usb/host/xhci-pci.c | 13 +++++++++++++
 drivers/usb/host/xhci.c     |  7 ++-----
 drivers/usb/host/xhci.h     |  1 +
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index a0025d23b257..2907fe4d78dd 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -521,6 +521,18 @@ static int xhci_pci_resume(struct usb_hcd *hcd, bool hibernated)
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
@@ -556,6 +568,7 @@ static int __init xhci_pci_init(void)
 #ifdef CONFIG_PM
 	xhci_pci_hc_driver.pci_suspend = xhci_pci_suspend;
 	xhci_pci_hc_driver.pci_resume = xhci_pci_resume;
+	xhci_pci_hc_driver.shutdown = xhci_pci_shutdown;
 #endif
 	return pci_register_driver(&xhci_pci_driver);
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6721d059f58a..c5ee562c4c74 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -770,7 +770,7 @@ static void xhci_stop(struct usb_hcd *hcd)
  *
  * This will only ever be called with the main usb_hcd (the USB3 roothub).
  */
-static void xhci_shutdown(struct usb_hcd *hcd)
+void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 
@@ -789,11 +789,8 @@ static void xhci_shutdown(struct usb_hcd *hcd)
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
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index dc6f62a4b197..13d8838cd552 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2050,6 +2050,7 @@ int xhci_start(struct xhci_hcd *xhci);
 int xhci_reset(struct xhci_hcd *xhci);
 int xhci_run(struct usb_hcd *hcd);
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
+void xhci_shutdown(struct usb_hcd *hcd);
 void xhci_init_driver(struct hc_driver *drv,
 		      const struct xhci_driver_overrides *over);
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id);
-- 
2.24.1


