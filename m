Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA17126D4A
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfLSSkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:40:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728323AbfLSSkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:40:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84AC5206D7;
        Thu, 19 Dec 2019 18:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780802;
        bh=gRXEjFAfXikEhoAMADE+phBfpxgJ8jYl1DmBHBNGdLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJKppowj8z3VOk0DeGAmh2GpZn1KA5bx5OyDQJ3NPUo1zk3feFayaJEcIngLda4lX
         qD72DXNluh8OcVYwNqjTWVhejnp57lIQY2TjEWWDIJXrUjiVxkLN3nnOB6okwJjKTt
         LFwuxVQgQL8iSfHyQ73D824ij5m+M8BIXtlUTX4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Lin <henryl@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 124/162] usb: xhci: only set D3hot for pci device
Date:   Thu, 19 Dec 2019 19:33:52 +0100
Message-Id: <20191219183215.310756164@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Lin <henryl@nvidia.com>

[ Upstream commit f2c710f7dca8457e88b4ac9de2060f011254f9dd ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-pci.c | 13 +++++++++++++
 drivers/usb/host/xhci.c     |  5 +----
 drivers/usb/host/xhci.h     |  1 +
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index d6e2199bcfe57..bda176fa6e488 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -446,6 +446,18 @@ static int xhci_pci_resume(struct usb_hcd *hcd, bool hibernated)
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
@@ -481,6 +493,7 @@ static int __init xhci_pci_init(void)
 #ifdef CONFIG_PM
 	xhci_pci_hc_driver.pci_suspend = xhci_pci_suspend;
 	xhci_pci_hc_driver.pci_resume = xhci_pci_resume;
+	xhci_pci_hc_driver.shutdown = xhci_pci_shutdown;
 #endif
 	return pci_register_driver(&xhci_pci_driver);
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 7a0db7fb731ee..af4e68152776e 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -754,11 +754,8 @@ void xhci_shutdown(struct usb_hcd *hcd)
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"xhci_shutdown completed - status = %x",
 			readl(&xhci->op_regs->status));
-
-	/* Yet another workaround for spurious wakeups at shutdown with HSW */
-	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
-		pci_set_power_state(to_pci_dev(hcd->self.controller), PCI_D3hot);
 }
+EXPORT_SYMBOL_GPL(xhci_shutdown);
 
 #ifdef CONFIG_PM
 static void xhci_save_registers(struct xhci_hcd *xhci)
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index b57bee70cdef2..e23e3a381672d 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1833,6 +1833,7 @@ int xhci_run(struct usb_hcd *hcd);
 void xhci_stop(struct usb_hcd *hcd);
 void xhci_shutdown(struct usb_hcd *hcd);
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
+void xhci_shutdown(struct usb_hcd *hcd);
 void xhci_init_driver(struct hc_driver *drv,
 		      const struct xhci_driver_overrides *over);
 
-- 
2.20.1



