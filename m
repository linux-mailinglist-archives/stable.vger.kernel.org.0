Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65ED125B85C
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 03:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgICBnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 21:43:02 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:53962 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726177AbgICBnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 21:43:00 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BA8DD404A2;
        Thu,  3 Sep 2020 01:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1599097379; bh=cKk7lvg8pSvU/gmbzlroFX67RKJIY7jUzel0Rqc+uXE=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=ifdkZy4KipSF8yqLWXo5wLnQ6cm7D7uttWT54NAkHcHMtA1cBLDXh2kIIneI32HnW
         GVyNiTM3ag5KvT7KCxWNbiJAv+RyqRnF0/Ka2DcDYkYuypGMIwy6gJHmUibdBwIdPE
         9pwTocp+VRqiFZB2SCk++1d3FoSS8oernf3Zziz9RB+xwlf98blp+SNghZMPcCvZaJ
         C6d3ETDpL2oXSgCaHtiFw3bFTFWxoNbt646cn5utK78MDta6k6MCj1ZwpwQ83Nmb+X
         zCNjCWlKqheOc32SPnt3t90DMQHmIp0X82TTIENF/o2G85LjB9rJA5AeLA2BrW0XRz
         RC93iNRRtuDrQ==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 4A63FA007B;
        Thu,  3 Sep 2020 01:42:58 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Wed, 02 Sep 2020 18:42:58 -0700
Date:   Wed, 02 Sep 2020 18:42:58 -0700
Message-Id: <037e16f184c6823752635e8d9d643f69e05682ff.1599096763.git.thinhn@synopsys.com>
In-Reply-To: <cover.1599096763.git.thinhn@synopsys.com>
References: <cover.1599096763.git.thinhn@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2 1/2] usb: dwc3: gadget: Resume pending requests after CLEAR_STALL
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function driver may queue new requests right after halting the
endpoint (i.e. queue new requests while the endpoint is stalled).
There's no restriction preventing it from doing so. However, dwc3
currently drops those requests after CLEAR_STALL. The driver should only
drop started requests. Keep the pending requests in the pending list to
resume and process them after the host issues ClearFeature(Halt) to the
endpoint.

Cc: stable@vger.kernel.org
Fixes: cb11ea56f37a ("usb: dwc3: gadget: Properly handle ClearFeature(halt)")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
---
Changes in v2:
- Account for wedged endpoint
- Account for CLEAR_FEATURE on stopped endpoints with pending requests
  (END_TRANSFER command won't be issued for stopped endpoints, so just kick
  pending request right after CLEAR_STALL)

 drivers/usb/dwc3/gadget.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index c2a0f64f8d1e..c04f7b29535e 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1628,8 +1628,13 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 	if (dep->flags & DWC3_EP_WAIT_TRANSFER_COMPLETE)
 		return 0;
 
-	/* Start the transfer only after the END_TRANSFER is completed */
-	if (dep->flags & DWC3_EP_END_TRANSFER_PENDING) {
+	/*
+	 * Start the transfer only after the END_TRANSFER is completed
+	 * and endpoint STALL is cleared.
+	 */
+	if ((dep->flags & DWC3_EP_END_TRANSFER_PENDING) ||
+	    (dep->flags & DWC3_EP_WEDGE) ||
+	    (dep->flags & DWC3_EP_STALL)) {
 		dep->flags |= DWC3_EP_DELAY_START;
 		return 0;
 	}
@@ -1836,13 +1841,14 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol)
 		list_for_each_entry_safe(req, tmp, &dep->started_list, list)
 			dwc3_gadget_move_cancelled_request(req);
 
-		list_for_each_entry_safe(req, tmp, &dep->pending_list, list)
-			dwc3_gadget_move_cancelled_request(req);
-
-		if (!(dep->flags & DWC3_EP_END_TRANSFER_PENDING)) {
-			dep->flags &= ~DWC3_EP_DELAY_START;
+		if (!(dep->flags & DWC3_EP_END_TRANSFER_PENDING))
 			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
-		}
+
+		if ((dep->flags & DWC3_EP_DELAY_START) &&
+		    !usb_endpoint_xfer_isoc(dep->endpoint.desc))
+			__dwc3_gadget_kick_transfer(dep);
+
+		dep->flags &= ~DWC3_EP_DELAY_START;
 	}
 
 	return ret;
-- 
2.28.0

