Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E0133BAC0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbhCOOKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233117AbhCOOAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3D7464F76;
        Mon, 15 Mar 2021 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816829;
        bh=+6yNoHokYa5gYaIFnqLmkTlRu3gJNAmKBggj+8B9zJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFqRs5Ajmbz6VZ/SDNxkpI07a02SUD2l14EUdCpzr3e+9VcvDWJAx7Q1NYsDNu76K
         /G5jF3rk9kPwxaFw6w6iU4afFfyHxypN0e6QrRoRmdgehQxfMVOn+s90cahQ4UEVSk
         3kySVk1eL3aWTyUohrRLOMuiVLJqyI7L1v8vZ1JQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 150/306] PCI/LINK: Remove bandwidth notification
Date:   Mon, 15 Mar 2021 14:53:33 +0100
Message-Id: <20210315135512.712910862@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit b4c7d2076b4e767dd2e075a2b3a9e57753fc67f5 ]

The PCIe Bandwidth Change Notification feature logs messages when the link
bandwidth changes.  Some users have reported that these messages occur
often enough to significantly reduce NVMe performance.  GPUs also seem to
generate these messages.

We don't know why the link bandwidth changes, but in the reported cases
there's no indication that it's caused by hardware failures.

Remove the bandwidth change notifications for now.  Hopefully we can add
this back when we have a better understanding of why this happens and how
we can make the messages useful instead of overwhelming.

Link: https://lore.kernel.org/r/20200115221008.GA191037@google.com/
Link: https://lore.kernel.org/r/155605909349.3575.13433421148215616375.stgit@gimli.home/
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206197
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/Kconfig           |   8 --
 drivers/pci/pcie/Makefile          |   1 -
 drivers/pci/pcie/bw_notification.c | 138 -----------------------------
 drivers/pci/pcie/portdrv.h         |   6 --
 drivers/pci/pcie/portdrv_pci.c     |   1 -
 5 files changed, 154 deletions(-)
 delete mode 100644 drivers/pci/pcie/bw_notification.c

diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
index 3946555a6042..45a2ef702b45 100644
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -133,14 +133,6 @@ config PCIE_PTM
 	  This is only useful if you have devices that support PTM, but it
 	  is safe to enable even if you don't.
 
-config PCIE_BW
-	bool "PCI Express Bandwidth Change Notification"
-	depends on PCIEPORTBUS
-	help
-	  This enables PCI Express Bandwidth Change Notification.  If
-	  you know link width or rate changes occur only to correct
-	  unreliable links, you may answer Y.
-
 config PCIE_EDR
 	bool "PCI Express Error Disconnect Recover support"
 	depends on PCIE_DPC && ACPI
diff --git a/drivers/pci/pcie/Makefile b/drivers/pci/pcie/Makefile
index d9697892fa3e..b2980db88cc0 100644
--- a/drivers/pci/pcie/Makefile
+++ b/drivers/pci/pcie/Makefile
@@ -12,5 +12,4 @@ obj-$(CONFIG_PCIEAER_INJECT)	+= aer_inject.o
 obj-$(CONFIG_PCIE_PME)		+= pme.o
 obj-$(CONFIG_PCIE_DPC)		+= dpc.o
 obj-$(CONFIG_PCIE_PTM)		+= ptm.o
-obj-$(CONFIG_PCIE_BW)		+= bw_notification.o
 obj-$(CONFIG_PCIE_EDR)		+= edr.o
diff --git a/drivers/pci/pcie/bw_notification.c b/drivers/pci/pcie/bw_notification.c
deleted file mode 100644
index 565d23cccb8b..000000000000
--- a/drivers/pci/pcie/bw_notification.c
+++ /dev/null
@@ -1,138 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * PCI Express Link Bandwidth Notification services driver
- * Author: Alexandru Gagniuc <mr.nuke.me@gmail.com>
- *
- * Copyright (C) 2019, Dell Inc
- *
- * The PCIe Link Bandwidth Notification provides a way to notify the
- * operating system when the link width or data rate changes.  This
- * capability is required for all root ports and downstream ports
- * supporting links wider than x1 and/or multiple link speeds.
- *
- * This service port driver hooks into the bandwidth notification interrupt
- * and warns when links become degraded in operation.
- */
-
-#define dev_fmt(fmt) "bw_notification: " fmt
-
-#include "../pci.h"
-#include "portdrv.h"
-
-static bool pcie_link_bandwidth_notification_supported(struct pci_dev *dev)
-{
-	int ret;
-	u32 lnk_cap;
-
-	ret = pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &lnk_cap);
-	return (ret == PCIBIOS_SUCCESSFUL) && (lnk_cap & PCI_EXP_LNKCAP_LBNC);
-}
-
-static void pcie_enable_link_bandwidth_notification(struct pci_dev *dev)
-{
-	u16 lnk_ctl;
-
-	pcie_capability_write_word(dev, PCI_EXP_LNKSTA, PCI_EXP_LNKSTA_LBMS);
-
-	pcie_capability_read_word(dev, PCI_EXP_LNKCTL, &lnk_ctl);
-	lnk_ctl |= PCI_EXP_LNKCTL_LBMIE;
-	pcie_capability_write_word(dev, PCI_EXP_LNKCTL, lnk_ctl);
-}
-
-static void pcie_disable_link_bandwidth_notification(struct pci_dev *dev)
-{
-	u16 lnk_ctl;
-
-	pcie_capability_read_word(dev, PCI_EXP_LNKCTL, &lnk_ctl);
-	lnk_ctl &= ~PCI_EXP_LNKCTL_LBMIE;
-	pcie_capability_write_word(dev, PCI_EXP_LNKCTL, lnk_ctl);
-}
-
-static irqreturn_t pcie_bw_notification_irq(int irq, void *context)
-{
-	struct pcie_device *srv = context;
-	struct pci_dev *port = srv->port;
-	u16 link_status, events;
-	int ret;
-
-	ret = pcie_capability_read_word(port, PCI_EXP_LNKSTA, &link_status);
-	events = link_status & PCI_EXP_LNKSTA_LBMS;
-
-	if (ret != PCIBIOS_SUCCESSFUL || !events)
-		return IRQ_NONE;
-
-	pcie_capability_write_word(port, PCI_EXP_LNKSTA, events);
-	pcie_update_link_speed(port->subordinate, link_status);
-	return IRQ_WAKE_THREAD;
-}
-
-static irqreturn_t pcie_bw_notification_handler(int irq, void *context)
-{
-	struct pcie_device *srv = context;
-	struct pci_dev *port = srv->port;
-	struct pci_dev *dev;
-
-	/*
-	 * Print status from downstream devices, not this root port or
-	 * downstream switch port.
-	 */
-	down_read(&pci_bus_sem);
-	list_for_each_entry(dev, &port->subordinate->devices, bus_list)
-		pcie_report_downtraining(dev);
-	up_read(&pci_bus_sem);
-
-	return IRQ_HANDLED;
-}
-
-static int pcie_bandwidth_notification_probe(struct pcie_device *srv)
-{
-	int ret;
-
-	/* Single-width or single-speed ports do not have to support this. */
-	if (!pcie_link_bandwidth_notification_supported(srv->port))
-		return -ENODEV;
-
-	ret = request_threaded_irq(srv->irq, pcie_bw_notification_irq,
-				   pcie_bw_notification_handler,
-				   IRQF_SHARED, "PCIe BW notif", srv);
-	if (ret)
-		return ret;
-
-	pcie_enable_link_bandwidth_notification(srv->port);
-	pci_info(srv->port, "enabled with IRQ %d\n", srv->irq);
-
-	return 0;
-}
-
-static void pcie_bandwidth_notification_remove(struct pcie_device *srv)
-{
-	pcie_disable_link_bandwidth_notification(srv->port);
-	free_irq(srv->irq, srv);
-}
-
-static int pcie_bandwidth_notification_suspend(struct pcie_device *srv)
-{
-	pcie_disable_link_bandwidth_notification(srv->port);
-	return 0;
-}
-
-static int pcie_bandwidth_notification_resume(struct pcie_device *srv)
-{
-	pcie_enable_link_bandwidth_notification(srv->port);
-	return 0;
-}
-
-static struct pcie_port_service_driver pcie_bandwidth_notification_driver = {
-	.name		= "pcie_bw_notification",
-	.port_type	= PCIE_ANY_PORT,
-	.service	= PCIE_PORT_SERVICE_BWNOTIF,
-	.probe		= pcie_bandwidth_notification_probe,
-	.suspend	= pcie_bandwidth_notification_suspend,
-	.resume		= pcie_bandwidth_notification_resume,
-	.remove		= pcie_bandwidth_notification_remove,
-};
-
-int __init pcie_bandwidth_notification_init(void)
-{
-	return pcie_port_service_register(&pcie_bandwidth_notification_driver);
-}
diff --git a/drivers/pci/pcie/portdrv.h b/drivers/pci/pcie/portdrv.h
index af7cf237432a..2ff5724b8f13 100644
--- a/drivers/pci/pcie/portdrv.h
+++ b/drivers/pci/pcie/portdrv.h
@@ -53,12 +53,6 @@ int pcie_dpc_init(void);
 static inline int pcie_dpc_init(void) { return 0; }
 #endif
 
-#ifdef CONFIG_PCIE_BW
-int pcie_bandwidth_notification_init(void);
-#else
-static inline int pcie_bandwidth_notification_init(void) { return 0; }
-#endif
-
 /* Port Type */
 #define PCIE_ANY_PORT			(~0)
 
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 0b250bc5f405..8bd4992a4f32 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -255,7 +255,6 @@ static void __init pcie_init_services(void)
 	pcie_pme_init();
 	pcie_dpc_init();
 	pcie_hp_init();
-	pcie_bandwidth_notification_init();
 }
 
 static int __init pcie_portdrv_init(void)
-- 
2.30.1



