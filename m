Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF495233C23
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 01:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbgG3X2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 19:28:53 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:33910 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728846AbgG3X2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 19:28:53 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6D081406ED;
        Thu, 30 Jul 2020 23:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1596151732; bh=QfW0bfI+X8X/+nMmxgJN2C3ANRt1+snc43CN/BAbXGE=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=cG0oF0TbNLnjCtnZ+U8o5YafWUuyoTELUFqFOBNCziixKVKO0toR8vbWkuWBXUcmE
         ZO8+JvbaxX+cuZC3SSzLbxKWWKiMzgC6/uK1f6YTQAREQWbf8cRzFuDP0dV3FcAjNx
         7Zoki60shs553f2qyVSDRGvLPAYryHIDufAcooiGQDhLvoccsJE4xQ/Tyf57zVIkzl
         NlPh1nZypldqiBc1cqU58vhzb9GO1QQePfAWgx1oJy9cc8yK7No/3Ceg4t23hCo2X9
         JZNtDhZVfLVMFKYDR/HnvnyQvfQiaade0kpw5BepRT9eMTJsYDA85JWfHwTxDHpTpR
         Q42NQUIyfWYWA==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id CD4C9A006F;
        Thu, 30 Jul 2020 23:28:50 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Thu, 30 Jul 2020 16:28:50 -0700
Date:   Thu, 30 Jul 2020 16:28:50 -0700
Message-Id: <febe1ba310b638f5013e64835c1cc4210e0b799a.1596151437.git.thinhn@synopsys.com>
In-Reply-To: <cover.1596151437.git.thinhn@synopsys.com>
References: <cover.1596151437.git.thinhn@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 1/3] usb: dwc3: gadget: Resume pending requests after CLEAR_STALL
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
 drivers/usb/dwc3/gadget.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index e44bfc3b5096..fcd0df1e7d3f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1566,8 +1566,12 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 	if (dep->flags & DWC3_EP_WAIT_TRANSFER_COMPLETE)
 		return 0;
 
-	/* Start the transfer only after the END_TRANSFER is completed */
-	if (dep->flags & DWC3_EP_END_TRANSFER_PENDING) {
+	/*
+	 * Start the transfer only after the END_TRANSFER is completed
+	 * and endpoint STALL is cleared.
+	 */
+	if ((dep->flags & DWC3_EP_END_TRANSFER_PENDING) ||
+	    (dep->flags & DWC3_EP_STALL)) {
 		dep->flags |= DWC3_EP_DELAY_START;
 		return 0;
 	}
@@ -1774,9 +1778,6 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol)
 		list_for_each_entry_safe(req, tmp, &dep->started_list, list)
 			dwc3_gadget_move_cancelled_request(req);
 
-		list_for_each_entry_safe(req, tmp, &dep->pending_list, list)
-			dwc3_gadget_move_cancelled_request(req);
-
 		if (!(dep->flags & DWC3_EP_END_TRANSFER_PENDING)) {
 			dep->flags &= ~DWC3_EP_DELAY_START;
 			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
-- 
2.11.0

