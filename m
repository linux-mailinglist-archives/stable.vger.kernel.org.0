Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 776C84D6CA
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfFTSMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728983AbfFTSMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:12:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C35F2084E;
        Thu, 20 Jun 2019 18:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054324;
        bh=5+Xkg1DTNteA5Ibst+nQrBbY6g3o6wRxnF+0b/k6Bx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7HeHvv8LR3V1MS8eiH1ZMh5ez0HukyYoDtwXKBvL+OYKEugmgLvqP/zDkoa7hHNB
         uYHTgmcaSPuukAdXaLt/ny0G5bNvz1qoNqzDHycAKErUPIF7RQl9f73EC9FThRhJeD
         0NWmadzcuTYpKlAWmw+ShrvLTT6V44V4+CZEyO8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/61] net: sh_eth: fix mdio access in sh_eth_close() for R-Car Gen2 and RZ/A1 SoCs
Date:   Thu, 20 Jun 2019 19:57:46 +0200
Message-Id: <20190620174346.083121151@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 315ca92dd863fecbffc0bb52ae0ac11e0398726a ]

The sh_eth_close() resets the MAC and then calls phy_stop()
so that mdio read access result is incorrect without any error
according to kernel trace like below:

ifconfig-216   [003] .n..   109.133124: mdio_access: ee700000.ethernet-ffffffff read  phy:0x01 reg:0x00 val:0xffff

According to the hardware manual, the RMII mode should be set to 1
before operation the Ethernet MAC. However, the previous code was not
set to 1 after the driver issued the soft_reset in sh_eth_dev_exit()
so that the mdio read access result seemed incorrect. To fix the issue,
this patch adds a condition and set the RMII mode register in
sh_eth_dev_exit() for R-Car Gen2 and RZ/A1 SoCs.

Note that when I have tried to move the sh_eth_dev_exit() calling
after phy_stop() on sh_eth_close(), but it gets worse (kernel panic
happened and it seems that a register is accessed while the clock is
off).

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index f27a0dc8c563..5e3e6e262ba3 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1588,6 +1588,10 @@ static void sh_eth_dev_exit(struct net_device *ndev)
 	sh_eth_get_stats(ndev);
 	mdp->cd->soft_reset(ndev);
 
+	/* Set the RMII mode again if required */
+	if (mdp->cd->rmiimode)
+		sh_eth_write(ndev, 0x1, RMIIMODE);
+
 	/* Set MAC address again */
 	update_mac_address(ndev);
 }
-- 
2.20.1



