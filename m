Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BAF29C523
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1824234AbgJ0SEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901066AbgJ0OSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:18:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28C84206D4;
        Tue, 27 Oct 2020 14:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808299;
        bh=XjCeFuVIs7iMdOD4dixjzJsDhNXcVicMYLW7Q+67zsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7AmjhDaXJJidNK0udbjpeehltypq/11OyQVG4wIKwTzcYx+pEEgcV201dR4dujLg
         BM1M1JBWTWnfrq8bcMMxA5j9X5H2UZCVoGqhPeeB7cJtnM1Fxt0qm0lbbtavCGArjT
         A89fEgILxi7tdMuGZ0HYJW4vT2+LYSu0tz+73bmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Tesarik <ptesarik@suse.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 4.19 012/264] r8169: fix data corruption issue on RTL8402
Date:   Tue, 27 Oct 2020 14:51:10 +0100
Message-Id: <20201027135431.236677193@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit ef9da46ddef071e1bbb943afbbe9b38771855554 ]

Petr reported that after resume from suspend RTL8402 partially
truncates incoming packets, and re-initializing register RxConfig
before the actual chip re-initialization sequence is needed to avoid
the issue.

Reported-by: Petr Tesarik <ptesarik@suse.cz>
Proposed-by: Petr Tesarik <ptesarik@suse.cz>
Tested-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |   46 +++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 21 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4111,6 +4111,27 @@ static void rtl_rar_set(struct rtl8169_p
 	rtl_unlock_work(tp);
 }
 
+static void rtl_init_rxcfg(struct rtl8169_private *tp)
+{
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_01 ... RTL_GIGA_MAC_VER_06:
+	case RTL_GIGA_MAC_VER_10 ... RTL_GIGA_MAC_VER_17:
+		RTL_W32(tp, RxConfig, RX_FIFO_THRESH | RX_DMA_BURST);
+		break;
+	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_24:
+	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_36:
+	case RTL_GIGA_MAC_VER_38:
+		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
+		break;
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
+		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
+		break;
+	default:
+		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
+		break;
+	}
+}
+
 static int rtl_set_mac_address(struct net_device *dev, void *p)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
@@ -4128,6 +4149,10 @@ static int rtl_set_mac_address(struct ne
 
 	pm_runtime_put_noidle(d);
 
+	/* Reportedly at least Asus X453MA truncates packets otherwise */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
+		rtl_init_rxcfg(tp);
+
 	return 0;
 }
 
@@ -4289,27 +4314,6 @@ static void rtl_pll_power_up(struct rtl8
 	}
 }
 
-static void rtl_init_rxcfg(struct rtl8169_private *tp)
-{
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_01 ... RTL_GIGA_MAC_VER_06:
-	case RTL_GIGA_MAC_VER_10 ... RTL_GIGA_MAC_VER_17:
-		RTL_W32(tp, RxConfig, RX_FIFO_THRESH | RX_DMA_BURST);
-		break;
-	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_24:
-	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_36:
-	case RTL_GIGA_MAC_VER_38:
-		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
-		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
-		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
-		break;
-	default:
-		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
-		break;
-	}
-}
-
 static void rtl8169_init_ring_indexes(struct rtl8169_private *tp)
 {
 	tp->dirty_tx = tp->cur_tx = tp->cur_rx = 0;


