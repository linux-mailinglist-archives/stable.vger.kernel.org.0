Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9886755D4DF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbiF0LtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238307AbiF0LsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D7EBE18;
        Mon, 27 Jun 2022 04:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 597CAB81131;
        Mon, 27 Jun 2022 11:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79FFC3411D;
        Mon, 27 Jun 2022 11:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330022;
        bh=InO1qyewBGSJED7hj3a0yvwG8y5y7l7Yk35cE3JajY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXI4Z6Ui1ixrEA/qfnrZ/53XFUiupzwz5CtuePguRNj1XKUHGQUBG31/N0imgnc2L
         hn3tP9jn/L1zHG+OEoeKWCCJys3nI2p8BA1ELOEXRJvsE3/C553eBq3WsMNKkMx/dD
         NZcaK0fcBzzO9S7gTCCS6KXBuQPpl4xo+zFDhxoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 058/181] veth: Add updating of trans_start
Date:   Mon, 27 Jun 2022 13:20:31 +0200
Message-Id: <20220627111946.248994237@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Vosburgh <jay.vosburgh@canonical.com>

[ Upstream commit e66e257a5d8368d9c0ba13d4630f474436533e8b ]

Since commit 21a75f0915dd ("bonding: Fix ARP monitor validation"),
the bonding ARP / ND link monitors depend on the trans_start time to
determine link availability.  NETIF_F_LLTX drivers must update trans_start
directly, which veth does not do.  This prevents use of the ARP or ND link
monitors with veth interfaces in a bond.

	Resolve this by having veth_xmit update the trans_start time.

Reported-by: Jonathan Toppins <jtoppins@redhat.com>
Tested-by: Jonathan Toppins <jtoppins@redhat.com>
Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Fixes: 21a75f0915dd ("bonding: Fix ARP monitor validation")
Link: https://lore.kernel.org/netdev/b2fd4147-8f50-bebd-963a-1a3e8d1d9715@redhat.com/
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index eb0121a64d6d..1d1dea07d932 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -312,6 +312,7 @@ static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
 static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
+	struct netdev_queue *queue = NULL;
 	struct veth_rq *rq = NULL;
 	struct net_device *rcv;
 	int length = skb->len;
@@ -329,6 +330,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 	rxq = skb_get_queue_mapping(skb);
 	if (rxq < rcv->real_num_rx_queues) {
 		rq = &rcv_priv->rq[rxq];
+		queue = netdev_get_tx_queue(dev, rxq);
 
 		/* The napi pointer is available when an XDP program is
 		 * attached or when GRO is enabled
@@ -340,6 +342,8 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb_tx_timestamp(skb);
 	if (likely(veth_forward_skb(rcv, skb, rq, use_napi) == NET_RX_SUCCESS)) {
+		if (queue)
+			txq_trans_cond_update(queue);
 		if (!use_napi)
 			dev_lstats_add(dev, length);
 	} else {
-- 
2.35.1



