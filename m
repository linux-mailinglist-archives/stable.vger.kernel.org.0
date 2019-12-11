Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F49D11AD36
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbfLKOSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:18:38 -0500
Received: from mga07.intel.com ([134.134.136.100]:52849 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbfLKOSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 09:18:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 06:18:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="414868247"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga006.fm.intel.com with ESMTP; 11 Dec 2019 06:18:35 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 5/6] xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default behaviour.
Date:   Wed, 11 Dec 2019 16:20:06 +0200
Message-Id: <20191211142007.8847-6-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211142007.8847-1-mathias.nyman@linux.intel.com>
References: <20191211142007.8847-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

xhci driver claims it needs XHCI_TRUST_TX_LENGTH quirk for both
Broadcom/Cavium and a Renesas xHC controllers.

The quirk was inteded for handling false "success" complete event for
transfers that had data left untransferred.
These transfers should complete with "short packet" events instead.

In these two new cases the false "success" completion is reported
after a "short packet" if the TD consists of several TRBs.
xHCI specs 4.10.1.1.2 say remaining TRBs should report "short packet"
as well after the first short packet in a TD, but this issue seems so
common it doesn't make sense to add the quirk for all vendors.

Turn these events into short packets automatically instead.

This gets rid of the  "The WARN Successful completion on short TX for
slot 1 ep 1: needs XHCI_TRUST_TX_LENGTH quirk" warning in many cases.

Cc: <stable@vger.kernel.org>
Reported-by: Eli Billauer <eli.billauer@gmail.com>
Reported-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Eli Billauer <eli.billauer@gmail.com>
Tested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 9ebaa8e132a9..d23f7408c81f 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2381,7 +2381,8 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	case COMP_SUCCESS:
 		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
 			break;
-		if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
+		if (xhci->quirks & XHCI_TRUST_TX_LENGTH ||
+		    ep_ring->last_td_was_short)
 			trb_comp_code = COMP_SHORT_PACKET;
 		else
 			xhci_warn_ratelimited(xhci,
-- 
2.17.1

