Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D8318B614
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729985AbgCSNX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730409AbgCSNX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:23:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1647206D7;
        Thu, 19 Mar 2020 13:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624237;
        bh=x/7Mj1IVLKhB1GyaA358yPJMXxDjNwkvTdsrP80kqqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kf6T1o4Z/qkwKMSZKZMq9KjNmX5UWNgRZYz3vxzcZeh6TPAs12kjxNf0rDCfEo5Qc
         AQE0JcYHjUsYpAZe77adGaX9nntFrYoBADA6S5W3AWaCkd/wQ98Vf1icycjQbcX+8k
         yESwhkw8PLStnjHLAs7e7wVUQN2O4XF4F0rzeLfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/60] net: ks8851-ml: Fix IRQ handling and locking
Date:   Thu, 19 Mar 2020 14:04:04 +0100
Message-Id: <20200319123927.681650037@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 44343418d0f2f623cb9da6f5000df793131cbe3b ]

The KS8851 requires that packet RX and TX are mutually exclusive.
Currently, the driver hopes to achieve this by disabling interrupt
from the card by writing the card registers and by disabling the
interrupt on the interrupt controller. This however is racy on SMP.

Replace this approach by expanding the spinlock used around the
ks_start_xmit() TX path to ks_irq() RX path to assure true mutual
exclusion and remove the interrupt enabling/disabling, which is
now not needed anymore. Furthermore, disable interrupts also in
ks_net_stop(), which was missing before.

Note that a massive improvement here would be to re-use the KS8851
driver approach, which is to move the TX path into a worker thread,
interrupt handling to threaded interrupt, and synchronize everything
with mutexes, but that would be a much bigger rework, for a separate
patch.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851_mll.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index 1c9e70c8cc30f..58579baf3f7a0 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -513,14 +513,17 @@ static irqreturn_t ks_irq(int irq, void *pw)
 {
 	struct net_device *netdev = pw;
 	struct ks_net *ks = netdev_priv(netdev);
+	unsigned long flags;
 	u16 status;
 
+	spin_lock_irqsave(&ks->statelock, flags);
 	/*this should be the first in IRQ handler */
 	ks_save_cmd_reg(ks);
 
 	status = ks_rdreg16(ks, KS_ISR);
 	if (unlikely(!status)) {
 		ks_restore_cmd_reg(ks);
+		spin_unlock_irqrestore(&ks->statelock, flags);
 		return IRQ_NONE;
 	}
 
@@ -546,6 +549,7 @@ static irqreturn_t ks_irq(int irq, void *pw)
 		ks->netdev->stats.rx_over_errors++;
 	/* this should be the last in IRQ handler*/
 	ks_restore_cmd_reg(ks);
+	spin_unlock_irqrestore(&ks->statelock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -615,6 +619,7 @@ static int ks_net_stop(struct net_device *netdev)
 
 	/* shutdown RX/TX QMU */
 	ks_disable_qmu(ks);
+	ks_disable_int(ks);
 
 	/* set powermode to soft power down to save power */
 	ks_set_powermode(ks, PMECR_PM_SOFTDOWN);
@@ -671,10 +676,9 @@ static netdev_tx_t ks_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	netdev_tx_t retv = NETDEV_TX_OK;
 	struct ks_net *ks = netdev_priv(netdev);
+	unsigned long flags;
 
-	disable_irq(netdev->irq);
-	ks_disable_int(ks);
-	spin_lock(&ks->statelock);
+	spin_lock_irqsave(&ks->statelock, flags);
 
 	/* Extra space are required:
 	*  4 byte for alignment, 4 for status/length, 4 for CRC
@@ -688,9 +692,7 @@ static netdev_tx_t ks_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 		dev_kfree_skb(skb);
 	} else
 		retv = NETDEV_TX_BUSY;
-	spin_unlock(&ks->statelock);
-	ks_enable_int(ks);
-	enable_irq(netdev->irq);
+	spin_unlock_irqrestore(&ks->statelock, flags);
 	return retv;
 }
 
-- 
2.20.1



