Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068304F1B18
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353366AbiDDVTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379832AbiDDSOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 14:14:21 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600AC3EA8F;
        Mon,  4 Apr 2022 11:12:24 -0700 (PDT)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1649095942; bh=t7buVznG3yYA/clRrtCyeVOjJjj86PX29F+Mo7FFbD4=;
        h=From:To:Cc:Subject:Date:From;
        b=hgq637ASRyJWWnpb/5p+PzMyiwCmOZ1E7FjoJroS8IjnYnPBEyiAnozUq4Y/4O/Zv
         WBms5xwx7I26Q4XR4Zp1Gb/P0Gdtc9QBBglKjvQeeognTIjidKHl3mNCG/GuzSXTvv
         zbDR2M6WhuKDO55eUOEn3lsGFz1zxtTAV+2xGJ2lZ1c/Hf+HUjrjrjn6Q7aEVYAhEL
         uDjO0cEOOp3nJXy3jc3Xiy2ligDg+8BhzKQqZa1MUfxJuCLyI4peA5R2Ga/iP1vyNE
         o6p7ATmqefViqKsIkik/jBSDExZGlXvFe9flumwCL1ob8uXetNEKzcG0jQaKB0LG6E
         WfBrU6/4AY8DA==
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        stable@vger.kernel.org, Peter Seiderer <ps.report@gmx.net>
Subject: [PATCH for-5.18 v2] ath9k: Fix usage of driver-private space in tx_info
Date:   Mon,  4 Apr 2022 20:11:51 +0200
Message-Id: <20220404181151.2669173-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The ieee80211_tx_info_clear_status() helper also clears the rate counts and
the driver-private part of struct ieee80211_tx_info, so using it breaks
quite a few other things. So back out of using it, and instead define a
ath-internal helper that only clears the area between the
status_driver_data and the rates info. Combined with moving the
ath_frame_info struct to status_driver_data, this avoids clearing anything
we shouldn't be, and so we can keep the existing code for handling the rate
information.

While fixing this I also noticed that the setting of
tx_info->status.rates[tx_rateindex].count on hardware underrun errors was
always immediately overridden by the normal setting of the same fields, so
rearrange the code so that the underrun detection actually takes effect.

The new helper could be generalised to a 'memset_between()' helper, but
leave it as a driver-internal helper for now since this needs to go to
stable.

Cc: stable@vger.kernel.org
Reported-by: Peter Seiderer <ps.report@gmx.net>
Fixes: 037250f0a45c ("ath9k: Properly clear TX status area before reporting to mac80211")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 30 ++++++++++++++++++---------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index cbcf96ac303e..db83cc4ba810 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -141,8 +141,8 @@ static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	BUILD_BUG_ON(sizeof(struct ath_frame_info) >
-		     sizeof(tx_info->rate_driver_data));
-	return (struct ath_frame_info *) &tx_info->rate_driver_data[0];
+		     sizeof(tx_info->status.status_driver_data));
+	return (struct ath_frame_info *) &tx_info->status.status_driver_data[0];
 }
 
 static void ath_send_bar(struct ath_atx_tid *tid, u16 seqno)
@@ -2542,6 +2542,16 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	spin_unlock_irqrestore(&sc->tx.txbuflock, flags);
 }
 
+static void ath_clear_tx_status(struct ieee80211_tx_info *tx_info)
+{
+	void *ptr = &tx_info->status;
+
+	memset(ptr + sizeof(tx_info->status.rates), 0,
+	       sizeof(tx_info->status) -
+	       sizeof(tx_info->status.rates) -
+	       sizeof(tx_info->status.status_driver_data));
+}
+
 static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 			     struct ath_tx_status *ts, int nframes, int nbad,
 			     int txok)
@@ -2553,7 +2563,7 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 	struct ath_hw *ah = sc->sc_ah;
 	u8 i, tx_rateindex;
 
-	ieee80211_tx_info_clear_status(tx_info);
+	ath_clear_tx_status(tx_info);
 
 	if (txok)
 		tx_info->status.ack_signal = ts->ts_rssi;
@@ -2569,6 +2579,13 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 	tx_info->status.ampdu_len = nframes;
 	tx_info->status.ampdu_ack_len = nframes - nbad;
 
+	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
+
+	for (i = tx_rateindex + 1; i < hw->max_rates; i++) {
+		tx_info->status.rates[i].count = 0;
+		tx_info->status.rates[i].idx = -1;
+	}
+
 	if ((ts->ts_status & ATH9K_TXERR_FILT) == 0 &&
 	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) == 0) {
 		/*
@@ -2590,13 +2607,6 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 			tx_info->status.rates[tx_rateindex].count =
 				hw->max_rate_tries;
 	}
-
-	for (i = tx_rateindex + 1; i < hw->max_rates; i++) {
-		tx_info->status.rates[i].count = 0;
-		tx_info->status.rates[i].idx = -1;
-	}
-
-	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
 }
 
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
-- 
2.35.1

