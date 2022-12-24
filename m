Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C647F655704
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbiLXBbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236376AbiLXBaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:30:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39CD36D46;
        Fri, 23 Dec 2022 17:30:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30E96B8219D;
        Sat, 24 Dec 2022 01:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A327DC433D2;
        Sat, 24 Dec 2022 01:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845406;
        bh=mmH/nPVvl+htovbJ1ua/Fax2SK3m8s772R+6Hm1S5qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDP7KrwczTG/DBCMIflBd8SQgvBR/ijfxDvJ7roNALeXkCbP7qmAQPyiQgwAfMe/+
         kCwvxOb8BSZH4UarhWPoJCozgj1QYT8f5Ph3z5Lnrh2FXVZVHvN7BXaFax9pYUmfj8
         DkcLxnH13YyO0QD7OEYdbQEylM+cNrISJF+HYmUTR49Fh7C/TcMk13f/nTELSKb2ab
         jEye5NWqGv5CzZRzdkR1OJpGt1BUfQmfGSr5o/JvYIaoRlmcEGtCtj8lI9HZYe0n0T
         mE6OAVYMuaAMLmXuQzf0/SpwnIDPZR9anxsU6Q9Uan68ydAu3maFRqnLgstj4xYUCj
         NtqrBKQvqvphw==
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
Subject: [PATCH AUTOSEL 6.1 11/26] usb: gadget: aspeed: fix buffer overflow
Date:   Fri, 23 Dec 2022 20:29:15 -0500
Message-Id: <20221224012930.392358-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224012930.392358-1-sashal@kernel.org>
References: <20221224012930.392358-1-sashal@kernel.org>
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
index 7a635c499777..ac3ca24f8b04 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/core.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/core.c
@@ -37,7 +37,7 @@ void ast_vhub_done(struct ast_vhub_ep *ep, struct ast_vhub_req *req,
 
 	list_del_init(&req->queue);
 
-	if (req->req.status == -EINPROGRESS)
+	if ((req->req.status == -EINPROGRESS) ||  (status == -EOVERFLOW))
 		req->req.status = status;
 
 	if (req->req.dma) {
diff --git a/drivers/usb/gadget/udc/aspeed-vhub/epn.c b/drivers/usb/gadget/udc/aspeed-vhub/epn.c
index b5252880b389..56e55472daa1 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/epn.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/epn.c
@@ -84,6 +84,7 @@ static void ast_vhub_epn_handle_ack(struct ast_vhub_ep *ep)
 {
 	struct ast_vhub_req *req;
 	unsigned int len;
+	int status = 0;
 	u32 stat;
 
 	/* Read EP status */
@@ -119,9 +120,15 @@ static void ast_vhub_epn_handle_ack(struct ast_vhub_ep *ep)
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
 
@@ -129,9 +136,10 @@ static void ast_vhub_epn_handle_ack(struct ast_vhub_ep *ep)
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

