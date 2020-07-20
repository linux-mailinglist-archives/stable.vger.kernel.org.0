Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC78F226396
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgGTPia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729191AbgGTPi3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:38:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9464F22CB2;
        Mon, 20 Jul 2020 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259509;
        bh=TN8wEmaPrhwkGhG8ux9wHaay0D/cpBGAWN5Wdw/bCrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SsM99foscrB3IEAwHrcHmYk/JyfmMsaiklsfC6XsVNwHweVr5oh0NDq7XFkXQoI5z
         /IWMDVEc8aAp1TxTwc2lIdIDdKfmeafzMkAwcUch/X+EJo7NcaHx++CWVu0B3WAXwX
         ubEBIG99ebCEFf66jlMnevtkvCsZOVF+1vR7SaqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 33/58] usb: gadget: udc: atmel: fix uninitialized read in debug printk
Date:   Mon, 20 Jul 2020 17:36:49 +0200
Message-Id: <20200720152748.815687834@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit 30517ffeb3bff842e1355cbc32f1959d9dbb5414 ]

Fixed commit moved the assignment of 'req', but did not update a
reference in the DBG() call. Use the argument as it was renamed.

Fixes: 5fb694f96e7c ("usb: gadget: udc: atmel: fix possible oops when unloading module")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/atmel_usba_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget/udc/atmel_usba_udc.c
index 668ac5e8681b5..e6902257d7de7 100644
--- a/drivers/usb/gadget/udc/atmel_usba_udc.c
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
@@ -843,7 +843,7 @@ static int usba_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 	u32 status;
 
 	DBG(DBG_GADGET | DBG_QUEUE, "ep_dequeue: %s, req %p\n",
-			ep->ep.name, req);
+			ep->ep.name, _req);
 
 	spin_lock_irqsave(&udc->lock, flags);
 
-- 
2.25.1



