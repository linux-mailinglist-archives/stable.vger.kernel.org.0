Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175583C4718
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbhGLGbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235394AbhGLG2Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:28:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D06A460238;
        Mon, 12 Jul 2021 06:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071067;
        bh=F9SIDCiiOgggij/nFc2jQ1bIscshgURVE6L4/SdvtLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiy96kz/JmoRuLGq24OewdLs8rCgM2zUEqGTUXC8E0fQOKIIbQT56byyISM8KX4vb
         BpbrdBcms28UqPJB7RNJ1hDOVse9VLqMdWF/VJ7LJWw2U8dpQ5jvPUVYrf83Y9FlkC
         EapNyTUyWNfmRJm772YAtxTwFdFeoLsS2rzfNzBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 207/348] brcmfmac: correctly report average RSSI in station info
Date:   Mon, 12 Jul 2021 08:09:51 +0200
Message-Id: <20210712060729.020886722@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Šipraga <ALSI@bang-olufsen.dk>

[ Upstream commit 9a1590934d9a02e570636432b93052c0c035f31f ]

The rx_lastpkt_rssi field provided by the firmware is suitable for
NL80211_STA_INFO_{SIGNAL,CHAIN_SIGNAL}, while the rssi field is an
average. Fix up the assignments and set the correct STA_INFO bits. This
lets userspace know that the average RSSI is part of the station info.

Fixes: cae355dc90db ("brcmfmac: Add RSSI information to get_station.")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210506132010.3964484-2-alsi@bang-olufsen.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 36 ++++++++++---------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 626449c1e897..6439adcd2f99 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2612,8 +2612,9 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_sta_info_le sta_info_le;
 	u32 sta_flags;
 	u32 is_tdls_peer;
-	s32 total_rssi;
-	s32 count_rssi;
+	s32 total_rssi_avg = 0;
+	s32 total_rssi = 0;
+	s32 count_rssi = 0;
 	int rssi;
 	u32 i;
 
@@ -2679,24 +2680,27 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BYTES);
 			sinfo->rx_bytes = le64_to_cpu(sta_info_le.rx_tot_bytes);
 		}
-		total_rssi = 0;
-		count_rssi = 0;
 		for (i = 0; i < BRCMF_ANT_MAX; i++) {
-			if (sta_info_le.rssi[i]) {
-				sinfo->chains |= BIT(count_rssi);
-				sinfo->chain_signal_avg[count_rssi] =
-					sta_info_le.rssi[i];
-				sinfo->chain_signal[count_rssi] =
-					sta_info_le.rssi[i];
-				total_rssi += sta_info_le.rssi[i];
-				count_rssi++;
-			}
+			if (sta_info_le.rssi[i] == 0 ||
+			    sta_info_le.rx_lastpkt_rssi[i] == 0)
+				continue;
+			sinfo->chains |= BIT(count_rssi);
+			sinfo->chain_signal[count_rssi] =
+				sta_info_le.rx_lastpkt_rssi[i];
+			sinfo->chain_signal_avg[count_rssi] =
+				sta_info_le.rssi[i];
+			total_rssi += sta_info_le.rx_lastpkt_rssi[i];
+			total_rssi_avg += sta_info_le.rssi[i];
+			count_rssi++;
 		}
 		if (count_rssi) {
-			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL);
 			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
-			total_rssi /= count_rssi;
-			sinfo->signal = total_rssi;
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL_AVG);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL);
+			sinfo->filled |=
+				BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL_AVG);
+			sinfo->signal = total_rssi / count_rssi;
+			sinfo->signal_avg = total_rssi_avg / count_rssi;
 		} else if (test_bit(BRCMF_VIF_STATUS_CONNECTED,
 			&ifp->vif->sme_state)) {
 			memset(&scb_val, 0, sizeof(scb_val));
-- 
2.30.2



