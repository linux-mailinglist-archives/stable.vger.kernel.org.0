Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC88C4266A5
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 11:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbhJHJZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 05:25:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:41430 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237740AbhJHJZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 05:25:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="249830677"
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="249830677"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 02:23:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="489390451"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga008.jf.intel.com with ESMTP; 08 Oct 2021 02:23:12 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Jonathan Bell <jonathan@raspberrypi.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 1/5] xhci: guard accesses to ep_state in xhci_endpoint_reset()
Date:   Fri,  8 Oct 2021 12:25:43 +0300
Message-Id: <20211008092547.3996295-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211008092547.3996295-1-mathias.nyman@linux.intel.com>
References: <20211008092547.3996295-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bell <jonathan@raspberrypi.com>

See https://github.com/raspberrypi/linux/issues/3981

Two read-modify-write cycles on ep->ep_state are not guarded by
xhci->lock. Fix these.

Signed-off-by: Jonathan Bell <jonathan@raspberrypi.com>
Fixes: f5249461b504 ("xhci: Clear the host side toggle manually when endpoint is soft reset")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 93c38b557afd..541fe4dcc43a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3214,10 +3214,13 @@ static void xhci_endpoint_reset(struct usb_hcd *hcd,
 		return;
 
 	/* Bail out if toggle is already being cleared by a endpoint reset */
+	spin_lock_irqsave(&xhci->lock, flags);
 	if (ep->ep_state & EP_HARD_CLEAR_TOGGLE) {
 		ep->ep_state &= ~EP_HARD_CLEAR_TOGGLE;
+		spin_unlock_irqrestore(&xhci->lock, flags);
 		return;
 	}
+	spin_unlock_irqrestore(&xhci->lock, flags);
 	/* Only interrupt and bulk ep's use data toggle, USB2 spec 5.5.4-> */
 	if (usb_endpoint_xfer_control(&host_ep->desc) ||
 	    usb_endpoint_xfer_isoc(&host_ep->desc))
@@ -3303,8 +3306,10 @@ static void xhci_endpoint_reset(struct usb_hcd *hcd,
 	xhci_free_command(xhci, cfg_cmd);
 cleanup:
 	xhci_free_command(xhci, stop_cmd);
+	spin_lock_irqsave(&xhci->lock, flags);
 	if (ep->ep_state & EP_SOFT_CLEAR_TOGGLE)
 		ep->ep_state &= ~EP_SOFT_CLEAR_TOGGLE;
+	spin_unlock_irqrestore(&xhci->lock, flags);
 }
 
 static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,
-- 
2.25.1

