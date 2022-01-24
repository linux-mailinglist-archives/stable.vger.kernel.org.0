Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8562C499E37
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355706AbiAXWay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585997AbiAXWZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:25:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF36C08C5D8;
        Mon, 24 Jan 2022 12:54:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49ACD611C2;
        Mon, 24 Jan 2022 20:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2C5C340E5;
        Mon, 24 Jan 2022 20:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057653;
        bh=pOMuClDdtMKtaAUzzkfbJsxX0oBaFCtga5RqV+vM42Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdB7B/TPgQQDKVc1Fb521n139HvNNlilCJFfCPbB8jLRK3drjTdmJJC0JqH755z3O
         wUIEjWfO5ATOiIOJiOK19agwCNo8MVX+XeQJHY96Hxd6DxHyyg0vVavRnlLpp1ECG6
         b/UfAHzl/UyBcpkiv4rishA9vWgx39CcheKnZi4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 0035/1039] net: phy: marvell: add Marvell specific PHY loopback
Date:   Mon, 24 Jan 2022 19:30:24 +0100
Message-Id: <20220124184126.314205688@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

commit 020a45aff1190c32b1087cd75b57fbf6bff46ea6 upstream.

Existing genphy_loopback() is not applicable for Marvell PHY. Besides
configuring bit-6 and bit-13 in Page 0 Register 0 (Copper Control
Register), it is also required to configure same bits  in Page 2
Register 21 (MAC Specific Control Register 2) according to speed of
the loopback is operating.

Tested working on Marvell88E1510 PHY for all speeds (1000/100/10Mbps).

FIXME: Based on trial and error test, it seem 1G need to have delay between
soft reset and loopback enablement.

Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configuration")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/marvell.c |   56 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -189,6 +189,8 @@
 #define MII_88E1510_GEN_CTRL_REG_1_MODE_RGMII_SGMII	0x4
 #define MII_88E1510_GEN_CTRL_REG_1_RESET	0x8000	/* Soft reset */
 
+#define MII_88E1510_MSCR_2		0x15
+
 #define MII_VCT5_TX_RX_MDI0_COUPLING	0x10
 #define MII_VCT5_TX_RX_MDI1_COUPLING	0x11
 #define MII_VCT5_TX_RX_MDI2_COUPLING	0x12
@@ -1932,6 +1934,58 @@ static void marvell_get_stats(struct phy
 		data[i] = marvell_get_stat(phydev, i);
 }
 
+static int m88e1510_loopback(struct phy_device *phydev, bool enable)
+{
+	int err;
+
+	if (enable) {
+		u16 bmcr_ctl = 0, mscr2_ctl = 0;
+
+		if (phydev->speed == SPEED_1000)
+			bmcr_ctl = BMCR_SPEED1000;
+		else if (phydev->speed == SPEED_100)
+			bmcr_ctl = BMCR_SPEED100;
+
+		if (phydev->duplex == DUPLEX_FULL)
+			bmcr_ctl |= BMCR_FULLDPLX;
+
+		err = phy_write(phydev, MII_BMCR, bmcr_ctl);
+		if (err < 0)
+			return err;
+
+		if (phydev->speed == SPEED_1000)
+			mscr2_ctl = BMCR_SPEED1000;
+		else if (phydev->speed == SPEED_100)
+			mscr2_ctl = BMCR_SPEED100;
+
+		err = phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
+				       MII_88E1510_MSCR_2, BMCR_SPEED1000 |
+				       BMCR_SPEED100, mscr2_ctl);
+		if (err < 0)
+			return err;
+
+		/* Need soft reset to have speed configuration takes effect */
+		err = genphy_soft_reset(phydev);
+		if (err < 0)
+			return err;
+
+		/* FIXME: Based on trial and error test, it seem 1G need to have
+		 * delay between soft reset and loopback enablement.
+		 */
+		if (phydev->speed == SPEED_1000)
+			msleep(1000);
+
+		return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
+				  BMCR_LOOPBACK);
+	} else {
+		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
+		if (err < 0)
+			return err;
+
+		return phy_config_aneg(phydev);
+	}
+}
+
 static int marvell_vct5_wait_complete(struct phy_device *phydev)
 {
 	int i;
@@ -3078,7 +3132,7 @@ static struct phy_driver marvell_drivers
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
-		.set_loopback = genphy_loopback,
+		.set_loopback = m88e1510_loopback,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
 		.cable_test_start = marvell_vct7_cable_test_start,


