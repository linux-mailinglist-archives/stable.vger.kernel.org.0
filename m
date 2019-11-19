Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2181017A7
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbfKSFlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:41:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729408AbfKSFlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:41:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B32FE208C3;
        Tue, 19 Nov 2019 05:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142065;
        bh=Ths97q+qE2uN8VtqEniJVy9I5rsNu3PZl7dyEi1Iplw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPKiCELXo7JO2InhiqOdH4pIli3Oafh/yA/Fxizb2cf3vRTvl6YU1bPsvSW9rQHuu
         KYrlb5k00gubEXoy4HLoqupDbC1Z1AzsyoccsiBSe1O5TjyPdBwOI8rl7IQova7Pi/
         0SRWh8hfIyZbOCNdR9amnr7v4H7VCM2sWu4bXUFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <keith.busch@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 376/422] PCI/ERR: Run error recovery callbacks for all affected devices
Date:   Tue, 19 Nov 2019 06:19:33 +0100
Message-Id: <20191119051423.396415575@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <keith.busch@intel.com>

[ Upstream commit bfcb79fca19d267712e425af1dd48812c40dec0c ]

If an Endpoint reported an error with ERR_FATAL, we previously ran driver
error recovery callbacks only for the Endpoint's driver.  But if we reset a
Link to recover from the error, all downstream components are affected,
including the Endpoint, any multi-function peers, and children of those
peers.

Initiate the Link reset from the deepest Downstream Port that is
reliable, and call the error recovery callbacks for all its children.

If a Downstream Port (including a Root Port) reports an error, we assume
the Port itself is reliable and we need to reset its downstream Link.  In
all other cases (Switch Upstream Ports, Endpoints, Bridges, etc), we assume
the Link leading to the component needs to be reset, so we initiate the
reset at the parent Downstream Port.

This allows two other clean-ups.  First, we currently only use a Link
reset, which can only be initiated using a Downstream Port, so we can
remove checks for Endpoints.  Second, the Downstream Port where we initiate
the Link reset is reliable (unlike components downstream from it), so the
special cases for error detect and resume are no longer necessary.

Signed-off-by: Keith Busch <keith.busch@intel.com>
[bhelgaas: changelog]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Sinan Kaya <okaya@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/err.c | 85 +++++++++++-------------------------------
 1 file changed, 21 insertions(+), 64 deletions(-)

diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index 12c1205e1d804..2c3b5bd59b18f 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -63,30 +63,12 @@ static int report_error_detected(struct pci_dev *dev, void *data)
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
 		!dev->driver->err_handler->error_detected) {
-		if (result_data->state == pci_channel_io_frozen &&
-			dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
-			/*
-			 * In case of fatal recovery, if one of down-
-			 * stream device has no driver. We might be
-			 * unable to recover because a later insmod
-			 * of a driver for this device is unaware of
-			 * its hw state.
-			 */
-			pci_printk(KERN_DEBUG, dev, "device has %s\n",
-				   dev->driver ?
-				   "no AER-aware driver" : "no driver");
-		}
-
 		/*
-		 * If there's any device in the subtree that does not
-		 * have an error_detected callback, returning
-		 * PCI_ERS_RESULT_NO_AER_DRIVER prevents calling of
-		 * the subsequent mmio_enabled/slot_reset/resume
-		 * callbacks of "any" device in the subtree. All the
-		 * devices in the subtree are left in the error state
-		 * without recovery.
+		 * If any device in the subtree does not have an error_detected
+		 * callback, PCI_ERS_RESULT_NO_AER_DRIVER prevents subsequent
+		 * error callbacks of "any" device in the subtree, and will
+		 * exit in the disconnected error state.
 		 */
-
 		if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
 			vote = PCI_ERS_RESULT_NO_AER_DRIVER;
 		else
@@ -184,34 +166,23 @@ static pci_ers_result_t default_reset_link(struct pci_dev *dev)
 
 static pci_ers_result_t reset_link(struct pci_dev *dev, u32 service)
 {
-	struct pci_dev *udev;
 	pci_ers_result_t status;
 	struct pcie_port_service_driver *driver = NULL;
 
-	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
-		/* Reset this port for all subordinates */
-		udev = dev;
-	} else {
-		/* Reset the upstream component (likely downstream port) */
-		udev = dev->bus->self;
-	}
-
-	/* Use the aer driver of the component firstly */
-	driver = pcie_port_find_service(udev, service);
-
+	driver = pcie_port_find_service(dev, service);
 	if (driver && driver->reset_link) {
-		status = driver->reset_link(udev);
-	} else if (udev->has_secondary_link) {
-		status = default_reset_link(udev);
+		status = driver->reset_link(dev);
+	} else if (dev->has_secondary_link) {
+		status = default_reset_link(dev);
 	} else {
 		pci_printk(KERN_DEBUG, dev, "no link-reset support at upstream device %s\n",
-			pci_name(udev));
+			pci_name(dev));
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
 	if (status != PCI_ERS_RESULT_RECOVERED) {
 		pci_printk(KERN_DEBUG, dev, "link reset at upstream device %s failed\n",
-			pci_name(udev));
+			pci_name(dev));
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -243,31 +214,7 @@ static pci_ers_result_t broadcast_error_message(struct pci_dev *dev,
 	else
 		result_data.result = PCI_ERS_RESULT_RECOVERED;
 
-	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
-		/*
-		 * If the error is reported by a bridge, we think this error
-		 * is related to the downstream link of the bridge, so we
-		 * do error recovery on all subordinates of the bridge instead
-		 * of the bridge and clear the error status of the bridge.
-		 */
-		if (cb == report_error_detected)
-			dev->error_state = state;
-		pci_walk_bus(dev->subordinate, cb, &result_data);
-		if (cb == report_resume) {
-			pci_aer_clear_device_status(dev);
-			pci_cleanup_aer_uncorrect_error_status(dev);
-			dev->error_state = pci_channel_io_normal;
-		}
-	} else {
-		/*
-		 * If the error is reported by an end point, we think this
-		 * error is related to the upstream link of the end point.
-		 * The error is non fatal so the bus is ok; just invoke
-		 * the callback for the function that logged the error.
-		 */
-		cb(dev, &result_data);
-	}
-
+	pci_walk_bus(dev->subordinate, cb, &result_data);
 	return result_data.result;
 }
 
@@ -347,6 +294,14 @@ void pcie_do_nonfatal_recovery(struct pci_dev *dev)
 
 	state = pci_channel_io_normal;
 
+	/*
+	 * Error recovery runs on all subordinates of the first downstream port.
+	 * If the downstream port detected the error, it is cleared at the end.
+	 */
+	if (!(pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT ||
+	      pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM))
+		dev = dev->bus->self;
+
 	status = broadcast_error_message(dev,
 			state,
 			"error_detected",
@@ -378,6 +333,8 @@ void pcie_do_nonfatal_recovery(struct pci_dev *dev)
 				"resume",
 				report_resume);
 
+	pci_aer_clear_device_status(dev);
+	pci_cleanup_aer_uncorrect_error_status(dev);
 	pci_info(dev, "AER: Device recovery successful\n");
 	return;
 
-- 
2.20.1



