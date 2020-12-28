Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5822E678F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgL1NIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:08:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730926AbgL1NIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:08:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19C6D22582;
        Mon, 28 Dec 2020 13:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160863;
        bh=xjtL+iv3DcMyV6dkej0drfYg8VG96FI18LRjD0Omnlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GADUdhdxwhaR9uRhzJjpkNoQDA/qo1t9sJA6oEff4oxevrNSfbTgS4/fOedczgb/G
         z9xtItyWcKBreFq+PIGd4/TFGnTdTPfPbsc4nRfcf6cET57QHTyxy2f4lsL11txQWQ
         jBiUJS7by3Q9DWbI/kKe6H0VjNywN7+IzI6mwUgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 021/242] net: stmmac: delete the eee_ctrl_timer after napi disabled
Date:   Mon, 28 Dec 2020 13:47:06 +0100
Message-Id: <20201228124905.714771477@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
@@ -2705,9 +2705,6 @@ static int stmmac_release(struct net_dev
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	if (priv->eee_enabled)
-		del_timer_sync(&priv->eee_ctrl_timer);
-
 	/* Stop and disconnect the PHY */
 	if (dev->phydev) {
 		phy_stop(dev->phydev);
@@ -2727,6 +2724,11 @@ static int stmmac_release(struct net_dev
 	if (priv->lpi_irq > 0)
 		free_irq(priv->lpi_irq, dev);
 
+	if (priv->eee_enabled) {
+		priv->tx_path_in_lpi_mode = false;
+		del_timer_sync(&priv->eee_ctrl_timer);
+	}
+
 	/* Stop TX/RX DMA and clear the descriptors */
 	stmmac_stop_all_dma(priv);
 
@@ -4418,6 +4420,11 @@ int stmmac_suspend(struct device *dev)
 
 	stmmac_disable_all_queues(priv);
 
+	if (priv->eee_enabled) {
+		priv->tx_path_in_lpi_mode = false;
+		del_timer_sync(&priv->eee_ctrl_timer);
+	}
+
 	/* Stop TX/RX DMA */
 	stmmac_stop_all_dma(priv);
 


