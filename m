Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E34417F8F3
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgCJMwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728124AbgCJMwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:52:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A114220674;
        Tue, 10 Mar 2020 12:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844757;
        bh=wGtPODP5oRTLsKphsGUQeHu6ALiA2GFwsmRudaHXPGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zws0UIjBoYNLI8u6xREAKJ4QOaqvAtCD/vLo6I31oDMyZdnop4Nx7711l85Y1O88Z
         7mpBQxSMozlfQwv4UtGXU5hRpOevyxALJ13+LVNW4Pzbpvr06BUTo4qqqHhQIXnwQ+
         CSDKa8kVxpcNKzkBL7qJqutcdVknnH/ba8dxd8e4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.4 070/168] usb: cdns3: gadget: toggle cycle bit before reset endpoint
Date:   Tue, 10 Mar 2020 13:38:36 +0100
Message-Id: <20200310123642.341409857@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit 4bf2dd65135a2d7fe202f7c10d65b51bcf645ac6 upstream.

If there are TRBs pending during reset endpoint operation, the
DMA will advance after reset operation, but it isn't expected,
since the data is not yet available (For OUT, the data is not
yet available). After the data is ready, there won't be any
interrupt since the EP_TRADDR already points to next TRB entry
and doorbell is not set.

To fix it, it toggles cycle bit before reset operation, and restores
it after reset, it could avoid unexpected DMA advance due to
cycle bit is for software during the endpoint reset operation.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200219141455.23257-3-peter.chen@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/cdns3/gadget.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2152,11 +2152,21 @@ int __cdns3_gadget_ep_clear_halt(struct
 {
 	struct cdns3_device *priv_dev = priv_ep->cdns3_dev;
 	struct usb_request *request;
+	struct cdns3_request *priv_req;
+	struct cdns3_trb *trb = NULL;
 	int ret;
 	int val;
 
 	trace_cdns3_halt(priv_ep, 0, 0);
 
+	request = cdns3_next_request(&priv_ep->pending_req_list);
+	if (request) {
+		priv_req = to_cdns3_request(request);
+		trb = priv_req->trb;
+		if (trb)
+			trb->control = trb->control ^ TRB_CYCLE;
+	}
+
 	writel(EP_CMD_CSTALL | EP_CMD_EPRST, &priv_dev->regs->ep_cmd);
 
 	/* wait for EPRST cleared */
@@ -2167,10 +2177,11 @@ int __cdns3_gadget_ep_clear_halt(struct
 
 	priv_ep->flags &= ~(EP_STALLED | EP_STALL_PENDING);
 
-	request = cdns3_next_request(&priv_ep->pending_req_list);
-
-	if (request)
+	if (request) {
+		if (trb)
+			trb->control = trb->control ^ TRB_CYCLE;
 		cdns3_rearm_transfer(priv_ep, 1);
+	}
 
 	cdns3_start_all_request(priv_dev, priv_ep);
 	return ret;


