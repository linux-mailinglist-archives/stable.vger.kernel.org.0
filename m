Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497403371CE
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 12:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhCKLwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 06:52:40 -0500
Received: from mga04.intel.com ([192.55.52.120]:42441 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232766AbhCKLwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 06:52:32 -0500
IronPort-SDR: izGyOYbaGaJmyst+MyAuxCIHnBjmHlxjGaC9WazGI7Dqhc3mCzmGeNCNExXcxjFCQ+B2WuX942
 2Q9+Icbx+PRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="186276002"
X-IronPort-AV: E=Sophos;i="5.81,240,1610438400"; 
   d="scan'208";a="186276002"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 03:52:31 -0800
IronPort-SDR: Wb8S3uHLQf8aoG2JUMRvkhL4Um0hhlxTNFc+y5gnnYk6tABGED6OgVuDlgQtOndHXw2dEGIaSa
 h5AYJEgRbtAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,240,1610438400"; 
   d="scan'208";a="409463978"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2021 03:52:25 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Stanislaw Gruszka <stf_xl@wp.pl>,
        stable@vger.kernel.org, Bernhard <bernhard.gebetsberger@gmx.at>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 1/4] usb: xhci: do not perform Soft Retry for some xHCI hosts
Date:   Thu, 11 Mar 2021 13:53:50 +0200
Message-Id: <20210311115353.2137560-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311115353.2137560-1-mathias.nyman@linux.intel.com>
References: <20210311115353.2137560-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislaw Gruszka <stf_xl@wp.pl>

On some systems rt2800usb and mt7601u devices are unable to operate since
commit f8f80be501aa ("xhci: Use soft retry to recover faster from
transaction errors")

Seems that some xHCI controllers can not perform Soft Retry correctly,
affecting those devices.

To avoid the problem add xhci->quirks flag that restore pre soft retry
xhci behaviour for affected xHCI controllers. Currently those are
AMD_PROMONTORYA_4 and AMD_PROMONTORYA_2, since it was confirmed
by the users: on those xHCI hosts issue happen and is gone after
disabling Soft Retry.

[minor commit message rewording for checkpatch -Mathias]
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202541
Fixes: f8f80be501aa ("xhci: Use soft retry to recover faster from transaction errors")
Cc: <stable@vger.kernel.org> # 4.20+
Reported-by: Bernhard <bernhard.gebetsberger@gmx.at>
Tested-by: Bernhard <bernhard.gebetsberger@gmx.at>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c  | 5 +++++
 drivers/usb/host/xhci-ring.c | 3 ++-
 drivers/usb/host/xhci.h      | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 84da8406d5b4..1f989a49c8c6 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -295,6 +295,11 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == 0x9026)
 		xhci->quirks |= XHCI_RESET_PLL_ON_DISCONNECT;
 
+	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
+	    (pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_2 ||
+	     pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_4))
+		xhci->quirks |= XHCI_NO_SOFT_RETRY;
+
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"QUIRK: Resetting on resume");
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 5e548a1c93ab..ce38076901e2 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2484,7 +2484,8 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		remaining	= 0;
 		break;
 	case COMP_USB_TRANSACTION_ERROR:
-		if ((ep_ring->err_count++ > MAX_SOFT_RETRY) ||
+		if (xhci->quirks & XHCI_NO_SOFT_RETRY ||
+		    (ep_ring->err_count++ > MAX_SOFT_RETRY) ||
 		    le32_to_cpu(slot_ctx->tt_info) & TT_SLOT)
 			break;
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index d41de5dc0452..ca822ad3b65b 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1891,6 +1891,7 @@ struct xhci_hcd {
 #define XHCI_SKIP_PHY_INIT	BIT_ULL(37)
 #define XHCI_DISABLE_SPARSE	BIT_ULL(38)
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
+#define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.25.1

