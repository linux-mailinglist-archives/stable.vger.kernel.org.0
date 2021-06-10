Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793C43A244A
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 08:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhFJGM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 02:12:59 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:47709 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhFJGM7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 02:12:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623305463; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: Cc: To: From: Sender;
 bh=jIX3aYx1BMoqk5WRI/kxfbys7dPIfQcOTPn3b00X2m8=; b=nr5mpD9ZlYiG4YPru8KtMaDtaJ30HHdVaS41rjQ1BBm6akwt6OrnWo6P08QW4k9vsLrIvdoV
 BdhqTVd2LJjJReChMjH2Ys86n0MqOopZxkFuzZeNOveNz8jbOZLo4FH546Vf7rmMcDk1rONW
 g1yIeIEt2ETbWPwfshfT87mJMgc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60c1ace6e27c0cc77f672760 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 10 Jun 2021 06:10:46
 GMT
Sender: linyyuan=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 19601C43460; Thu, 10 Jun 2021 06:10:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from linyyuan (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: linyyuan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B270CC433D3;
        Thu, 10 Jun 2021 06:10:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B270CC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=linyyuan@codeaurora.org
From:   <linyyuan@codeaurora.org>
To:     "'Felipe Balbi'" <balbi@kernel.org>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Cc:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] usb: gadget: eem: fix command packet transfer issue
Date:   Thu, 10 Jun 2021 14:10:40 +0800
Message-ID: <000201d75dbf$58d1cc40$0a7564c0$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AdddvrdSHyFlR9ZoTh6zFIq8vt/Gcg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linyu Yuan <linyyuan@codeaurora.com>

there is following warning,
[<ffffff8008905a94>] dwc3_gadget_ep_queue+0x1b4/0x1c8
[<ffffff800895ec9c>] usb_ep_queue+0x3c/0x120
[<ffffff80089677a0>] eem_unwrap+0x180/0x330
[<ffffff80089634f8>] rx_complete+0x70/0x230
[<ffffff800895edbc>] usb_gadget_giveback_request+0x3c/0xe8
[<ffffff8008901e7c>] dwc3_gadget_giveback+0xb4/0x190
[<ffffff8008905254>] dwc3_endpoint_transfer_complete+0x32c/0x410
[<ffffff80089060fc>] dwc3_bh_work+0x654/0x12e8
[<ffffff80080c63fc>] process_one_work+0x1d4/0x4a8
[<ffffff80080c6720>] worker_thread+0x50/0x4a8
[<ffffff80080cc8e8>] kthread+0xe8/0x100
[<ffffff8008083980>] ret_from_fork+0x10/0x50
request ffffffc0716bf200 belongs to 'ep0out'

when gadget receive a eem command packet from host, it need to response,
but queue usb request to wrong endpoint.
fix it by queue usb request to eem IN endpoint and allow host read it.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Linyu Yuan <linyyuan@codeaurora.org>
---
 drivers/usb/gadget/function/f_eem.c | 44
++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/f_eem.c
b/drivers/usb/gadget/function/f_eem.c
index 2cd9942..2c2ca1e 100644
--- a/drivers/usb/gadget/function/f_eem.c
+++ b/drivers/usb/gadget/function/f_eem.c
@@ -30,6 +30,11 @@ struct f_eem {
 	u8				ctrl_id;
 };
 
+struct in_context {
+	struct sk_buff	*skb;
+	struct usb_ep	*ep;
+};
+
 static inline struct f_eem *func_to_eem(struct usb_function *f)
 {
 	return container_of(f, struct f_eem, port.func);
@@ -320,9 +325,12 @@ static int eem_bind(struct usb_configuration *c, struct
usb_function *f)
 
 static void eem_cmd_complete(struct usb_ep *ep, struct usb_request *req)
 {
-	struct sk_buff *skb = (struct sk_buff *)req->context;
+	struct in_context *ctx = req->context;
 
-	dev_kfree_skb_any(skb);
+	kfree(req->buf);
+	dev_kfree_skb_any(ctx->skb);
+	usb_ep_free_request(ctx->ep, req);
+	kfree(ctx);
 }
 
 /*
@@ -410,7 +418,9 @@ static int eem_unwrap(struct gether *port,
 		 * b15:		bmType (0 == data, 1 == command)
 		 */
 		if (header & BIT(15)) {
-			struct usb_request	*req = cdev->req;
+			struct usb_request	*req;
+			struct in_context	*ctx;
+			struct usb_ep		*ep;
 			u16			bmEEMCmd;
 
 			/* EEM command packet format:
@@ -439,13 +449,37 @@ static int eem_unwrap(struct gether *port,
 				skb_trim(skb2, len);
 				put_unaligned_le16(BIT(15) | BIT(11) | len,
 							skb_push(skb2, 2));
+
+				ep = port->in_ep;
+				req = usb_ep_alloc_request(ep, GFP_ATOMIC);
+				if (!req) {
+					dev_kfree_skb_any(skb2);
+					break;
+				}
+
+				ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+				if (!ctx)
+					goto nomem;
+				ctx->skb = skb2;
+				ctx->ep = ep;
+
+				req->buf = kmalloc(skb2->len, GFP_KERNEL);
+				if (!req->buf)
+					goto nomem;
+
 				skb_copy_bits(skb2, 0, req->buf, skb2->len);
 				req->length = skb2->len;
 				req->complete = eem_cmd_complete;
 				req->zero = 1;
-				req->context = skb2;
-				if (usb_ep_queue(port->in_ep, req,
GFP_ATOMIC))
+				req->context = ctx;
+				if (usb_ep_queue(ep, req, GFP_ATOMIC)) {
 					DBG(cdev, "echo response queue
fail\n");
+nomem:
+					kfree(req->buf);
+					usb_ep_free_request(ep, req);
+					dev_kfree_skb_any(skb2);
+					kfree(ctx);
+				}
 				break;
 
 			case 1:  /* echo response */
-- 
2.7.4

