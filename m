Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAD96158A1
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiKBCz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiKBCz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:55:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B5A220FB
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:55:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C213B82064
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E8DC433D6;
        Wed,  2 Nov 2022 02:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357725;
        bh=yb0/IESyzdeWQPDJOh9QPdBxMM+rHJ6SRYnUlYuNwsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ym6Aj6NWlflqd6paGPrufmeZOV20FnkBSntI5K/ee8NMpXPXabQ9aX6vB0aUGA7W9
         DxgFMFlIFSteuWoKqcdPCnFEtBMBDt+NqQX3mBQ7CYajaWAsXFI/zORKIF2IU57NI8
         zsPgb8vCCsC0QuU2ZTQdGwwI8bQHDOU3tZloBHuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 219/240] net: broadcom: bcm4908_enet: update TX stats after actual transmission
Date:   Wed,  2 Nov 2022 03:33:14 +0100
Message-Id: <20221102022116.353753968@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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
index c131d8118489..5ec429663f4c 100644
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



