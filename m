Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1506615957
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiKBDJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiKBDIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:08:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2691F17AA7
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:08:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6EAC617BB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EB7C433D6;
        Wed,  2 Nov 2022 03:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358532;
        bh=JMNt0vNfbEM8ZGzj78BgA1AD3Q0jjv6YDBvo8TqRAEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwaCRnOQ13dhkjuI05LcLc+6Ft7wk4U5/7nr/jcDGJRFh6O8GPm6BVwFHmoNhuoMP
         7IxF0b34JNS1lDHVhmwD68jj12Qk49IG/x8RDEAyb0jX23uEkuHf2RMVYVKd3txd4s
         ED9Y/rOYjrK5jEswvT0obbdyjKB5gSSJHP4m/Azw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/132] net: broadcom: bcm4908_enet: update TX stats after actual transmission
Date:   Wed,  2 Nov 2022 03:33:41 +0100
Message-Id: <20221102022102.688949244@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit ef3556ee16c68735ec69bd08df41d1cd83b14ad3 ]

Queueing packets doesn't guarantee their transmission. Update TX stats
after hardware confirms consuming submitted data.

This also fixes a possible race and NULL dereference.
bcm4908_enet_start_xmit() could try to access skb after freeing it in
the bcm4908_enet_poll_tx().

Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: 4feffeadbcb2e ("net: broadcom: bcm4908enet: add BCM4908 controller driver")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221027112430.8696-1-zajec5@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 994731a33e18..7e89664943ce 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -561,8 +561,6 @@ static int bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_device *netde
 
 	if (++ring->write_idx == ring->length - 1)
 		ring->write_idx = 0;
-	enet->netdev->stats.tx_bytes += skb->len;
-	enet->netdev->stats.tx_packets++;
 
 	return NETDEV_TX_OK;
 }
@@ -635,6 +633,7 @@ static int bcm4908_enet_poll_tx(struct napi_struct *napi, int weight)
 	struct bcm4908_enet_dma_ring_bd *buf_desc;
 	struct bcm4908_enet_dma_ring_slot *slot;
 	struct device *dev = enet->dev;
+	unsigned int bytes = 0;
 	int handled = 0;
 
 	while (handled < weight && tx_ring->read_idx != tx_ring->write_idx) {
@@ -645,12 +644,17 @@ static int bcm4908_enet_poll_tx(struct napi_struct *napi, int weight)
 
 		dma_unmap_single(dev, slot->dma_addr, slot->len, DMA_TO_DEVICE);
 		dev_kfree_skb(slot->skb);
-		if (++tx_ring->read_idx == tx_ring->length)
-			tx_ring->read_idx = 0;
 
 		handled++;
+		bytes += slot->len;
+
+		if (++tx_ring->read_idx == tx_ring->length)
+			tx_ring->read_idx = 0;
 	}
 
+	enet->netdev->stats.tx_packets += handled;
+	enet->netdev->stats.tx_bytes += bytes;
+
 	if (handled < weight) {
 		napi_complete_done(napi, handled);
 		bcm4908_enet_dma_ring_intrs_on(enet, tx_ring);
-- 
2.35.1



