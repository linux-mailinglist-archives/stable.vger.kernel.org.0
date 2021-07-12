Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376BB3C4424
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhGLGRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233112AbhGLGRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:17:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0B1F61042;
        Mon, 12 Jul 2021 06:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070487;
        bh=fkPuSWE0j56OUGLFi49Br0/qyRX+IZeR8I4io2jJA/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EO9+KhF7MBRADm0b7Ji+kEYdWWI7Mv60PKqlH3wlP95rOMj46n4ZK815Mjr3SN+3O
         yCXaTxXYkwHwH+EqF+yjrvjuAz7mZVkJ4+9pmZ6LS7JVg0t0zwgQxFUCLgz/Nq6oss
         KrWBGYVw4IYFEd+XNIvfcDhTxvrzqL5ERWhQI8tQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linyu Yuan <linyyuan@codeaurora.com>
Subject: [PATCH 5.4 012/348] usb: gadget: eem: fix echo command packet response issue
Date:   Mon, 12 Jul 2021 08:06:36 +0200
Message-Id: <20210712060701.891627620@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linyu Yuan <linyyuan@codeaurora.com>

commit 4249d6fbc10fd997abdf8a1ea49c0389a0edf706 upstream.

when receive eem echo command, it will send a response,
but queue this response to the usb request which allocate
from gadget device endpoint zero,
and transmit the request to IN endpoint of eem interface.

on dwc3 gadget, it will trigger following warning in function
__dwc3_gadget_ep_queue(),

	if (WARN(req->dep != dep, "request %pK belongs to '%s'\n",
				&req->request, req->dep->name))
		return -EINVAL;

fix it by allocating a usb request from IN endpoint of eem interface,
and transmit the usb request to same IN endpoint of eem interface.

Signed-off-by: Linyu Yuan <linyyuan@codeaurora.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210616115142.34075-1-linyyuan@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_eem.c |   43 ++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

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
@@ -322,9 +327,12 @@ fail:
 
 static void eem_cmd_complete(struct usb_ep *ep, struct usb_request *req)
 {
-	struct sk_buff *skb = (struct sk_buff *)req->context;
+	struct in_context *ctx = req->context;
 
-	dev_kfree_skb_any(skb);
+	dev_kfree_skb_any(ctx->skb);
+	kfree(req->buf);
+	usb_ep_free_request(ctx->ep, req);
+	kfree(ctx);
 }
 
 /*
@@ -412,7 +420,9 @@ static int eem_unwrap(struct gether *por
 		 * b15:		bmType (0 == data, 1 == command)
 		 */
 		if (header & BIT(15)) {
-			struct usb_request	*req = cdev->req;
+			struct usb_request	*req;
+			struct in_context	*ctx;
+			struct usb_ep		*ep;
 			u16			bmEEMCmd;
 
 			/* EEM command packet format:
@@ -441,11 +451,36 @@ static int eem_unwrap(struct gether *por
 				skb_trim(skb2, len);
 				put_unaligned_le16(BIT(15) | BIT(11) | len,
 							skb_push(skb2, 2));
+
+				ep = port->in_ep;
+				req = usb_ep_alloc_request(ep, GFP_ATOMIC);
+				if (!req) {
+					dev_kfree_skb_any(skb2);
+					goto next;
+				}
+
+				req->buf = kmalloc(skb2->len, GFP_KERNEL);
+				if (!req->buf) {
+					usb_ep_free_request(ep, req);
+					dev_kfree_skb_any(skb2);
+					goto next;
+				}
+
+				ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+				if (!ctx) {
+					kfree(req->buf);
+					usb_ep_free_request(ep, req);
+					dev_kfree_skb_any(skb2);
+					goto next;
+				}
+				ctx->skb = skb2;
+				ctx->ep = ep;
+
 				skb_copy_bits(skb2, 0, req->buf, skb2->len);
 				req->length = skb2->len;
 				req->complete = eem_cmd_complete;
 				req->zero = 1;
-				req->context = skb2;
+				req->context = ctx;
 				if (usb_ep_queue(port->in_ep, req, GFP_ATOMIC))
 					DBG(cdev, "echo response queue fail\n");
 				break;


