Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501871F43F
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfEOK6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbfEOK6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:58:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F10621473;
        Wed, 15 May 2019 10:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917887;
        bh=O51IcFakGuOgXhOuci8TbJmMC0n8xvIIuyNT2UA6TJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JRC9RNTqEzTBLVkOcX2k4D5yDmI8DVC0Z8yEWrDrSz44iPLHUrMz29D0uB1n+WGY
         expDRBhHc+myHmC7Z/QYQgynacqC4mT4CVuw4OuC0Tlyp/oJZEq0mtFYvqdpDwW0ro
         OaQ7USDlQy/3vnz+0GtleZ5QgZ3I8M+B84boK6uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaofei Shen <xiaofeis@codeaurora.org>,
        Sneh Shah <snehshah@codeaurora.org>,
        Vinod Koul <vkoul@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 13/86] net: stmmac: move stmmac_check_ether_addr() to driver probe
Date:   Wed, 15 May 2019 12:54:50 +0200
Message-Id: <20190515090645.283801074@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit b561af36b1841088552464cdc3f6371d92f17710 ]

stmmac_check_ether_addr() checks the MAC address and assigns one in
driver open(). In many cases when we create slave netdevice, the dev
addr is inherited from master but the master dev addr maybe NULL at
that time, so move this call to driver probe so that address is
always valid.

Signed-off-by: Xiaofei Shen <xiaofeis@codeaurora.org>
Tested-by: Xiaofei Shen <xiaofeis@codeaurora.org>
Signed-off-by: Sneh Shah <snehshah@codeaurora.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1736,8 +1736,6 @@ static int stmmac_open(struct net_device
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
 
-	stmmac_check_ether_addr(priv);
-
 	if (priv->pcs != STMMAC_PCS_RGMII && priv->pcs != STMMAC_PCS_TBI &&
 	    priv->pcs != STMMAC_PCS_RTBI) {
 		ret = stmmac_init_phy(dev);
@@ -2824,6 +2822,8 @@ struct stmmac_priv *stmmac_dvr_probe(str
 	if (ret)
 		goto error_hw_init;
 
+	stmmac_check_ether_addr(priv);
+
 	ndev->netdev_ops = &stmmac_netdev_ops;
 
 	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |


