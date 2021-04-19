Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B32336447A
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242068AbhDSN2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242080AbhDSN0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:26:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2110960233;
        Mon, 19 Apr 2021 13:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838494;
        bh=reYunfgr1fduJ6XCrG1g5WQGLA5Q9lQxV1xC6aQvpio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRR5vIWBX7Uj0So9nB/+KNFYb3XpHXoIkZx+Hr6191mBDL6QbVuUl0/oDEIr4Ft2e
         4ZG3D0YJuwbEUPlUImOtQpA3IkCGJrB7WIob/qqmvEsrsQOPdPN2XjCcKeXdYx9IBn
         1uQZUnlyyNRq/UzQiqQhgD5O26q7MQkhIfKF/hZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 69/73] r8169: improve rtl_jumbo_config
Date:   Mon, 19 Apr 2021 15:07:00 +0200
Message-Id: <20210419130526.068041797@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 9db0ac57bd3286fedcf43a86b29b847cea281cc7 ]

Merge enabling and disabling jumbo packets to one function to make
the code a little simpler.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 69 +++++++++--------------
 1 file changed, 27 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 19ebde91555d..1352dd0b69e9 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4093,66 +4093,52 @@ static void r8168b_1_hw_jumbo_disable(struct rtl8169_private *tp)
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~(1 << 0));
 }
 
-static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
+static void rtl_jumbo_config(struct rtl8169_private *tp)
 {
-	rtl_unlock_config_regs(tp);
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_12:
-	case RTL_GIGA_MAC_VER_17:
-		pcie_set_readrq(tp->pci_dev, 512);
-		r8168b_1_hw_jumbo_enable(tp);
-		break;
-	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_26:
-		pcie_set_readrq(tp->pci_dev, 512);
-		r8168c_hw_jumbo_enable(tp);
-		break;
-	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
-		r8168dp_hw_jumbo_enable(tp);
-		break;
-	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
-		pcie_set_readrq(tp->pci_dev, 512);
-		r8168e_hw_jumbo_enable(tp);
-		break;
-	default:
-		break;
-	}
-	rtl_lock_config_regs(tp);
-}
+	bool jumbo = tp->dev->mtu > ETH_DATA_LEN;
 
-static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
-{
 	rtl_unlock_config_regs(tp);
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
-		r8168b_1_hw_jumbo_disable(tp);
+		if (jumbo) {
+			pcie_set_readrq(tp->pci_dev, 512);
+			r8168b_1_hw_jumbo_enable(tp);
+		} else {
+			r8168b_1_hw_jumbo_disable(tp);
+		}
 		break;
 	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_26:
-		r8168c_hw_jumbo_disable(tp);
+		if (jumbo) {
+			pcie_set_readrq(tp->pci_dev, 512);
+			r8168c_hw_jumbo_enable(tp);
+		} else {
+			r8168c_hw_jumbo_disable(tp);
+		}
 		break;
 	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
-		r8168dp_hw_jumbo_disable(tp);
+		if (jumbo)
+			r8168dp_hw_jumbo_enable(tp);
+		else
+			r8168dp_hw_jumbo_disable(tp);
 		break;
 	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
-		r8168e_hw_jumbo_disable(tp);
+		if (jumbo) {
+			pcie_set_readrq(tp->pci_dev, 512);
+			r8168e_hw_jumbo_enable(tp);
+		} else {
+			r8168e_hw_jumbo_disable(tp);
+		}
 		break;
 	default:
 		break;
 	}
 	rtl_lock_config_regs(tp);
 
-	if (pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
+	if (!jumbo && pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
 		pcie_set_readrq(tp->pci_dev, 4096);
 }
 
-static void rtl_jumbo_config(struct rtl8169_private *tp, int mtu)
-{
-	if (mtu > ETH_DATA_LEN)
-		rtl_hw_jumbo_enable(tp);
-	else
-		rtl_hw_jumbo_disable(tp);
-}
-
 DECLARE_RTL_COND(rtl_chipcmd_cond)
 {
 	return RTL_R8(tp, ChipCmd) & CmdReset;
@@ -5458,7 +5444,7 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 	rtl_set_rx_tx_desc_registers(tp);
 	rtl_lock_config_regs(tp);
 
-	rtl_jumbo_config(tp, tp->dev->mtu);
+	rtl_jumbo_config(tp);
 
 	/* Initially a 10 us delay. Turned it into a PCI commit. - FR */
 	RTL_R16(tp, CPlusCmd);
@@ -5473,10 +5459,9 @@ static int rtl8169_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-	rtl_jumbo_config(tp, new_mtu);
-
 	dev->mtu = new_mtu;
 	netdev_update_features(dev);
+	rtl_jumbo_config(tp);
 
 	/* Reportedly at least Asus X453MA truncates packets otherwise */
 	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
-- 
2.30.2



