Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD9538FC1D
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhEYIJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:09:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:31759 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231961AbhEYIJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 04:09:05 -0400
IronPort-SDR: nI3rIPl8FHWSzH/Qa+Yin1ZxIPJvmRW4PyZuac6e87eQUayhxY2+Ca+fhQIud/aY0DkFghFfrV
 2Gb5EK0svDpQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9994"; a="181767647"
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="181767647"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 00:38:57 -0700
IronPort-SDR: w/+bxz1WPKfdBIpomh7O8zz32YMTtLiJVSQ+3Roqf0P3688ler2NvTd2Gsi0UjX5GI5A/KyE9K
 jHbb3c2FysyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="546464456"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga001.fm.intel.com with ESMTP; 25 May 2021 00:38:56 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Peter Ganzhorn <peter.ganzhorn@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] xhci: Fix 5.12 regression of missing xHC cache clearing command after a Stall
Date:   Tue, 25 May 2021 10:41:00 +0300
Message-Id: <20210525074100.1154090-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525074100.1154090-1-mathias.nyman@linux.intel.com>
References: <20210525074100.1154090-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If endpoints halts due to a stall then the dequeue pointer read from
hardware may already be set ahead of the stalled TRB.
After commit 674f8438c121 ("xhci: split handling halted endpoints into two
steps") in 5.12 xhci driver won't issue a Set TR Dequeue if hardware
dequeue pointer is already in the right place.

Turns out the "Set TR Dequeue pointer" command is anyway needed as it in
addition to moving the dequeue pointer also clears endpoint state and
cache.

Reported-by: Peter Ganzhorn <peter.ganzhorn@googlemail.com>
Tested-by: Peter Ganzhorn <peter.ganzhorn@googlemail.com>
Fixes: 674f8438c121 ("xhci: split handling halted endpoints into two steps")
Cc: <stable@vger.kernel.org> # 5.12
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 256d336354a0..6acd2329e08d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -933,14 +933,18 @@ static int xhci_invalidate_cancelled_tds(struct xhci_virt_ep *ep)
 			continue;
 		}
 		/*
-		 * If ring stopped on the TD we need to cancel, then we have to
+		 * If a ring stopped on the TD we need to cancel then we have to
 		 * move the xHC endpoint ring dequeue pointer past this TD.
+		 * Rings halted due to STALL may show hw_deq is past the stalled
+		 * TD, but still require a set TR Deq command to flush xHC cache.
 		 */
 		hw_deq = xhci_get_hw_deq(xhci, ep->vdev, ep->ep_index,
 					 td->urb->stream_id);
 		hw_deq &= ~0xf;
 
-		if (trb_in_td(xhci, td->start_seg, td->first_trb,
+		if (td->cancel_status == TD_HALTED) {
+			cached_td = td;
+		} else if (trb_in_td(xhci, td->start_seg, td->first_trb,
 			      td->last_trb, hw_deq, false)) {
 			switch (td->cancel_status) {
 			case TD_CLEARED: /* TD is already no-op */
-- 
2.25.1

