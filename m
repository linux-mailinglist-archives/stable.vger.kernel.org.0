Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B574D5D9
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbfFTSBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbfFTSBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:01:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48AC62084A;
        Thu, 20 Jun 2019 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053693;
        bh=dyrPen8UBKVWOtfB03I5Mx+bnvrcbZLHun8Mz816CaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ypV12nM5yILNR7+0IF5ocC1BXi/wROIofuD+8zdFGXQFtm3AU7X7rKyDvZrBu8VqD
         6UPaVMHBnWGTrgvc5W7qwmpW0I5h5sYeogFwTa+/GbY6M6cARsfbMkcpPLHEAoqjsu
         M7+HzY6eGVuAL2Ndld5AorIu98zhBco7Zk/pJbJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 79/84] net: sh_eth: fix mdio access in sh_eth_close() for R-Car Gen2 and RZ/A1 SoCs
Date:   Thu, 20 Jun 2019 19:57:16 +0200
Message-Id: <20190620174348.987754510@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
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
index afaf79b8761f..2d9f4ed9a65e 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1408,6 +1408,10 @@ static void sh_eth_dev_exit(struct net_device *ndev)
 	sh_eth_get_stats(ndev);
 	sh_eth_reset(ndev);
 
+	/* Set the RMII mode again if required */
+	if (mdp->cd->rmiimode)
+		sh_eth_write(ndev, 0x1, RMIIMODE);
+
 	/* Set MAC address again */
 	update_mac_address(ndev);
 }
-- 
2.20.1



