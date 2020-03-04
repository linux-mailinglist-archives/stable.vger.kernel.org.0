Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB25178DE2
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 10:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbgCDJ54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 04:57:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727734AbgCDJ54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 04:57:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9648F2072D;
        Wed,  4 Mar 2020 09:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583315874;
        bh=EPFSTeZcdLqBhWnXummteQtG6aNJ1Rq/CrA+ZHQTfBQ=;
        h=Subject:To:From:Date:From;
        b=WzySfWxAYXUdoomzGfYc1uZ2zEmGbvsEagivsWN/snj1azsfqgQCnOfdduGsJbwT5
         FxejUDAup0bQ1vmPK5b/I9fRj9uhEOS2NQ9/M+KjmSlWxWYuKc8eLnQnEmhjbL+UHA
         N45QDwn7Ph8R/wGkL0ZRJm3c3b2tQdp4IajzDix8=
Subject: patch "usb: cdns3: gadget: link trb should point to next request" added to usb-linus
To:     peter.chen@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Mar 2020 10:57:51 +0100
Message-ID: <1583315871150194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdns3: gadget: link trb should point to next request

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8a7c47fb7285b23ca259c888016513d5566fa9e8 Mon Sep 17 00:00:00 2001
From: Peter Chen <peter.chen@nxp.com>
Date: Wed, 19 Feb 2020 22:14:54 +0800
Subject: usb: cdns3: gadget: link trb should point to next request

It has marked the dequeue trb as link trb, but its next segment
pointer is still itself, it causes the transfer can't go on. Fix
it by set its pointer as the trb address for the next request.

Fixes: f616c3bda47e ("usb: cdns3: Fix dequeue implementation")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200219141455.23257-2-peter.chen@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 736b0c6e27fe..1d8a2af35bb0 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2550,7 +2550,7 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 	/* Update ring only if removed request is on pending_req_list list */
 	if (req_on_hw_ring) {
 		link_trb->buffer = TRB_BUFFER(priv_ep->trb_pool_dma +
-					      (priv_req->start_trb * TRB_SIZE));
+			((priv_req->end_trb + 1) * TRB_SIZE));
 		link_trb->control = (link_trb->control & TRB_CYCLE) |
 				    TRB_TYPE(TRB_LINK) | TRB_CHAIN;
 
-- 
2.25.1


