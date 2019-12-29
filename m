Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C93F12C845
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732369AbfL2RxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:53:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732380AbfL2RxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:53:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A948206DB;
        Sun, 29 Dec 2019 17:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641981;
        bh=ZOnJdoB1lGT+VFynHu3iVeto4APmlgvn7l+a46QwGVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbjfm8jkL21wV1LKDsbR9tMVg54u4jKrCrvL+bjdIdwQRwG5LheDIQcLPL8ZqJA2W
         nBWnyKxx00iNzCmKaGW3NuvkPNvYvC/69oe04k2gEespyL63O8S3tSiir2gSbx6BPU
         GaZ50SV0+pak7BVYsrxAvORJ3OBjEY6Kx2zM7M3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 293/434] r8169: respect EEE user setting when restarting network
Date:   Sun, 29 Dec 2019 18:25:46 +0100
Message-Id: <20191229172721.411108848@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 7ec3f872bc85ada93db34448d73bb399d6b82c2c ]

Currently, if network is re-started, we advertise all supported EEE
modes, thus potentially overriding a manual adjustment the user made
e.g. via ethtool. Be friendly to the user and preserve a manual
setting on network re-start.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4fe0977d01fa..5ae0b5663d54 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -680,6 +680,7 @@ struct rtl8169_private {
 	struct rtl8169_counters *counters;
 	struct rtl8169_tc_offsets tc_offset;
 	u32 saved_wolopts;
+	int eee_adv;
 
 	const char *fw_name;
 	struct rtl_fw *rtl_fw;
@@ -2075,6 +2076,10 @@ static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
 	}
 
 	ret = phy_ethtool_set_eee(tp->phydev, data);
+
+	if (!ret)
+		tp->eee_adv = phy_read_mmd(dev->phydev, MDIO_MMD_AN,
+					   MDIO_AN_EEE_ADV);
 out:
 	pm_runtime_put_noidle(d);
 	return ret;
@@ -2105,10 +2110,16 @@ static const struct ethtool_ops rtl8169_ethtool_ops = {
 static void rtl_enable_eee(struct rtl8169_private *tp)
 {
 	struct phy_device *phydev = tp->phydev;
-	int supported = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
+	int adv;
+
+	/* respect EEE advertisement the user may have set */
+	if (tp->eee_adv >= 0)
+		adv = tp->eee_adv;
+	else
+		adv = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
 
-	if (supported > 0)
-		phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, supported);
+	if (adv >= 0)
+		phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, adv);
 }
 
 static void rtl8169_get_mac_version(struct rtl8169_private *tp)
@@ -7064,6 +7075,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->pci_dev = pdev;
 	tp->msg_enable = netif_msg_init(debug.msg_enable, R8169_MSG_DEFAULT);
 	tp->supports_gmii = ent->driver_data == RTL_CFG_NO_GBIT ? 0 : 1;
+	tp->eee_adv = -1;
 
 	/* Get the *optional* external "ether_clk" used on some boards */
 	rc = rtl_get_ether_clk(tp);
-- 
2.20.1



