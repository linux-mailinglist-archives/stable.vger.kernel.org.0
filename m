Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDE024D132
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 11:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgHUJMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 05:12:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:65060 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgHUJMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 05:12:47 -0400
IronPort-SDR: YsSiN+7ZdFMhZV3q41L6suoPN4aBKx2Jgntd7L6iRiPAMmXjoK6AIudp3g/iVN4DQMtTVxhcB+
 ucfuAuYYU13A==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="143128379"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="143128379"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 02:12:47 -0700
IronPort-SDR: ApBpiIXPkEePgPrHMGK3xbzaDGFSZZrywAoIP2j3jTV6XQCcHib55P9PbQnp1UN8tuu7Sp8sBB
 VKCJ53B+opFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="321194900"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga004.fm.intel.com with ESMTP; 21 Aug 2020 02:12:44 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 2/3] xhci: Do warm-reset when both CAS and XDEV_RESUME are set
Date:   Fri, 21 Aug 2020 12:15:48 +0300
Message-Id: <20200821091549.20556-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821091549.20556-1-mathias.nyman@linux.intel.com>
References: <20200821091549.20556-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

Sometimes re-plugging a USB device during system sleep renders the device
useless:
[  173.418345] xhci_hcd 0000:00:14.0: Get port status 2-4 read: 0x14203e2, return 0x10262
...
[  176.496485] usb 2-4: Waited 2000ms for CONNECT
[  176.496781] usb usb2-port4: status 0000.0262 after resume, -19
[  176.497103] usb 2-4: can't resume, status -19
[  176.497438] usb usb2-port4: logical disconnect

Because PLS equals to XDEV_RESUME, xHCI driver reports U3 to usbcore,
despite of CAS bit is flagged.

So proritize CAS over XDEV_RESUME to let usbcore handle warm-reset for
the port.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index c3554e37e09f..4e14e164cb68 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -740,15 +740,6 @@ static void xhci_hub_report_usb3_link_state(struct xhci_hcd *xhci,
 {
 	u32 pls = status_reg & PORT_PLS_MASK;
 
-	/* resume state is a xHCI internal state.
-	 * Do not report it to usb core, instead, pretend to be U3,
-	 * thus usb core knows it's not ready for transfer
-	 */
-	if (pls == XDEV_RESUME) {
-		*status |= USB_SS_PORT_LS_U3;
-		return;
-	}
-
 	/* When the CAS bit is set then warm reset
 	 * should be performed on port
 	 */
@@ -770,6 +761,16 @@ static void xhci_hub_report_usb3_link_state(struct xhci_hcd *xhci,
 		 */
 		pls |= USB_PORT_STAT_CONNECTION;
 	} else {
+		/*
+		 * Resume state is an xHCI internal state.  Do not report it to
+		 * usb core, instead, pretend to be U3, thus usb core knows
+		 * it's not ready for transfer.
+		 */
+		if (pls == XDEV_RESUME) {
+			*status |= USB_SS_PORT_LS_U3;
+			return;
+		}
+
 		/*
 		 * If CAS bit isn't set but the Port is already at
 		 * Compliance Mode, fake a connection so the USB core
-- 
2.17.1

