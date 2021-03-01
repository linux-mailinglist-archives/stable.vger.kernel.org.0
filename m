Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDFD328DFE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240456AbhCATWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:22:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241326AbhCATRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:17:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4456665308;
        Mon,  1 Mar 2021 17:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620524;
        bh=HcKQ6sigd6xlm8JyehdJlzLAtOZfX3tnxebHSF/tCLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/61l9tLc+OTcfNyOU4L1rdQezQh/GqJqdioy32Esb4p2ovyuJXtrbnXjUW4WKmkk
         MAh23ezk3wB6zEgpaXSunhKMJUFjQXkGvfQUySS1vZcWdGC4Uk/2sTSPmUhqffENyw
         Aj3YkeimfYVkGzC8EcaFotWAJ9t4pAuk0sJ/8yBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 167/775] net: phy: mscc: coma mode disabled for VSC8514
Date:   Mon,  1 Mar 2021 17:05:35 +0100
Message-Id: <20210301161209.894813968@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjarni Jonasson <bjarni.jonasson@microchip.com>

[ Upstream commit ca0d7fd0a58dfc9503775dae7daee341c115e0c7 ]

The 'coma mode' (configurable through sw or hw) provides an
optional feature that may be used to control when the PHYs become active.
The typical usage is to synchronize the link-up time across
all PHY instances. This patch releases coma mode if not done by hardware,
otherwise the phys will not link-up.

Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc.h      |  4 ++++
 drivers/net/phy/mscc/mscc_main.c | 16 ++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 2028c319f14dd..a50235fdf7d99 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -140,6 +140,10 @@ enum rgmii_clock_delay {
 #define MSCC_PHY_PAGE_1588		  0x1588 /* PTP (1588) */
 #define MSCC_PHY_PAGE_TEST		  0x2a30 /* Test reg */
 #define MSCC_PHY_PAGE_TR		  0x52b5 /* Token ring registers */
+#define MSCC_PHY_GPIO_CONTROL_2           14
+
+#define MSCC_PHY_COMA_MODE		  0x2000 /* input(1) / output(0) */
+#define MSCC_PHY_COMA_OUTPUT		  0x1000 /* value to output */
 
 /* Extended Page 1 Registers */
 #define MSCC_PHY_CU_MEDIA_CRC_VALID_CNT	  18
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 0e6e7076a740e..3a7705228ed59 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1516,6 +1516,21 @@ static void vsc8584_get_base_addr(struct phy_device *phydev)
 	vsc8531->addr = addr;
 }
 
+static void vsc85xx_coma_mode_release(struct phy_device *phydev)
+{
+	/* The coma mode (pin or reg) provides an optional feature that
+	 * may be used to control when the PHYs become active.
+	 * Alternatively the COMA_MODE pin may be connected low
+	 * so that the PHYs are fully active once out of reset.
+	 */
+
+	/* Enable output (mode=0) and write zero to it */
+	vsc85xx_phy_write_page(phydev, MSCC_PHY_PAGE_EXTENDED_GPIO);
+	__phy_modify(phydev, MSCC_PHY_GPIO_CONTROL_2,
+		     MSCC_PHY_COMA_MODE | MSCC_PHY_COMA_OUTPUT, 0);
+	vsc85xx_phy_write_page(phydev, MSCC_PHY_PAGE_STANDARD);
+}
+
 static int vsc8584_config_init(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
@@ -1962,6 +1977,7 @@ static int vsc8514_config_init(struct phy_device *phydev)
 		ret = vsc8514_config_host_serdes(phydev);
 		if (ret)
 			goto err;
+		vsc85xx_coma_mode_release(phydev);
 	}
 
 	phy_unlock_mdio_bus(phydev);
-- 
2.27.0



