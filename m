Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF14F37B76C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhELIHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:07:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:32313 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhELIHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 04:07:42 -0400
IronPort-SDR: jAOivGY+TfgqqmTCjCAmM4em6XiZEz9v4WjlipTxcNG63aQzhLj/rWI74jyjDiDYdjveLxHMbq
 cnkvHtGEYIXg==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="220616880"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="220616880"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 01:06:31 -0700
IronPort-SDR: u88WJVahEWnzu8oTuF41IROw5IBEeszTtK3/QRks4QfuvIJwEAwrxip5yzsIpgmlUCy83W+098
 diA59LXK/pMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="625208240"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga005.fm.intel.com with ESMTP; 12 May 2021 01:06:29 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Abhijeet Rao <abhijeet.rao@intel.com>,
        stable@vger.kernel.org,
        "Nikunj A . Dadhania" <nikunj.dadhania@intel.com>,
        Azhar Shaikh <azhar.shaikh@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 1/5] xhci-pci: Allow host runtime PM as default for Intel Alder Lake xHCI
Date:   Wed, 12 May 2021 11:08:12 +0300
Message-Id: <20210512080816.866037-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210512080816.866037-1-mathias.nyman@linux.intel.com>
References: <20210512080816.866037-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhijeet Rao <abhijeet.rao@intel.com>

In the same way as Intel Tiger Lake TCSS (Type-C Subsystem) the Alder Lake
TCSS xHCI needs to be runtime suspended whenever possible to allow the
TCSS hardware block to enter D3cold and thus save energy.

Cc: stable@vger.kernel.org
Signed-off-by: Abhijeet Rao <abhijeet.rao@intel.com>
Signed-off-by: Nikunj A. Dadhania <nikunj.dadhania@intel.com>
Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 5bbccc9a0179..a858add8436c 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -57,6 +57,7 @@
 #define PCI_DEVICE_ID_INTEL_CML_XHCI			0xa3af
 #define PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI		0x9a13
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
+#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI		0x461e
 
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
@@ -243,7 +244,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ICE_LAKE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI))
+	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
-- 
2.25.1

