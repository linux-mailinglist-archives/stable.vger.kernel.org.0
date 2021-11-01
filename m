Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326BD441659
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhKAJY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232410AbhKAJXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CE9261177;
        Mon,  1 Nov 2021 09:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758431;
        bh=zL/Gsn+YgVZJ8X1wFC9uwaZjs+VHA+eyjszlB8UZVV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgCtSfrYZCLLWjQtqkN2Uv1Se/+u7dJpOSXlebol7xJQI6+frbSHzgJtAWphXt35N
         ISR/WWV2caibtXnI7Gfh4E81dqWbBq+A7Lc3sdIJgvpK1+YQxFJszxYF3GRaEhEX2U
         Sa8nUKd4dEIbkPy28WFZMDAzE8IPdzoIZPrWkTg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trevor Woerner <twoerner@gmail.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 20/25] net: nxp: lpc_eth.c: avoid hang when bringing interface down
Date:   Mon,  1 Nov 2021 10:17:32 +0100
Message-Id: <20211101082451.797079081@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082447.070493993@linuxfoundation.org>
References: <20211101082447.070493993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trevor Woerner <twoerner@gmail.com>

commit ace19b992436a257d9a793672e57abc28fe83e2e upstream.

A hard hang is observed whenever the ethernet interface is brought
down. If the PHY is stopped before the LPC core block is reset,
the SoC will hang. Comparing lpc_eth_close() and lpc_eth_open() I
re-arranged the ordering of the functions calls in lpc_eth_close() to
reset the hardware before stopping the PHY.
Fixes: b7370112f519 ("lpc32xx: Added ethernet driver")
Signed-off-by: Trevor Woerner <twoerner@gmail.com>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/nxp/lpc_eth.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1037,9 +1037,6 @@ static int lpc_eth_close(struct net_devi
 	napi_disable(&pldat->napi);
 	netif_stop_queue(ndev);
 
-	if (ndev->phydev)
-		phy_stop(ndev->phydev);
-
 	spin_lock_irqsave(&pldat->lock, flags);
 	__lpc_eth_reset(pldat);
 	netif_carrier_off(ndev);
@@ -1047,6 +1044,8 @@ static int lpc_eth_close(struct net_devi
 	writel(0, LPC_ENET_MAC2(pldat->net_base));
 	spin_unlock_irqrestore(&pldat->lock, flags);
 
+	if (ndev->phydev)
+		phy_stop(ndev->phydev);
 	clk_disable_unprepare(pldat->clk);
 
 	return 0;


