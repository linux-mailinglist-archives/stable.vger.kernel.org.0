Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8C6507ED
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbfFXKGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729347AbfFXKGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:06:19 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED004214DA;
        Mon, 24 Jun 2019 10:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370779;
        bh=T7BqYE8I2vyHBuykujpcA5LqSfrrb1mopoTNAfBBtE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHxpVRIMVyvBIEiD9Z6bqQYznlLjNmbjnGkGjTaK/joK6dWX6mXBx7JUX4+oeIksn
         Z6lhEqsS8zMZz8dReGN5F2i/0s1X1jP0Z2dnXDEYU0iMgL2ix1OHLX6fmRK8Mh1+ih
         I6FcUFGuexqxPeYH/DUCquCMnKrP17ZvN38YBaYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Lee <mark-mc.lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 53/90] net: ethernet: mediatek: Use hw_feature to judge if HWLRO is supported
Date:   Mon, 24 Jun 2019 17:56:43 +0800
Message-Id: <20190624092317.642323934@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9e4f56f1a7f3287718d0083b5cb85298dc05a5fd ]

Should hw_feature as hardware capability flags to check if hardware LRO
got support.

Signed-off-by: Mark Lee <mark-mc.lee@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6e6abdc399de..0c70fb345f83 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2304,13 +2304,13 @@ static int mtk_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 
 	switch (cmd->cmd) {
 	case ETHTOOL_GRXRINGS:
-		if (dev->features & NETIF_F_LRO) {
+		if (dev->hw_features & NETIF_F_LRO) {
 			cmd->data = MTK_MAX_RX_RING_NUM;
 			ret = 0;
 		}
 		break;
 	case ETHTOOL_GRXCLSRLCNT:
-		if (dev->features & NETIF_F_LRO) {
+		if (dev->hw_features & NETIF_F_LRO) {
 			struct mtk_mac *mac = netdev_priv(dev);
 
 			cmd->rule_cnt = mac->hwlro_ip_cnt;
@@ -2318,11 +2318,11 @@ static int mtk_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 		}
 		break;
 	case ETHTOOL_GRXCLSRULE:
-		if (dev->features & NETIF_F_LRO)
+		if (dev->hw_features & NETIF_F_LRO)
 			ret = mtk_hwlro_get_fdir_entry(dev, cmd);
 		break;
 	case ETHTOOL_GRXCLSRLALL:
-		if (dev->features & NETIF_F_LRO)
+		if (dev->hw_features & NETIF_F_LRO)
 			ret = mtk_hwlro_get_fdir_all(dev, cmd,
 						     rule_locs);
 		break;
@@ -2339,11 +2339,11 @@ static int mtk_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 
 	switch (cmd->cmd) {
 	case ETHTOOL_SRXCLSRLINS:
-		if (dev->features & NETIF_F_LRO)
+		if (dev->hw_features & NETIF_F_LRO)
 			ret = mtk_hwlro_add_ipaddr(dev, cmd);
 		break;
 	case ETHTOOL_SRXCLSRLDEL:
-		if (dev->features & NETIF_F_LRO)
+		if (dev->hw_features & NETIF_F_LRO)
 			ret = mtk_hwlro_del_ipaddr(dev, cmd);
 		break;
 	default:
-- 
2.20.1



