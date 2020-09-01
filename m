Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B60259751
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbgIAPfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729607AbgIAPfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:35:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7059920866;
        Tue,  1 Sep 2020 15:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974506;
        bh=Kic1QFBMmfsiLLqVcXRF13eeR/kpQuM9+nAq1RLFgjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVF7wlikKYpnMrxRq/NqDpGXBKdl3T8uRSGX4OJJBdqAj/ezpqabiInaFqFjfLXfD
         aUYXFCZgySWOY2Y1Tlhh2Z54PY8oUeIE+Lp2WGukHBreHyRjaoXzkAclUCf62+cyJg
         ltVWpID0c7NpAhwE5EthCle/yyz4HHxOtR5XKOIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 203/214] usb: dwc3: gadget: Handle ZLP for sg requests
Date:   Tue,  1 Sep 2020 17:11:23 +0200
Message-Id: <20200901151002.657404941@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit bc9a2e226ea95e1699f7590845554de095308b75 ]

Currently dwc3 doesn't handle usb_request->zero for SG requests. This
change checks and prepares extra TRBs for the ZLP for SG requests.

Cc: <stable@vger.kernel.org> # v4.5+
Fixes: 04c03d10e507 ("usb: dwc3: gadget: handle request->zero")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 8e67591df76be..4225544342519 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1104,6 +1104,35 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 					req->request.stream_id,
 					req->request.short_not_ok,
 					req->request.no_interrupt);
+		} else if (req->request.zero && req->request.length &&
+			   !usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
+			   !rem && !chain) {
+			struct dwc3	*dwc = dep->dwc;
+			struct dwc3_trb	*trb;
+
+			req->needs_extra_trb = true;
+
+			/* Prepare normal TRB */
+			dwc3_prepare_one_trb(dep, req, trb_length, true, i);
+
+			/* Prepare one extra TRB to handle ZLP */
+			trb = &dep->trb_pool[dep->trb_enqueue];
+			req->num_trbs++;
+			__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, 0,
+					       !req->direction, 1,
+					       req->request.stream_id,
+					       req->request.short_not_ok,
+					       req->request.no_interrupt);
+
+			/* Prepare one more TRB to handle MPS alignment */
+			if (!req->direction) {
+				trb = &dep->trb_pool[dep->trb_enqueue];
+				req->num_trbs++;
+				__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, maxp,
+						       false, 1, req->request.stream_id,
+						       req->request.short_not_ok,
+						       req->request.no_interrupt);
+			}
 		} else {
 			dwc3_prepare_one_trb(dep, req, trb_length, chain, i);
 		}
-- 
2.25.1



