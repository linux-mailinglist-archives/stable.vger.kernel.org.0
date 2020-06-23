Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF61205D4F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388608AbgFWULt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388908AbgFWULs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:11:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70FA2206C3;
        Tue, 23 Jun 2020 20:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943108;
        bh=TJCPnIsIztKJ9g2c5mwpsEd++GFJ/uyUVDTdOTYSgM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIlZPFJ+XT9v3rXgKXVXRZg7lEA3pEpqEqR8zjjYaI0ugnB6PsjrvokB7weNagKeO
         1ELpuzs+/aB2J9S5Jc9ZTkyciUzY7N9gCTr+DqzH/4XFM+HRXxM4jYG6NbqxVgyIR0
         TMZmfeemzhDcs93bWVjc58gYuV+V1RAcmNOM4xKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 262/477] usb: gadget: lpc32xx_udc: dont dereference ep pointer before null check
Date:   Tue, 23 Jun 2020 21:54:19 +0200
Message-Id: <20200623195419.947458845@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit eafa80041645cd7604c4357b1a0cd4a3c81f2227 ]

Currently pointer ep is being dereferenced before it is null checked
leading to a null pointer dereference issue.  Fix this by only assigning
pointer udc once ep is known to be not null.  Also remove a debug
message that requires a valid udc which may not be possible at that
point.

Addresses-Coverity: ("Dereference before null check")
Fixes: 24a28e428351 ("USB: gadget driver for LPC32xx")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/lpc32xx_udc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/udc/lpc32xx_udc.c b/drivers/usb/gadget/udc/lpc32xx_udc.c
index cb997b82c0088..465d0b7c6522a 100644
--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -1614,17 +1614,17 @@ static int lpc32xx_ep_enable(struct usb_ep *_ep,
 			     const struct usb_endpoint_descriptor *desc)
 {
 	struct lpc32xx_ep *ep = container_of(_ep, struct lpc32xx_ep, ep);
-	struct lpc32xx_udc *udc = ep->udc;
+	struct lpc32xx_udc *udc;
 	u16 maxpacket;
 	u32 tmp;
 	unsigned long flags;
 
 	/* Verify EP data */
 	if ((!_ep) || (!ep) || (!desc) ||
-	    (desc->bDescriptorType != USB_DT_ENDPOINT)) {
-		dev_dbg(udc->dev, "bad ep or descriptor\n");
+	    (desc->bDescriptorType != USB_DT_ENDPOINT))
 		return -EINVAL;
-	}
+
+	udc = ep->udc;
 	maxpacket = usb_endpoint_maxp(desc);
 	if ((maxpacket == 0) || (maxpacket > ep->maxpacket)) {
 		dev_dbg(udc->dev, "bad ep descriptor's packet size\n");
@@ -1872,7 +1872,7 @@ static int lpc32xx_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 static int lpc32xx_ep_set_halt(struct usb_ep *_ep, int value)
 {
 	struct lpc32xx_ep *ep = container_of(_ep, struct lpc32xx_ep, ep);
-	struct lpc32xx_udc *udc = ep->udc;
+	struct lpc32xx_udc *udc;
 	unsigned long flags;
 
 	if ((!ep) || (ep->hwep_num <= 1))
@@ -1882,6 +1882,7 @@ static int lpc32xx_ep_set_halt(struct usb_ep *_ep, int value)
 	if (ep->is_in)
 		return -EAGAIN;
 
+	udc = ep->udc;
 	spin_lock_irqsave(&udc->lock, flags);
 
 	if (value == 1) {
-- 
2.25.1



