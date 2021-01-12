Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE482F35AA
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 17:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406861AbhALQZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 11:25:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406863AbhALQZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 11:25:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A09772080D;
        Tue, 12 Jan 2021 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610468696;
        bh=ToNvRJMEt13rda+LGOMvpTdwNQWyOlwTl4f4v7E/CBo=;
        h=Subject:To:From:Date:From;
        b=K+zs1iKMQd3mBXo2TQvN01l1FsHEe/937m2Up9xlAoMbbH/HVTM76nBZQ7CPMGmef
         na0ZngNsWlCmogJjmVva3h1HU2iRwQge1sMLc/QhlvxZukbw46XfaYk+hEox90RM0J
         OKd72sswvGK0wPOgpa49AP9uIXROMT2AkaGsMNjA=
Subject: patch "usb: gadget: aspeed: fix stop dma register setting." added to usb-linus
To:     ryan_chen@aspeedtech.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, joel@jms.id.au, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 Jan 2021 17:26:04 +0100
Message-ID: <1610468764179235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: aspeed: fix stop dma register setting.

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4e0dcf62ab4cf917d0cbe751b8bf229a065248d4 Mon Sep 17 00:00:00 2001
From: Ryan Chen <ryan_chen@aspeedtech.com>
Date: Fri, 8 Jan 2021 16:12:38 +0800
Subject: usb: gadget: aspeed: fix stop dma register setting.

The vhub engine has two dma mode, one is descriptor list, another
is single stage DMA. Each mode has different stop register setting.
Descriptor list operation (bit2) : 0 disable reset, 1: enable reset
Single mode operation (bit0) : 0 : disable, 1: enable

Fixes: 7ecca2a4080c ("usb/gadget: Add driver for Aspeed SoC virtual hub")
Cc: stable <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Acked-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Ryan Chen <ryan_chen@aspeedtech.com>
Link: https://lore.kernel.org/r/20210108081238.10199-2-ryan_chen@aspeedtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/aspeed-vhub/epn.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/aspeed-vhub/epn.c b/drivers/usb/gadget/udc/aspeed-vhub/epn.c
index 0bd6b20435b8..02d8bfae58fb 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/epn.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/epn.c
@@ -420,7 +420,10 @@ static void ast_vhub_stop_active_req(struct ast_vhub_ep *ep,
 	u32 state, reg, loops;
 
 	/* Stop DMA activity */
-	writel(0, ep->epn.regs + AST_VHUB_EP_DMA_CTLSTAT);
+	if (ep->epn.desc_mode)
+		writel(VHUB_EP_DMA_CTRL_RESET, ep->epn.regs + AST_VHUB_EP_DMA_CTLSTAT);
+	else
+		writel(0, ep->epn.regs + AST_VHUB_EP_DMA_CTLSTAT);
 
 	/* Wait for it to complete */
 	for (loops = 0; loops < 1000; loops++) {
-- 
2.30.0


