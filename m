Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A78657F38
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiL1QDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbiL1QCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:02:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F5D192A3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:02:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BF97B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AA4C433D2;
        Wed, 28 Dec 2022 16:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243346;
        bh=1gcWucT5Vh7LGy2jKM3SozrcRdTed8rJdJ1qE5dYkjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXfgFmGclbr075MpZ/pHfxYHHeKUBe8pVD0dxkLU7hsfiXuBavS8HNSdZZ36e/Lcd
         ImE7kEnrr3VdrQOvJXyglJVtsV6BLneyRANo0JbodrnJMTjNmn6C/pCrtJK4quJTE6
         04mW0rhDpYYgdYESVC6UKtbVErHFmpAnrL9BuKX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 711/731] xhci: Prevent infinite loop in transaction errors recovery for streams
Date:   Wed, 28 Dec 2022 15:43:38 +0100
Message-Id: <20221228144317.057700246@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit a1575120972ecd7baa6af6a69e4e7ea9213bde7c upstream.

Make sure to also limit the amount of soft reset retries for transaction
errors on streams in cases where the transaction error event doesn't point
to any specific TRB.

In these cases we don't know the TRB or stream ring, but we do know which
endpoint had the error.

To keep error counting simple and functional, move the current err_count
from ring structure to endpoint structure.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20221130091944.2171610-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   14 ++++++++++----
 drivers/usb/host/xhci.h      |    2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2524,7 +2524,7 @@ static int process_bulk_intr_td(struct x
 
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
-		ep_ring->err_count = 0;
+		ep->err_count = 0;
 		/* handle success with untransferred data as short packet */
 		if (ep_trb != td->last_trb || remaining) {
 			xhci_warn(xhci, "WARN Successful completion on short TX\n");
@@ -2550,7 +2550,7 @@ static int process_bulk_intr_td(struct x
 		break;
 	case COMP_USB_TRANSACTION_ERROR:
 		if (xhci->quirks & XHCI_NO_SOFT_RETRY ||
-		    (ep_ring->err_count++ > MAX_SOFT_RETRY) ||
+		    (ep->err_count++ > MAX_SOFT_RETRY) ||
 		    le32_to_cpu(slot_ctx->tt_info) & TT_SLOT)
 			break;
 
@@ -2631,8 +2631,14 @@ static int handle_tx_event(struct xhci_h
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
@@ -1629,7 +1630,6 @@ struct xhci_ring {
 	 * if we own the TRB (if we are the consumer).  See section 4.9.1.
 	 */
 	u32			cycle_state;
-	unsigned int            err_count;
 	unsigned int		stream_id;
 	unsigned int		num_segs;
 	unsigned int		num_trbs_free;


