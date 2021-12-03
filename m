Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAB94677BF
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 13:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhLCNBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 08:01:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35734 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244358AbhLCNBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 08:01:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BDFFB826D0
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 12:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3B9C53FAD;
        Fri,  3 Dec 2021 12:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638536289;
        bh=/UaYF0xzZkeib+wINJ5cK13U/JLoWWQl6Y9f1EbtbPg=;
        h=Subject:To:From:Date:From;
        b=MVEnazBztQ/qKlPO47LbSyyNZhoALJ80YaZfdFLdWpzoBH+o/yWnIvZND6WLt15fZ
         YiG7G2KHPmciv/wgp6CtpNoAuu2nfYSgrGNUY7E79MiaRvCZKkGAIKgq+1wYw5s303
         iooqZSikqcHw6ihFXG94QgnIcmvaL2M1Rzv6h1N4=
Subject: patch "usb: cdns3: gadget: fix new urb never complete if ep cancel previous" added to usb-linus
To:     Frank.Li@nxp.com, gregkh@linuxfoundation.org, jun.li@nxp.com,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Dec 2021 13:57:59 +0100
Message-ID: <1638536279261@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdns3: gadget: fix new urb never complete if ep cancel previous

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 387c2b6ba197c6df28e75359f7d892f7c8dec204 Mon Sep 17 00:00:00 2001
From: Frank Li <Frank.Li@nxp.com>
Date: Tue, 30 Nov 2021 09:42:39 -0600
Subject: usb: cdns3: gadget: fix new urb never complete if ep cancel previous
 requests

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
 drivers/usb/cdns3/cdns3-gadget.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 1f3b4a142212..f9af7ebe003d 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -337,19 +337,6 @@ static void cdns3_ep_inc_deq(struct cdns3_endpoint *priv_ep)
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
@@ -1517,10 +1504,11 @@ static void cdns3_transfer_completed(struct cdns3_device *priv_dev,
 
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
-- 
2.34.1


