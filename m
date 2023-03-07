Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A876AF32E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbjCGTBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjCGTBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:01:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166FC2A6D2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:47:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5004F61526
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9F0C433D2;
        Tue,  7 Mar 2023 18:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214839;
        bh=sMQH2xsUTHJh1TuyxhanJMIeC3DgM3gQ67AASBNBwgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=us/zW9p+id3Jc4adksl54Et8dT6ZU6Ei+3zsXP0o6iC4CN/7N0c/VqieMm/0/+pKY
         ++om3p30mYiW4X0W7aymbrIeIYfzNdttXUYntT7l/kaP89gWXDtEhZG6BwUQ8rY7Y7
         aasr5kp11b7iUWWL2hpUMwfEYUhS1Ti9/hUvnU5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/567] wifi: rtlwifi: rtl8821ae: dont call kfree_skb() under spin_lock_irqsave()
Date:   Tue,  7 Mar 2023 17:56:43 +0100
Message-Id: <20230307165908.799159590@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 106031c1f4a850915190d7ec1026696282f9359b ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. All the SKBs have
been dequeued from the old queue, so it's safe to enqueue these
SKBs to a free queue, then free them after spin_unlock_irqrestore()
at once. Compile tested only.

Fixes: 5c99f04fec93 ("rtlwifi: rtl8723be: Update driver to match Realtek release of 06/28/14")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221207141411.46098-2-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 33ffc24d36759..c4ee65cc2d5e6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -26,8 +26,10 @@ static void _rtl8821ae_return_beacon_queue_skb(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[BEACON_QUEUE];
+	struct sk_buff_head free_list;
 	unsigned long flags;
 
+	skb_queue_head_init(&free_list);
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 	while (skb_queue_len(&ring->queue)) {
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
@@ -37,10 +39,12 @@ static void _rtl8821ae_return_beacon_queue_skb(struct ieee80211_hw *hw)
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
 
 static void _rtl8821ae_set_bcn_ctrl_reg(struct ieee80211_hw *hw,
-- 
2.39.2



