Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398145CB63
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfGBIII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:08:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727269AbfGBIIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:08:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE7EE20665;
        Tue,  2 Jul 2019 08:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054886;
        bh=jfaFKRwODgzpe5m0PyRnqYrbY6UgLRoTY0gkJzjgTx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CR/KZ8ItQoL3weAWfrnvTnXanjqB0mHDiNRiX7x0G1mHr4Hfav9ihVyEuejZ3Ijpd
         F0Z54w3xbUgr5984jlS7sjXzfHm558AiHY/GLWO5lAoM2YZ9C/0AqN2bjQiqPAyat2
         Tn9jH7BW7TG1VxC7MED1ELdj8guDTGx0R87E5AQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/72] usb: dwc3: gadget: track number of TRBs per request
Date:   Tue,  2 Jul 2019 10:01:26 +0200
Message-Id: <20190702080125.974366303@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 09fe1f8d7e2f461275b1cdd832f2cfa5e9be346d upstream

This will help us remove the wait_event() from our ->dequeue().

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
(cherry picked from commit 09fe1f8d7e2f461275b1cdd832f2cfa5e9be346d)
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.h   | 3 +++
 drivers/usb/dwc3/gadget.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 4872cba8699b..0de78cb29f2c 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -847,6 +847,7 @@ struct dwc3_hwparams {
  * @epnum: endpoint number to which this request refers
  * @trb: pointer to struct dwc3_trb
  * @trb_dma: DMA address of @trb
+ * @num_trbs: number of TRBs used by this request
  * @needs_extra_trb: true when request needs one extra TRB (either due to ZLP
  *	or unaligned OUT)
  * @direction: IN or OUT direction flag
@@ -867,6 +868,8 @@ struct dwc3_request {
 	struct dwc3_trb		*trb;
 	dma_addr_t		trb_dma;
 
+	unsigned		num_trbs;
+
 	unsigned		needs_extra_trb:1;
 	unsigned		direction:1;
 	unsigned		mapped:1;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 8db7466e4f76..fd91c494307c 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1041,6 +1041,8 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 		req->trb_dma = dwc3_trb_dma_offset(dep, trb);
 	}
 
+	req->num_trbs++;
+
 	__dwc3_prepare_one_trb(dep, trb, dma, length, chain, node,
 			stream_id, short_not_ok, no_interrupt);
 }
@@ -1075,6 +1077,7 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 
 			/* Now prepare one extra TRB to align transfer size */
 			trb = &dep->trb_pool[dep->trb_enqueue];
+			req->num_trbs++;
 			__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr,
 					maxp - rem, false, 1,
 					req->request.stream_id,
@@ -1119,6 +1122,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 
 		/* Now prepare one extra TRB to align transfer size */
 		trb = &dep->trb_pool[dep->trb_enqueue];
+		req->num_trbs++;
 		__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, maxp - rem,
 				false, 1, req->request.stream_id,
 				req->request.short_not_ok,
@@ -1135,6 +1139,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 
 		/* Now prepare one extra TRB to handle ZLP */
 		trb = &dep->trb_pool[dep->trb_enqueue];
+		req->num_trbs++;
 		__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, 0,
 				false, 1, req->request.stream_id,
 				req->request.short_not_ok,
@@ -2231,6 +2236,7 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	dwc3_ep_inc_deq(dep);
 
 	trace_dwc3_complete_trb(dep, trb);
+	req->num_trbs--;
 
 	/*
 	 * If we're in the middle of series of chained TRBs and we
-- 
2.20.1



