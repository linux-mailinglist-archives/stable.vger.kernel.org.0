Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8295106AFE
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbfKVKk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:40:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbfKVKk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:40:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39B5D20718;
        Fri, 22 Nov 2019 10:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419226;
        bh=51B5i7ZSZGGTkvJ7fYCTtynCDM1daTOX1raD80Vc/BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMBmIEwOCoTxEhBGODKGw/ljWV2yGJPht3iENHs7FFLI2kY4pYgstP99+ACELPEQe
         yNwzEUXw4jKrKUipEQf6WusMgrOrE0DVI6h+lHfa/UWo/RF+F6GzbT5iAW7CKOQwp0
         RnEz9CBozjQCnb4Zjao6U3QHuVyX88yLyAH6wyD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 023/222] ath9k: fix tx99 with monitor mode interface
Date:   Fri, 22 Nov 2019 11:26:03 +0100
Message-Id: <20191122100837.620107323@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d9c52fd17cb483bd8a470398afcb79f86c1b77c8 ]

Tx99 is typically configured via a monitor mode interface, which does
not get added to the driver as a vif. Since the code currently expects
a configured virtual interface for tx99, enabling tx99 via debugfs fails.
Since the vif is not needed anyway, remove all checks for it.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
[kvalo@codeaurora.org: s/CPTCFG/CONFIG/]
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 -
 drivers/net/wireless/ath/ath9k/main.c  | 12 +++---------
 drivers/net/wireless/ath/ath9k/tx99.c  |  9 ---------
 drivers/net/wireless/ath/ath9k/xmit.c  |  2 +-
 4 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7bda18c61eb6e..51e878a9d5211 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1033,7 +1033,6 @@ struct ath_softc {
 
 	struct ath_spec_scan_priv spec_priv;
 
-	struct ieee80211_vif *tx99_vif;
 	struct sk_buff *tx99_skb;
 	bool tx99_state;
 	s16 tx99_power;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b868f02ced893..fbc34beee1580 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1249,15 +1249,10 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_node *an = &avp->mcast_node;
 
-	mutex_lock(&sc->mutex);
+	if (IS_ENABLED(CONFIG_ATH9K_TX99))
+		return -EOPNOTSUPP;
 
-	if (IS_ENABLED(CONFIG_ATH9K_TX99)) {
-		if (sc->cur_chan->nvifs >= 1) {
-			mutex_unlock(&sc->mutex);
-			return -EOPNOTSUPP;
-		}
-		sc->tx99_vif = vif;
-	}
+	mutex_lock(&sc->mutex);
 
 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
 	sc->cur_chan->nvifs++;
@@ -1340,7 +1335,6 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	ath9k_p2p_remove_vif(sc, vif);
 
 	sc->cur_chan->nvifs--;
-	sc->tx99_vif = NULL;
 	if (!ath9k_is_chanctx_enabled())
 		list_del(&avp->list);
 
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index 8e9480cc33e15..0cb5b2a873be8 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -54,12 +54,6 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info;
 	struct sk_buff *skb;
-	struct ath_vif *avp;
-
-	if (!sc->tx99_vif)
-		return NULL;
-
-	avp = (struct ath_vif *)sc->tx99_vif->drv_priv;
 
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb)
@@ -77,14 +71,11 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
 	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
 
-	hdr->seq_ctrl |= cpu_to_le16(avp->seq_no);
-
 	tx_info = IEEE80211_SKB_CB(skb);
 	memset(tx_info, 0, sizeof(*tx_info));
 	rate = &tx_info->control.rates[0];
 	tx_info->band = sc->cur_chan->chandef.chan->band;
 	tx_info->flags = IEEE80211_TX_CTL_NO_ACK;
-	tx_info->control.vif = sc->tx99_vif;
 	rate->count = 1;
 	if (ah->curchan && IS_CHAN_HT(ah->curchan)) {
 		rate->flags |= IEEE80211_TX_RC_MCS;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 0ef27d99bef33..2c35819f65426 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2970,7 +2970,7 @@ int ath9k_tx99_send(struct ath_softc *sc, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	ath_set_rates(sc->tx99_vif, NULL, bf);
+	ath_set_rates(NULL, NULL, bf);
 
 	ath9k_hw_set_desc_link(sc->sc_ah, bf->bf_desc, bf->bf_daddr);
 	ath9k_hw_tx99_start(sc->sc_ah, txctl->txq->axq_qnum);
-- 
2.20.1



