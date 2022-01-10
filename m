Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69719489253
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbiAJHl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241748AbiAJHiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:38:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FBEC028BB1;
        Sun,  9 Jan 2022 23:32:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5C6BB81213;
        Mon, 10 Jan 2022 07:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAF0C36AED;
        Mon, 10 Jan 2022 07:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799963;
        bh=5ucqwL7Dxkwj99euF0edW3rqp3iP71cRd2u/ZGk/uBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Joj5pbsBMUEXkr2g6F/IyqexB9vdYtZsk2oJZUFmBRoZWXlcRF/UnIW8jnce2nvfR
         OpPyn5uVUj5j75sKuXNEfcLUBm81xgK9568XFc01KpeTO31ayqzVPNJZryBPdUK2aN
         mRWdsyK4GRdvwfq3owvFNbPGQfUCZ4Qby/fRLrZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 30/72] net: ena: Fix wrong rx request id by resetting device
Date:   Mon, 10 Jan 2022 08:23:07 +0100
Message-Id: <20220110071822.580753572@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

commit cb3d4f98f0b26eafa0b913ac3716e4714254a747 upstream.

A wrong request id received from the device is a sign that
something is wrong with it, therefore trigger a device reset.

Also add some debug info to the "Page is NULL" print to make
it easier to debug.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1428,6 +1428,7 @@ static struct sk_buff *ena_rx_skb(struct
 				  u16 *next_to_clean)
 {
 	struct ena_rx_buffer *rx_info;
+	struct ena_adapter *adapter;
 	u16 len, req_id, buf = 0;
 	struct sk_buff *skb;
 	void *page_addr;
@@ -1440,8 +1441,14 @@ static struct sk_buff *ena_rx_skb(struct
 	rx_info = &rx_ring->rx_buffer_info[req_id];
 
 	if (unlikely(!rx_info->page)) {
-		netif_err(rx_ring->adapter, rx_err, rx_ring->netdev,
-			  "Page is NULL\n");
+		adapter = rx_ring->adapter;
+		netif_err(adapter, rx_err, rx_ring->netdev,
+			  "Page is NULL. qid %u req_id %u\n", rx_ring->qid, req_id);
+		ena_increase_stat(&rx_ring->rx_stats.bad_req_id, 1, &rx_ring->syncp);
+		adapter->reset_reason = ENA_REGS_RESET_INV_RX_REQ_ID;
+		/* Make sure reset reason is set before triggering the reset */
+		smp_mb__before_atomic();
+		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
 		return NULL;
 	}
 


