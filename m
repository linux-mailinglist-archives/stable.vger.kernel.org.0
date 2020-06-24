Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159CA20752D
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 16:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404012AbgFXODR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 10:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403985AbgFXODR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 10:03:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F43320724;
        Wed, 24 Jun 2020 14:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593007396;
        bh=Uje/l+wPriXf4GX/EFa/SX9n062d7tvnuHOZj/3q6i4=;
        h=Subject:To:From:Date:From;
        b=FrJW2gPEKuz2fpPEIzXQadJekRuruYqAT9IctnWYnQYPuUvQdJ/TvnIgU0h+oyHBJ
         JTtRMSqrv2iczJY+m8OI0PC/vy7c0gbQd0zVxJjjPk110kPGWnKrixoEb568HvCGn9
         MJXFg56C3cx+AKPEqY1olwPqgID2QZygxk78pbWw=
Subject: patch "usb: cdns3: ep0: add spinlock for cdns3_check_new_setup" added to usb-linus
To:     peter.chen@nxp.com, gregkh@linuxfoundation.org, pawell@cadence.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Jun 2020 16:03:07 +0200
Message-ID: <1593007387177220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdns3: ep0: add spinlock for cdns3_check_new_setup

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d0b78265cac9d8b5f7d5c97fa44860d6ab952dc8 Mon Sep 17 00:00:00 2001
From: Peter Chen <peter.chen@nxp.com>
Date: Tue, 23 Jun 2020 11:09:18 +0800
Subject: usb: cdns3: ep0: add spinlock for cdns3_check_new_setup

The other thread may access other endpoints when the cdns3_check_new_setup
is handling, add spinlock to protect it.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: <stable@vger.kernel.org>
Reviewed-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20200623030918.8409-4-peter.chen@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/ep0.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c
index 04e49582fb55..61ec5bb2b0ca 100644
--- a/drivers/usb/cdns3/ep0.c
+++ b/drivers/usb/cdns3/ep0.c
@@ -705,15 +705,17 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
 	int ret = 0;
 	u8 zlp = 0;
 
+	spin_lock_irqsave(&priv_dev->lock, flags);
 	trace_cdns3_ep0_queue(priv_dev, request);
 
 	/* cancel the request if controller receive new SETUP packet. */
-	if (cdns3_check_new_setup(priv_dev))
+	if (cdns3_check_new_setup(priv_dev)) {
+		spin_unlock_irqrestore(&priv_dev->lock, flags);
 		return -ECONNRESET;
+	}
 
 	/* send STATUS stage. Should be called only for SET_CONFIGURATION */
 	if (priv_dev->ep0_stage == CDNS3_STATUS_STAGE) {
-		spin_lock_irqsave(&priv_dev->lock, flags);
 		cdns3_select_ep(priv_dev, 0x00);
 
 		erdy_sent = !priv_dev->hw_configured_flag;
@@ -738,7 +740,6 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
 		return 0;
 	}
 
-	spin_lock_irqsave(&priv_dev->lock, flags);
 	if (!list_empty(&priv_ep->pending_req_list)) {
 		dev_err(priv_dev->dev,
 			"can't handle multiple requests for ep0\n");
-- 
2.27.0


