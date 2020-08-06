Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFEE23D4CE
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 02:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgHFApA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 20:45:00 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59032 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbgHFAox (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 20:44:53 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7D0FFC0BBD;
        Thu,  6 Aug 2020 00:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1596674692; bh=j3TZyohjlu7miEdDkUqXhS4KlhSz5WBxeTsWisi04to=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=KY/9AR0h7v1W65PhPPWjYhm6nkdwd7iJInPQ4JIydV36KXK/ojBG1s+ZkOYhJTZlL
         YJ+LvIxxTLmXHYu/kFdRboY7rFRF9km2zQwWyAmcRfROX7wE1il8Y2en/xKUaAeaZp
         pw+s2QYGLAtQO5kU4c/JPgrpgQ1pA+qZsmUNM+NoV3j6aBIvxeDN5t8NYfbRegiwpH
         sY3IMKlDcRF4UIDNH8EBjx9EHE7yqiMrH48Rszjg7yX7wzAa3gaEsInwtLjYE5UHcc
         TpVdhafKRL+j8c3XIuTe2ZTlHB+A1lo7t1HRkI79aKjV9G1sMzDCje2xEe+fEF71w5
         kOVqnVkg6+nug==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 1485EA0096;
        Thu,  6 Aug 2020 00:44:50 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Wed, 05 Aug 2020 17:44:50 -0700
Date:   Wed, 05 Aug 2020 17:44:50 -0700
Message-Id: <a8718dffe7deb439d71d36c7b207ed84a7ed45a4.1596674377.git.thinhn@synopsys.com>
In-Reply-To: <cover.1596674377.git.thinhn@synopsys.com>
References: <cover.1596674377.git.thinhn@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 1/7] usb: dwc3: gadget: Don't setup more than requested
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The SG list may be set up with entry size more than the requested
length. Check the usb_request->length and make sure that we don't setup
the TRBs to send/receive more than requested. This case may occur when
the SG entry is allocated up to a certain minimum size, but the request
length is less than that. It can also occur when the request is reused
for a different request length.

Cc: stable@vger.kernel.org
Fixes: a31e63b608ff ("usb: dwc3: gadget: Correct handling of scattergather lists")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 41 ++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index e44bfc3b5096..657616077502 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1054,27 +1054,25 @@ static void __dwc3_prepare_one_trb(struct dwc3_ep *dep, struct dwc3_trb *trb,
  * dwc3_prepare_one_trb - setup one TRB from one request
  * @dep: endpoint for which this request is prepared
  * @req: dwc3_request pointer
+ * @trb_length: buffer size of the TRB
  * @chain: should this TRB be chained to the next?
  * @node: only for isochronous endpoints. First TRB needs different type.
  */
 static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
-		struct dwc3_request *req, unsigned chain, unsigned node)
+		struct dwc3_request *req, unsigned int trb_length,
+		unsigned chain, unsigned node)
 {
 	struct dwc3_trb		*trb;
-	unsigned int		length;
 	dma_addr_t		dma;
 	unsigned		stream_id = req->request.stream_id;
 	unsigned		short_not_ok = req->request.short_not_ok;
 	unsigned		no_interrupt = req->request.no_interrupt;
 	unsigned		is_last = req->request.is_last;
 
-	if (req->request.num_sgs > 0) {
-		length = sg_dma_len(req->start_sg);
+	if (req->request.num_sgs > 0)
 		dma = sg_dma_address(req->start_sg);
-	} else {
-		length = req->request.length;
+	else
 		dma = req->request.dma;
-	}
 
 	trb = &dep->trb_pool[dep->trb_enqueue];
 
@@ -1086,7 +1084,7 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 
 	req->num_trbs++;
 
-	__dwc3_prepare_one_trb(dep, trb, dma, length, chain, node,
+	__dwc3_prepare_one_trb(dep, trb, dma, trb_length, chain, node,
 			stream_id, short_not_ok, no_interrupt, is_last);
 }
 
@@ -1104,8 +1102,13 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 		unsigned int length = req->request.length;
 		unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);
 		unsigned int rem = length % maxp;
+		unsigned int trb_length;
 		unsigned chain = true;
 
+		trb_length = min_t(unsigned int, length, sg_dma_len(req->start_sg));
+
+		length -= trb_length;
+
 		/*
 		 * IOMMU driver is coalescing the list of sgs which shares a
 		 * page boundary into one and giving it to USB driver. With
@@ -1113,7 +1116,7 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 		 * sgs passed. So mark the chain bit to false if it isthe last
 		 * mapped sg.
 		 */
-		if (i == remaining - 1)
+		if ((i == remaining - 1) || !length)
 			chain = false;
 
 		if (rem && usb_endpoint_dir_out(dep->endpoint.desc) && !chain) {
@@ -1123,7 +1126,7 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 			req->needs_extra_trb = true;
 
 			/* prepare normal TRB */
-			dwc3_prepare_one_trb(dep, req, true, i);
+			dwc3_prepare_one_trb(dep, req, trb_length, true, i);
 
 			/* Now prepare one extra TRB to align transfer size */
 			trb = &dep->trb_pool[dep->trb_enqueue];
@@ -1135,7 +1138,7 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 					req->request.no_interrupt,
 					req->request.is_last);
 		} else {
-			dwc3_prepare_one_trb(dep, req, chain, i);
+			dwc3_prepare_one_trb(dep, req, trb_length, chain, i);
 		}
 
 		/*
@@ -1150,6 +1153,16 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 
 		req->num_queued_sgs++;
 
+		/*
+		 * The number of pending SG entries may not correspond to the
+		 * number of mapped SG entries. If all the data are queued, then
+		 * don't include unused SG entries.
+		 */
+		if (length == 0) {
+			req->num_pending_sgs -= req->request.num_mapped_sgs - req->num_queued_sgs;
+			break;
+		}
+
 		if (!dwc3_calc_trbs_left(dep))
 			break;
 	}
@@ -1169,7 +1182,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 		req->needs_extra_trb = true;
 
 		/* prepare normal TRB */
-		dwc3_prepare_one_trb(dep, req, true, 0);
+		dwc3_prepare_one_trb(dep, req, length, true, 0);
 
 		/* Now prepare one extra TRB to align transfer size */
 		trb = &dep->trb_pool[dep->trb_enqueue];
@@ -1187,7 +1200,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 		req->needs_extra_trb = true;
 
 		/* prepare normal TRB */
-		dwc3_prepare_one_trb(dep, req, true, 0);
+		dwc3_prepare_one_trb(dep, req, length, true, 0);
 
 		/* Now prepare one extra TRB to handle ZLP */
 		trb = &dep->trb_pool[dep->trb_enqueue];
@@ -1198,7 +1211,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 				req->request.no_interrupt,
 				req->request.is_last);
 	} else {
-		dwc3_prepare_one_trb(dep, req, false, 0);
+		dwc3_prepare_one_trb(dep, req, length, false, 0);
 	}
 }
 
-- 
2.28.0

