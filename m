Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD332015D0
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390061AbgFSO7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388538AbgFSO7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:59:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3D0021919;
        Fri, 19 Jun 2020 14:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578746;
        bh=joHfT7bcauPIx7wZQqsTyIJ76SF7kDA5AvCTJjZoit0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbdGR6O0P/GlZ7lXLE6Eki2qZyGizw/IJ7XJSow9QWg+R6a/adlJxy3UuEcLXj0qB
         fWv7hP0evL3vku57w3nmjCjztaXk2C6nFXSEpeBHudER1pZgDv18K8Tankrg2TUAkg
         Kc7AZc09epdh/NZEvd5VkdHXzWegYidvdrKgkPHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 140/267] net: allwinner: Fix use correct return type for ndo_start_xmit()
Date:   Fri, 19 Jun 2020 16:32:05 +0200
Message-Id: <20200619141655.544002719@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 09f6c44aaae0f1bdb8b983d7762676d5018c53bc ]

The method ndo_start_xmit() returns a value of type netdev_tx_t. Fix
the ndo function to use the correct type. And emac_start_xmit() can
leak one skb if 'channel' == 3.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 3143de45baaa..c458b81ba63a 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -433,7 +433,7 @@ static void emac_timeout(struct net_device *dev)
 /* Hardware start transmission.
  * Send a packet to media from the upper layer.
  */
-static int emac_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t emac_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct emac_board_info *db = netdev_priv(dev);
 	unsigned long channel;
@@ -441,7 +441,7 @@ static int emac_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	channel = db->tx_fifo_stat & 3;
 	if (channel == 3)
-		return 1;
+		return NETDEV_TX_BUSY;
 
 	channel = (channel == 1 ? 1 : 0);
 
-- 
2.25.1



