Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5429AE2C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752914AbgJ0N5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752902AbgJ0N5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:57:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58CFC2072D;
        Tue, 27 Oct 2020 13:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807055;
        bh=5WOmYSinOU/SAFvVq9zhYWqybNx2U3YRLq2Znu1rzRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBgxpMi8zjkRW1uuaj37RkqHtBVIY6NL1f/wwOIcGQZNmwP9Ah5AWx0xsgksFnd7D
         Z8PTXK1xw/YWhiSxsoBicczFm4gtEH8yt7YRXevXXlRAGMA5fp9S7iG7fMeVJMk/3P
         Q6ZTTacSAvGBeqvG/n09zYGTRKkGnF57eLyUEuoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Tesarik <ptesarik@suse.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 4.4 004/112] r8169: fix data corruption issue on RTL8402
Date:   Tue, 27 Oct 2020 14:48:34 +0100
Message-Id: <20201027134900.746223875@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
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
 drivers/net/ethernet/realtek/r8169.c |  116 ++++++++++++++++++-----------------
 1 file changed, 60 insertions(+), 56 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4452,6 +4452,62 @@ static void rtl_rar_set(struct rtl8169_p
 	rtl_unlock_work(tp);
 }
 
+static void rtl_init_rxcfg(struct rtl8169_private *tp)
+{
+	void __iomem *ioaddr = tp->mmio_addr;
+
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_01:
+	case RTL_GIGA_MAC_VER_02:
+	case RTL_GIGA_MAC_VER_03:
+	case RTL_GIGA_MAC_VER_04:
+	case RTL_GIGA_MAC_VER_05:
+	case RTL_GIGA_MAC_VER_06:
+	case RTL_GIGA_MAC_VER_10:
+	case RTL_GIGA_MAC_VER_11:
+	case RTL_GIGA_MAC_VER_12:
+	case RTL_GIGA_MAC_VER_13:
+	case RTL_GIGA_MAC_VER_14:
+	case RTL_GIGA_MAC_VER_15:
+	case RTL_GIGA_MAC_VER_16:
+	case RTL_GIGA_MAC_VER_17:
+		RTL_W32(RxConfig, RX_FIFO_THRESH | RX_DMA_BURST);
+		break;
+	case RTL_GIGA_MAC_VER_18:
+	case RTL_GIGA_MAC_VER_19:
+	case RTL_GIGA_MAC_VER_20:
+	case RTL_GIGA_MAC_VER_21:
+	case RTL_GIGA_MAC_VER_22:
+	case RTL_GIGA_MAC_VER_23:
+	case RTL_GIGA_MAC_VER_24:
+	case RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_35:
+		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
+		break;
+	case RTL_GIGA_MAC_VER_40:
+		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
+		break;
+	case RTL_GIGA_MAC_VER_41:
+	case RTL_GIGA_MAC_VER_42:
+	case RTL_GIGA_MAC_VER_43:
+	case RTL_GIGA_MAC_VER_44:
+	case RTL_GIGA_MAC_VER_45:
+	case RTL_GIGA_MAC_VER_46:
+	case RTL_GIGA_MAC_VER_47:
+	case RTL_GIGA_MAC_VER_48:
+		RTL_W32(RxConfig, RX128_INT_EN | RX_DMA_BURST | RX_EARLY_OFF);
+		break;
+	case RTL_GIGA_MAC_VER_49:
+	case RTL_GIGA_MAC_VER_50:
+	case RTL_GIGA_MAC_VER_51:
+		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
+		break;
+	default:
+		RTL_W32(RxConfig, RX128_INT_EN | RX_DMA_BURST);
+		break;
+	}
+}
+
 static int rtl_set_mac_address(struct net_device *dev, void *p)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
@@ -4464,6 +4520,10 @@ static int rtl_set_mac_address(struct ne
 
 	rtl_rar_set(tp, dev->dev_addr);
 
+	/* Reportedly at least Asus X453MA truncates packets otherwise */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
+		rtl_init_rxcfg(tp);
+
 	return 0;
 }
 
@@ -4900,62 +4960,6 @@ static void rtl_init_pll_power_ops(struc
 		break;
 	}
 }
-
-static void rtl_init_rxcfg(struct rtl8169_private *tp)
-{
-	void __iomem *ioaddr = tp->mmio_addr;
-
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_01:
-	case RTL_GIGA_MAC_VER_02:
-	case RTL_GIGA_MAC_VER_03:
-	case RTL_GIGA_MAC_VER_04:
-	case RTL_GIGA_MAC_VER_05:
-	case RTL_GIGA_MAC_VER_06:
-	case RTL_GIGA_MAC_VER_10:
-	case RTL_GIGA_MAC_VER_11:
-	case RTL_GIGA_MAC_VER_12:
-	case RTL_GIGA_MAC_VER_13:
-	case RTL_GIGA_MAC_VER_14:
-	case RTL_GIGA_MAC_VER_15:
-	case RTL_GIGA_MAC_VER_16:
-	case RTL_GIGA_MAC_VER_17:
-		RTL_W32(RxConfig, RX_FIFO_THRESH | RX_DMA_BURST);
-		break;
-	case RTL_GIGA_MAC_VER_18:
-	case RTL_GIGA_MAC_VER_19:
-	case RTL_GIGA_MAC_VER_20:
-	case RTL_GIGA_MAC_VER_21:
-	case RTL_GIGA_MAC_VER_22:
-	case RTL_GIGA_MAC_VER_23:
-	case RTL_GIGA_MAC_VER_24:
-	case RTL_GIGA_MAC_VER_34:
-	case RTL_GIGA_MAC_VER_35:
-		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
-		break;
-	case RTL_GIGA_MAC_VER_40:
-		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
-		break;
-	case RTL_GIGA_MAC_VER_41:
-	case RTL_GIGA_MAC_VER_42:
-	case RTL_GIGA_MAC_VER_43:
-	case RTL_GIGA_MAC_VER_44:
-	case RTL_GIGA_MAC_VER_45:
-	case RTL_GIGA_MAC_VER_46:
-	case RTL_GIGA_MAC_VER_47:
-	case RTL_GIGA_MAC_VER_48:
-		RTL_W32(RxConfig, RX128_INT_EN | RX_DMA_BURST | RX_EARLY_OFF);
-		break;
-	case RTL_GIGA_MAC_VER_49:
-	case RTL_GIGA_MAC_VER_50:
-	case RTL_GIGA_MAC_VER_51:
-		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
-		break;
-	default:
-		RTL_W32(RxConfig, RX128_INT_EN | RX_DMA_BURST);
-		break;
-	}
-}
 
 static void rtl8169_init_ring_indexes(struct rtl8169_private *tp)
 {


