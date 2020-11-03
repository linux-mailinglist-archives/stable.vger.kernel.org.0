Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563B92A5224
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731304AbgKCUrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731269AbgKCUrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB8422404;
        Tue,  3 Nov 2020 20:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436426;
        bh=+KaaIApkluWBZbpMxNM7gphpXwYy1JM++RJjU/3zBiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kx+1gyI+ZBBGXPOs01t6ycUw7MF0fTZBAyMb1JWnMV8YinE4zCUwyTiU/YOA/h9yT
         5aNm4dbeJpYADuI2upRu7bECRzmdYZUnLsGW0cgtd4N1nyKdqSyOVNVlo5xdg8bdjA
         CDlHxdLn9DlqA7LsgPrq3RiK0hayAzxOwDA/JtJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.9 245/391] usb: dwc3: gadget: Resume pending requests after CLEAR_STALL
Date:   Tue,  3 Nov 2020 21:34:56 +0100
Message-Id: <20201103203403.540787315@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit c503672abe1348f10f5a54a662336358c6e1a297 upstream.

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
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1628,8 +1628,13 @@ static int __dwc3_gadget_ep_queue(struct
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
@@ -1836,13 +1841,14 @@ int __dwc3_gadget_ep_set_halt(struct dwc
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


