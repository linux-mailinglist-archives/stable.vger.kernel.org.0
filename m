Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBAA4526BE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238986AbhKPCKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238791AbhKOR7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:59:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 447FF632CF;
        Mon, 15 Nov 2021 17:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997742;
        bh=sSpDhzScpt00UuWxntFiasssOzC/nJ3VGTws58mP+jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=litGK6Ynu9pWOiXCJ6JNLUMYhsMONY4SgpAm82xYw+m1sE+1un9B+uc/vSWHjeF5u
         g8i7WBwuj/w5JzRuHX1pdsCXsGT3U1qBtnYjHNwUzb2JwZKFVrqYpAwJ6JqPLv6s4d
         HGLHvgr8ITk35v8lSqSUgJvO1PA3rMu0uPO2NpkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/575] wcn36xx: Correct band/freq reporting on RX
Date:   Mon, 15 Nov 2021 17:59:36 +0100
Message-Id: <20211115165352.453569179@linuxfoundation.org>
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

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit 8a27ca39478270e07baf9c09aa0c99709769ba03 ]

For packets originating from hardware scan, the channel and band is
included in the buffer descriptor (bd->rf_band & bd->rx_ch).

For 2Ghz band the channel value is directly reported in the 4-bit
rx_ch field. For 5Ghz band, the rx_ch field contains a mapping
index (given the 4-bit limitation).

The reserved0 value field is also used to extend 4-bit mapping to
5-bit mapping to support more than 16 5Ghz channels.

This change adds correct reporting of the frequency/band, that is
used in scan mechanism. And is required for 5Ghz hardware scan
support.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1634554678-7993-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/txrx.c | 23 +++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/txrx.h |  3 ++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index eaf2410e39647..c0f51fa13dfa1 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -31,6 +31,13 @@ struct wcn36xx_rate {
 	enum rate_info_bw bw;
 };
 
+/* Buffer descriptor rx_ch field is limited to 5-bit (4+1), a mapping is used
+ * for 11A Channels.
+ */
+static const u8 ab_rx_ch_map[] = { 36, 40, 44, 48, 52, 56, 60, 64, 100, 104,
+				   108, 112, 116, 120, 124, 128, 132, 136, 140,
+				   149, 153, 157, 161, 165, 144 };
+
 static const struct wcn36xx_rate wcn36xx_rate_table[] = {
 	/* 11b rates */
 	{  10, 0, RX_ENC_LEGACY, 0, RATE_INFO_BW_20 },
@@ -291,6 +298,22 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 	    ieee80211_is_probe_resp(hdr->frame_control))
 		status.boottime_ns = ktime_get_boottime_ns();
 
+	if (bd->scan_learn) {
+		/* If packet originates from hardware scanning, extract the
+		 * band/channel from bd descriptor.
+		 */
+		u8 hwch = (bd->reserved0 << 4) + bd->rx_ch;
+
+		if (bd->rf_band != 1 && hwch <= sizeof(ab_rx_ch_map) && hwch >= 1) {
+			status.band = NL80211_BAND_5GHZ;
+			status.freq = ieee80211_channel_to_frequency(ab_rx_ch_map[hwch - 1],
+								     status.band);
+		} else {
+			status.band = NL80211_BAND_2GHZ;
+			status.freq = ieee80211_channel_to_frequency(hwch, status.band);
+		}
+	}
+
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
 
 	if (ieee80211_is_beacon(hdr->frame_control)) {
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.h b/drivers/net/wireless/ath/wcn36xx/txrx.h
index 032216e82b2be..b54311ffde9c5 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.h
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.h
@@ -110,7 +110,8 @@ struct wcn36xx_rx_bd {
 	/* 0x44 */
 	u32	exp_seq_num:12;
 	u32	cur_seq_num:12;
-	u32	fr_type_subtype:8;
+	u32	rf_band:2;
+	u32	fr_type_subtype:6;
 
 	/* 0x48 */
 	u32	msdu_size:16;
-- 
2.33.0



