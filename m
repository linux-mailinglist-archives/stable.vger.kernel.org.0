Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD18663D199
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 10:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiK3JSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 04:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbiK3JSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 04:18:23 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF8F56D40;
        Wed, 30 Nov 2022 01:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669799902; x=1701335902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iedjmQIOCc41+OwF/Rn/1aQX09s7hqd3FiY8I7GR+Zw=;
  b=bZvtR0ofmZKsiKBAHGDp1+pJpx5w2j1Ck4Qjyw2WU2OJBc9tzLCmqE+U
   272/fJIBBaVDuXUYSZzThA0CSX1MY2VsvMT0BHU/6WOU7xPvJSHaUWMx/
   hQkJcC6Uz6vKc41jkPxLZL4DZ2AUraL5/SXIzDMPd49KzzJhU7igyrOmj
   aV1wgAxwcqRxX67M/pYprlR5n9wxx9PR0+y6Ar5fynhH5QlcZV3N7KWGn
   z2Ttd996sy7Rey+UEc0YGqu8Z2W8A8XxFZJFu7UION9Sg9OFfenzQoNyQ
   sa4dGwDJfaVwYN8HiarPW9CsWcz1750vCIaNoqZ1/I8dPsQVlNB8R8n1b
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="295711294"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="295711294"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 01:18:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="674962718"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="674962718"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga008.jf.intel.com with ESMTP; 30 Nov 2022 01:18:20 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 5/6] xhci: Prevent infinite loop in transaction errors recovery for streams
Date:   Wed, 30 Nov 2022 11:19:43 +0200
Message-Id: <20221130091944.2171610-6-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221130091944.2171610-1-mathias.nyman@linux.intel.com>
References: <20221130091944.2171610-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to also limit the amount of soft reset retries for transaction
errors on streams in cases where the transaction error event doesn't point
to any specific TRB.

In these cases we don't know the TRB or stream ring, but we do know which
endpoint had the error.

To keep error counting simple and functional, move the current err_count
from ring structure to endpoint structure.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 14 ++++++++++----
 drivers/usb/host/xhci.h      |  2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index f6af479188e8..039ec9734fcd 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2458,7 +2458,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
 
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
-		ep_ring->err_count = 0;
+		ep->err_count = 0;
 		/* handle success with untransferred data as short packet */
 		if (ep_trb != td->last_trb || remaining) {
 			xhci_warn(xhci, "WARN Successful completion on short TX\n");
@@ -2484,7 +2484,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
 		break;
 	case COMP_USB_TRANSACTION_ERROR:
 		if (xhci->quirks & XHCI_NO_SOFT_RETRY ||
-		    (ep_ring->err_count++ > MAX_SOFT_RETRY) ||
+		    (ep->err_count++ > MAX_SOFT_RETRY) ||
 		    le32_to_cpu(slot_ctx->tt_info) & TT_SLOT)
 			break;
 
@@ -2565,8 +2565,14 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		case COMP_USB_TRANSACTION_ERROR:
 		case COMP_INVALID_STREAM_TYPE_ERROR:
 		case COMP_INVALID_STREAM_ID_ERROR:
-			xhci_handle_halted_endpoint(xhci, ep, 0, NULL,
-						    EP_SOFT_RESET);
+			xhci_dbg(xhci, "Stream transaction error ep %u no id\n",
+				 ep_index);
+			if (ep->err_count++ > MAX_SOFT_RETRY)
+				xhci_handle_halted_endpoint(xhci, ep, 0, NULL,
+							    EP_HARD_RESET);
+			else
+				xhci_handle_halted_endpoint(xhci, ep, 0, NULL,
+							    EP_SOFT_RESET);
 			goto cleanup;
 		case COMP_RING_UNDERRUN:
 		case COMP_RING_OVERRUN:
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index cc084d9505cd..c9f06c5e4e9d 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -933,6 +933,7 @@ struct xhci_virt_ep {
 	 * have to restore the device state to the previous state
 	 */
 	struct xhci_ring		*new_ring;
+	unsigned int			err_count;
 	unsigned int			ep_state;
 #define SET_DEQ_PENDING		(1 << 0)
 #define EP_HALTED		(1 << 1)	/* For stall handling */
@@ -1627,7 +1628,6 @@ struct xhci_ring {
 	 * if we own the TRB (if we are the consumer).  See section 4.9.1.
 	 */
 	u32			cycle_state;
-	unsigned int            err_count;
 	unsigned int		stream_id;
 	unsigned int		num_segs;
 	unsigned int		num_trbs_free;
-- 
2.25.1

