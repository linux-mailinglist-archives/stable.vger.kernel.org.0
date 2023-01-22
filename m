Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C074676F63
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjAVPU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjAVPUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:20:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E93222F9
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:20:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49F2CB80B1D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97934C4339B;
        Sun, 22 Jan 2023 15:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400852;
        bh=uwcUacqhlocee2N/E3O3fXyezXvUrb/ZYiJ7oRXiPPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxh+0eCHHVTYIffpyRuSJ6vb8Yglv/MTY0BOa/OaZaauLoyHHCiHYHV+5YWYA3+1z
         lxH5/X9fQ4KAx2zfi7HsicF6hYOv7YhFUNE6yCpWjJtGkuapTuGwsIfhx7zlrJZRe+
         fMvMZ5zebSjBFABBhkpUR4lIO2YjizXPpZzzlcAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chunhao Lin <hau@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/193] r8169: fix dmar pte write access is not set error
Date:   Sun, 22 Jan 2023 16:02:25 +0100
Message-Id: <20230122150247.099795632@linuxfoundation.org>
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

[ Upstream commit bb41c13c05c23d9bc46b4e37d8914078c6a40e3a ]

When close device, if wol is enabled, rx will be enabled. When open
device it will cause rx packet to be dma to the wrong memory address
after pci_set_master() and system log will show blow messages.

DMAR: DRHD: handling fault status reg 3
DMAR: [DMA Write] Request device [02:00.0] PASID ffffffff fault addr
ffdd4000 [fault reason 05] PTE Write access is not set

In this patch, driver disable tx/rx when close device. If wol is
enabled, only enable rx filter and disable rxdv_gate(if support) to
let hardware only receive packet to fifo but not to dma it.

Signed-off-by: Chunhao Lin <hau@realtek.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 316c925c956f..cabed1b7b45e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2435,6 +2435,9 @@ static void rtl_wol_enable_rx(struct rtl8169_private *tp)
 	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
 		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
 			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
+
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_40)
+		rtl_disable_rxdvgate(tp);
 }
 
 static void rtl_prepare_power_down(struct rtl8169_private *tp)
@@ -3869,7 +3872,7 @@ static void rtl8169_tx_clear(struct rtl8169_private *tp)
 	netdev_reset_queue(tp->dev);
 }
 
-static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
+static void rtl8169_cleanup(struct rtl8169_private *tp)
 {
 	napi_disable(&tp->napi);
 
@@ -3881,9 +3884,6 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
 
 	rtl_rx_close(tp);
 
-	if (going_down && tp->dev->wol_enabled)
-		goto no_reset;
-
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
@@ -3904,7 +3904,7 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
 	}
 
 	rtl_hw_reset(tp);
-no_reset:
+
 	rtl8169_tx_clear(tp);
 	rtl8169_init_ring_indexes(tp);
 }
@@ -3915,7 +3915,7 @@ static void rtl_reset_work(struct rtl8169_private *tp)
 
 	netif_stop_queue(tp->dev);
 
-	rtl8169_cleanup(tp, false);
+	rtl8169_cleanup(tp);
 
 	for (i = 0; i < NUM_RX_DESC; i++)
 		rtl8169_mark_to_asic(tp->RxDescArray + i);
@@ -4601,7 +4601,7 @@ static void rtl8169_down(struct rtl8169_private *tp)
 	pci_clear_master(tp->pci_dev);
 	rtl_pci_commit(tp);
 
-	rtl8169_cleanup(tp, true);
+	rtl8169_cleanup(tp);
 	rtl_disable_exit_l1(tp);
 	rtl_prepare_power_down(tp);
 }
-- 
2.35.1



