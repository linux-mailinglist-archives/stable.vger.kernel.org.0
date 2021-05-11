Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A0E37ADA4
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 20:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhEKSE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 14:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbhEKSEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 14:04:24 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC3AC061346;
        Tue, 11 May 2021 11:03:14 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lgWiu-007aAS-UV; Tue, 11 May 2021 20:03:13 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sriram R <srirrama@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH 16/18] ath10k: Validate first subframe of A-MSDU before processing the list
Date:   Tue, 11 May 2021 20:02:57 +0200
Message-Id: <20210511200110.e6f5eb7b9847.I38a77ae26096862527a5eab73caebd7346af8b66@changeid>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511180259.159598-1-johannes@sipsolutions.net>
References: <20210511180259.159598-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriram R <srirrama@codeaurora.org>

In certain scenarios a normal MSDU can be received as an A-MSDU when
the A-MSDU present bit of a QoS header gets flipped during reception.
Since this bit is unauthenticated, the hardware crypto engine can pass
the frame to the driver without any error indication.

This could result in processing unintended subframes collected in the
A-MSDU list. Hence, validate A-MSDU list by checking if the first frame
has a valid subframe header.

Comparing the non-aggregated MSDU and an A-MSDU, the fields of the first
subframe DA matches the LLC/SNAP header fields of a normal MSDU.
In order to avoid processing such frames, add a validation to
filter such A-MSDU frames where the first subframe header DA matches
with the LLC/SNAP header pattern.

Tested-on: QCA9984 hw1.0 PCI 10.4-3.10-00047

Cc: stable@vger.kernel.org
Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 61 ++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 87196f9bbdea..7ffb5d5b2a70 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2108,14 +2108,62 @@ static void ath10k_htt_rx_h_unchain(struct ath10k *ar,
 	ath10k_unchain_msdu(amsdu, unchain_cnt);
 }
 
+static bool ath10k_htt_rx_validate_amsdu(struct ath10k *ar,
+					 struct sk_buff_head *amsdu)
+{
+	u8 *subframe_hdr;
+	struct sk_buff *first;
+	bool is_first, is_last;
+	struct htt_rx_desc *rxd;
+	struct ieee80211_hdr *hdr;
+	size_t hdr_len, crypto_len;
+	enum htt_rx_mpdu_encrypt_type enctype;
+	int bytes_aligned = ar->hw_params.decap_align_bytes;
+
+	first = skb_peek(amsdu);
+
+	rxd = (void *)first->data - sizeof(*rxd);
+	hdr = (void *)rxd->rx_hdr_status;
+
+	is_first = !!(rxd->msdu_end.common.info0 &
+		      __cpu_to_le32(RX_MSDU_END_INFO0_FIRST_MSDU));
+	is_last = !!(rxd->msdu_end.common.info0 &
+		     __cpu_to_le32(RX_MSDU_END_INFO0_LAST_MSDU));
+
+	/* Return in case of non-aggregated msdu */
+	if (is_first && is_last)
+		return true;
+
+	/* First msdu flag is not set for the first msdu of the list */
+	if (!is_first)
+		return false;
+
+	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
+		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
+
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	crypto_len = ath10k_htt_rx_crypto_param_len(ar, enctype);
+
+	subframe_hdr = (u8 *)hdr + round_up(hdr_len, bytes_aligned) +
+		       crypto_len;
+
+	/* Validate if the amsdu has a proper first subframe.
+	 * There are chances a single msdu can be received as amsdu when
+	 * the unauthenticated amsdu flag of a QoS header
+	 * gets flipped in non-SPP AMSDU's, in such cases the first
+	 * subframe has llc/snap header in place of a valid da.
+	 * return false if the da matches rfc1042 pattern
+	 */
+	if (ether_addr_equal(subframe_hdr, rfc1042_header))
+		return false;
+
+	return true;
+}
+
 static bool ath10k_htt_rx_amsdu_allowed(struct ath10k *ar,
 					struct sk_buff_head *amsdu,
 					struct ieee80211_rx_status *rx_status)
 {
-	/* FIXME: It might be a good idea to do some fuzzy-testing to drop
-	 * invalid/dangerous frames.
-	 */
-
 	if (!rx_status->freq) {
 		ath10k_dbg(ar, ATH10K_DBG_HTT, "no channel configured; ignoring frame(s)!\n");
 		return false;
@@ -2126,6 +2174,11 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k *ar,
 		return false;
 	}
 
+	if (!ath10k_htt_rx_validate_amsdu(ar, amsdu)) {
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "invalid amsdu received\n");
+		return false;
+	}
+
 	return true;
 }
 
-- 
2.30.2

