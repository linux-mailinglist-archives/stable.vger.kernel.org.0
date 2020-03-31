Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042EE198F6D
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbgCaJDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730180AbgCaJDR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:03:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ACC5208E0;
        Tue, 31 Mar 2020 09:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645396;
        bh=oaAtHJtM84W+1ON8Z6ZB0S+/6Uf0penKkZJl/ZES+/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKhBDFU53gz0bqGHRvaIO3Bu44ZG8Ct10n2Q3acSPNy6LwoSWwuKLX4voOvkTLK9E
         RAn8psVRNShRRWAG1Eku08h7IPFlp3nnGRhraDcvu2ZvsNjnRYRcX3ot2YOzZJQcRr
         UEsuELFDPJq7Ywj3HOjQiCPZML/bYgJv2qbBmRHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 041/170] net: bcmgenet: keep MAC in reset until PHY is up
Date:   Tue, 31 Mar 2020 10:57:35 +0200
Message-Id: <20200331085428.748528317@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 88f6c8bf1aaed5039923fb4c701cab4d42176275 ]

As noted in commit 28c2d1a7a0bf ("net: bcmgenet: enable loopback
during UniMAC sw_reset") the UniMAC must be clocked at least 5
cycles while the sw_reset is asserted to ensure a clean reset.

That commit enabled local loopback to provide an Rx clock from the
GENET sourced Tx clk. However, when connected in MII mode the Tx
clk is sourced by the PHY so if an EPHY is not supplying clocks
(e.g. when the link is down) the UniMAC does not receive the
necessary clocks.

This commit extends the sw_reset window until the PHY reports that
the link is up thereby ensuring that the clocks are being provided
to the MAC to produce a clean reset.

One consequence is that if the system attempts to enter a Wake on
LAN suspend state when the PHY link has not been active the MAC
may not have had a chance to initialize cleanly. In this case, we
remove the sw_reset and enable the WoL reception path as normal
with the hope that the PHY will provide the necessary clocks to
drive the WoL blocks if the link becomes active after the system
has entered suspend.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   10 ++++------
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |    6 +++++-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |    6 ++++++
 3 files changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1972,6 +1972,8 @@ static void umac_enable_set(struct bcmge
 	u32 reg;
 
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	if (reg & CMD_SW_RESET)
+		return;
 	if (enable)
 		reg |= mask;
 	else
@@ -1991,13 +1993,9 @@ static void reset_umac(struct bcmgenet_p
 	bcmgenet_rbuf_ctrl_set(priv, 0);
 	udelay(10);
 
-	/* disable MAC while updating its registers */
-	bcmgenet_umac_writel(priv, 0, UMAC_CMD);
-
-	/* issue soft reset with (rg)mii loopback to ensure a stable rxclk */
-	bcmgenet_umac_writel(priv, CMD_SW_RESET | CMD_LCL_LOOP_EN, UMAC_CMD);
+	/* issue soft reset and disable MAC while updating its registers */
+	bcmgenet_umac_writel(priv, CMD_SW_RESET, UMAC_CMD);
 	udelay(2);
-	bcmgenet_umac_writel(priv, 0, UMAC_CMD);
 }
 
 static void bcmgenet_intr_disable(struct bcmgenet_priv *priv)
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -132,8 +132,12 @@ int bcmgenet_wol_power_down_cfg(struct b
 		return -EINVAL;
 	}
 
-	/* disable RX */
+	/* Can't suspend with WoL if MAC is still in reset */
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	if (reg & CMD_SW_RESET)
+		reg &= ~CMD_SW_RESET;
+
+	/* disable RX */
 	reg &= ~CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 	mdelay(10);
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -95,6 +95,12 @@ void bcmgenet_mii_setup(struct net_devic
 			       CMD_HD_EN |
 			       CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE);
 		reg |= cmd_bits;
+		if (reg & CMD_SW_RESET) {
+			reg &= ~CMD_SW_RESET;
+			bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+			udelay(2);
+			reg |= CMD_TX_EN | CMD_RX_EN;
+		}
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 	} else {
 		/* done if nothing has changed */


