Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5952C60B500
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiJXSLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiJXSLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:11:21 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC01526643B;
        Mon, 24 Oct 2022 09:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666630374; x=1698166374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bexf1Q4IXvJ0nXE7OXISfS8HSsFBlE4lIaoPqYMF2CU=;
  b=RdnqU9CJXYfrRVMXg2JrYrhRMLf/fIeSLmv4MmgTK6g/RVvUqdde+9ME
   j8thPOP6z+WBP/NMMVXRZ7uiMF8iUmzttdFid+hYh0Sqs5FG+gh5RjsdT
   JNMY12mhtbw5HHs1Url/72FmShsR93J09bdHl+VqWbzgwqH94tMzZZ9Ek
   kpSuLwKaKc0dzz3Xp1gkWgz0x3T+M8s3Ha0jKzbbLT6hJrRKbg7vfHDdo
   xYeEvnIhI8++JEn/CObWnzeyzLJOiwZCmTEmeubXDuCy0UP4mpGHtyj0Y
   yyFgJICHlC2RREIngMqK4fX6A9mn1AU7/NqL3ukoiyHnKCElRPwaEFiUi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="290732871"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="290732871"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 07:26:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="700177617"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="700177617"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga004.fm.intel.com with ESMTP; 24 Oct 2022 07:26:02 -0700
From:   Mathias Nyman <mathias.nyman@intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/4] xhci: Add quirk to reset host back to default state at shutdown
Date:   Mon, 24 Oct 2022 17:27:18 +0300
Message-Id: <20221024142720.4122053-3-mathias.nyman@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221024142720.4122053-1-mathias.nyman@intel.com>
References: <20221024142720.4122053-1-mathias.nyman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

Systems based on Alder Lake P see significant boot time delay if
boot firmware tries to control usb ports in unexpected link states.

This is seen with self-powered usb devices that survive in U3 link
suspended state over S5.

A more generic solution to power off ports at shutdown was attempted in
commit 83810f84ecf1 ("xhci: turn off port power in shutdown")
but it caused regression.

Add host specific XHCI_RESET_TO_DEFAULT quirk which will reset host and
ports back to default state in shutdown.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c |  4 ++++
 drivers/usb/host/xhci.c     | 10 ++++++++--
 drivers/usb/host/xhci.h     |  1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 6dd3102749b7..fbbd547ba12a 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -257,6 +257,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == PCI_DEVICE_ID_INTEL_DNV_XHCI))
 		xhci->quirks |= XHCI_MISSING_CAS;
 
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI)
+		xhci->quirks |= XHCI_RESET_TO_DEFAULT;
+
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 	    (pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_2C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_4C_XHCI ||
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 5176765c4013..79d7931c048a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -810,9 +810,15 @@ void xhci_shutdown(struct usb_hcd *hcd)
 
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
-	/* Workaround for spurious wakeups at shutdown with HSW */
-	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+
+	/*
+	 * Workaround for spurious wakeps at shutdown with HSW, and for boot
+	 * firmware delay in ADL-P PCH if port are left in U3 at shutdown
+	 */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP ||
+	    xhci->quirks & XHCI_RESET_TO_DEFAULT)
 		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
+
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index c0964fe8ac12..cc084d9505cd 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1897,6 +1897,7 @@ struct xhci_hcd {
 #define XHCI_BROKEN_D3COLD	BIT_ULL(41)
 #define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 #define XHCI_SUSPEND_RESUME_CLKS	BIT_ULL(43)
+#define XHCI_RESET_TO_DEFAULT	BIT_ULL(44)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.25.1

