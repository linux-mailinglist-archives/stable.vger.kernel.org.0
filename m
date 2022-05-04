Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016DD51A972
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350653AbiEDRRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356282AbiEDRL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:11:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2BC4B86B;
        Wed,  4 May 2022 09:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 070F2B827A5;
        Wed,  4 May 2022 16:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A937C385AF;
        Wed,  4 May 2022 16:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683455;
        bh=YoUFmdvg5KfbtmqFuUJalffTSLiY1qDj5yqd8lBmxaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WadLr26t8G4tp6VbEwUsZ4Z3cwbP52OdKSGxoKr1kS6/ZqiFZJtEVMKHKWAOpZ4/K
         Ta8BIZH0fzi6lWtqSNR+u9+zSglMw/Xgf/PcdoJN6ANUdg3wSZ/sYmM9XMRsjPmEXK
         +I+cgGUN++bQ2vM8h3dLXJ4AEbFOgAh+/rYZl2Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Lemon <jonathan.lemon@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 130/225] net: bcmgenet: hide status block before TX timestamping
Date:   Wed,  4 May 2022 18:46:08 +0200
Message-Id: <20220504153121.957057863@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

[ Upstream commit acac0541d1d65e81e599ec399d34d184d2424401 ]

The hardware checksum offloading requires use of a transmit
status block inserted before the outgoing frame data, this was
updated in '9a9ba2a4aaaa ("net: bcmgenet: always enable status blocks")'

However, skb_tx_timestamp() assumes that it is passed a raw frame
and PTP parsing chokes on this status block.

Fix this by calling __skb_pull(), which hides the TSB before calling
skb_tx_timestamp(), so an outgoing PTP packet is parsed correctly.

As the data in the skb has already been set up for DMA, and the
dma_unmap_* calls use a separately stored address, there is no
no effective change in the data transmission.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220424165307.591145-1-jonathan.lemon@gmail.com
Fixes: d03825fba459 ("net: bcmgenet: add skb_tx_timestamp call")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 2da804f84b48..c2bfb25e087c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2035,6 +2035,11 @@ static struct sk_buff *bcmgenet_add_tsb(struct net_device *dev,
 	return skb;
 }
 
+static void bcmgenet_hide_tsb(struct sk_buff *skb)
+{
+	__skb_pull(skb, sizeof(struct status_64));
+}
+
 static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
@@ -2141,6 +2146,8 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	GENET_CB(skb)->last_cb = tx_cb_ptr;
+
+	bcmgenet_hide_tsb(skb);
 	skb_tx_timestamp(skb);
 
 	/* Decrement total BD count and advance our write pointer */
-- 
2.35.1



