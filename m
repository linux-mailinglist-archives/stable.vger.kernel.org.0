Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43896469E38
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345314AbhLFPhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:37:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37600 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347711AbhLFPc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:32:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2F22B81139;
        Mon,  6 Dec 2021 15:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23FEC34901;
        Mon,  6 Dec 2021 15:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804565;
        bh=ZBYlU7XvXfNxRPCuMTxeE7nN0cc967AWrOlsez40VEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1F03PJuiG5CCT1S9it+yEC9vlp04wQp0n4QHCM2Eyjwf1Ig1lERGplQ/yF7NZ7ngP
         daKMGBvy/l6fj+V9+20qXbC69w4JmjGk9Pu61CGPedXz/5IGHOLva5Jf+mvAtfv/X1
         AeMg34qnbZFCg3I8pOht5KHJC0BQFIz6gMBC7WrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Frank Li <Frank.Li@nxp.com>, Jun Li <jun.li@nxp.com>
Subject: [PATCH 5.15 192/207] usb: cdns3: gadget: fix new urb never complete if ep cancel previous requests
Date:   Mon,  6 Dec 2021 15:57:26 +0100
Message-Id: <20211206145616.929844604@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Li <Frank.Li@nxp.com>

commit 387c2b6ba197c6df28e75359f7d892f7c8dec204 upstream.

This issue was found at android12 MTP.
1. MTP submit many out urb request.
2. Cancel left requests (>20) when enough data get from host
3. Send ACK by IN endpoint.
4. MTP submit new out urb request.
5. 4's urb never complete.

TRACE LOG:

MtpServer-2157    [000] d..3  1287.150391: cdns3_ep_dequeue: ep1out: req: 00000000299e6836, req buff 000000009df42287, length: 0/16384 zsi, status: -115, trb: [start:87, end:87: virt addr 0x80004000ffd50420], flags:1 SID: 0
MtpServer-2157    [000] d..3  1287.150410: cdns3_gadget_giveback: ep1out: req: 00000000299e6836, req buff 000000009df42287, length: 0/16384 zsi, status: -104, trb: [start:87, end:87: virt addr 0x80004000ffd50420], flags:0 SID: 0
MtpServer-2157    [000] d..3  1287.150433: cdns3_ep_dequeue: ep1out: req: 0000000080b7bde6, req buff 000000009ed5c556, length: 0/16384 zsi, status: -115, trb: [start:88, end:88: virt addr 0x80004000ffd5042c], flags:1 SID: 0
MtpServer-2157    [000] d..3  1287.150446: cdns3_gadget_giveback: ep1out: req: 0000000080b7bde6, req buff 000000009ed5c556, length: 0/16384 zsi, status: -104, trb: [start:88, end:88: virt addr 0x80004000ffd5042c], flags:0 SID: 0
	....
MtpServer-2157    [000] d..1  1293.630410: cdns3_alloc_request: ep1out: req: 00000000afbccb7d, req buff 0000000000000000, length: 0/0 zsi, status: 0, trb: [start:0, end:0: virt addr (null)], flags:0 SID: 0
MtpServer-2157    [000] d..2  1293.630421: cdns3_ep_queue: ep1out: req: 00000000afbccb7d, req buff 00000000871caf90, length: 0/512 zsi, status: -115, trb: [start:0, end:0: virt addr (null)], flags:0 SID: 0
MtpServer-2157    [000] d..2  1293.630445: cdns3_wa1: WA1: ep1out set guard
MtpServer-2157    [000] d..2  1293.630450: cdns3_wa1: WA1: ep1out restore cycle bit
MtpServer-2157    [000] d..2  1293.630453: cdns3_prepare_trb: ep1out: trb 000000007317b3ee, dma buf: 0xffd5bc00, size: 512, burst: 128 ctrl: 0x00000424 (C=0, T=0, ISP, IOC, Normal) SID:0 LAST_SID:0
MtpServer-2157    [000] d..2  1293.630460: cdns3_doorbell_epx: ep1out, ep_trbaddr ffd50414
	....
irq/241-5b13000-2154    [000] d..1  1293.680849: cdns3_epx_irq: IRQ for ep1out: 01000408 ISP , ep_traddr: ffd508ac ep_last_sid: 00000000 use_streams: 0
irq/241-5b13000-2154    [000] d..1  1293.680858: cdns3_complete_trb: ep1out: trb 0000000021a11b54, dma buf: 0xffd50420, size: 16384, burst: 128 ctrl: 0x00001810 (C=0, T=0, CHAIN, LINK) SID:0 LAST_SID:0
irq/241-5b13000-2154    [000] d..1  1293.680865: cdns3_request_handled: Req: 00000000afbccb7d not handled, DMA pos: 185, ep deq: 88, ep enq: 185, start trb: 184, end trb: 184

Actually DMA pos already bigger than previous submit request afbccb7d's TRB (184-184). The reason of (not handled) is that deq position is wrong.

The TRB link is below when irq happen.

	DEQ LINK LINK LINK LINK LINK .... TRB(afbccb7d):START  DMA(EP_TRADDR).

Original code check LINK TRB, but DEQ just move one step.

	LINK DEQ LINK LINK LINK LINK .... TRB(afbccb7d):START  DMA(EP_TRADDR).

This patch skip all LINK TRB and sync DEQ to trb's start.

	LINK LINK LINK LINK LINK .... DEQ = TRB(afbccb7d):START  DMA(EP_TRADDR).

Acked-by: Peter Chen <peter.chen@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Jun Li <jun.li@nxp.com>
Link: https://lore.kernel.org/r/20211130154239.8029-1-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -337,19 +337,6 @@ static void cdns3_ep_inc_deq(struct cdns
 	cdns3_ep_inc_trb(&priv_ep->dequeue, &priv_ep->ccs, priv_ep->num_trbs);
 }
 
-static void cdns3_move_deq_to_next_trb(struct cdns3_request *priv_req)
-{
-	struct cdns3_endpoint *priv_ep = priv_req->priv_ep;
-	int current_trb = priv_req->start_trb;
-
-	while (current_trb != priv_req->end_trb) {
-		cdns3_ep_inc_deq(priv_ep);
-		current_trb = priv_ep->dequeue;
-	}
-
-	cdns3_ep_inc_deq(priv_ep);
-}
-
 /**
  * cdns3_allow_enable_l1 - enable/disable permits to transition to L1.
  * @priv_dev: Extended gadget object
@@ -1517,10 +1504,11 @@ static void cdns3_transfer_completed(str
 
 		trb = priv_ep->trb_pool + priv_ep->dequeue;
 
-		/* Request was dequeued and TRB was changed to TRB_LINK. */
-		if (TRB_FIELD_TO_TYPE(le32_to_cpu(trb->control)) == TRB_LINK) {
+		/* The TRB was changed as link TRB, and the request was handled at ep_dequeue */
+		while (TRB_FIELD_TO_TYPE(le32_to_cpu(trb->control)) == TRB_LINK) {
 			trace_cdns3_complete_trb(priv_ep, trb);
-			cdns3_move_deq_to_next_trb(priv_req);
+			cdns3_ep_inc_deq(priv_ep);
+			trb = priv_ep->trb_pool + priv_ep->dequeue;
 		}
 
 		if (!request->stream_id) {


