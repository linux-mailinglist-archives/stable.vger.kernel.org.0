Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D6E411CC7
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345879AbhITRNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344759AbhITRLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:11:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FA1961872;
        Mon, 20 Sep 2021 16:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157017;
        bh=b8H0HunHmHK0w1E2yHB/xjSngPAyIzA85o6k2sqwxaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQh6CELmIKWiZaiZ3QzrhUp3Wu6Bn5Ej5NCzgoH14mEW1dwvnZdEx1qzlKUL5BTyP
         +MpPmLG/VpJGuGKFBU1dnCgXHPC0Ro5ASsWCmIDXKkUGhMbaJvFwTxyq5O1XKNsqVI
         OMdi34wIZUxk+uaZa7u2n7fjNuWWhyaDoynJ2oZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 016/217] ath10k: fix recent bandwidth conversion bug
Date:   Mon, 20 Sep 2021 18:40:37 +0200
Message-Id: <20210920163925.160980523@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

commit 91493e8e10f0f495b04a5c32096d56ea1f254c93 upstream.

The commit "cfg80211: make RATE_INFO_BW_20 the default" changed
the index of RATE_INFO_BW_20, but the updates to ath10k missed
the special bandwidth calculation case in
ath10k_update_per_peer_tx_stats().

This will fix below warning,

 WARNING: CPU: 0 PID: 609 at net/wireless/util.c:1254
 cfg80211_calculate_bitrate+0x174/0x220
 invalid rate bw=1, mcs=9, nss=2

 (unwind_backtrace) from
 (cfg80211_calculate_bitrate+0x174/0x220)
 (cfg80211_calculate_bitrate) from
 (nl80211_put_sta_rate+0x44/0x1dc)from
 (nl80211_put_sta_rate) from
 (nl80211_send_station+0x388/0xaf0)
 (nl80211_get_station+0xa8/0xec)
 [ end trace da8257d6a850e91a ]

Fixes: 842be75c77cb ("cfg80211: make RATE_INFO_BW_20 the default")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   42 +++++++++++++++++--------------
 1 file changed, 24 insertions(+), 18 deletions(-)

--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -613,6 +613,28 @@ struct amsdu_subframe_hdr {
 
 #define GROUP_ID_IS_SU_MIMO(x) ((x) == 0 || (x) == 63)
 
+static inline u8 ath10k_bw_to_mac80211_bw(u8 bw)
+{
+	u8 ret = 0;
+
+	switch (bw) {
+	case 0:
+		ret = RATE_INFO_BW_20;
+		break;
+	case 1:
+		ret = RATE_INFO_BW_40;
+		break;
+	case 2:
+		ret = RATE_INFO_BW_80;
+		break;
+	case 3:
+		ret = RATE_INFO_BW_160;
+		break;
+	}
+
+	return ret;
+}
+
 static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 				  struct ieee80211_rx_status *status,
 				  struct htt_rx_desc *rxd)
@@ -721,23 +743,7 @@ static void ath10k_htt_rx_h_rates(struct
 		if (sgi)
 			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
-		switch (bw) {
-		/* 20MHZ */
-		case 0:
-			break;
-		/* 40MHZ */
-		case 1:
-			status->bw = RATE_INFO_BW_40;
-			break;
-		/* 80MHZ */
-		case 2:
-			status->bw = RATE_INFO_BW_80;
-			break;
-		case 3:
-			status->bw = RATE_INFO_BW_160;
-			break;
-		}
-
+		status->bw = ath10k_bw_to_mac80211_bw(bw);
 		status->encoding = RX_ENC_VHT;
 		break;
 	default:
@@ -2436,7 +2442,7 @@ ath10k_update_per_peer_tx_stats(struct a
 		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
 
 	arsta->txrate.nss = txrate.nss;
-	arsta->txrate.bw = txrate.bw + RATE_INFO_BW_20;
+	arsta->txrate.bw = ath10k_bw_to_mac80211_bw(txrate.bw);
 }
 
 static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,


