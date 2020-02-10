Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4A0157C9D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgBJNnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:43:47 -0500
Received: from mga05.intel.com ([192.55.52.43]:14982 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728650AbgBJNnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 08:43:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Feb 2020 05:43:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,425,1574150400"; 
   d="scan'208";a="265858453"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga002.fm.intel.com with ESMTP; 10 Feb 2020 05:43:44 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/4] xhci: fix runtime pm enabling for quirky Intel hosts
Date:   Mon, 10 Feb 2020 15:45:52 +0200
Message-Id: <20200210134553.9144-4-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200210134553.9144-1-mathias.nyman@linux.intel.com>
References: <20200210134553.9144-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Intel hosts that need the XHCI_PME_STUCK_QUIRK flag should enable
runtime pm by calling xhci_pme_acpi_rtd3_enable() before
usb_hcd_pci_probe() calls pci_dev_run_wake().
Otherwise usage count for the device won't be decreased, and runtime
suspend is prevented.

usb_hcd_pci_probe() only decreases the usage count if device can
generate run-time wake-up events, i.e. when pci_dev_run_wake()
returns true.

This issue was exposed by pci_dev_run_wake() change in
commit 8feaec33b986 ("PCI / PM: Always check PME wakeup capability for
runtime wakeup support")
and should be backported to kernels with that change

Cc: <stable@vger.kernel.org> # 4.13+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 4917c5b033fa..da7c2db41671 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -302,6 +302,9 @@ static int xhci_pci_setup(struct usb_hcd *hcd)
 	if (!usb_hcd_is_primary_hcd(hcd))
 		return 0;
 
+	if (xhci->quirks & XHCI_PME_STUCK_QUIRK)
+		xhci_pme_acpi_rtd3_enable(pdev);
+
 	xhci_dbg(xhci, "Got SBRN %u\n", (unsigned int) xhci->sbrn);
 
 	/* Find any debug ports */
@@ -359,9 +362,6 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 			HCC_MAX_PSA(xhci->hcc_params) >= 4)
 		xhci->shared_hcd->can_do_streams = 1;
 
-	if (xhci->quirks & XHCI_PME_STUCK_QUIRK)
-		xhci_pme_acpi_rtd3_enable(dev);
-
 	/* USB-2 and USB-3 roothubs initialized, allow runtime pm suspend */
 	pm_runtime_put_noidle(&dev->dev);
 
-- 
2.17.1

