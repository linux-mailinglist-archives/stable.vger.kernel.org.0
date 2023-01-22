Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C36676F62
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjAVPUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjAVPUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:20:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B736222F3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:20:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB3C660C60
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036EDC433EF;
        Sun, 22 Jan 2023 15:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400849;
        bh=I6wpNC3xtH3hq0r0FdDpCBleKYRWWMJrb/9l3pluQI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZfsejxqVJ0PNGwIXE18SZ9nys9KAWA7sGL+v/CAjQdk3VRZ7nLwC2ObCIwlyMclm
         kS5BPnmO+TmvVPM/qIIUXoIDp6JJc/Gj4HevAP4sVJz/tRGiU3Oc1jIWFCRm7uwFeP
         d3JStuIvLgvbkH6BhfCBLBgeEObMwY/VkTcS9RXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chunhao Lin <hau@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/193] r8169: move rtl_wol_enable_rx() and rtl_prepare_power_down()
Date:   Sun, 22 Jan 2023 16:02:24 +0100
Message-Id: <20230122150247.053024269@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunhao Lin <hau@realtek.com>

[ Upstream commit ad425666a1f05d9b215a84cf010c3789b2ea8206 ]

There is no functional change. Moving these two functions for following
patch "r8169: fix dmar pte write access is not set error".

Signed-off-by: Chunhao Lin <hau@realtek.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 44 +++++++++++------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index fe8dc8e0522b..316c925c956f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2207,28 +2207,6 @@ static int rtl_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
-static void rtl_wol_enable_rx(struct rtl8169_private *tp)
-{
-	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
-		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
-			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
-}
-
-static void rtl_prepare_power_down(struct rtl8169_private *tp)
-{
-	if (tp->dash_type != RTL_DASH_NONE)
-		return;
-
-	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_33)
-		rtl_ephy_write(tp, 0x19, 0xff64);
-
-	if (device_may_wakeup(tp_to_dev(tp))) {
-		phy_speed_down(tp->phydev, false);
-		rtl_wol_enable_rx(tp);
-	}
-}
-
 static void rtl_init_rxcfg(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
@@ -2452,6 +2430,28 @@ static void rtl_enable_rxdvgate(struct rtl8169_private *tp)
 	rtl_wait_txrx_fifo_empty(tp);
 }
 
+static void rtl_wol_enable_rx(struct rtl8169_private *tp)
+{
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
+		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
+			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
+}
+
+static void rtl_prepare_power_down(struct rtl8169_private *tp)
+{
+	if (tp->dash_type != RTL_DASH_NONE)
+		return;
+
+	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_33)
+		rtl_ephy_write(tp, 0x19, 0xff64);
+
+	if (device_may_wakeup(tp_to_dev(tp))) {
+		phy_speed_down(tp->phydev, false);
+		rtl_wol_enable_rx(tp);
+	}
+}
+
 static void rtl_set_tx_config_registers(struct rtl8169_private *tp)
 {
 	u32 val = TX_DMA_BURST << TxDMAShift |
-- 
2.35.1



