Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D811137F43
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbgAKKRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:17:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730389AbgAKKRw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:17:52 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BA6E205F4;
        Sat, 11 Jan 2020 10:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737871;
        bh=Ip+IIaODiV15hv7n3lJiWcwHnWf8dWUAsBCm4PN9k/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EF58uxVtlkqVSI1P82l3uiM+DD0FKsYF5G+O8aM5ss42M/GzzJlyAmcurRQJhujIi
         NbzNiE/oD7eNpXrAweiPaNFvm4ij0XZBviiP6BxtctjA0Zoovn1XhFBbr9pQubxwQw
         QFQ/FGryfmOW93saQgfetdQxe5CvJ/PZ4oQwiQd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/84] net: stmmac: Do not accept invalid MTU values
Date:   Sat, 11 Jan 2020 10:50:25 +0100
Message-Id: <20200111094904.531150484@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit eaf4fac478077d4ed57cbca2c044c4b58a96bd98 ]

The maximum MTU value is determined by the maximum size of TX FIFO so
that a full packet can fit in the FIFO. Add a check for this in the MTU
change callback.

Also check if provided and rounded MTU does not passes the maximum limit
of 16K.

Changes from v2:
- Align MTU before checking if its valid

Fixes: 7ac6653a085b ("stmmac: Move the STMicroelectronics driver")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 014fe93ed2d8..ec37ef7521e9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3604,12 +3604,24 @@ static void stmmac_set_rx_mode(struct net_device *dev)
 static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	int txfifosz = priv->plat->tx_fifo_size;
+
+	if (txfifosz == 0)
+		txfifosz = priv->dma_cap.tx_fifo_size;
+
+	txfifosz /= priv->plat->tx_queues_to_use;
 
 	if (netif_running(dev)) {
 		netdev_err(priv->dev, "must be stopped to change its MTU\n");
 		return -EBUSY;
 	}
 
+	new_mtu = STMMAC_ALIGN(new_mtu);
+
+	/* If condition true, FIFO is too small or MTU too large */
+	if ((txfifosz < new_mtu) || (new_mtu > BUF_SIZE_16KiB))
+		return -EINVAL;
+
 	dev->mtu = new_mtu;
 
 	netdev_update_features(dev);
-- 
2.20.1



