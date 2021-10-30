Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF93E4408F3
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 15:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhJ3NKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 09:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhJ3NKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 09:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECE1460E9C;
        Sat, 30 Oct 2021 13:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635599260;
        bh=rya3I4r8fSg8wq9kxe16R1bDx2VWmC4VS+mWmLY4z6E=;
        h=Subject:To:Cc:From:Date:From;
        b=xSjlbYXpL3q44OqJsVf8soNqZbrTj//ASzOOv+E8+c5p831YEykk54yc2w+nlmpk2
         ucq2/Rt7HKluxVUabGw2MhkrML1Q+m670B5EFKqR81Im1VIxxojv+R+MzKmIgP2oyD
         VLSUol+f4uMxSS2kwWkxpF4h9vWzSx4RxJ6UVZQ0=
Subject: FAILED: patch "[PATCH] net: nxp: lpc_eth.c: avoid hang when bringing interface down" failed to apply to 4.4-stable tree
To:     twoerner@gmail.com, davem@davemloft.net, vz@mleia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 15:07:38 +0200
Message-ID: <163559925868110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ace19b992436a257d9a793672e57abc28fe83e2e Mon Sep 17 00:00:00 2001
From: Trevor Woerner <twoerner@gmail.com>
Date: Sun, 24 Oct 2021 13:50:02 -0400
Subject: [PATCH] net: nxp: lpc_eth.c: avoid hang when bringing interface down

A hard hang is observed whenever the ethernet interface is brought
down. If the PHY is stopped before the LPC core block is reset,
the SoC will hang. Comparing lpc_eth_close() and lpc_eth_open() I
re-arranged the ordering of the functions calls in lpc_eth_close() to
reset the hardware before stopping the PHY.
Fixes: b7370112f519 ("lpc32xx: Added ethernet driver")
Signed-off-by: Trevor Woerner <twoerner@gmail.com>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index d29fe562b3de..c910fa2f40a4 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1015,9 +1015,6 @@ static int lpc_eth_close(struct net_device *ndev)
 	napi_disable(&pldat->napi);
 	netif_stop_queue(ndev);
 
-	if (ndev->phydev)
-		phy_stop(ndev->phydev);
-
 	spin_lock_irqsave(&pldat->lock, flags);
 	__lpc_eth_reset(pldat);
 	netif_carrier_off(ndev);
@@ -1025,6 +1022,8 @@ static int lpc_eth_close(struct net_device *ndev)
 	writel(0, LPC_ENET_MAC2(pldat->net_base));
 	spin_unlock_irqrestore(&pldat->lock, flags);
 
+	if (ndev->phydev)
+		phy_stop(ndev->phydev);
 	clk_disable_unprepare(pldat->clk);
 
 	return 0;

