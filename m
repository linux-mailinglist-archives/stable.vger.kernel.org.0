Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59649593BAA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346433AbiHOUWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346519AbiHOUUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E2997D50;
        Mon, 15 Aug 2022 12:00:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 963136122B;
        Mon, 15 Aug 2022 19:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E544C433D7;
        Mon, 15 Aug 2022 19:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590053;
        bh=q6objEWJqQalE6qrNAA/Zzot4pb3FshImXwWMJLY6gM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ze2Y664KhBYGW1JCZoaNYQDpX/SUNK4+1LXNat03vUJvBVtraE/KVJVLbG84YoWc8
         csSAS/UwZvbXt7vxixYIcLVP7OZq5v7Ps2lh7Iw1CaNqXyoDGl80V276Li9eqBU5zg
         +NNzCB8JHfhUBK0C0AVyHZ/JR87wSAaJ3W17vE2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 5.18 0128/1095] usb: dwc3: gadget: refactor dwc3_repare_one_trb
Date:   Mon, 15 Aug 2022 19:52:07 +0200
Message-Id: <20220815180434.882377454@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 23385cec5f354794dadced7f28c31da7ae3eb54c upstream.

The function __dwc3_prepare_one_trb has many parameters. Since it is
only used in dwc3_prepare_one_trb there is no point in keeping the
function. We merge both functions and get rid of the big list of
parameters.

Fixes: 40d829fb2ec6 ("usb: dwc3: gadget: Correct ISOC DATA PIDs for short packets")
Cc: stable <stable@kernel.org>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220704141812.1532306-2-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   92 ++++++++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 52 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1181,17 +1181,49 @@ static u32 dwc3_calc_trbs_left(struct dw
 	return trbs_left;
 }
 
-static void __dwc3_prepare_one_trb(struct dwc3_ep *dep, struct dwc3_trb *trb,
-		dma_addr_t dma, unsigned int length, unsigned int chain,
-		unsigned int node, unsigned int stream_id,
-		unsigned int short_not_ok, unsigned int no_interrupt,
-		unsigned int is_last, bool must_interrupt)
+/**
+ * dwc3_prepare_one_trb - setup one TRB from one request
+ * @dep: endpoint for which this request is prepared
+ * @req: dwc3_request pointer
+ * @trb_length: buffer size of the TRB
+ * @chain: should this TRB be chained to the next?
+ * @node: only for isochronous endpoints. First TRB needs different type.
+ * @use_bounce_buffer: set to use bounce buffer
+ * @must_interrupt: set to interrupt on TRB completion
+ */
+static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
+		struct dwc3_request *req, unsigned int trb_length,
+		unsigned int chain, unsigned int node, bool use_bounce_buffer,
+		bool must_interrupt)
 {
+	struct dwc3_trb		*trb;
+	dma_addr_t		dma;
+	unsigned int		stream_id = req->request.stream_id;
+	unsigned int		short_not_ok = req->request.short_not_ok;
+	unsigned int		no_interrupt = req->request.no_interrupt;
+	unsigned int		is_last = req->request.is_last;
 	struct dwc3		*dwc = dep->dwc;
 	struct usb_gadget	*gadget = dwc->gadget;
 	enum usb_device_speed	speed = gadget->speed;
 
-	trb->size = DWC3_TRB_SIZE_LENGTH(length);
+	if (use_bounce_buffer)
+		dma = dep->dwc->bounce_addr;
+	else if (req->request.num_sgs > 0)
+		dma = sg_dma_address(req->start_sg);
+	else
+		dma = req->request.dma;
+
+	trb = &dep->trb_pool[dep->trb_enqueue];
+
+	if (!req->trb) {
+		dwc3_gadget_move_started_request(req);
+		req->trb = trb;
+		req->trb_dma = dwc3_trb_dma_offset(dep, trb);
+	}
+
+	req->num_trbs++;
+
+	trb->size = DWC3_TRB_SIZE_LENGTH(trb_length);
 	trb->bpl = lower_32_bits(dma);
 	trb->bph = upper_32_bits(dma);
 
@@ -1231,10 +1263,10 @@ static void __dwc3_prepare_one_trb(struc
 				unsigned int mult = 2;
 				unsigned int maxp = usb_endpoint_maxp(ep->desc);
 
-				if (length <= (2 * maxp))
+				if (trb_length <= (2 * maxp))
 					mult--;
 
-				if (length <= maxp)
+				if (trb_length <= maxp)
 					mult--;
 
 				trb->size |= DWC3_TRB_SIZE_PCM1(mult);
@@ -1308,50 +1340,6 @@ static void __dwc3_prepare_one_trb(struc
 	trace_dwc3_prepare_trb(dep, trb);
 }
 
-/**
- * dwc3_prepare_one_trb - setup one TRB from one request
- * @dep: endpoint for which this request is prepared
- * @req: dwc3_request pointer
- * @trb_length: buffer size of the TRB
- * @chain: should this TRB be chained to the next?
- * @node: only for isochronous endpoints. First TRB needs different type.
- * @use_bounce_buffer: set to use bounce buffer
- * @must_interrupt: set to interrupt on TRB completion
- */
-static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
-		struct dwc3_request *req, unsigned int trb_length,
-		unsigned int chain, unsigned int node, bool use_bounce_buffer,
-		bool must_interrupt)
-{
-	struct dwc3_trb		*trb;
-	dma_addr_t		dma;
-	unsigned int		stream_id = req->request.stream_id;
-	unsigned int		short_not_ok = req->request.short_not_ok;
-	unsigned int		no_interrupt = req->request.no_interrupt;
-	unsigned int		is_last = req->request.is_last;
-
-	if (use_bounce_buffer)
-		dma = dep->dwc->bounce_addr;
-	else if (req->request.num_sgs > 0)
-		dma = sg_dma_address(req->start_sg);
-	else
-		dma = req->request.dma;
-
-	trb = &dep->trb_pool[dep->trb_enqueue];
-
-	if (!req->trb) {
-		dwc3_gadget_move_started_request(req);
-		req->trb = trb;
-		req->trb_dma = dwc3_trb_dma_offset(dep, trb);
-	}
-
-	req->num_trbs++;
-
-	__dwc3_prepare_one_trb(dep, trb, dma, trb_length, chain, node,
-			stream_id, short_not_ok, no_interrupt, is_last,
-			must_interrupt);
-}
-
 static bool dwc3_needs_extra_trb(struct dwc3_ep *dep, struct dwc3_request *req)
 {
 	unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);


