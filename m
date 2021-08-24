Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C503F6488
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbhHXRFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238824AbhHXRDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:03:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3CCD613E6;
        Tue, 24 Aug 2021 16:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824355;
        bh=zLibVpV21IW3HVRbT++x8PzePun8ys/u21YDL6Dg448=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTEC95ezLrMuRMhob19M3EnWBE/vND5i9zENAH6yvjdDU3RFOy/3tOQOerLcSfC5O
         rP11QGX56bo+mmMOUviBYChQHZW3iqSFAKJEd35Y164upm3KBIZxyFoxovIW9vc0d0
         K3On93XFQK+LV7S7agfUVAf+P3oB+TtrkRJcTvTaZTN0v5wGAIqkSbKo1/xC4Gw0KZ
         GKavPJb/2sr1HLz2hIw1G+zwG+MK0ER5WjSxpf2My3nm/JiB3h5H3+CnuNzP8BRZ1j
         urXDZeXQNb8Y7euEPhBP+++YNVLMYGpvTi4L8Cu9rcXBdt8fHYAtMAWjrmZQsK6Re/
         Pdtq19rC5baEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 05/98] ath9k: Postpone key cache entry deletion for TXQ frames reference it
Date:   Tue, 24 Aug 2021 12:57:35 -0400
Message-Id: <20210824165908.709932-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
Cc: Pali Rohár <pali@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/hw.h   |  1 +
 drivers/net/wireless/ath/ath9k/main.c | 87 ++++++++++++++++++++++++++-
 2 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 023599e10dd5..b7b65b1c90e8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -820,6 +820,7 @@ struct ath_hw {
 	struct ath9k_pacal_info pacal_info;
 	struct ar5416Stats stats;
 	struct ath9k_tx_queue_info txq[ATH9K_NUM_TX_QUEUES];
+	DECLARE_BITMAP(pending_del_keymap, ATH_KEYMAX);
 
 	enum ath9k_int imask;
 	u32 imrs2_reg;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9fd3dc66d17a..5739c1dbf166 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -826,12 +826,80 @@ exit:
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
 
@@ -899,6 +967,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
+	for (i = 0; i < ATH_KEYMAX; i++)
+		ath9k_pending_key_del(sc, i);
+
 	/* Clear key cache entries explicitly to get rid of any potentially
 	 * remaining keys.
 	 */
@@ -1728,6 +1799,12 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
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
@@ -1757,7 +1834,15 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
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
-- 
2.30.2

