Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4551D20B44B
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 17:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgFZPRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 11:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgFZPRU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 11:17:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A232420706;
        Fri, 26 Jun 2020 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593184640;
        bh=ab37v7OZdeSXnDEq9iwT2i5MaXHbFkM4loshClsWa1g=;
        h=Subject:To:From:Date:From;
        b=plCfOmrH++/OxKTjUYczD4nAmecXmb6DElNSlB8F+FYKPGpkabzlXHkmg5Aq4YEoV
         tOS9uRW/F8WbrMieZd4lIX0UaJAFzlsrkAorL8Kaxl6TrsWZv6XCbk+Zl/qa+fYlfF
         GFHmBkanTLkM/lOy4KrlLCoWyRrzrv8/ZPWwB0Cw=
Subject: patch "usb: cdns3: ep0: add spinlock for cdns3_check_new_setup" added to usb-linus
To:     peter.chen@nxp.com, balbi@kernel.org, pawell@cadence.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Jun 2020 17:17:13 +0200
Message-ID: <15931846331772@kroah.com>
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


From 2587a029fa2a877d0a8dda955ef1b24c94b4bd0e Mon Sep 17 00:00:00 2001
From: Peter Chen <peter.chen@nxp.com>
Date: Tue, 23 Jun 2020 11:09:18 +0800
Subject: usb: cdns3: ep0: add spinlock for cdns3_check_new_setup

The other thread may access other endpoints when the cdns3_check_new_setup
is handling, add spinlock to protect it.

Cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Reviewed-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
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


