Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C6638FC46
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhEYIK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:10:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:31759 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232079AbhEYIJe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 04:09:34 -0400
IronPort-SDR: IoDfQ+6EsChNy23OO+CCSFnFNccJpJXdePk7/V5ldvr2/bKLHMbURYinsC1rCep8xO50gIadPn
 MjY5x2J0efnQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9994"; a="181767645"
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="181767645"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 00:38:56 -0700
IronPort-SDR: +GtxmqZd4aKvHYndGGGVhQW8fJdQ1/uPZwb8C5RZQLHExwu8Ekh7AD3/b2dNJLENQYzwbxnwIw
 Dg6vGmLV7viQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="546464445"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga001.fm.intel.com with ESMTP; 25 May 2021 00:38:54 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Peter Ganzhorn <peter.ganzhorn@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] xhci: fix giving back URB with incorrect status regression in 5.12
Date:   Tue, 25 May 2021 10:40:59 +0300
Message-Id: <20210525074100.1154090-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525074100.1154090-1-mathias.nyman@linux.intel.com>
References: <20210525074100.1154090-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5.12 kernel changes how xhci handles cancelled URBs and halted
endpoints. Among these changes cancelled and stalled URBs are no longer
given back before they are cleared from xHC hardware cache.

These changes unfortunately cleared the -EPIPE status of a stalled
transfer in one case before giving bak the URB, causing a USB card reader
to fail from working.

Reported-by: Peter Ganzhorn <peter.ganzhorn@googlemail.com>
Tested-by: Peter Ganzhorn <peter.ganzhorn@googlemail.com>
Fixes: 674f8438c121 ("xhci: split handling halted endpoints into two steps")
Cc: <stable@vger.kernel.org> # 5.12
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index a8e4189277da..256d336354a0 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -828,14 +828,10 @@ static void xhci_giveback_invalidated_tds(struct xhci_virt_ep *ep)
 	list_for_each_entry_safe(td, tmp_td, &ep->cancelled_td_list,
 				 cancelled_td_list) {
 
-		/*
-		 * Doesn't matter what we pass for status, since the core will
-		 * just overwrite it (because the URB has been unlinked).
-		 */
 		ring = xhci_urb_to_transfer_ring(ep->xhci, td->urb);
 
 		if (td->cancel_status == TD_CLEARED)
-			xhci_td_cleanup(ep->xhci, td, ring, 0);
+			xhci_td_cleanup(ep->xhci, td, ring, td->status);
 
 		if (ep->xhci->xhc_state & XHCI_STATE_DYING)
 			return;
-- 
2.25.1

