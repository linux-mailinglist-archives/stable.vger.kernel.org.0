Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B0120750A
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 15:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404002AbgFXN45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 09:56:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:43621 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403988AbgFXN44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 09:56:56 -0400
IronPort-SDR: CHxjOlN/I2NnaeCepfCigJ0SdDWQQcUzX6Wy3fLi7T5CiYofUpLGQ97tLberabqDLNtxoYUiiB
 ec3C2QplRDtg==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="132909273"
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="132909273"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 06:56:54 -0700
IronPort-SDR: 7GufgUfPevYUFSYVvAr9L29Z7PKaQpp69WU9cT/WnXmMyxdxIRmoD+/fs8roW8eq/Dh0fUSoi4
 ImJvbq1Ygh3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="263644059"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jun 2020 06:56:53 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4/5] xhci: Return if xHCI doesn't support LPM
Date:   Wed, 24 Jun 2020 16:59:48 +0300
Message-Id: <20200624135949.22611-5-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624135949.22611-1-mathias.nyman@linux.intel.com>
References: <20200624135949.22611-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

Just return if xHCI is quirked to disable LPM. We can save some time
from reading registers and doing spinlocks.

Add stable tag as we want this patch together with the next one,
"Poll for U0 after disabling USB2 LPM" which fixes a suspend issue
for some USB2 LPM devices

Cc: stable@vger.kernel.org
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 03b64b73eb99..f97106e2860f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4391,6 +4391,9 @@ static int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 	int		hird, exit_latency;
 	int		ret;
 
+	if (xhci->quirks & XHCI_HW_LPM_DISABLE)
+		return -EPERM;
+
 	if (hcd->speed >= HCD_USB3 || !xhci->hw_lpm_support ||
 			!udev->lpm_capable)
 		return -EPERM;
@@ -4413,7 +4416,7 @@ static int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 	xhci_dbg(xhci, "%s port %d USB2 hardware LPM\n",
 			enable ? "enable" : "disable", port_num + 1);
 
-	if (enable && !(xhci->quirks & XHCI_HW_LPM_DISABLE)) {
+	if (enable) {
 		/* Host supports BESL timeout instead of HIRD */
 		if (udev->usb2_hw_lpm_besl_capable) {
 			/* if device doesn't have a preferred BESL value use a
-- 
2.17.1

