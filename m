Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EC7450BF9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhKORcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:32:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237888AbhKORan (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:30:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 876C0632A6;
        Mon, 15 Nov 2021 17:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996829;
        bh=JzZbuh0/yBajRrgHi591iU4sASsev/E7iUpeVlTiWew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuQex/uiyNAyH0sUUzmEU04M0bhusRPXEY4cof4ae3xMhg0x3uO0dfGTnKv2W4Eo0
         7AA7cSZj79onJb2TPh1xqZQsouHfjvXGD+Jh3w7eUfyenDecPSJY1NlIg6yQG7PEg8
         YztTAxm2hmGT1aSQeorFkaE0Rnu4BZQ1AzOHFUbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudheesh Mavila <sudheesh.mavila@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 249/355] net: amd-xgbe: Toggle PLL settings during rate change
Date:   Mon, 15 Nov 2021 18:02:53 +0100
Message-Id: <20211115165321.788147726@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit daf182d360e509a494db18666799f4e85d83dda0 ]

For each rate change command submission, the FW has to do a phy
power off sequence internally. For this to happen correctly, the
PLL re-initialization control setting has to be turned off before
sending mailbox commands and re-enabled once the command submission
is complete.

Without the PLL control setting, the link up takes longer time in a
fixed phy configuration.

Fixes: 47f164deab22 ("amd-xgbe: Add PCI device support")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-common.h |  8 ++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 20 +++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index b2cd3bdba9f89..533b8519ec352 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
@@ -1331,6 +1331,10 @@
 #define MDIO_VEND2_PMA_CDR_CONTROL	0x8056
 #endif
 
+#ifndef MDIO_VEND2_PMA_MISC_CTRL0
+#define MDIO_VEND2_PMA_MISC_CTRL0	0x8090
+#endif
+
 #ifndef MDIO_CTRL1_SPEED1G
 #define MDIO_CTRL1_SPEED1G		(MDIO_CTRL1_SPEED10G & ~BMCR_SPEED100)
 #endif
@@ -1389,6 +1393,10 @@
 #define XGBE_PMA_RX_RST_0_RESET_ON	0x10
 #define XGBE_PMA_RX_RST_0_RESET_OFF	0x00
 
+#define XGBE_PMA_PLL_CTRL_MASK		BIT(15)
+#define XGBE_PMA_PLL_CTRL_ENABLE	BIT(15)
+#define XGBE_PMA_PLL_CTRL_DISABLE	0x0000
+
 /* Bit setting and getting macros
  *  The get macro will extract the current bit field value from within
  *  the variable
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index d6f6afb67bcc6..0b325ae875b52 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1972,12 +1972,26 @@ static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
 	}
 }
 
+static void xgbe_phy_pll_ctrl(struct xgbe_prv_data *pdata, bool enable)
+{
+	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
+			 XGBE_PMA_PLL_CTRL_MASK,
+			 enable ? XGBE_PMA_PLL_CTRL_ENABLE
+				: XGBE_PMA_PLL_CTRL_DISABLE);
+
+	/* Wait for command to complete */
+	usleep_range(100, 200);
+}
+
 static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 					unsigned int cmd, unsigned int sub_cmd)
 {
 	unsigned int s0 = 0;
 	unsigned int wait;
 
+	/* Disable PLL re-initialization during FW command processing */
+	xgbe_phy_pll_ctrl(pdata, false);
+
 	/* Log if a previous command did not complete */
 	if (XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS)) {
 		netif_dbg(pdata, link, pdata->netdev,
@@ -1998,7 +2012,7 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 	wait = XGBE_RATECHANGE_COUNT;
 	while (wait--) {
 		if (!XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS))
-			return;
+			goto reenable_pll;
 
 		usleep_range(1000, 2000);
 	}
@@ -2008,6 +2022,10 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 
 	/* Reset on error */
 	xgbe_phy_rx_reset(pdata);
+
+reenable_pll:
+	/* Enable PLL re-initialization */
+	xgbe_phy_pll_ctrl(pdata, true);
 }
 
 static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
-- 
2.33.0



