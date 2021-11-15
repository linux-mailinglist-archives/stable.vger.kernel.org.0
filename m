Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BBF450DC8
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbhKOSHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:07:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239543AbhKOSBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:01:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13DD563349;
        Mon, 15 Nov 2021 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997806;
        bh=9+lUQniHAAywrW77hocU9ltMPxQVAbh3iCnAv3SaDK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2DKeLzSWR3kml0B6BaaBX1StJlIfSl9NHeZSdE7lRdPFffqZEYyanWlqFCevS9DU
         j8Hd+M9Wfb/WaL5UswxCv3mzok1pugCdGM+2W8GPEuETn0263g74w1PQH+hI2aIHRA
         5SuisMfwW2+u1/b29Ff2cF4qBi4PX978BMMF2ON0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/575] ath11k: fix packet drops due to incorrect 6 GHz freq value in rx status
Date:   Mon, 15 Nov 2021 18:00:06 +0100
Message-Id: <20211115165353.498364994@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>

[ Upstream commit 9d6ae1f5cf733c0e8d7f904c501fd015c4b9f0f4 ]

Frequency in rx status is being filled incorrectly in the 6 GHz band as
channel number received is invalid in this case which is causing packet
drops. So fix that.

Fixes: 5dcf42f8b79d ("ath11k: Use freq instead of channel number in rx path")
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210722102054.43419-2-jouni@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c |  9 ++++++---
 drivers/net/wireless/ath/ath11k/wmi.c   | 10 +++++++---
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 7d6fd8155bb22..2e77dca6b1ad6 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2303,8 +2303,10 @@ static void ath11k_dp_rx_h_ppdu(struct ath11k *ar, struct hal_rx_desc *rx_desc,
 	channel_num = ath11k_dp_rx_h_msdu_start_freq(rx_desc);
 	center_freq = ath11k_dp_rx_h_msdu_start_freq(rx_desc) >> 16;
 
-	if (center_freq >= 5935 && center_freq <= 7105) {
+	if (center_freq >= ATH11K_MIN_6G_FREQ &&
+	    center_freq <= ATH11K_MAX_6G_FREQ) {
 		rx_status->band = NL80211_BAND_6GHZ;
+		rx_status->freq = center_freq;
 	} else if (channel_num >= 1 && channel_num <= 14) {
 		rx_status->band = NL80211_BAND_2GHZ;
 	} else if (channel_num >= 36 && channel_num <= 173) {
@@ -2322,8 +2324,9 @@ static void ath11k_dp_rx_h_ppdu(struct ath11k *ar, struct hal_rx_desc *rx_desc,
 				rx_desc, sizeof(struct hal_rx_desc));
 	}
 
-	rx_status->freq = ieee80211_channel_to_frequency(channel_num,
-							 rx_status->band);
+	if (rx_status->band != NL80211_BAND_6GHZ)
+		rx_status->freq = ieee80211_channel_to_frequency(channel_num,
+								 rx_status->band);
 
 	ath11k_dp_rx_h_rate(ar, rx_desc, rx_status);
 }
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index e17419c8dde0d..74ebe8e7d1d81 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5668,8 +5668,10 @@ static void ath11k_mgmt_rx_event(struct ath11k_base *ab, struct sk_buff *skb)
 	if (rx_ev.status & WMI_RX_STATUS_ERR_MIC)
 		status->flag |= RX_FLAG_MMIC_ERROR;
 
-	if (rx_ev.chan_freq >= ATH11K_MIN_6G_FREQ) {
+	if (rx_ev.chan_freq >= ATH11K_MIN_6G_FREQ &&
+	    rx_ev.chan_freq <= ATH11K_MAX_6G_FREQ) {
 		status->band = NL80211_BAND_6GHZ;
+		status->freq = rx_ev.chan_freq;
 	} else if (rx_ev.channel >= 1 && rx_ev.channel <= 14) {
 		status->band = NL80211_BAND_2GHZ;
 	} else if (rx_ev.channel >= 36 && rx_ev.channel <= ATH11K_MAX_5G_CHAN) {
@@ -5690,8 +5692,10 @@ static void ath11k_mgmt_rx_event(struct ath11k_base *ab, struct sk_buff *skb)
 
 	sband = &ar->mac.sbands[status->band];
 
-	status->freq = ieee80211_channel_to_frequency(rx_ev.channel,
-						      status->band);
+	if (status->band != NL80211_BAND_6GHZ)
+		status->freq = ieee80211_channel_to_frequency(rx_ev.channel,
+							      status->band);
+
 	status->signal = rx_ev.snr + ATH11K_DEFAULT_NOISE_FLOOR;
 	status->rate_idx = ath11k_mac_bitrate_to_idx(sband, rx_ev.rate / 100);
 
-- 
2.33.0



