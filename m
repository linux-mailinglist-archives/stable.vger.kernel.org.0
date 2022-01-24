Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA56497FE1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240290AbiAXMsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:48:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60558 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242389AbiAXMsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:48:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 408E26103F
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52979C340E7;
        Mon, 24 Jan 2022 12:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643028520;
        bh=AV3YxxoWbOVOUmEHa2q2yo72KAsnqCMGF+lZKM8ixB4=;
        h=Subject:To:Cc:From:Date:From;
        b=cxxRRoYDZ4Qf6lZcmRj8TCsESnlOr41IBTUh3OZP8y2nt5m3gYPno/52JfG0iLB+d
         a2P46MMqj8qE4pxLzWRhI9POPRKWBpIbOIexBjfhR8xx44+juzQX3bJ48tCZyYLy1A
         wPjjQlW4Qx+DKy+s7f/mpXqojg4EUc4tLGwXqctw=
Subject: FAILED: patch "[PATCH] net: axienet: Fix TX ring slot available check" failed to apply to 4.19-stable tree
To:     robert.hancock@calian.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:48:31 +0100
Message-ID: <164302851122136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 996defd7f8b5dafc1d480b7585c7c62437f80c3c Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Tue, 18 Jan 2022 15:41:29 -0600
Subject: [PATCH] net: axienet: Fix TX ring slot available check

The check for whether a TX ring slot was available was incorrect,
since a slot which had been loaded with transmit data but the device had
not started transmitting would be treated as available, potentially
causing non-transmitted slots to be overwritten. The control field in
the descriptor should be checked, rather than the status field (which may
only be updated when the device completes the entry).

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3f92001bacaf..85fe2b3bd37a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -643,7 +643,6 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		if (cur_p->skb && (status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			dev_consume_skb_irq(cur_p->skb);
 
-		cur_p->cntrl = 0;
 		cur_p->app0 = 0;
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
@@ -651,6 +650,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		cur_p->skb = NULL;
 		/* ensure our transmit path and device don't prematurely see status cleared */
 		wmb();
+		cur_p->cntrl = 0;
 		cur_p->status = 0;
 
 		if (sizep)
@@ -713,7 +713,7 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 	/* Ensure we see all descriptor updates from device or TX IRQ path */
 	rmb();
 	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
-	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
+	if (cur_p->cntrl)
 		return NETDEV_TX_BUSY;
 	return 0;
 }

