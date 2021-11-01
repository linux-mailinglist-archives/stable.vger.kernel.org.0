Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D036C4417BC
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhKAJjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:39:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233629AbhKAJho (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:37:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5218461352;
        Mon,  1 Nov 2021 09:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758788;
        bh=NWtY/yBNxkcnnGKSfGyzyg6bWegWiIGZz37uhmBi0/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4yyVAfK6qGGWexuRjf7jtOQUe2Mxq4Q2Rkhts1bs99cVlNSHETTN53TPl87QB7Gs
         BdrMJvx4igyLWwRNU3ranuYFMDeNNCBxIeIxZnHQmBEOx5G9TlSaMwGMpQs6i4AG8M
         zz9jI4TByH3t5THqAMYG8mDttQUarFrsbl1eoSvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trevor Woerner <twoerner@gmail.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 59/77] net: nxp: lpc_eth.c: avoid hang when bringing interface down
Date:   Mon,  1 Nov 2021 10:17:47 +0100
Message-Id: <20211101082524.058311014@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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
@@ -1015,9 +1015,6 @@ static int lpc_eth_close(struct net_devi
 	napi_disable(&pldat->napi);
 	netif_stop_queue(ndev);
 
-	if (ndev->phydev)
-		phy_stop(ndev->phydev);
-
 	spin_lock_irqsave(&pldat->lock, flags);
 	__lpc_eth_reset(pldat);
 	netif_carrier_off(ndev);
@@ -1025,6 +1022,8 @@ static int lpc_eth_close(struct net_devi
 	writel(0, LPC_ENET_MAC2(pldat->net_base));
 	spin_unlock_irqrestore(&pldat->lock, flags);
 
+	if (ndev->phydev)
+		phy_stop(ndev->phydev);
 	clk_disable_unprepare(pldat->clk);
 
 	return 0;


