Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54EA451F9F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbhKPAor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:44:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343730AbhKOTVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 846DF635D3;
        Mon, 15 Nov 2021 18:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001913;
        bh=zbbVDabIKGVZ9+LPzrzvUTvMHhXE7JD8nifuWSKT9As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUhcI9nZdz+svBJl7n8LEBfzoFNOr2+UzxGuyBzNSkx6ESrK77/v9DU61feFRJUOV
         Tu9eAlA+xEG/VKnZgWzHKKD82Bpaph5tgm/VVYsZeMOAWhu5jdaOhNNW2k+towmhdp
         p8qFGlX8J5IliIOMkhqVXy3xmA852q+cbzCLhVUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 368/917] ath11k: fix packet drops due to incorrect 6 GHz freq value in rx status
Date:   Mon, 15 Nov 2021 17:57:43 +0100
Message-Id: <20211115165441.238685927@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index af0a600ea067c..0ae6bebff801d 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2337,8 +2337,10 @@ static void ath11k_dp_rx_h_ppdu(struct ath11k *ar, struct hal_rx_desc *rx_desc,
 	channel_num = meta_data;
 	center_freq = meta_data >> 16;
 
-	if (center_freq >= 5935 && center_freq <= 7105) {
+	if (center_freq >= ATH11K_MIN_6G_FREQ &&
+	    center_freq <= ATH11K_MAX_6G_FREQ) {
 		rx_status->band = NL80211_BAND_6GHZ;
+		rx_status->freq = center_freq;
 	} else if (channel_num >= 1 && channel_num <= 14) {
 		rx_status->band = NL80211_BAND_2GHZ;
 	} else if (channel_num >= 36 && channel_num <= 173) {
@@ -2356,8 +2358,9 @@ static void ath11k_dp_rx_h_ppdu(struct ath11k *ar, struct hal_rx_desc *rx_desc,
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
index a53eef8e2631c..99c0b81e496bf 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -6127,8 +6127,10 @@ static void ath11k_mgmt_rx_event(struct ath11k_base *ab, struct sk_buff *skb)
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
@@ -6149,8 +6151,10 @@ static void ath11k_mgmt_rx_event(struct ath11k_base *ab, struct sk_buff *skb)
 
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



