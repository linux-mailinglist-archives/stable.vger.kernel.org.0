Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04642655725
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiLXBcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbiLXBbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:31:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AF1B3A;
        Fri, 23 Dec 2022 17:30:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55CF261FAA;
        Sat, 24 Dec 2022 01:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795F2C433D2;
        Sat, 24 Dec 2022 01:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845427;
        bh=4vG+/W/uFwo1EbehRw344z6Ae4IfvCK60GDYogsD2vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTeOfYJX83Re6XdLdGuMPJh3aumXZYCwqzlAcPbzuP2cn7PG6M8iKvDqf956L7vTQ
         UqVGG1/9k9Fi2l3aZnRfI0kj+2hYoGz/jQQ6NYIObVNetZkKwrvNjFiwpdTqwWE210
         AP6pXl9bCcyob0P2RxYGHqCs/tdJZ+BWDWDEcmBRZp+vxkVMRynFqxc7gZQ/pGmMB9
         XP0lrOSZe+z8HtyM9BUW6yU28p8RM8rkDJywRPtqM6THsTmhEVkWejLtSeLZAFWRBG
         uoVE9HZE1ts5XC6Dyk+aXheXBxv4p6n09D5cn9Sa2ZmtnA9sNmx1CZkbT2jeDE7Lic
         A0I2ub9ji4Kmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, mathias.nyman@intel.com,
        evgreen@chromium.org, yj84.jang@samsung.com,
        stern@rowland.harvard.edu, bhelgaas@google.com,
        heikki.krogerus@linux.intel.com, christophe.leroy@csgroup.eu,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 21/26] xhci: disable U3 suspended ports in S4 hibernate poweroff_late stage
Date:   Fri, 23 Dec 2022 20:29:25 -0500
Message-Id: <20221224012930.392358-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224012930.392358-1-sashal@kernel.org>
References: <20221224012930.392358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit c3bbacd61baace2f4fbab17012c3d149df2d50f1 ]

Disable U3 suspended ports in hibernate S4 poweroff_late for systems
with XHCI_RESET_TO_DEFAULT quirk, if wakeup is not enabled.

This reduces the number of self-powered usb devices from surviving in
U3 suspended state into next reboot.

Bootloader/firmware on these systems can't handle usb ports in U3, and
will timeout, causing extra delay during reboot/restore from S4.

Add pci_poweroff_late() callback to struct usb_hcd to get this done at
the correct stage in hibernate.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20221130091944.2171610-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hcd-pci.c  | 13 ++++++++++
 drivers/usb/host/xhci-pci.c | 52 +++++++++++++++++++++++++++++++++++++
 include/linux/usb/hcd.h     |  3 +++
 3 files changed, 68 insertions(+)

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 9b77f49b3560..ab2f3737764e 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -558,6 +558,17 @@ static int hcd_pci_suspend_noirq(struct device *dev)
 	return retval;
 }
 
+static int hcd_pci_poweroff_late(struct device *dev)
+{
+	struct pci_dev		*pci_dev = to_pci_dev(dev);
+	struct usb_hcd		*hcd = pci_get_drvdata(pci_dev);
+
+	if (hcd->driver->pci_poweroff_late && !HCD_DEAD(hcd))
+		return hcd->driver->pci_poweroff_late(hcd, device_may_wakeup(dev));
+
+	return 0;
+}
+
 static int hcd_pci_resume_noirq(struct device *dev)
 {
 	powermac_set_asic(to_pci_dev(dev), 1);
@@ -578,6 +589,7 @@ static int hcd_pci_restore(struct device *dev)
 
 #define hcd_pci_suspend		NULL
 #define hcd_pci_suspend_noirq	NULL
+#define hcd_pci_poweroff_late	NULL
 #define hcd_pci_resume_noirq	NULL
 #define hcd_pci_resume		NULL
 #define hcd_pci_restore		NULL
@@ -615,6 +627,7 @@ const struct dev_pm_ops usb_hcd_pci_pm_ops = {
 	.thaw_noirq	= NULL,
 	.thaw		= hcd_pci_resume,
 	.poweroff	= hcd_pci_suspend,
+	.poweroff_late	= hcd_pci_poweroff_late,
 	.poweroff_noirq	= hcd_pci_suspend_noirq,
 	.restore_noirq	= hcd_pci_resume_noirq,
 	.restore	= hcd_pci_restore,
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 7bccbe50bab1..f8100aa2f5d0 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -620,6 +620,57 @@ static int xhci_pci_resume(struct usb_hcd *hcd, bool hibernated)
 	return retval;
 }
 
+static int xhci_pci_poweroff_late(struct usb_hcd *hcd, bool do_wakeup)
+{
+	struct xhci_hcd		*xhci = hcd_to_xhci(hcd);
+	struct xhci_port	*port;
+	struct usb_device	*udev;
+	unsigned int		slot_id;
+	u32			portsc;
+	int			i;
+
+	/*
+	 * Systems with XHCI_RESET_TO_DEFAULT quirk have boot firmware that
+	 * cause significant boot delay if usb ports are in suspended U3 state
+	 * during boot. Some USB devices survive in U3 state over S4 hibernate
+	 *
+	 * Disable ports that are in U3 if remote wake is not enabled for either
+	 * host controller or connected device
+	 */
+
+	if (!(xhci->quirks & XHCI_RESET_TO_DEFAULT))
+		return 0;
+
+	for (i = 0; i < HCS_MAX_PORTS(xhci->hcs_params1); i++) {
+		port = &xhci->hw_ports[i];
+		portsc = readl(port->addr);
+
+		if ((portsc & PORT_PLS_MASK) != XDEV_U3)
+			continue;
+
+		slot_id = xhci_find_slot_id_by_port(port->rhub->hcd, xhci,
+						    port->hcd_portnum + 1);
+		if (!slot_id || !xhci->devs[slot_id]) {
+			xhci_err(xhci, "No dev for slot_id %d for port %d-%d in U3\n",
+				 slot_id, port->rhub->hcd->self.busnum, port->hcd_portnum + 1);
+			continue;
+		}
+
+		udev = xhci->devs[slot_id]->udev;
+
+		/* if wakeup is enabled then don't disable the port */
+		if (udev->do_remote_wakeup && do_wakeup)
+			continue;
+
+		xhci_dbg(xhci, "port %d-%d in U3 without wakeup, disable it\n",
+			 port->rhub->hcd->self.busnum, port->hcd_portnum + 1);
+		portsc = xhci_port_state_to_neutral(portsc);
+		writel(portsc | PORT_PE, port->addr);
+	}
+
+	return 0;
+}
+
 static void xhci_pci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd		*xhci = hcd_to_xhci(hcd);
@@ -686,6 +737,7 @@ static int __init xhci_pci_init(void)
 #ifdef CONFIG_PM
 	xhci_pci_hc_driver.pci_suspend = xhci_pci_suspend;
 	xhci_pci_hc_driver.pci_resume = xhci_pci_resume;
+	xhci_pci_hc_driver.pci_poweroff_late = xhci_pci_poweroff_late;
 	xhci_pci_hc_driver.shutdown = xhci_pci_shutdown;
 #endif
 	return pci_register_driver(&xhci_pci_driver);
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 78cd566ee238..b51c07111729 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -269,6 +269,9 @@ struct hc_driver {
 	/* called after entering D0 (etc), before resuming the hub */
 	int	(*pci_resume)(struct usb_hcd *hcd, bool hibernated);
 
+	/* called just before hibernate final D3 state, allows host to poweroff parts */
+	int	(*pci_poweroff_late)(struct usb_hcd *hcd, bool do_wakeup);
+
 	/* cleanly make HCD stop writing memory and doing I/O */
 	void	(*stop) (struct usb_hcd *hcd);
 
-- 
2.35.1

