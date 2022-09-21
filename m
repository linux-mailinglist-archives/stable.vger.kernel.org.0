Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DD65C0310
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiIUQAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiIUP7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:59:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0377C658F;
        Wed, 21 Sep 2022 08:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4305BB830C6;
        Wed, 21 Sep 2022 15:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D434C433C1;
        Wed, 21 Sep 2022 15:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775518;
        bh=nmUcLh5m6eOyTaX4X96jP9dp6Gkgrpd8qnjDO3bIoB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wppnVXopuRC6+WzhiujAJ6EZEdVKlcrSpPTZgYhf5HNeUkLYbf4wTzhZBsUdFvJq
         i0RDTlSN4ft3Isu7TipU7RZz2pBJb9MCJpiBccy6ySDb01jwdcNilvyZeqoyQ33q9R
         wDRvmAqH6z5Uas6P8cI1maMpP6wLVFmtilu0osvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Frank Li <Frank.Li@nxp.com>, Jun Li <jun.li@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/39] usb: cdns3: gadget: fix new urb never complete if ep cancel previous requests
Date:   Wed, 21 Sep 2022 17:46:14 +0200
Message-Id: <20220921153646.049505110@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 387c2b6ba197c6df28e75359f7d892f7c8dec204 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index a37ea946459c..c6fc14b169da 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -352,19 +352,6 @@ static void cdns3_ep_inc_deq(struct cdns3_endpoint *priv_ep)
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
@@ -1518,10 +1505,11 @@ static void cdns3_transfer_completed(struct cdns3_device *priv_dev,
 
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
2.35.1



