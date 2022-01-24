Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD53497FAF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241707AbiAXMhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241667AbiAXMhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:37:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFB8C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 04:37:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FD3360FF9
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71D6C340E1;
        Mon, 24 Jan 2022 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643027858;
        bh=ep+v+mxrHjnexH/8n/3/HMxkJSxOL71gs2ay+2QOxKs=;
        h=Subject:To:Cc:From:Date:From;
        b=LUeKVT+HQT+dTrx2mMR1PEhd2cd07IRUA5vUjD3VS9LgYyIDGMpZmmFpqhvImUyzC
         /oQhMbej/aXeKkOY+fvXyvo/frwb1vGphn23wRZW9LE333XwvKyhSZE/WiRwynv+yW
         mkigF+n5vfdpwRy275JjAu1FZm8NO6kbP7qG/7gs=
Subject: FAILED: patch "[PATCH] net: axienet: increase reset timeout" failed to apply to 4.4-stable tree
To:     robert.hancock@calian.com, andrew@lunn.ch, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:37:35 +0100
Message-ID: <16430278551578@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2e5644b1bab2ccea9cfc7a9520af95b94eb0dbf1 Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Tue, 18 Jan 2022 15:41:24 -0600
Subject: [PATCH] net: axienet: increase reset timeout

The previous timeout of 1ms was too short to handle some cases where the
core is reset just after the input clocks were started, which will
be introduced in an upcoming patch. Increase the timeout to 50ms. Also
simplify the reset timeout checking to use read_poll_timeout.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 23ac353b35fe..9c5b24af61fa 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -496,7 +496,8 @@ static void axienet_setoptions(struct net_device *ndev, u32 options)
 
 static int __axienet_device_reset(struct axienet_local *lp)
 {
-	u32 timeout;
+	u32 value;
+	int ret;
 
 	/* Reset Axi DMA. This would reset Axi Ethernet core as well. The reset
 	 * process of Axi DMA takes a while to complete as all pending
@@ -506,15 +507,13 @@ static int __axienet_device_reset(struct axienet_local *lp)
 	 * they both reset the entire DMA core, so only one needs to be used.
 	 */
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, XAXIDMA_CR_RESET_MASK);
-	timeout = DELAY_OF_ONE_MILLISEC;
-	while (axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET) &
-				XAXIDMA_CR_RESET_MASK) {
-		udelay(1);
-		if (--timeout == 0) {
-			netdev_err(lp->ndev, "%s: DMA reset timeout!\n",
-				   __func__);
-			return -ETIMEDOUT;
-		}
+	ret = read_poll_timeout(axienet_dma_in32, value,
+				!(value & XAXIDMA_CR_RESET_MASK),
+				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
+				XAXIDMA_TX_CR_OFFSET);
+	if (ret) {
+		dev_err(lp->dev, "%s: DMA reset timeout!\n", __func__);
+		return ret;
 	}
 
 	return 0;

