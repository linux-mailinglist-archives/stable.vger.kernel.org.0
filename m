Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B3E37ADA8
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 20:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhEKSEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 14:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhEKSEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 14:04:24 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD45C061348;
        Tue, 11 May 2021 11:03:15 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lgWiv-007aAS-FH; Tue, 11 May 2021 20:03:13 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sriram R <srirrama@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH 18/18] ath11k: Drop multicast fragments
Date:   Tue, 11 May 2021 20:02:59 +0200
Message-Id: <20210511200110.1d53bfd20a8b.Ibb63283051bb5e2c45951932c6e1f351d5a73dc3@changeid>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511180259.159598-1-johannes@sipsolutions.net>
References: <20210511180259.159598-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriram R <srirrama@codeaurora.org>

Fragmentation is used only with unicast frames. Drop multicast fragments
to avoid any undesired behavior.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01734-QCAHKSWPL_SILICONZ-1 v2

Cc: stable@vger.kernel.org
Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 3382f8bfcb48..603d2f93ac18 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -260,6 +260,16 @@ static void ath11k_dp_rxdesc_set_msdu_len(struct ath11k_base *ab,
 	ab->hw_params.hw_ops->rx_desc_set_msdu_len(desc, len);
 }
 
+static bool ath11k_dp_rx_h_attn_is_mcbc(struct ath11k_base *ab,
+					struct hal_rx_desc *desc)
+{
+	struct rx_attention *attn = ath11k_dp_rx_get_attention(ab, desc);
+
+	return ath11k_dp_rx_h_msdu_end_first_msdu(ab, desc) &&
+		(!!FIELD_GET(RX_ATTENTION_INFO1_MCAST_BCAST,
+		 __le32_to_cpu(attn->info1)));
+}
+
 static void ath11k_dp_service_mon_ring(struct timer_list *t)
 {
 	struct ath11k_base *ab = from_timer(ab, t, mon_reap_timer);
@@ -3468,6 +3478,7 @@ static int ath11k_dp_rx_frag_h_mpdu(struct ath11k *ar,
 	u8 tid;
 	int ret = 0;
 	bool more_frags;
+	bool is_mcbc;
 
 	rx_desc = (struct hal_rx_desc *)msdu->data;
 	peer_id = ath11k_dp_rx_h_mpdu_start_peer_id(ar->ab, rx_desc);
@@ -3475,6 +3486,11 @@ static int ath11k_dp_rx_frag_h_mpdu(struct ath11k *ar,
 	seqno = ath11k_dp_rx_h_mpdu_start_seq_no(ar->ab, rx_desc);
 	frag_no = ath11k_dp_rx_h_mpdu_start_frag_no(ar->ab, msdu);
 	more_frags = ath11k_dp_rx_h_mpdu_start_more_frags(ar->ab, msdu);
+	is_mcbc = ath11k_dp_rx_h_attn_is_mcbc(ar->ab, rx_desc);
+
+	/* Multicast/Broadcast fragments are not expected */
+	if (is_mcbc)
+		return -EINVAL;
 
 	if (!ath11k_dp_rx_h_mpdu_start_seq_ctrl_valid(ar->ab, rx_desc) ||
 	    !ath11k_dp_rx_h_mpdu_start_fc_valid(ar->ab, rx_desc) ||
-- 
2.30.2

