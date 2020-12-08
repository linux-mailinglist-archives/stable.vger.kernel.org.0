Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B602D27A9
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 10:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgLHJbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 04:31:07 -0500
Received: from mga06.intel.com ([134.134.136.31]:9877 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727647AbgLHJbH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 04:31:07 -0500
IronPort-SDR: 7cJc4MpzznhSIZrEuyPD8IhYzBdaDQtitaYSUcqbVl7sVkE8CL288QjBzvuuWoUJMDDILv9b/6
 STPqQBqtjYaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="235460689"
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="235460689"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 01:28:04 -0800
IronPort-SDR: oPaoZGDOzrTnZkayFGkNfnOVN5EKyxMuEaANrejIGzvPvJyyEaLT+2K4T2EV43zZIeSJkyr2JS
 0igSbsO4w4oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="552165902"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga005.jf.intel.com with ESMTP; 08 Dec 2020 01:28:02 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3/5] xhci-pci: Allow host runtime PM as default for Intel Alpine Ridge LP
Date:   Tue,  8 Dec 2020 11:29:10 +0200
Message-Id: <20201208092912.1773650-4-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201208092912.1773650-1-mathias.nyman@linux.intel.com>
References: <20201208092912.1773650-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

The xHCI controller on Alpine Ridge LP keeps the whole Thunderbolt
controller awake if the host controller is not allowed to sleep.
This is the case even if no USB devices are connected to the host.

Add the Intel Alpine Ridge LP product-id to the list of product-ids
for which we allow runtime PM by default.

Fixes: 2815ef7fe4d4 ("xhci-pci: allow host runtime PM as default for Intel Alpine and Titan Ridge")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index bf89172c43ca..5f94d7edeb37 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -47,6 +47,7 @@
 #define PCI_DEVICE_ID_INTEL_DNV_XHCI			0x19d0
 #define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_2C_XHCI	0x15b5
 #define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_4C_XHCI	0x15b6
+#define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_LP_XHCI	0x15c1
 #define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_C_2C_XHCI	0x15db
 #define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_C_4C_XHCI	0x15d4
 #define PCI_DEVICE_ID_INTEL_TITAN_RIDGE_2C_XHCI		0x15e9
@@ -232,6 +233,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 	    (pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_2C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_4C_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_LP_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_C_2C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_C_4C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_TITAN_RIDGE_2C_XHCI ||
-- 
2.25.1

