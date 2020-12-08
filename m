Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9439F2D27B0
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 10:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgLHJbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 04:31:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:9885 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727745AbgLHJbK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 04:31:10 -0500
IronPort-SDR: ParJaAwdKAH4TQOijb1YOiGowubC6P9+zAgYbHgjPDzJNg2hYB2FVmfaPYr7ztIcLYGWKaCa1u
 l9G4YqC2JXGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="235460694"
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="235460694"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 01:28:07 -0800
IronPort-SDR: LPAtSp8n01TZ0SQxsUNIICc9+Z+1evzMwfxRR7PtH5KdJhlb64yQX/X8/R2f1FQZ2KzJetFY6v
 GA+dLTQ8Cukg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="552165913"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga005.jf.intel.com with ESMTP; 08 Dec 2020 01:28:05 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Li Jun <jun.li@nxp.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5/5] xhci: Give USB2 ports time to enter U3 in bus suspend
Date:   Tue,  8 Dec 2020 11:29:12 +0200
Message-Id: <20201208092912.1773650-6-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201208092912.1773650-1-mathias.nyman@linux.intel.com>
References: <20201208092912.1773650-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

If a USB2 device wakeup is not enabled/supported the link state may
still be in U0 in xhci_bus_suspend(), where it's then manually put
to suspended U3 state.

Just as with selective suspend the device needs time to enter U3
suspend before continuing with further suspend operations
(e.g. system suspend), otherwise we may enter system suspend with link
state in U0.

[commit message rewording -Mathias]
Cc: <stable@vger.kernel.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index c799ca5361d4..74c497fd3476 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1712,6 +1712,10 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
 	hcd->state = HC_STATE_SUSPENDED;
 	bus_state->next_statechange = jiffies + msecs_to_jiffies(10);
 	spin_unlock_irqrestore(&xhci->lock, flags);
+
+	if (bus_state->bus_suspended)
+		usleep_range(5000, 10000);
+
 	return 0;
 }
 
-- 
2.25.1

