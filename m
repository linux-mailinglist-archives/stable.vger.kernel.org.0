Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66732065A5
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388656AbgFWUHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388650AbgFWUHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:07:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66EF5206C3;
        Tue, 23 Jun 2020 20:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942864;
        bh=4b7pSvFY5F3c9kS5ZhzsLgjKFeSxAsCKKVwB2CjpAjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQli0xSfs/4sBQlvoYlti14JuO9XJABeSgMbkGT1UdceMeRqERoL1DFh0Z1z8IKVh
         e04FxY1FvhCWP6AWGnsj9cgRgFFVwrR5pjbFrboOHjxcmL4GNlke5NOYj8iGDp033J
         hkVkeUYvjLsO7vJ1CITV8EvabWshu/VUh1ZD63m0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 164/477] usb: dwc3: gadget: Properly handle ClearFeature(halt)
Date:   Tue, 23 Jun 2020 21:52:41 +0200
Message-Id: <20200623195415.339589309@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit cb11ea56f37a36288cdd0a4799a983ee3aa437dd ]

DWC3 must not issue CLEAR_STALL command to control endpoints. The
controller automatically clears the STALL when it receives the SETUP
token. Also, when the driver receives ClearFeature(halt_ep), DWC3 must
stop any active transfer from the endpoint and give back all the
requests to the function drivers.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 585cb3deea7ad..ab6562c5b9279 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1508,6 +1508,10 @@ static void dwc3_gadget_ep_skip_trbs(struct dwc3_ep *dep, struct dwc3_request *r
 {
 	int i;
 
+	/* If req->trb is not set, then the request has not started */
+	if (!req->trb)
+		return;
+
 	/*
 	 * If request was already started, this means we had to
 	 * stop the transfer. With that we also need to ignore
@@ -1598,6 +1602,8 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol)
 {
 	struct dwc3_gadget_ep_cmd_params	params;
 	struct dwc3				*dwc = dep->dwc;
+	struct dwc3_request			*req;
+	struct dwc3_request			*tmp;
 	int					ret;
 
 	if (usb_endpoint_xfer_isoc(dep->endpoint.desc)) {
@@ -1634,13 +1640,37 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol)
 		else
 			dep->flags |= DWC3_EP_STALL;
 	} else {
+		/*
+		 * Don't issue CLEAR_STALL command to control endpoints. The
+		 * controller automatically clears the STALL when it receives
+		 * the SETUP token.
+		 */
+		if (dep->number <= 1) {
+			dep->flags &= ~(DWC3_EP_STALL | DWC3_EP_WEDGE);
+			return 0;
+		}
 
 		ret = dwc3_send_clear_stall_ep_cmd(dep);
-		if (ret)
+		if (ret) {
 			dev_err(dwc->dev, "failed to clear STALL on %s\n",
 					dep->name);
-		else
-			dep->flags &= ~(DWC3_EP_STALL | DWC3_EP_WEDGE);
+			return ret;
+		}
+
+		dep->flags &= ~(DWC3_EP_STALL | DWC3_EP_WEDGE);
+
+		dwc3_stop_active_transfer(dep, true, true);
+
+		list_for_each_entry_safe(req, tmp, &dep->started_list, list)
+			dwc3_gadget_move_cancelled_request(req);
+
+		list_for_each_entry_safe(req, tmp, &dep->pending_list, list)
+			dwc3_gadget_move_cancelled_request(req);
+
+		if (!(dep->flags & DWC3_EP_END_TRANSFER_PENDING)) {
+			dep->flags &= ~DWC3_EP_DELAY_START;
+			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
+		}
 	}
 
 	return ret;
-- 
2.25.1



