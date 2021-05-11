Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B74137AD9F
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 20:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhEKSE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 14:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbhEKSEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 14:04:23 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C96DC061343;
        Tue, 11 May 2021 11:03:13 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lgWiu-007aAS-3e; Tue, 11 May 2021 20:03:12 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Wen Gong <wgong@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH 13/18] ath10k: drop fragments with multicast DA for SDIO
Date:   Tue, 11 May 2021 20:02:54 +0200
Message-Id: <20210511200110.9ca6ca7945a9.I1e18b514590af17c155bda86699bc3a971a8dcf4@changeid>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511180259.159598-1-johannes@sipsolutions.net>
References: <20210511180259.159598-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

Fragmentation is not used with multicast frames. Discard unexpected
fragments with multicast DA. This fixes CVE-2020-26145.

Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00049

Cc: stable@vger.kernel.org
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index cb04848ed5cb..b1d93ff5215a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2617,6 +2617,13 @@ static bool ath10k_htt_rx_proc_rx_frag_ind_hl(struct ath10k_htt *htt,
 	rx_desc = (struct htt_hl_rx_desc *)(skb->data + tot_hdr_len);
 	rx_desc_info = __le32_to_cpu(rx_desc->info);
 
+	hdr = (struct ieee80211_hdr *)((u8 *)rx_desc + rx_hl->fw_desc.len);
+
+	if (is_multicast_ether_addr(hdr->addr1)) {
+		/* Discard the fragment with multicast DA */
+		goto err;
+	}
+
 	if (!MS(rx_desc_info, HTT_RX_DESC_HL_INFO_ENCRYPTED)) {
 		spin_unlock_bh(&ar->data_lock);
 		return ath10k_htt_rx_proc_rx_ind_hl(htt, &resp->rx_ind_hl, skb,
@@ -2624,8 +2631,6 @@ static bool ath10k_htt_rx_proc_rx_frag_ind_hl(struct ath10k_htt *htt,
 						    HTT_RX_NON_TKIP_MIC);
 	}
 
-	hdr = (struct ieee80211_hdr *)((u8 *)rx_desc + rx_hl->fw_desc.len);
-
 	if (ieee80211_has_retry(hdr->frame_control))
 		goto err;
 
-- 
2.30.2

