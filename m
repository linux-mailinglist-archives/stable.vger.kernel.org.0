Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1333A3CDD27
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbhGSO4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240602AbhGSOyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:54:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB78561242;
        Mon, 19 Jul 2021 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708792;
        bh=yLm9Ids/xFJbLUQFfomfKXhBtilsf1S2tPUWLQcicis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W33njzRhuRKtVq4dau6tC1LAh1R70JeRgCdLOqmzKXndH0NwJ1jAE0egxQVIeJUZ5
         gKGLB5MkcXryHVPyilxLiui0/B4YKdQC+MPvCpnFkjfJVyflvuUCv+4PWPqhmx1uJI
         roKfMkyi7zRHrRWf2+BmY1snWk/oT/em9rwDTrYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/421] brcmfmac: correctly report average RSSI in station info
Date:   Mon, 19 Jul 2021 16:49:03 +0200
Message-Id: <20210719144951.094741621@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index de8fd5780932..75790b13c962 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2543,8 +2543,9 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
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
 
@@ -2610,24 +2611,27 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
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



