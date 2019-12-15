Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC0511F6F3
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 10:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfLOJYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 04:24:24 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:36819 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726078AbfLOJYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 04:24:24 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id CC8156A5;
        Sun, 15 Dec 2019 04:24:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 04:24:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mVPWxh
        IAA29VhJLnXkmYmB6wJdA8jmdvLON8bOKRmxE=; b=s4oQ6ngO9IbO50JKrWGLx2
        wYC+ZvX6asia/IgUgqnjKZQjnjvsvz3k7g7T3kyeJ2fHFZMFvDenj7BKu3iN6jDh
        c4OC7aul2S3fe8fLfSExskAEliKjmqFR21C+iX4cYM3UeXBR6BJsFMyY8WWub1i4
        zo48HWe1VMftyZaJMGSsrE5qmhpvJPCuMWu/J+YnENuS5DZ2fK782hznJXF5pAGb
        U0YD2+6nPvihaOTz0rgC1+s4oE1JI1IPuWzuJee0bRHZe+1TTVEYjMdS31NZYDSP
        /YMJbCuM08Pj8ouoHrolGuM9FcxiRDlIqFYD18rBTKZewYIxPh/kAmRAqcCSsrMA
        ==
X-ME-Sender: <xms:xvv1XaFAxNnznalXsFlgoRizX9t0Scbg-fCzdpV1f9DlNvCXvSMGRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:xvv1XYB2tkpHEHzLFF7z5Lc5tqYqCvONFRVOU-quECHxpMtrRDOaAA>
    <xmx:xvv1XYBXFXai31p_mOEs6FButQ22bNtXDToOMnSjSsSBYAajHLwIeg>
    <xmx:xvv1XeM0ebtN9wvbaAhHRP1gfrT3e95KWT-FLyR3VBou16pJvmpuhQ>
    <xmx:xvv1XbiCiijCdayeVHa5NBUZ1NcWD2EDrm1O4HVGHfp8w5P-EiuIew>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1747C30600AB;
        Sun, 15 Dec 2019 04:24:21 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: xhci: only set D3hot for pci device" failed to apply to 4.4-stable tree
To:     henryl@nvidia.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 10:24:12 +0100
Message-ID: <157640185211541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f2c710f7dca8457e88b4ac9de2060f011254f9dd Mon Sep 17 00:00:00 2001
From: Henry Lin <henryl@nvidia.com>
Date: Wed, 11 Dec 2019 16:20:04 +0200
Subject: [PATCH] usb: xhci: only set D3hot for pci device

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

