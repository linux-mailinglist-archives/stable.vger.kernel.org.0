Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C2EF84A
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbfD3Lkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728518AbfD3Lkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:40:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ACA921707;
        Tue, 30 Apr 2019 11:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624436;
        bh=EBtGlrmXK6Nr4x1nqgVgKRjjQ6nOmHMhXkpLO/EBqPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOdPuumwyPgXbtx3BXjyrzp4Bvf1YJuQ2UUfaouoHoQ4269xWxg6aXl4+B94HqZ/9
         QEgQLJbpNLOiFJeClUCjiWdMeHWQFnT1LuoCeY9ZHGGg4qPsf5dsmWwnB5XAFSxkuL
         vzxLSEnREUpqdOvKlLKHf1BokIFt8zEeT9gRz5CI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaofei Shen <xiaofeis@codeaurora.org>,
        Sneh Shah <snehshah@codeaurora.org>,
        Vinod Koul <vkoul@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 35/41] net: stmmac: move stmmac_check_ether_addr() to driver probe
Date:   Tue, 30 Apr 2019 13:38:46 +0200
Message-Id: <20190430113532.741672996@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
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
@@ -1796,8 +1796,6 @@ static int stmmac_open(struct net_device
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
 
-	stmmac_check_ether_addr(priv);
-
 	if (priv->hw->pcs != STMMAC_PCS_RGMII &&
 	    priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI) {
@@ -3355,6 +3353,8 @@ int stmmac_dvr_probe(struct device *devi
 	if (ret)
 		goto error_hw_init;
 
+	stmmac_check_ether_addr(priv);
+
 	ndev->netdev_ops = &stmmac_netdev_ops;
 
 	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |


