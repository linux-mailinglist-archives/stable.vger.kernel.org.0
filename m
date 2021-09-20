Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED3B411A12
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239569AbhITQrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:47:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239460AbhITQrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:47:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BE0B60F38;
        Mon, 20 Sep 2021 16:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156334;
        bh=xtJhTLLvX71+USSm1QBz/ju7Ee1nsnsdTRvFUa570bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OyljQ4AAVJxN2vuJ4omYVbL6AmJLzi1KRgHgRF8YUeC1W1gXfLmkP7/WS6zuvNem4
         i73cZO+wdkOzIjFhe6O6z2zKDFSDfNslDh17E7fyBIxZAH1OTgMoFjEJBRo3GWkGPr
         HymkHcg5UZU584+YfUQr0w0hy3AVVHGBVp1FnvU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 012/133] ath9k: Postpone key cache entry deletion for TXQ frames reference it
Date:   Mon, 20 Sep 2021 18:41:30 +0200
Message-Id: <20210920163913.010593884@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Malinen <jouni@codeaurora.org>

commit ca2848022c12789685d3fab3227df02b863f9696 upstream.

Do not delete a key cache entry that is still being referenced by
pending frames in TXQs. This avoids reuse of the key cache entry while a
frame might still be transmitted using it.

To avoid having to do any additional operations during the main TX path
operations, track pending key cache entries in a new bitmap and check
whether any pending entries can be deleted before every new key
add/remove operation. Also clear any remaining entries when stopping the
interface.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201214172118.18100-6-jouni@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/hw.h   |    1 
 drivers/net/wireless/ath/ath9k/main.c |   87 +++++++++++++++++++++++++++++++++-
 2 files changed, 87 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -814,6 +814,7 @@ struct ath_hw {
 	struct ath9k_pacal_info pacal_info;
 	struct ar5416Stats stats;
 	struct ath9k_tx_queue_info txq[ATH9K_NUM_TX_QUEUES];
+	DECLARE_BITMAP(pending_del_keymap, ATH_KEYMAX);
 
 	enum ath9k_int imask;
 	u32 imrs2_reg;
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -819,12 +819,80 @@ exit:
 	ieee80211_free_txskb(hw, skb);
 }
 
+static bool ath9k_txq_list_has_key(struct list_head *txq_list, u32 keyix)
+{
+	struct ath_buf *bf;
+	struct ieee80211_tx_info *txinfo;
+	struct ath_frame_info *fi;
+
+	list_for_each_entry(bf, txq_list, list) {
+		if (bf->bf_state.stale || !bf->bf_mpdu)
+			continue;
+
+		txinfo = IEEE80211_SKB_CB(bf->bf_mpdu);
+		fi = (struct ath_frame_info *)&txinfo->rate_driver_data[0];
+		if (fi->keyix == keyix)
+			return true;
+	}
+
+	return false;
+}
+
+static bool ath9k_txq_has_key(struct ath_softc *sc, u32 keyix)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	int i;
+	struct ath_txq *txq;
+	bool key_in_use = false;
+
+	for (i = 0; !key_in_use && i < ATH9K_NUM_TX_QUEUES; i++) {
+		if (!ATH_TXQ_SETUP(sc, i))
+			continue;
+		txq = &sc->tx.txq[i];
+		if (!txq->axq_depth)
+			continue;
+		if (!ath9k_hw_numtxpending(ah, txq->axq_qnum))
+			continue;
+
+		ath_txq_lock(sc, txq);
+		key_in_use = ath9k_txq_list_has_key(&txq->axq_q, keyix);
+		if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+			int idx = txq->txq_tailidx;
+
+			while (!key_in_use &&
+			       !list_empty(&txq->txq_fifo[idx])) {
+				key_in_use = ath9k_txq_list_has_key(
+					&txq->txq_fifo[idx], keyix);
+				INCR(idx, ATH_TXFIFO_DEPTH);
+			}
+		}
+		ath_txq_unlock(sc, txq);
+	}
+
+	return key_in_use;
+}
+
+static void ath9k_pending_key_del(struct ath_softc *sc, u8 keyix)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!test_bit(keyix, ah->pending_del_keymap) ||
+	    ath9k_txq_has_key(sc, keyix))
+		return;
+
+	/* No more TXQ frames point to this key cache entry, so delete it. */
+	clear_bit(keyix, ah->pending_del_keymap);
+	ath_key_delete(common, keyix);
+}
+
 static void ath9k_stop(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	bool prev_idle;
+	int i;
 
 	ath9k_deinit_channel_context(sc);
 
@@ -890,6 +958,9 @@ static void ath9k_stop(struct ieee80211_
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
+	for (i = 0; i < ATH_KEYMAX; i++)
+		ath9k_pending_key_del(sc, i);
+
 	/* Clear key cache entries explicitly to get rid of any potentially
 	 * remaining keys.
 	 */
@@ -1692,6 +1763,12 @@ static int ath9k_set_key(struct ieee8021
 	if (sta)
 		an = (struct ath_node *)sta->drv_priv;
 
+	/* Delete pending key cache entries if no more frames are pointing to
+	 * them in TXQs.
+	 */
+	for (i = 0; i < ATH_KEYMAX; i++)
+		ath9k_pending_key_del(sc, i);
+
 	switch (cmd) {
 	case SET_KEY:
 		if (sta)
@@ -1721,7 +1798,15 @@ static int ath9k_set_key(struct ieee8021
 		}
 		break;
 	case DISABLE_KEY:
-		ath_key_delete(common, key->hw_key_idx);
+		if (ath9k_txq_has_key(sc, key->hw_key_idx)) {
+			/* Delay key cache entry deletion until there are no
+			 * remaining TXQ frames pointing to this entry.
+			 */
+			set_bit(key->hw_key_idx, sc->sc_ah->pending_del_keymap);
+			ath_hw_keysetmac(common, key->hw_key_idx, NULL);
+		} else {
+			ath_key_delete(common, key->hw_key_idx);
+		}
 		if (an) {
 			for (i = 0; i < ARRAY_SIZE(an->key_idx); i++) {
 				if (an->key_idx[i] != key->hw_key_idx)


