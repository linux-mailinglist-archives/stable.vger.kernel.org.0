Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D105EA06F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbiIZKha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235928AbiIZKf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:35:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C5A4B0EC;
        Mon, 26 Sep 2022 03:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D824F60BB1;
        Mon, 26 Sep 2022 10:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E09C433D7;
        Mon, 26 Sep 2022 10:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187705;
        bh=/wbhLBoU0qvXpttVO+bWXQUXq4lVO5MWkMqUzD+B8Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TG61GHodY995W4WVNiqwSsNCtx/M6wVWr6l5+qwhr4yZeN+LDTS5Gdl25C2l6TjCP
         kp+NNd1GM/3lC1jy0K+z+OGQfT52/T5lxGtmtGmrH+QDv19JYd+yYv9yLTS2cDgPXS
         rAw2m5sAnRR/Q5jPsfSlORd+v9G5j0WEm9bQMy54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/120] usb: dwc3: gadget: Refactor pullup()
Date:   Mon, 26 Sep 2022 12:11:05 +0200
Message-Id: <20220926100751.832849301@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 861c010a2ee1bc4a66d23f0da4aa22e75d8eaa24 ]

Move soft-disconnect sequence out of dwc3_gadget_pullup(). No
functional change here.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/4c0f259b17d95acaaa931f90276683a48a32fe22.1650593829.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 040f2dbd2010 ("usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 65 ++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index ea56f4fb234e..9a7656d01d06 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2008,6 +2008,40 @@ static void dwc3_gadget_disable_irq(struct dwc3 *dwc);
 static void __dwc3_gadget_stop(struct dwc3 *dwc);
 static int __dwc3_gadget_start(struct dwc3 *dwc);
 
+static int dwc3_gadget_soft_disconnect(struct dwc3 *dwc)
+{
+	u32 count;
+
+	dwc->connected = false;
+
+	/*
+	 * In the Synopsys DesignWare Cores USB3 Databook Rev. 3.30a
+	 * Section 4.1.8 Table 4-7, it states that for a device-initiated
+	 * disconnect, the SW needs to ensure that it sends "a DEPENDXFER
+	 * command for any active transfers" before clearing the RunStop
+	 * bit.
+	 */
+	dwc3_stop_active_transfers(dwc);
+	__dwc3_gadget_stop(dwc);
+
+	/*
+	 * In the Synopsys DesignWare Cores USB3 Databook Rev. 3.30a
+	 * Section 1.3.4, it mentions that for the DEVCTRLHLT bit, the
+	 * "software needs to acknowledge the events that are generated
+	 * (by writing to GEVNTCOUNTn) while it is waiting for this bit
+	 * to be set to '1'."
+	 */
+	count = dwc3_readl(dwc->regs, DWC3_GEVNTCOUNT(0));
+	count &= DWC3_GEVNTCOUNT_MASK;
+	if (count > 0) {
+		dwc3_writel(dwc->regs, DWC3_GEVNTCOUNT(0), count);
+		dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
+			dwc->ev_buf->length;
+	}
+
+	return dwc3_gadget_run_stop(dwc, false, false);
+}
+
 static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 {
 	struct dwc3		*dwc = gadget_to_dwc(g);
@@ -2064,33 +2098,7 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 	spin_lock_irqsave(&dwc->lock, flags);
 
 	if (!is_on) {
-		u32 count;
-
-		dwc->connected = false;
-		/*
-		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
-		 * Section 4.1.8 Table 4-7, it states that for a device-initiated
-		 * disconnect, the SW needs to ensure that it sends "a DEPENDXFER
-		 * command for any active transfers" before clearing the RunStop
-		 * bit.
-		 */
-		dwc3_stop_active_transfers(dwc);
-		__dwc3_gadget_stop(dwc);
-
-		/*
-		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
-		 * Section 1.3.4, it mentions that for the DEVCTRLHLT bit, the
-		 * "software needs to acknowledge the events that are generated
-		 * (by writing to GEVNTCOUNTn) while it is waiting for this bit
-		 * to be set to '1'."
-		 */
-		count = dwc3_readl(dwc->regs, DWC3_GEVNTCOUNT(0));
-		count &= DWC3_GEVNTCOUNT_MASK;
-		if (count > 0) {
-			dwc3_writel(dwc->regs, DWC3_GEVNTCOUNT(0), count);
-			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
-						dwc->ev_buf->length;
-		}
+		ret = dwc3_gadget_soft_disconnect(dwc);
 	} else {
 		/*
 		 * In the Synopsys DWC_usb31 1.90a programming guide section
@@ -2104,9 +2112,8 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 
 		dwc3_event_buffers_setup(dwc);
 		__dwc3_gadget_start(dwc);
+		ret = dwc3_gadget_run_stop(dwc, true, false);
 	}
-
-	ret = dwc3_gadget_run_stop(dwc, is_on, false);
 	spin_unlock_irqrestore(&dwc->lock, flags);
 	enable_irq(dwc->irq_gadget);
 
-- 
2.35.1



