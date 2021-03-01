Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32977328840
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbhCARgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:36:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237975AbhCAR3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:29:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47CB365094;
        Mon,  1 Mar 2021 16:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617492;
        bh=DrQP4ayme/HbwjzpSjV4yqlWxErtT3xv6YJLVeDwdxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oxa+RMNvekTMpybV7tlCsDfZCsTJZkOsucXgtDtUS07njZDnS7pPQXOY9lz8thLA1
         XCLkpd9iPtR9/p4QpspGmm0o5N5Ayj5hgSiP6dmORGznMFulIJpHA0X3gmYEa7zIFY
         FtQkd3kUmg/b+1EZ6mEWAbinNs+KCZTEpGBoV9BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudheesh Mavila <sudheesh.mavila@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/340] net: amd-xgbe: Reset the PHY rx data path when mailbox command timeout
Date:   Mon,  1 Mar 2021 17:10:09 +0100
Message-Id: <20210301161051.519693816@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 30b7edc82ec82578f4f5e6706766f0a9535617d3 ]

Sometimes mailbox commands timeout when the RX data path becomes
unresponsive. This prevents the submission of new mailbox commands to DXIO.
This patch identifies the timeout and resets the RX data path so that the
next message can be submitted properly.

Fixes: 549b32af9f7c ("amd-xgbe: Simplify mailbox interface rate change code")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-common.h | 14 +++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 28 ++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index b40d4377cc71d..b2cd3bdba9f89 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
@@ -1279,10 +1279,18 @@
 #define MDIO_PMA_10GBR_FECCTRL		0x00ab
 #endif
 
+#ifndef MDIO_PMA_RX_CTRL1
+#define MDIO_PMA_RX_CTRL1		0x8051
+#endif
+
 #ifndef MDIO_PCS_DIG_CTRL
 #define MDIO_PCS_DIG_CTRL		0x8000
 #endif
 
+#ifndef MDIO_PCS_DIGITAL_STAT
+#define MDIO_PCS_DIGITAL_STAT		0x8010
+#endif
+
 #ifndef MDIO_AN_XNP
 #define MDIO_AN_XNP			0x0016
 #endif
@@ -1358,6 +1366,8 @@
 #define XGBE_KR_TRAINING_ENABLE		BIT(1)
 
 #define XGBE_PCS_CL37_BP		BIT(12)
+#define XGBE_PCS_PSEQ_STATE_MASK	0x1c
+#define XGBE_PCS_PSEQ_STATE_POWER_GOOD	0x10
 
 #define XGBE_AN_CL37_INT_CMPLT		BIT(0)
 #define XGBE_AN_CL37_INT_MASK		0x01
@@ -1375,6 +1385,10 @@
 #define XGBE_PMA_CDR_TRACK_EN_OFF	0x00
 #define XGBE_PMA_CDR_TRACK_EN_ON	0x01
 
+#define XGBE_PMA_RX_RST_0_MASK		BIT(4)
+#define XGBE_PMA_RX_RST_0_RESET_ON	0x10
+#define XGBE_PMA_RX_RST_0_RESET_OFF	0x00
+
 /* Bit setting and getting macros
  *  The get macro will extract the current bit field value from within
  *  the variable
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 128cd648ba99c..f024db6d90158 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1948,6 +1948,27 @@ static void xgbe_phy_set_redrv_mode(struct xgbe_prv_data *pdata)
 	xgbe_phy_put_comm_ownership(pdata);
 }
 
+static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
+{
+	int reg;
+
+	reg = XMDIO_READ_BITS(pdata, MDIO_MMD_PCS, MDIO_PCS_DIGITAL_STAT,
+			      XGBE_PCS_PSEQ_STATE_MASK);
+	if (reg == XGBE_PCS_PSEQ_STATE_POWER_GOOD) {
+		/* Mailbox command timed out, reset of RX block is required.
+		 * This can be done by asseting the reset bit and wait for
+		 * its compeletion.
+		 */
+		XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_RX_CTRL1,
+				 XGBE_PMA_RX_RST_0_MASK, XGBE_PMA_RX_RST_0_RESET_ON);
+		ndelay(20);
+		XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_RX_CTRL1,
+				 XGBE_PMA_RX_RST_0_MASK, XGBE_PMA_RX_RST_0_RESET_OFF);
+		usleep_range(40, 50);
+		netif_err(pdata, link, pdata->netdev, "firmware mailbox reset performed\n");
+	}
+}
+
 static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 					unsigned int cmd, unsigned int sub_cmd)
 {
@@ -1955,9 +1976,11 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 	unsigned int wait;
 
 	/* Log if a previous command did not complete */
-	if (XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS))
+	if (XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS)) {
 		netif_dbg(pdata, link, pdata->netdev,
 			  "firmware mailbox not ready for command\n");
+		xgbe_phy_rx_reset(pdata);
+	}
 
 	/* Construct the command */
 	XP_SET_BITS(s0, XP_DRIVER_SCRATCH_0, COMMAND, cmd);
@@ -1979,6 +2002,9 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 
 	netif_dbg(pdata, link, pdata->netdev,
 		  "firmware mailbox command did not complete\n");
+
+	/* Reset on error */
+	xgbe_phy_rx_reset(pdata);
 }
 
 static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
-- 
2.27.0



