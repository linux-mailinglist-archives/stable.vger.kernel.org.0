Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD32178DE3
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 10:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgCDJ6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 04:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728387AbgCDJ6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 04:58:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67EE52072D;
        Wed,  4 Mar 2020 09:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583315881;
        bh=SEeKMPdVGSgdWdSwDFrf0OgL9xypumSLmDutdFwOLS4=;
        h=Subject:To:From:Date:From;
        b=H/NJLgzfIzzUWEWbHWidHlgd/t+IMTwBsSolY0jrq/eXoVHtK9pPyVzPO/CUceuQn
         behOMTJCRJC20h5Jtd+OO2mjQmFUAZL17EUlJuB8xPZjSTo3rqSSkoAlFZaFz2jVTB
         OTLjDW+WylFMkU4Wd/kUHLk9TzazeeHwgaOT730I=
Subject: patch "usb: cdns3: gadget: toggle cycle bit before reset endpoint" added to usb-linus
To:     peter.chen@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Mar 2020 10:57:51 +0100
Message-ID: <1583315871189249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdns3: gadget: toggle cycle bit before reset endpoint

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4bf2dd65135a2d7fe202f7c10d65b51bcf645ac6 Mon Sep 17 00:00:00 2001
From: Peter Chen <peter.chen@nxp.com>
Date: Wed, 19 Feb 2020 22:14:55 +0800
Subject: usb: cdns3: gadget: toggle cycle bit before reset endpoint

If there are TRBs pending during reset endpoint operation, the
DMA will advance after reset operation, but it isn't expected,
since the data is not yet available (For OUT, the data is not
yet available). After the data is ready, there won't be any
interrupt since the EP_TRADDR already points to next TRB entry
and doorbell is not set.

To fix it, it toggles cycle bit before reset operation, and restores
it after reset, it could avoid unexpected DMA advance due to
cycle bit is for software during the endpoint reset operation.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200219141455.23257-3-peter.chen@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/gadget.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 1d8a2af35bb0..3574dbb09366 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2595,11 +2595,21 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 {
 	struct cdns3_device *priv_dev = priv_ep->cdns3_dev;
 	struct usb_request *request;
+	struct cdns3_request *priv_req;
+	struct cdns3_trb *trb = NULL;
 	int ret;
 	int val;
 
 	trace_cdns3_halt(priv_ep, 0, 0);
 
+	request = cdns3_next_request(&priv_ep->pending_req_list);
+	if (request) {
+		priv_req = to_cdns3_request(request);
+		trb = priv_req->trb;
+		if (trb)
+			trb->control = trb->control ^ TRB_CYCLE;
+	}
+
 	writel(EP_CMD_CSTALL | EP_CMD_EPRST, &priv_dev->regs->ep_cmd);
 
 	/* wait for EPRST cleared */
@@ -2610,10 +2620,11 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 
 	priv_ep->flags &= ~(EP_STALLED | EP_STALL_PENDING);
 
-	request = cdns3_next_request(&priv_ep->pending_req_list);
-
-	if (request)
+	if (request) {
+		if (trb)
+			trb->control = trb->control ^ TRB_CYCLE;
 		cdns3_rearm_transfer(priv_ep, 1);
+	}
 
 	cdns3_start_all_request(priv_dev, priv_ep);
 	return ret;
-- 
2.25.1


