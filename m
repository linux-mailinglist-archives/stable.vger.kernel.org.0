Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BB34318DD
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 14:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhJRMVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 08:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhJRMVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 08:21:54 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8FCC06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 05:19:43 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id y74-20020a1c7d4d000000b00322f53b9bbfso4648782wmc.3
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 05:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Mrj3/k0aO18EsPYiCwstLG8nMGZmvk0h62LLWvj8MuM=;
        b=xMsBXm0aLESWeDDz5Kqb3aN+4x8vP6piEdaiQxaSmDmNHMdPFWmrPBGA/4rGlPuKl7
         VuTjlMczOgT/drL7FpXM1jD4ZJLN+jdeyO+f4VgCxN7n3Lz3fWC5ys27ekvQg+5fhGEQ
         UhQ7CcH3uKjV0AiPe+sPkC/1xweOnkQ1lobWmfHbgoS2nS0BmwboU6SKp29LZdjhsAdd
         3GM2A+mKUzXNBNquObS7kusQ2LMUOMWRN9lfOEW0vCWiT1UXrYKdlcg5K0ugOSw2QLRx
         spb8+2VNZP5UIHo7C2vcb9B9nem/r3RrHihTE2ji9rTp+xfAEYGRHv12yUioO+93c1aA
         ZCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Mrj3/k0aO18EsPYiCwstLG8nMGZmvk0h62LLWvj8MuM=;
        b=6NX0eFOEajvBkjwaJs3hWy4Y7gqvBmzbWar+Thw5qrk9ljuLiyugJsgvszLqAQwhMK
         ZvAy91rAyohF83SfCwOsTDmraIgiAYVGj/qgsFDPhxVW5xRHgjmwl4BvooMFqQ/9KCRj
         ST3NpUCxcFA6cQMnn6xfZj3THOhxFL0kPpmMoiW4aXRr/sdERsCZ13JaBKjod/qib7HV
         Yabv46rSnYH8QNwPv8DOVManWN6OdiFdPngk3+cqDrUs8fh+laIXh9xKkoGAmg1jetWR
         9LUhE0xmxBG136B17h6hWHjOLaG8fkOSSXUR6GKaLmxLFLhxkeq/OBZjDPet8t835a+N
         0qnA==
X-Gm-Message-State: AOAM530U2VQP4JKStGZaUmyffspyqORHkWUKHD4C2q3EFtHOTXzoGq8o
        k162ouNZydluklIGJGWw63+tYw==
X-Google-Smtp-Source: ABdhPJyLaB1NRDA68oEvR9Z0cbVypaukDqy8AckBPTGNpsEW6ewkxEmdaJ3uwc+efPhVrwRZ0A+6tw==
X-Received: by 2002:a1c:f713:: with SMTP id v19mr29600470wmh.188.1634559582145;
        Mon, 18 Oct 2021 05:19:42 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:9df5:c752:530b:345b])
        by smtp.gmail.com with ESMTPSA id u5sm12654865wrg.57.2021.10.18.05.19.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Oct 2021 05:19:41 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        bryan.odonoghue@linaro.org, Loic Poulain <loic.poulain@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] wcn36xx: Fix tx_status mechanism
Date:   Mon, 18 Oct 2021 14:31:00 +0200
Message-Id: <1634560260-15056-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This change fix the TX ack mechanism in various ways:

- For NO_ACK tagged packets, we don't need to way for TX_ACK indication
and so are not subject to the single packet ack limitation. So we don't
have to stop the tx queue, and can call the tx status callback as soon
as DMA transfer has completed.

- Fix skb ownership/reference. Only start status indication timeout
once the DMA transfer has been completed. This avoids the skb to be
both referenced in the DMA tx ring and by the tx_ack_skb pointer,
preventing any use-after-free or double-free.

- This adds a sanity (paranoia?) check on the skb tx ack pointer.

- Resume TX queue if TX status tagged packet TX fails.

Cc: stable@vger.kernel.org
Fixes: fdf21cc37149 ("wcn36xx: Add TX ack support")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c  | 37 +++++++++++++--------------------
 drivers/net/wireless/ath/wcn36xx/txrx.c | 30 ++++++--------------------
 2 files changed, 21 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 8e1dbfd..0e0bbcd 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -403,8 +403,21 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
 			dma_unmap_single(wcn->dev, ctl->desc->src_addr_l,
 					 ctl->skb->len, DMA_TO_DEVICE);
 			info = IEEE80211_SKB_CB(ctl->skb);
-			if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
-				/* Keep frame until TX status comes */
+			if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
+				if (info->flags & IEEE80211_TX_CTL_NO_ACK) {
+					info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+					ieee80211_tx_status_irqsafe(wcn->hw, ctl->skb);
+				} else {
+					/* Wait for the TX ack indication or timeout... */
+					spin_lock(&wcn->dxe_lock);
+					if (WARN_ON(wcn->tx_ack_skb))
+						ieee80211_free_txskb(wcn->hw, wcn->tx_ack_skb);
+					wcn->tx_ack_skb = ctl->skb; /* Tracking ref */
+					mod_timer(&wcn->tx_ack_timer, jiffies + HZ / 10);
+					spin_unlock(&wcn->dxe_lock);
+				}
+				/* do not free, ownership transferred to mac80211 status cb */
+			} else {
 				ieee80211_free_txskb(wcn->hw, ctl->skb);
 			}
 
@@ -426,7 +439,6 @@ static irqreturn_t wcn36xx_irq_tx_complete(int irq, void *dev)
 {
 	struct wcn36xx *wcn = (struct wcn36xx *)dev;
 	int int_src, int_reason;
-	bool transmitted = false;
 
 	wcn36xx_dxe_read_register(wcn, WCN36XX_DXE_INT_SRC_RAW_REG, &int_src);
 
@@ -466,7 +478,6 @@ static irqreturn_t wcn36xx_irq_tx_complete(int irq, void *dev)
 		if (int_reason & (WCN36XX_CH_STAT_INT_DONE_MASK |
 				  WCN36XX_CH_STAT_INT_ED_MASK)) {
 			reap_tx_dxes(wcn, &wcn->dxe_tx_h_ch);
-			transmitted = true;
 		}
 	}
 
@@ -479,7 +490,6 @@ static irqreturn_t wcn36xx_irq_tx_complete(int irq, void *dev)
 					   WCN36XX_DXE_0_INT_CLR,
 					   WCN36XX_INT_MASK_CHAN_TX_L);
 
-
 		if (int_reason & WCN36XX_CH_STAT_INT_ERR_MASK ) {
 			wcn36xx_dxe_write_register(wcn,
 						   WCN36XX_DXE_0_INT_ERR_CLR,
@@ -507,25 +517,8 @@ static irqreturn_t wcn36xx_irq_tx_complete(int irq, void *dev)
 		if (int_reason & (WCN36XX_CH_STAT_INT_DONE_MASK |
 				  WCN36XX_CH_STAT_INT_ED_MASK)) {
 			reap_tx_dxes(wcn, &wcn->dxe_tx_l_ch);
-			transmitted = true;
-		}
-	}
-
-	spin_lock(&wcn->dxe_lock);
-	if (wcn->tx_ack_skb && transmitted) {
-		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(wcn->tx_ack_skb);
-
-		/* TX complete, no need to wait for 802.11 ack indication */
-		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS &&
-		    info->flags & IEEE80211_TX_CTL_NO_ACK) {
-			info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
-			del_timer(&wcn->tx_ack_timer);
-			ieee80211_tx_status_irqsafe(wcn->hw, wcn->tx_ack_skb);
-			wcn->tx_ack_skb = NULL;
-			ieee80211_wake_queues(wcn->hw);
 		}
 	}
-	spin_unlock(&wcn->dxe_lock);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 1edc703..ef1b133 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -612,6 +612,8 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
 	bool is_low = ieee80211_is_data(hdr->frame_control);
 	bool bcast = is_broadcast_ether_addr(hdr->addr1) ||
 		is_multicast_ether_addr(hdr->addr1);
+	bool ack_ind = (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) &&
+					!(info->flags & IEEE80211_TX_CTL_NO_ACK);
 	struct wcn36xx_tx_bd bd;
 	int ret;
 
@@ -627,30 +629,16 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
 
 	bd.dpu_rf = WCN36XX_BMU_WQ_TX;
 
-	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
+	if (unlikely(ack_ind)) {
 		wcn36xx_dbg(WCN36XX_DBG_DXE, "TX_ACK status requested\n");
 
-		spin_lock_irqsave(&wcn->dxe_lock, flags);
-		if (wcn->tx_ack_skb) {
-			spin_unlock_irqrestore(&wcn->dxe_lock, flags);
-			wcn36xx_warn("tx_ack_skb already set\n");
-			return -EINVAL;
-		}
-
-		wcn->tx_ack_skb = skb;
-		spin_unlock_irqrestore(&wcn->dxe_lock, flags);
-
 		/* Only one at a time is supported by fw. Stop the TX queues
 		 * until the ack status gets back.
 		 */
 		ieee80211_stop_queues(wcn->hw);
 
-		/* TX watchdog if no TX irq or ack indication received  */
-		mod_timer(&wcn->tx_ack_timer, jiffies + HZ / 10);
-
 		/* Request ack indication from the firmware */
-		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
-			bd.tx_comp = 1;
+		bd.tx_comp = 1;
 	}
 
 	/* Data frames served first*/
@@ -664,14 +652,8 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
 	bd.tx_bd_sign = 0xbdbdbdbd;
 
 	ret = wcn36xx_dxe_tx_frame(wcn, vif_priv, &bd, skb, is_low);
-	if (ret && (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
-		/* If the skb has not been transmitted,
-		 * don't keep a reference to it.
-		 */
-		spin_lock_irqsave(&wcn->dxe_lock, flags);
-		wcn->tx_ack_skb = NULL;
-		spin_unlock_irqrestore(&wcn->dxe_lock, flags);
-
+	if (unlikely(ret && ack_ind)) {
+		/* If the skb has not been transmitted, resume TX queue */
 		ieee80211_wake_queues(wcn->hw);
 	}
 
-- 
2.7.4

