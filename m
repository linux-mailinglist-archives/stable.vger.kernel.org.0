Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88ECE64A1E3
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiLLNqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiLLNqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:46:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888186253
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:46:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EF2961089
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60FFC433EF;
        Mon, 12 Dec 2022 13:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852777;
        bh=x3Jmmz1njMUjZsp0Qb6EeANfec/hdP8cxH/1omFSBEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Shwgfwyqbhz76XE1f+sl60Dlsjii/2X9iGV1bWZH45wZhAcsZNRE3C9Ge26oVweTx
         oDtDM0awjvANpBSDWPF6WtRo0sEsN+jYmaN8iXu5ak2kv/TNzgHGB2WX3Lpq6yhOsa
         qk8y/iHCh9f9ggRhDmv6QJb92xgjkG4KNwK52XsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Casper Andersson <casper.casan@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 122/157] net: microchip: sparx5: correctly free skb in xmit
Date:   Mon, 12 Dec 2022 14:17:50 +0100
Message-Id: <20221212130939.760402682@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Casper Andersson <casper.casan@gmail.com>

[ Upstream commit 121c6672b0191ffcebff4b88ec022c39e0a95789 ]

consume_skb on transmitted, kfree_skb on dropped, do not free on
TX_BUSY.

Previously the xmit function could return -EBUSY without freeing, which
supposedly is interpreted as a drop. And was using kfree on successfully
transmitted packets.

sparx5_fdma_xmit and sparx5_inject returns error code, where -EBUSY
indicates TX_BUSY and any other error code indicates dropped.

Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Signed-off-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/sparx5/sparx5_fdma.c   |  2 +-
 .../ethernet/microchip/sparx5/sparx5_packet.c | 41 +++++++++++--------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index 66360c8c5a38..141897dfe388 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -317,7 +317,7 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
 	next_dcb_hw = sparx5_fdma_next_dcb(tx, tx->curr_entry);
 	db_hw = &next_dcb_hw->db[0];
 	if (!(db_hw->status & FDMA_DCB_STATUS_DONE))
-		tx->dropped++;
+		return -EINVAL;
 	db = list_first_entry(&tx->db_list, struct sparx5_db, list);
 	list_move_tail(&db->list, &tx->db_list);
 	next_dcb_hw->nextptr = FDMA_DCB_INVALID_DATA;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 21844beba72d..0ce0fc985222 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -234,9 +234,8 @@ int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	sparx5_set_port_ifh(ifh, port->portno);
 
 	if (sparx5->ptp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-		ret = sparx5_ptp_txtstamp_request(port, skb);
-		if (ret)
-			return ret;
+		if (sparx5_ptp_txtstamp_request(port, skb) < 0)
+			return NETDEV_TX_BUSY;
 
 		sparx5_set_port_ifh_rew_op(ifh, SPARX5_SKB_CB(skb)->rew_op);
 		sparx5_set_port_ifh_pdu_type(ifh, SPARX5_SKB_CB(skb)->pdu_type);
@@ -250,23 +249,31 @@ int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	else
 		ret = sparx5_inject(sparx5, ifh, skb, dev);
 
-	if (ret == NETDEV_TX_OK) {
-		stats->tx_bytes += skb->len;
-		stats->tx_packets++;
+	if (ret == -EBUSY)
+		goto busy;
+	if (ret < 0)
+		goto drop;
 
-		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
-		    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
-			return ret;
+	stats->tx_bytes += skb->len;
+	stats->tx_packets++;
+	sparx5->tx.packets++;
 
-		dev_kfree_skb_any(skb);
-	} else {
-		stats->tx_dropped++;
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+	    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+		return NETDEV_TX_OK;
 
-		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
-		    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
-			sparx5_ptp_txtstamp_release(port, skb);
-	}
-	return ret;
+	dev_consume_skb_any(skb);
+	return NETDEV_TX_OK;
+drop:
+	stats->tx_dropped++;
+	sparx5->tx.dropped++;
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+busy:
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+	    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+		sparx5_ptp_txtstamp_release(port, skb);
+	return NETDEV_TX_BUSY;
 }
 
 static enum hrtimer_restart sparx5_injection_timeout(struct hrtimer *tmr)
-- 
2.35.1



