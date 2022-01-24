Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C91E49A9ED
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323846AbiAYD3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446089AbiAXVGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:06:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FEAC06136B;
        Mon, 24 Jan 2022 12:07:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F842B810BD;
        Mon, 24 Jan 2022 20:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E728C340E5;
        Mon, 24 Jan 2022 20:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054840;
        bh=QQYbblQ35leF5mIDeINDGQFfwan87gWS7LaQi2QXxZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xT0ymktvrfA6sG0TT+iKfB8fTas5BsE3O//P2oWzUAxsIw7JxYDdOjCqLJtqVCYbt
         H/UxeblPCOwzfmO9UNNykZ7mvvQpPzFMQihhm7qmC5VxNAmPSxHkO5qMM9TZt/tWfj
         Aiql5XJeIMAB4ZGnBnTT3lEVufgPnCUhCqfjABVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 520/563] net: axienet: increase reset timeout
Date:   Mon, 24 Jan 2022 19:44:45 +0100
Message-Id: <20220124184042.421883072@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit 2e5644b1bab2ccea9cfc7a9520af95b94eb0dbf1 upstream.

The previous timeout of 1ms was too short to handle some cases where the
core is reset just after the input clocks were started, which will
be introduced in an upcoming patch. Increase the timeout to 50ms. Also
simplify the reset timeout checking to use read_poll_timeout.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -496,7 +496,8 @@ static void axienet_setoptions(struct ne
 
 static int __axienet_device_reset(struct axienet_local *lp)
 {
-	u32 timeout;
+	u32 value;
+	int ret;
 
 	/* Reset Axi DMA. This would reset Axi Ethernet core as well. The reset
 	 * process of Axi DMA takes a while to complete as all pending
@@ -506,15 +507,13 @@ static int __axienet_device_reset(struct
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


