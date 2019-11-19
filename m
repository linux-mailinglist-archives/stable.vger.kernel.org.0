Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 011DD10172E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbfKSFtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:49:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728994AbfKSFtk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:49:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AB4220721;
        Tue, 19 Nov 2019 05:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142579;
        bh=Vooz1Os3ADptGxCHgQSrrCLjgPdhf0blMOl7JrvYjUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqZKd0xRcWSeB6twuWFnDFjYq5PnQo/TIu43w8YahAwsi2oKKHrqerOCLw5IsoW+S
         UG1Fs8Gv+iY/dXRpZ+cf+0XCKdo35eqGEI8zHvBjN7ZRUqh2PY4oNcLLkwP52Gv3tO
         GTkAYv8EwTE8mU68zxkNzZTG1K4xVaJh+QpArRuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 089/239] ath9k: add back support for using active monitor interfaces for tx99
Date:   Tue, 19 Nov 2019 06:18:09 +0100
Message-Id: <20191119051319.296217759@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 6df0580be8bc30803c4d8b2ed9c2230a2740c795 ]

Various documented examples on how to set up tx99 with ath9k rely
on setting up a regular monitor interface for setting the channel.
My previous patch "ath9k: fix tx99 with monitor mode interface" made
it possible to set it up this way again. However, it was removing support
for using an active monitor interface, which is required for controlling
the bitrate as well, since the bitrate is not passed down with a regular
monitor interface.

This patch partially reverts the previous one, but keeps support for using
a regular monitor interface to keep documented steps working in cases
where the bitrate does not matter

Fixes: d9c52fd17cb48 ("ath9k: fix tx99 with monitor mode interface")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/main.c  | 10 ++++++++--
 drivers/net/wireless/ath/ath9k/tx99.c  |  7 +++++++
 drivers/net/wireless/ath/ath9k/xmit.c  |  2 +-
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index db2b119199d7b..f9339b5c3624b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1074,6 +1074,7 @@ struct ath_softc {
 
 	struct ath_spec_scan_priv spec_priv;
 
+	struct ieee80211_vif *tx99_vif;
 	struct sk_buff *tx99_skb;
 	bool tx99_state;
 	s16 tx99_power;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 055f869516804..3589f1f3e744d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1250,8 +1250,13 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_node *an = &avp->mcast_node;
 
-	if (IS_ENABLED(CONFIG_ATH9K_TX99))
-		return -EOPNOTSUPP;
+	if (IS_ENABLED(CONFIG_ATH9K_TX99)) {
+		if (sc->cur_chan->nvifs >= 1) {
+			mutex_unlock(&sc->mutex);
+			return -EOPNOTSUPP;
+		}
+		sc->tx99_vif = vif;
+	}
 
 	mutex_lock(&sc->mutex);
 
@@ -1336,6 +1341,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	ath9k_p2p_remove_vif(sc, vif);
 
 	sc->cur_chan->nvifs--;
+	sc->tx99_vif = NULL;
 	if (!ath9k_is_chanctx_enabled())
 		list_del(&avp->list);
 
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index 311547f532bc3..87d09d1e74aa0 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -54,6 +54,7 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info;
 	struct sk_buff *skb;
+	struct ath_vif *avp;
 
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb)
@@ -71,11 +72,17 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
 	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
 
+	if (sc->tx99_vif) {
+		avp = (struct ath_vif *) sc->tx99_vif->drv_priv;
+		hdr->seq_ctrl |= cpu_to_le16(avp->seq_no);
+	}
+
 	tx_info = IEEE80211_SKB_CB(skb);
 	memset(tx_info, 0, sizeof(*tx_info));
 	rate = &tx_info->control.rates[0];
 	tx_info->band = sc->cur_chan->chandef.chan->band;
 	tx_info->flags = IEEE80211_TX_CTL_NO_ACK;
+	tx_info->control.vif = sc->tx99_vif;
 	rate->count = 1;
 	if (ah->curchan && IS_CHAN_HT(ah->curchan)) {
 		rate->flags |= IEEE80211_TX_RC_MCS;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a743e3535d0a8..458c4f53ba5d1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2952,7 +2952,7 @@ int ath9k_tx99_send(struct ath_softc *sc, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	ath_set_rates(NULL, NULL, bf);
+	ath_set_rates(sc->tx99_vif, NULL, bf);
 
 	ath9k_hw_set_desc_link(sc->sc_ah, bf->bf_desc, bf->bf_daddr);
 	ath9k_hw_tx99_start(sc->sc_ah, txctl->txq->axq_qnum);
-- 
2.20.1



