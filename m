Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332642E3940
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731575AbgL1NVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:21:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387908AbgL1NVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:21:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC41F207C9;
        Mon, 28 Dec 2020 13:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161631;
        bh=lMs1uzFsLCBKQ961/06UdSYFUPJ3xEaiiqMoE3S69EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vk7zrctiTI13CRrx8n2ePEJsjMrVJhBU4NMJfaaLQj5oh0jAOosOeyGMT+zJtNIzz
         cDo+UOmk0ebvLvNzY4hM0iJ3CvyIwipy9SPd9muFzSBbAODVj5i3yDB1BvMfkpynHv
         /JU1viserbtVVwv+02qJCTUlmsYefU8BMTdiOGkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 035/346] net: stmmac: delete the eee_ctrl_timer after napi disabled
Date:   Mon, 28 Dec 2020 13:45:54 +0100
Message-Id: <20201228124921.480673231@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit 5f58591323bf3f342920179f24515935c4b5fd60 ]

There have chance to re-enable the eee_ctrl_timer and fire the timer
in napi callback after delete the timer in .stmmac_release(), which
introduces to access eee registers in the timer function after clocks
are disabled then causes system hang. Found this issue when do
suspend/resume and reboot stress test.

It is safe to delete the timer after napi disabled and disable lpi mode.

Fixes: d765955d2ae0b ("stmmac: add the Energy Efficient Ethernet support")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2702,9 +2702,6 @@ static int stmmac_release(struct net_dev
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
-	if (priv->eee_enabled)
-		del_timer_sync(&priv->eee_ctrl_timer);
-
 	/* Stop and disconnect the PHY */
 	if (dev->phydev) {
 		phy_stop(dev->phydev);
@@ -2723,6 +2720,11 @@ static int stmmac_release(struct net_dev
 	if (priv->lpi_irq > 0)
 		free_irq(priv->lpi_irq, dev);
 
+	if (priv->eee_enabled) {
+		priv->tx_path_in_lpi_mode = false;
+		del_timer_sync(&priv->eee_ctrl_timer);
+	}
+
 	/* Stop TX/RX DMA and clear the descriptors */
 	stmmac_stop_all_dma(priv);
 
@@ -4510,6 +4512,11 @@ int stmmac_suspend(struct device *dev)
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
 		del_timer_sync(&priv->tx_queue[chan].txtimer);
 
+	if (priv->eee_enabled) {
+		priv->tx_path_in_lpi_mode = false;
+		del_timer_sync(&priv->eee_ctrl_timer);
+	}
+
 	/* Stop TX/RX DMA */
 	stmmac_stop_all_dma(priv);
 


