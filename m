Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276842A5996
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbgKCUk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730206AbgKCUkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:40:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51340223AB;
        Tue,  3 Nov 2020 20:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436024;
        bh=vbhmWNAfFloNN1ZhGiiBhaSAizStjkbh4+d9cRpkQLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFUoJltB2BAUUgSuxEPZz/+wqqxEWbJsiGhDNHe2ttvHhx4D6AYb+IkjphxOrecc5
         cnWhfXoNNFJ9xQmTrEoUchpzEDiXH/uMgKpB/yf57ZRJez0CTpfmPasRO9s9Si7xuN
         EGcbh4fctuoditHGhuncKbMsd+xKWDZlNOd4aaBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 071/391] ath10k: fix retry packets update in station dump
Date:   Tue,  3 Nov 2020 21:32:02 +0100
Message-Id: <20201103203352.025477759@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkateswara Naralasetty <vnaralas@codeaurora.org>

[ Upstream commit 67b927f9820847d30e97510b2f00cd142b9559b6 ]

When tx status enabled, retry count is updated from tx completion status.
which is not working as expected due to firmware limitation where
firmware can not provide per MSDU rate statistics from tx completion
status. Due to this tx retry count is always 0 in station dump.

Fix this issue by updating the retry packet count from per peer
statistics. This patch will not break on SDIO devices since, this retry
count is already updating from peer statistics for SDIO devices.

Tested-on: QCA9984 PCI 10.4-3.6-00104
Tested-on: QCA9882 PCI 10.2.4-1.0-00047

Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1591856446-26977-1-git-send-email-vnaralas@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 8 +++++---
 drivers/net/wireless/ath/ath10k/mac.c    | 5 +++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 215ade6faf328..69ad4ca1a87c1 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -3583,12 +3583,14 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 	}
 
 	if (ar->htt.disable_tx_comp) {
-		arsta->tx_retries += peer_stats->retry_pkts;
 		arsta->tx_failed += peer_stats->failed_pkts;
-		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx retries %d tx failed %d\n",
-			   arsta->tx_retries, arsta->tx_failed);
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "tx failed %d\n",
+			   arsta->tx_failed);
 	}
 
+	arsta->tx_retries += peer_stats->retry_pkts;
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx retries %d", arsta->tx_retries);
+
 	if (ath10k_debug_is_extd_tx_stats_enabled(ar))
 		ath10k_accumulate_per_peer_tx_stats(ar, arsta, peer_stats,
 						    rate_idx);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2177e9d92bdff..03c7edf05a1d1 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8542,12 +8542,13 @@ static void ath10k_sta_statistics(struct ieee80211_hw *hw,
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 
 	if (ar->htt.disable_tx_comp) {
-		sinfo->tx_retries = arsta->tx_retries;
-		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_RETRIES);
 		sinfo->tx_failed = arsta->tx_failed;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 	}
 
+	sinfo->tx_retries = arsta->tx_retries;
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_RETRIES);
+
 	ath10k_mac_sta_get_peer_stats_info(ar, sta, sinfo);
 }
 
-- 
2.27.0



