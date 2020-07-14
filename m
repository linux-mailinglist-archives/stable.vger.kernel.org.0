Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3061021FBA4
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbgGNTDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731099AbgGNS5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:57:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F6A7207F5;
        Tue, 14 Jul 2020 18:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753055;
        bh=Y4vXQKe7mtBW2sC8bi/lqBkpZsVxlG9RqnJgmezmESQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbCPD67aONpLOpcDa7XWq+Ld/+Bu+duqqSIjbswGUQWUoW1+pEWai3fu7/gsNLNeO
         ToF4OYXRu0M8hLPzwRXxAoQ6miHqBfqTqE1fCxGV/h/n+7GYXRrZG2hAcxZMIC9PC2
         oqxkNBKGxbDEW9bUuZ9E8JbYreeGVCbHXhEILaMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 103/166] net: macb: fix macb_suspend() by removing call to netif_carrier_off()
Date:   Tue, 14 Jul 2020 20:44:28 +0200
Message-Id: <20200714184120.775125901@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

[ Upstream commit 64febc5e56c9a748162f206dcc5be1a44436087a ]

As we now use the phylink call to phylink_stop() in the non-WoL path,
there is no need for this call to netif_carrier_off() anymore. It can
disturb the underlying phylink FSM.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 79c2fe0543038..548815255e22b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4604,7 +4604,6 @@ static int __maybe_unused macb_suspend(struct device *dev)
 			bp->pm_data.scrt2 = gem_readl_n(bp, ETHT, SCRT2_ETHT);
 	}
 
-	netif_carrier_off(netdev);
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_remove(netdev);
 	pm_runtime_force_suspend(dev);
-- 
2.25.1



