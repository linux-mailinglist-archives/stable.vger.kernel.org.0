Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C752C9BDF
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390029AbgLAJM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:12:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389294AbgLAJMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D007A20656;
        Tue,  1 Dec 2020 09:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813934;
        bh=tGTaATgfD6RKUxwRK5mMXMfONh2iRvno4kiTWwiGpPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yf1j5eq6g4GrYfC5aD0ySdd/iDj0AwsJovtFeT98S6yY/jqc6+44FS0x4g7zxhuET
         cFeMRA75/FJxA8C8o+UJsqLZ5tQmn4AhocZ7JvT4R6FTq0w1zJS72Qu4/JjxmoxphF
         S3lR+vb8LTFCiVkW5UhD4Y16WtJ8q14jl5M6Ezhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Peter Chen <peter.chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 080/152] usb: cdns3: gadget: fix some endian issues
Date:   Tue,  1 Dec 2020 09:53:15 +0100
Message-Id: <20201201084722.398944135@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit 8dafb3c04df3b3b5a3ee2c7f5d8285a8b2f0aa78 ]

It is found by sparse.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 60 +++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index e0e1cb907ffd8..dc5e6be3fd45a 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -261,8 +261,8 @@ int cdns3_allocate_trb_pool(struct cdns3_endpoint *priv_ep)
 		 */
 		link_trb->control = 0;
 	} else {
-		link_trb->buffer = TRB_BUFFER(priv_ep->trb_pool_dma);
-		link_trb->control = TRB_CYCLE | TRB_TYPE(TRB_LINK) | TRB_TOGGLE;
+		link_trb->buffer = cpu_to_le32(TRB_BUFFER(priv_ep->trb_pool_dma));
+		link_trb->control = cpu_to_le32(TRB_CYCLE | TRB_TYPE(TRB_LINK) | TRB_TOGGLE);
 	}
 	return 0;
 }
@@ -853,10 +853,10 @@ static void cdns3_wa1_restore_cycle_bit(struct cdns3_endpoint *priv_ep)
 		priv_ep->wa1_trb_index = 0xFFFF;
 		if (priv_ep->wa1_cycle_bit) {
 			priv_ep->wa1_trb->control =
-				priv_ep->wa1_trb->control | 0x1;
+				priv_ep->wa1_trb->control | cpu_to_le32(0x1);
 		} else {
 			priv_ep->wa1_trb->control =
-				priv_ep->wa1_trb->control & ~0x1;
+				priv_ep->wa1_trb->control & cpu_to_le32(~0x1);
 		}
 	}
 }
@@ -1014,17 +1014,16 @@ static int cdns3_ep_run_stream_transfer(struct cdns3_endpoint *priv_ep,
 		  TRB_STREAM_ID(priv_req->request.stream_id) | TRB_ISP;
 
 	if (!request->num_sgs) {
-		trb->buffer = TRB_BUFFER(trb_dma);
+		trb->buffer = cpu_to_le32(TRB_BUFFER(trb_dma));
 		length = request->length;
 	} else {
-		trb->buffer = TRB_BUFFER(request->sg[sg_idx].dma_address);
+		trb->buffer = cpu_to_le32(TRB_BUFFER(request->sg[sg_idx].dma_address));
 		length = request->sg[sg_idx].length;
 	}
 
 	tdl = DIV_ROUND_UP(length, priv_ep->endpoint.maxpacket);
 
-	trb->length = TRB_BURST_LEN(16 /*priv_ep->trb_burst_size*/) |
-				  TRB_LEN(length);
+	trb->length = cpu_to_le32(TRB_BURST_LEN(16) | TRB_LEN(length));
 
 	/*
 	 * For DEV_VER_V2 controller version we have enabled
@@ -1033,11 +1032,11 @@ static int cdns3_ep_run_stream_transfer(struct cdns3_endpoint *priv_ep,
 	 */
 	if (priv_dev->dev_ver >= DEV_VER_V2) {
 		if (priv_dev->gadget.speed == USB_SPEED_SUPER)
-			trb->length |= TRB_TDL_SS_SIZE(tdl);
+			trb->length |= cpu_to_le32(TRB_TDL_SS_SIZE(tdl));
 	}
 	priv_req->flags |= REQUEST_PENDING;
 
-	trb->control = control;
+	trb->control = cpu_to_le32(control);
 
 	trace_cdns3_prepare_trb(priv_ep, priv_req->trb);
 
@@ -1162,8 +1161,8 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 		    TRBS_PER_SEGMENT > 2)
 			ch_bit = TRB_CHAIN;
 
-		link_trb->control = ((priv_ep->pcs) ? TRB_CYCLE : 0) |
-				    TRB_TYPE(TRB_LINK) | TRB_TOGGLE | ch_bit;
+		link_trb->control = cpu_to_le32(((priv_ep->pcs) ? TRB_CYCLE : 0) |
+				    TRB_TYPE(TRB_LINK) | TRB_TOGGLE | ch_bit);
 	}
 
 	if (priv_dev->dev_ver <= DEV_VER_V2)
@@ -1178,8 +1177,8 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 
 		/* fill TRB */
 		control |= TRB_TYPE(TRB_NORMAL);
-		trb->buffer = TRB_BUFFER(request->num_sgs == 0
-				? trb_dma : request->sg[sg_iter].dma_address);
+		trb->buffer = cpu_to_le32(TRB_BUFFER(request->num_sgs == 0
+				? trb_dma : request->sg[sg_iter].dma_address));
 
 		if (likely(!request->num_sgs))
 			length = request->length;
@@ -1193,10 +1192,10 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 			total_tdl += DIV_ROUND_UP(length,
 					       priv_ep->endpoint.maxpacket);
 
-		trb->length = TRB_BURST_LEN(priv_ep->trb_burst_size) |
-					TRB_LEN(length);
+		trb->length = cpu_to_le32(TRB_BURST_LEN(priv_ep->trb_burst_size) |
+					TRB_LEN(length));
 		if (priv_dev->gadget.speed == USB_SPEED_SUPER)
-			trb->length |= TRB_TDL_SS_SIZE(td_size);
+			trb->length |= cpu_to_le32(TRB_TDL_SS_SIZE(td_size));
 		else
 			control |= TRB_TDL_HS_SIZE(td_size);
 
@@ -1218,9 +1217,9 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 		}
 
 		if (sg_iter)
-			trb->control = control;
+			trb->control = cpu_to_le32(control);
 		else
-			priv_req->trb->control = control;
+			priv_req->trb->control = cpu_to_le32(control);
 
 		control = 0;
 		++sg_iter;
@@ -1234,7 +1233,7 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 	priv_req->flags |= REQUEST_PENDING;
 
 	if (sg_iter == 1)
-		trb->control |= TRB_IOC | TRB_ISP;
+		trb->control |= cpu_to_le32(TRB_IOC | TRB_ISP);
 
 	if (priv_dev->dev_ver < DEV_VER_V2 &&
 	    (priv_ep->flags & EP_TDLCHK_EN)) {
@@ -1260,7 +1259,7 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 
 	/* give the TD to the consumer*/
 	if (togle_pcs)
-		trb->control =  trb->control ^ 1;
+		trb->control = trb->control ^ cpu_to_le32(1);
 
 	if (priv_dev->dev_ver <= DEV_VER_V2)
 		cdns3_wa1_tray_restore_cycle_bit(priv_dev, priv_ep);
@@ -1399,7 +1398,7 @@ static bool cdns3_request_handled(struct cdns3_endpoint *priv_ep,
 
 	trb = &priv_ep->trb_pool[priv_req->start_trb];
 
-	if ((trb->control  & TRB_CYCLE) != priv_ep->ccs)
+	if ((le32_to_cpu(trb->control) & TRB_CYCLE) != priv_ep->ccs)
 		goto finish;
 
 	if (doorbell == 1 && current_index == priv_ep->dequeue)
@@ -1448,7 +1447,7 @@ static void cdns3_transfer_completed(struct cdns3_device *priv_dev,
 		trb = priv_ep->trb_pool + priv_ep->dequeue;
 
 		/* Request was dequeued and TRB was changed to TRB_LINK. */
-		if (TRB_FIELD_TO_TYPE(trb->control) == TRB_LINK) {
+		if (TRB_FIELD_TO_TYPE(le32_to_cpu(trb->control)) == TRB_LINK) {
 			trace_cdns3_complete_trb(priv_ep, trb);
 			cdns3_move_deq_to_next_trb(priv_req);
 		}
@@ -1580,7 +1579,7 @@ static int cdns3_check_ep_interrupt_proceed(struct cdns3_endpoint *priv_ep)
 		 * that host ignore the ERDY packet and driver has to send it
 		 * again.
 		 */
-		if (tdl && (dbusy | !EP_STS_BUFFEMPTY(ep_sts_reg) |
+		if (tdl && (dbusy || !EP_STS_BUFFEMPTY(ep_sts_reg) ||
 		    EP_STS_HOSTPP(ep_sts_reg))) {
 			writel(EP_CMD_ERDY |
 			       EP_CMD_ERDY_SID(priv_ep->last_stream_id),
@@ -2564,10 +2563,10 @@ found:
 
 	/* Update ring only if removed request is on pending_req_list list */
 	if (req_on_hw_ring && link_trb) {
-		link_trb->buffer = TRB_BUFFER(priv_ep->trb_pool_dma +
-			((priv_req->end_trb + 1) * TRB_SIZE));
-		link_trb->control = (link_trb->control & TRB_CYCLE) |
-				    TRB_TYPE(TRB_LINK) | TRB_CHAIN;
+		link_trb->buffer = cpu_to_le32(TRB_BUFFER(priv_ep->trb_pool_dma +
+			((priv_req->end_trb + 1) * TRB_SIZE)));
+		link_trb->control = cpu_to_le32((le32_to_cpu(link_trb->control) & TRB_CYCLE) |
+				    TRB_TYPE(TRB_LINK) | TRB_CHAIN);
 
 		if (priv_ep->wa1_trb == priv_req->trb)
 			cdns3_wa1_restore_cycle_bit(priv_ep);
@@ -2622,7 +2621,7 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 		priv_req = to_cdns3_request(request);
 		trb = priv_req->trb;
 		if (trb)
-			trb->control = trb->control ^ TRB_CYCLE;
+			trb->control = trb->control ^ cpu_to_le32(TRB_CYCLE);
 	}
 
 	writel(EP_CMD_CSTALL | EP_CMD_EPRST, &priv_dev->regs->ep_cmd);
@@ -2637,7 +2636,8 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 
 	if (request) {
 		if (trb)
-			trb->control = trb->control ^ TRB_CYCLE;
+			trb->control = trb->control ^ cpu_to_le32(TRB_CYCLE);
+
 		cdns3_rearm_transfer(priv_ep, 1);
 	}
 
-- 
2.27.0



