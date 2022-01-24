Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F89498AE1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344636AbiAXTHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346272AbiAXTFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:05:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EA2C0613F0;
        Mon, 24 Jan 2022 11:01:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59D0AB8123A;
        Mon, 24 Jan 2022 19:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1FEC340EA;
        Mon, 24 Jan 2022 19:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050861;
        bh=MAeeJZOxqn6EdjZ+yLTH/ZYr2Om5f/r9frQ/yzaDLFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcnbjoBdne6VWiGRW+dtQPPyMv20XLvMPB50APa4SBwSrgJaQfZY3vgmWvm5lc7YS
         3LvdWeovlWvaotVnCFXcTrcOnTR8pe3qAvqWRt1gY3k8eRHCWPcZsjWsZnqkAkO4gO
         NUM8IlG0enuhAH0XQXHt1dop3AKkII7arnyZRvPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 135/157] net: axienet: fix number of TX ring slots for available check
Date:   Mon, 24 Jan 2022 19:43:45 +0100
Message-Id: <20220124183937.059128872@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit aba57a823d2985a2cc8c74a2535f3a88e68d9424 upstream.

The check for the number of available TX ring slots was off by 1 since a
slot is required for the skb header as well as each fragment. This could
result in overwriting a TX ring slot that was still in use.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -680,7 +680,7 @@ axienet_start_xmit(struct sk_buff *skb,
 	num_frag = skb_shinfo(skb)->nr_frags;
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
-	if (axienet_check_tx_bd_space(lp, num_frag)) {
+	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
 		if (netif_queue_stopped(ndev))
 			return NETDEV_TX_BUSY;
 
@@ -690,7 +690,7 @@ axienet_start_xmit(struct sk_buff *skb,
 		smp_mb();
 
 		/* Space might have just been freed - check again */
-		if (axienet_check_tx_bd_space(lp, num_frag))
+		if (axienet_check_tx_bd_space(lp, num_frag + 1))
 			return NETDEV_TX_BUSY;
 
 		netif_wake_queue(ndev);


