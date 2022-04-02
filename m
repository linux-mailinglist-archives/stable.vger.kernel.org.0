Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8365C4F016B
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiDBM3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiDBM3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:29:48 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C70D5EA4;
        Sat,  2 Apr 2022 05:27:57 -0700 (PDT)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648902475; bh=O24983sUH73+7zh8F7+H1u+iS+44kE3Ad9wzWR8/DZU=;
        h=From:To:Cc:Subject:Date:From;
        b=TLfBjWhCeW9Lko2a7ewORthmCRjNnda1Yv2ADndIupf/1/T5MHTT+eXIoOGUi19ap
         H/JsW3XwXHp+7jsQvXtMxtxMq4tBywKLhIMO9dbjeHiyejIH55kMvnUHWlt5gATMPg
         aUjIDAstJfdGqI+ALZMooR4oxI6Ms8pLU/gcckNptqwoDC/DwjHN/7H26ATA1yvA1h
         njdgBlQh1kbgWmV0FFkI3y4tBbaE+y9KVpBXd8NZQupsIJz5DGPNI6R1nJpdKwWcRt
         ceYU3d7InewfiKPoY99LqyLtJ7JpzJ9DGPV/cnwJePkJHyJveEGiL97zxYxAIdnC41
         vQ+GBEwESIY0g==
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        stable@vger.kernel.org, Peter Seiderer <ps.report@gmx.net>
Subject: [PATCH v5.18] ath9k: Save rate counts before clearing tx status area
Date:   Sat,  2 Apr 2022 14:27:51 +0200
Message-Id: <20220402122752.2347797-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The ieee80211_tx_info_clear_status() helper also clears the rate counts, so
we should restore them after clearing. However, we can get rid of the
existing clearing of the counts of invalid rates. Rearrange the code a bit
so the order fits the indexes, and so the setting of the count to
hw->max_rate_tries on underrun is not immediately overridden.

Cc: stable@vger.kernel.org
Reported-by: Peter Seiderer <ps.report@gmx.net>
Fixes: 037250f0a45c ("ath9k: Properly clear TX status area before reporting to mac80211")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index cbcf96ac303e..ac7efecff29c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2551,16 +2551,19 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hw *hw = sc->hw;
 	struct ath_hw *ah = sc->sc_ah;
-	u8 i, tx_rateindex;
+	u8 i, tx_rateindex, tries[IEEE80211_TX_MAX_RATES];
+
+	tx_rateindex = ts->ts_rateindex;
+	WARN_ON(tx_rateindex >= hw->max_rates);
+
+	for (i = 0; i < tx_rateindex; i++)
+		tries[i] = tx_info->status.rates[i].count;
 
 	ieee80211_tx_info_clear_status(tx_info);
 
 	if (txok)
 		tx_info->status.ack_signal = ts->ts_rssi;
 
-	tx_rateindex = ts->ts_rateindex;
-	WARN_ON(tx_rateindex >= hw->max_rates);
-
 	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
 
@@ -2569,6 +2572,14 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 	tx_info->status.ampdu_len = nframes;
 	tx_info->status.ampdu_ack_len = nframes - nbad;
 
+	for (i = 0; i < tx_rateindex; i++)
+		tx_info->status.rates[i].count = tries[i];
+
+	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
+
+	for (i = tx_rateindex + 1; i < hw->max_rates; i++)
+		tx_info->status.rates[i].idx = -1;
+
 	if ((ts->ts_status & ATH9K_TXERR_FILT) == 0 &&
 	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) == 0) {
 		/*
@@ -2591,12 +2602,6 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 				hw->max_rate_tries;
 	}
 
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

