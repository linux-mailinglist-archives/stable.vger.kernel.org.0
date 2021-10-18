Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8204A431F56
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhJROUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbhJROUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 10:20:16 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39020C0612F2
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 07:16:45 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id s198-20020a1ca9cf000000b0030d6986ea9fso117056wme.1
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 07:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LAd+S0Qnz+V8XxjM+PVfUF/cgcdX7dHn+MP2lN3vIGw=;
        b=FSmnVMcfCwvzrHxPNyCK6iCEYmyR46utpI4L7WYoDcKbBm+DiVvKL3/8XrgSjZyy2P
         kc9O9Mnd64saaasklTaWc4GVhXsNmYUCEPsAcxrxOOHKJatbqdfENrlGN0D0yq3dDoof
         DEqYlLp0jDQNqAm4IEwN6Sjb7/q9i7YfxHA/q4tkcN9iSNeOmmLD/4a7AcYgRqI4SJZS
         LQm4TFYcpWIJqgCmzQ9BljASZM9Jwzm5QK/NxpQBaOJvFgbvKG+bt2LTjg15ExK3y+q/
         2TyVT3I2iyynFQOe9BzfRTJf6HMkn9uLYMNs08dpNFQemPYVWiZ9x/aU/l28S4U5/gle
         eiZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LAd+S0Qnz+V8XxjM+PVfUF/cgcdX7dHn+MP2lN3vIGw=;
        b=du5Cs3TxTRhFDr9eB5h4zb3A6BByXzuyWdA/Ox83dLNf5vi6a/tAaodvepar6ZVGC5
         kQekYC3NJOPxjisNoJ3lLcmNt0CuEy5JpZgOENidRCeAFSxIKdDtDeP/S7/8n95BE2Pr
         bXP3DY+Pach6Qvs64D3LWI+d3va32FOq3tLzmYBaJ4Ni38PAoIHDjvXqcuiEKLnNq9Oy
         QTVv1ORUEEolBVtZMtG0HRd5dmZERXsZCyDx90ShFFa+fVqtpTq7Ef2/ev6viywg2ufT
         rlfsjsDoVGxpcto1/zh7IubcQO00yAQJmvClUyq6L1mJY8ZWq2I/26x/kdsLBXCCkRmv
         dhbw==
X-Gm-Message-State: AOAM532M11OkgPhI7lHHSu/8msOfTPbLKkB4uzk/V1PbNs3/ANFnCvyD
        R+QFX3p/zPbsR21qCki/yNL3Dw==
X-Google-Smtp-Source: ABdhPJzABYktdw0zjlgeJ3AzNeoPQyZk7xqA/hSJMeTkJzF4o5LJqe0QUd6TsgF3nAtjzDXJCoPLJQ==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr31541462wmk.51.1634566603668;
        Mon, 18 Oct 2021 07:16:43 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:9df5:c752:530b:345b])
        by smtp.gmail.com with ESMTPSA id v185sm18482862wme.35.2021.10.18.07.16.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Oct 2021 07:16:43 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        bryan.odonoghue@linaro.org, Loic Poulain <loic.poulain@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] wcn36xx: Fix tx_status mechanism
Date:   Mon, 18 Oct 2021 16:28:01 +0200
Message-Id: <1634567281-28997-1-git-send-email-loic.poulain@linaro.org>
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
 v2: Fix unused variable error/warning (flag)

 drivers/net/wireless/ath/wcn36xx/dxe.c  | 37 +++++++++++++--------------------
 drivers/net/wireless/ath/wcn36xx/txrx.c | 31 ++++++---------------------
 2 files changed, 21 insertions(+), 47 deletions(-)

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
index 1edc703..f9d2fc3 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -608,10 +608,11 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct wcn36xx_vif *vif_priv = NULL;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	unsigned long flags;
 	bool is_low = ieee80211_is_data(hdr->frame_control);
 	bool bcast = is_broadcast_ether_addr(hdr->addr1) ||
 		is_multicast_ether_addr(hdr->addr1);
+	bool ack_ind = (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) &&
+					!(info->flags & IEEE80211_TX_CTL_NO_ACK);
 	struct wcn36xx_tx_bd bd;
 	int ret;
 
@@ -627,30 +628,16 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
 
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
@@ -664,14 +651,8 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
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

