Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3492505434
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241173AbiDRNEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241697AbiDRNDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:03:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB0F33E0E;
        Mon, 18 Apr 2022 05:44:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CC516101A;
        Mon, 18 Apr 2022 12:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573B1C385A1;
        Mon, 18 Apr 2022 12:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285842;
        bh=FsijuT52MCT/PVbdPTYVHlLQ4qELsxbQwBXMUhdZYy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9j2nhKx5m4+2pl5KMW9pJkr4sT65Do+MXe6yzvvR8qWILUEBERInWfd3eGAHhP0v
         igAr7NDjQgNXfZ+wVNcFN/GfSd2j5p5TcmdhGkbRXp9RjVor87ZoCMQbH8oXOGfmTX
         rhE2WChmKs1fVRirRRSW5SiEyi0SEOINOK6P0mVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Seiderer <ps.report@gmx.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.4 42/63] ath9k: Fix usage of driver-private space in tx_info
Date:   Mon, 18 Apr 2022 14:13:39 +0200
Message-Id: <20220418121137.049816471@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit 5a6b06f5927c940fa44026695779c30b7536474c upstream.

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
Reviewed-by: Peter Seiderer <ps.report@gmx.net>
Tested-by: Peter Seiderer <ps.report@gmx.net>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220404204800.2681133-1-toke@toke.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c |   30 ++++++++++++++++++++----------
 2 files changed, 21 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -836,7 +836,7 @@ static bool ath9k_txq_list_has_key(struc
 			continue;
 
 		txinfo = IEEE80211_SKB_CB(bf->bf_mpdu);
-		fi = (struct ath_frame_info *)&txinfo->rate_driver_data[0];
+		fi = (struct ath_frame_info *)&txinfo->status.status_driver_data[0];
 		if (fi->keyix == keyix)
 			return true;
 	}
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -141,8 +141,8 @@ static struct ath_frame_info *get_frame_
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	BUILD_BUG_ON(sizeof(struct ath_frame_info) >
-		     sizeof(tx_info->rate_driver_data));
-	return (struct ath_frame_info *) &tx_info->rate_driver_data[0];
+		     sizeof(tx_info->status.status_driver_data));
+	return (struct ath_frame_info *) &tx_info->status.status_driver_data[0];
 }
 
 static void ath_send_bar(struct ath_atx_tid *tid, u16 seqno)
@@ -2498,6 +2498,16 @@ skip_tx_complete:
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
@@ -2509,7 +2519,7 @@ static void ath_tx_rc_status(struct ath_
 	struct ath_hw *ah = sc->sc_ah;
 	u8 i, tx_rateindex;
 
-	ieee80211_tx_info_clear_status(tx_info);
+	ath_clear_tx_status(tx_info);
 
 	if (txok)
 		tx_info->status.ack_signal = ts->ts_rssi;
@@ -2525,6 +2535,13 @@ static void ath_tx_rc_status(struct ath_
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
@@ -2546,13 +2563,6 @@ static void ath_tx_rc_status(struct ath_
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


