Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B289C6B4753
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbjCJOuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbjCJOtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:49:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DCA1241C7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:47:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2C15B822DD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85F0C433A1;
        Fri, 10 Mar 2023 14:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459665;
        bh=AHm20nTNBjo1d6IVm2OJ0g44xG919XOaTguNIUCZYac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUUiUpZDN2vSk4R6EI61j3JoMi8wr7/A5DmxNGMkebBJzZ4fZPGxv6zogRhe/r4uy
         MRjT1Nq/2pnOlafpShMCzLyLmHll7fy4iMLo7uueDRD0AKnlcDEjmvRXge0Js7SEWN
         nwNv107dieBKjSIdgDr5z/9OgEPl1iY2ZAEYVxiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/529] wifi: rtlwifi: rtl8723be: dont call kfree_skb() under spin_lock_irqsave()
Date:   Fri, 10 Mar 2023 14:33:15 +0100
Message-Id: <20230310133807.408849563@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 313950c2114e7051c4e3020fd82495fa1fb526a8 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. All the SKBs have
been dequeued from the old queue, so it's safe to enqueue these
SKBs to a free queue, then free them after spin_unlock_irqrestore()
at once. Compile tested only.

Fixes: 5c99f04fec93 ("rtlwifi: rtl8723be: Update driver to match Realtek release of 06/28/14")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221207141411.46098-4-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 0748aedce2adb..ccbb082d5e928 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -30,8 +30,10 @@ static void _rtl8723be_return_beacon_queue_skb(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[BEACON_QUEUE];
+	struct sk_buff_head free_list;
 	unsigned long flags;
 
+	skb_queue_head_init(&free_list);
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 	while (skb_queue_len(&ring->queue)) {
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
@@ -41,10 +43,12 @@ static void _rtl8723be_return_beacon_queue_skb(struct ieee80211_hw *hw)
 				 rtlpriv->cfg->ops->get_desc(hw, (u8 *)entry,
 						true, HW_DESC_TXBUFF_ADDR),
 				 skb->len, DMA_TO_DEVICE);
-		kfree_skb(skb);
+		__skb_queue_tail(&free_list, skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
+
+	__skb_queue_purge(&free_list);
 }
 
 static void _rtl8723be_set_bcn_ctrl_reg(struct ieee80211_hw *hw,
-- 
2.39.2



