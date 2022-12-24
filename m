Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F086557C8
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbiLXBke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbiLXBjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:39:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFB4532DC;
        Fri, 23 Dec 2022 17:33:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F4FF61FAA;
        Sat, 24 Dec 2022 01:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297BBC433EF;
        Sat, 24 Dec 2022 01:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845583;
        bh=m7RYbdCtdTyobCvML/GmRq/7Oin1VziRpdb1dYoMzFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4lV5j3D5S5Yqy7X1FiyHhkCXSUyCAw2VqYJVh2SfMVe2EdMrNPnEWVJ2JT1OvRUO
         s+PUtwimxVzAIoU3ltt7GxFuKJ4BrMO5RZbs43oWcJBKEuRbfb8UC/F0vBIXQkx/uc
         LujN9Wsza9ttMedyVkuWYw5EBexPItuyNsvYlZJQ0chYEPlXda0DCHDAeWZiDSVK6v
         AKnStDm2mgDRjyB1uzyzFTMbedCPT3TSkiLhAfpYHgJ5vg44NZiS66xhN7zV+ay5Zw
         uwnjN2z39ajkG94cfn2T9DcSkXYonnT76ta0r1ena3XnLbGlb25M9gE3gEVV7iUdsR
         QYxV7P5BR8M7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Henry Tian <tianxiaofeng@bytedance.com>,
        Lei YU <yulei.sh@bytedance.com>,
        Neal Liu <neal_liu@aspeedtech.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, joel@jms.id.au,
        jakobkoschel@gmail.com, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 2/6] usb: gadget: aspeed: fix buffer overflow
Date:   Fri, 23 Dec 2022 20:32:50 -0500
Message-Id: <20221224013254.393646-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013254.393646-1-sashal@kernel.org>
References: <20221224013254.393646-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Tian <tianxiaofeng@bytedance.com>

[ Upstream commit 83045e19feae937c425248824d1dc0fc95583842 ]

In ast_vhub_epn_handle_ack() when the received data length exceeds the
buffer, it does not check the case and just copies to req.buf and cause
a buffer overflow, kernel oops on this case.

This issue could be reproduced on a BMC with an OS that enables the
lan over USB:
1. In OS, enable the usb eth dev, verify it pings the BMC OK;
2. In OS, set the usb dev mtu to 2000. (Default is 1500);
3. In OS, ping the BMC with `-s 2000` argument.

The BMC kernel will get oops with below logs:

    skbuff: skb_over_panic: text:8058e098 len:2048 put:2048 head:84c678a0 data:84c678c2 tail:0x84c680c2 end:0x84c67f00 dev:usb0
    ------------[ cut here ]------------
    kernel BUG at net/core/skbuff.c:113!
    Internal error: Oops - BUG: 0 [#1] ARM
    CPU: 0 PID: 0 Comm: swapper Not tainted 5.15.69-c9fb275-dirty-d1e579a #1
    Hardware name: Generic DT based system
    PC is at skb_panic+0x60/0x6c
    LR is at irq_work_queue+0x6c/0x94

Fix the issue by checking the length and set `-EOVERFLOW`.

Tested: Verify the BMC kernel does not get oops in the above case, and
the usb ethernet gets RX packets errors instead.

Signed-off-by: Lei YU <yulei.sh@bytedance.com>
Signed-off-by: Henry Tian <tianxiaofeng@bytedance.com>
Reviewed-by: Neal Liu <neal_liu@aspeedtech.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: https://lore.kernel.org/r/20221024094853.2877441-1-yulei.sh@bytedance.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/aspeed-vhub/core.c |  2 +-
 drivers/usb/gadget/udc/aspeed-vhub/epn.c  | 16 ++++++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/udc/aspeed-vhub/core.c b/drivers/usb/gadget/udc/aspeed-vhub/core.c
index 902e61be4d64..7ce4dc132da3 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/core.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/core.c
@@ -42,7 +42,7 @@ void ast_vhub_done(struct ast_vhub_ep *ep, struct ast_vhub_req *req,
 
 	list_del_init(&req->queue);
 
-	if (req->req.status == -EINPROGRESS)
+	if ((req->req.status == -EINPROGRESS) ||  (status == -EOVERFLOW))
 		req->req.status = status;
 
 	if (req->req.dma) {
diff --git a/drivers/usb/gadget/udc/aspeed-vhub/epn.c b/drivers/usb/gadget/udc/aspeed-vhub/epn.c
index 931f540a747e..32c381b3ed40 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/epn.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/epn.c
@@ -89,6 +89,7 @@ static void ast_vhub_epn_handle_ack(struct ast_vhub_ep *ep)
 {
 	struct ast_vhub_req *req;
 	unsigned int len;
+	int status = 0;
 	u32 stat;
 
 	/* Read EP status */
@@ -124,9 +125,15 @@ static void ast_vhub_epn_handle_ack(struct ast_vhub_ep *ep)
 	len = VHUB_EP_DMA_TX_SIZE(stat);
 
 	/* If not using DMA, copy data out if needed */
-	if (!req->req.dma && !ep->epn.is_in && len)
-		memcpy(req->req.buf + req->req.actual, ep->buf, len);
-
+	if (!req->req.dma && !ep->epn.is_in && len) {
+		if (req->req.actual + len > req->req.length) {
+			req->last_desc = 1;
+			status = -EOVERFLOW;
+			goto done;
+		} else {
+			memcpy(req->req.buf + req->req.actual, ep->buf, len);
+		}
+	}
 	/* Adjust size */
 	req->req.actual += len;
 
@@ -134,9 +141,10 @@ static void ast_vhub_epn_handle_ack(struct ast_vhub_ep *ep)
 	if (len < ep->ep.maxpacket)
 		req->last_desc = 1;
 
+done:
 	/* That's it ? complete the request and pick a new one */
 	if (req->last_desc >= 0) {
-		ast_vhub_done(ep, req, 0);
+		ast_vhub_done(ep, req, status);
 		req = list_first_entry_or_null(&ep->queue, struct ast_vhub_req,
 					       queue);
 
-- 
2.35.1

