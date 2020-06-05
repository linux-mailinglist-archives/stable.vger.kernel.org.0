Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4F51EFA9D
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgFEOTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbgFEOTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:19:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92EC6208A7;
        Fri,  5 Jun 2020 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366758;
        bh=wa6/VyqRftc183tLN+IpPw5dqH9ERY51scjelX0jqUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jh3A+P9Ro89p8TgC6p4e5uDULAYh5g+AlqMxX4tJaST91Vw0NVlN/MuyaYATA9MV4
         P4yp/2nWVreOWW9yqsWUyu8+W9riJ+3vXbE8JT5j4Nx7t2QTG9tP5Hkm63D3cLCtLe
         FXg705r6HIQDOooTqYj8z48FVdE9/rnRdJapo8as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/38] net: ethernet: stmmac: Enable interface clocks on probe for IPQ806x
Date:   Fri,  5 Jun 2020 16:15:19 +0200
Message-Id: <20200605140254.981119618@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
References: <20200605140252.542768750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>

[ Upstream commit a96ac8a0045e3cbe3e5af6d1b3c78c6c2065dec5 ]

The ipq806x_gmac_probe() function enables the PTP clock but not the
appropriate interface clocks. This means that if the bootloader hasn't
done so attempting to bring up the interface will fail with an error
like:

[   59.028131] ipq806x-gmac-dwmac 37600000.ethernet: Failed to reset the dma
[   59.028196] ipq806x-gmac-dwmac 37600000.ethernet eth1: stmmac_hw_setup: DMA engine initialization failed
[   59.034056] ipq806x-gmac-dwmac 37600000.ethernet eth1: stmmac_open: Hw setup failed

This patch, a slightly cleaned up version of one posted by Sergey
Sergeev in:

https://forum.openwrt.org/t/support-for-mikrotik-rb3011uias-rm/4064/257

correctly enables the clock; we have already configured the source just
before this.

Tested on a MikroTik RB3011.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index 0d21082ceb93..4d75158c64b2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -318,6 +318,19 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 	/* Enable PTP clock */
 	regmap_read(gmac->nss_common, NSS_COMMON_CLK_GATE, &val);
 	val |= NSS_COMMON_CLK_GATE_PTP_EN(gmac->id);
+	switch (gmac->phy_mode) {
+	case PHY_INTERFACE_MODE_RGMII:
+		val |= NSS_COMMON_CLK_GATE_RGMII_RX_EN(gmac->id) |
+			NSS_COMMON_CLK_GATE_RGMII_TX_EN(gmac->id);
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+		val |= NSS_COMMON_CLK_GATE_GMII_RX_EN(gmac->id) |
+				NSS_COMMON_CLK_GATE_GMII_TX_EN(gmac->id);
+		break;
+	default:
+		/* We don't get here; the switch above will have errored out */
+		unreachable();
+	}
 	regmap_write(gmac->nss_common, NSS_COMMON_CLK_GATE, val);
 
 	if (gmac->phy_mode == PHY_INTERFACE_MODE_SGMII) {
-- 
2.25.1



