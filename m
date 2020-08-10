Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF77240EB5
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbgHJTPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:15:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729005AbgHJTPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:15:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FA6222B49;
        Mon, 10 Aug 2020 19:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086902;
        bh=dFDUeVvVdY8Fs9I9C6hZNkObUoIHi4TQ5HEz4oU+ZtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1UPjAqscrKwh2pGgBImSwrnCYG9rtMuEmJ4RD4SfB8Iv+vr6/0VPYcte0rAYc8t6l
         psdHMYsO6CLRNKrUc1HO13cC+swEdBaAG5N7vJ9EN7/nuH2rOm3/XD2Tka9fmIwjhW
         1J1G68aKWhz1GyZBZaWrmVGs6mTp6QwWdTlVbr0g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasi Kumar <sasi.kumar@broadcom.com>,
        Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/16] bdc: Fix bug causing crash after multiple disconnects
Date:   Mon, 10 Aug 2020 15:14:39 -0400
Message-Id: <20200810191443.3795581-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191443.3795581-1-sashal@kernel.org>
References: <20200810191443.3795581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasi Kumar <sasi.kumar@broadcom.com>

[ Upstream commit a95bdfd22076497288868c028619bc5995f5cc7f ]

Multiple connects/disconnects can cause a crash on the second
disconnect. The driver had a problem where it would try to send
endpoint commands after it was disconnected which is not allowed
by the hardware. The fix is to only allow the endpoint commands
when the endpoint is connected. This will also fix issues that
showed up when using configfs to create gadgets.

Signed-off-by: Sasi Kumar <sasi.kumar@broadcom.com>
Signed-off-by: Al Cooper <alcooperx@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/bdc/bdc_core.c |  4 ++++
 drivers/usb/gadget/udc/bdc/bdc_ep.c   | 16 ++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/udc/bdc/bdc_core.c b/drivers/usb/gadget/udc/bdc/bdc_core.c
index e9bd8d4abca00..f09a74d79c9eb 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -286,6 +286,7 @@ static void bdc_mem_init(struct bdc *bdc, bool reinit)
 	 * in that case reinit is passed as 1
 	 */
 	if (reinit) {
+		int i;
 		/* Enable interrupts */
 		temp = bdc_readl(bdc->regs, BDC_BDCSC);
 		temp |= BDC_GIE;
@@ -295,6 +296,9 @@ static void bdc_mem_init(struct bdc *bdc, bool reinit)
 		/* Initialize SRR to 0 */
 		memset(bdc->srr.sr_bds, 0,
 					NUM_SR_ENTRIES * sizeof(struct bdc_bd));
+		/* clear ep flags to avoid post disconnect stops/deconfigs */
+		for (i = 1; i < bdc->num_eps; ++i)
+			bdc->bdc_ep_array[i]->flags = 0;
 	} else {
 		/* One time initiaization only */
 		/* Enable status report function pointers */
diff --git a/drivers/usb/gadget/udc/bdc/bdc_ep.c b/drivers/usb/gadget/udc/bdc/bdc_ep.c
index 3a65272fbed86..9f5f18891ba85 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_ep.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_ep.c
@@ -621,7 +621,6 @@ int bdc_ep_enable(struct bdc_ep *ep)
 	}
 	bdc_dbg_bd_list(bdc, ep);
 	/* only for ep0: config ep is called for ep0 from connect event */
-	ep->flags |= BDC_EP_ENABLED;
 	if (ep->ep_num == 1)
 		return ret;
 
@@ -767,10 +766,13 @@ static int ep_dequeue(struct bdc_ep *ep, struct bdc_req *req)
 					__func__, ep->name, start_bdi, end_bdi);
 	dev_dbg(bdc->dev, "ep_dequeue ep=%p ep->desc=%p\n",
 						ep, (void *)ep->usb_ep.desc);
-	/* Stop the ep to see where the HW is ? */
-	ret = bdc_stop_ep(bdc, ep->ep_num);
-	/* if there is an issue with stopping ep, then no need to go further */
-	if (ret)
+	/* if still connected, stop the ep to see where the HW is ? */
+	if (!(bdc_readl(bdc->regs, BDC_USPC) & BDC_PST_MASK)) {
+		ret = bdc_stop_ep(bdc, ep->ep_num);
+		/* if there is an issue, then no need to go further */
+		if (ret)
+			return 0;
+	} else
 		return 0;
 
 	/*
@@ -1921,7 +1923,9 @@ static int bdc_gadget_ep_disable(struct usb_ep *_ep)
 		__func__, ep->name, ep->flags);
 
 	if (!(ep->flags & BDC_EP_ENABLED)) {
-		dev_warn(bdc->dev, "%s is already disabled\n", ep->name);
+		if (bdc->gadget.speed != USB_SPEED_UNKNOWN)
+			dev_warn(bdc->dev, "%s is already disabled\n",
+				 ep->name);
 		return 0;
 	}
 	spin_lock_irqsave(&bdc->lock, flags);
-- 
2.25.1

