Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4F7395BA4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhEaNXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhEaNU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B591613C1;
        Mon, 31 May 2021 13:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467122;
        bh=4E+nc63r0mEuXc726KefRqJjDnaV6ISLk7S99gQVJkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2kq3i3hRQYpTzBOxRx83IGcqhoPlG23/mpiAeZb7s77MATKVdmzAoQykUGED1hrsV
         ljwUBivRIH/n40aUhhYcX3m0Z3Biaydxq40aiuLn6LPjrbZqOx1TNDfOqyFTYL3RTd
         /i7WI8jJfxTPYluH0PprahLg4w6w2ZoaSI/V6aYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sriram R <srirrama@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.9 13/66] ath10k: Validate first subframe of A-MSDU before processing the list
Date:   Mon, 31 May 2021 15:13:46 +0200
Message-Id: <20210531130636.683554299@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriram R <srirrama@codeaurora.org>

commit 62a8ff67eba52dae9b107e1fb8827054ed00a265 upstream.

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
Link: https://lore.kernel.org/r/20210511200110.e6f5eb7b9847.I38a77ae26096862527a5eab73caebd7346af8b66@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   61 ++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1582,14 +1582,62 @@ static void ath10k_htt_rx_h_unchain(stru
 	ath10k_unchain_msdu(amsdu);
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
 		ath10k_warn(ar, "no channel configured; ignoring frame(s)!\n");
 		return false;
@@ -1600,6 +1648,11 @@ static bool ath10k_htt_rx_amsdu_allowed(
 		return false;
 	}
 
+	if (!ath10k_htt_rx_validate_amsdu(ar, amsdu)) {
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "invalid amsdu received\n");
+		return false;
+	}
+
 	return true;
 }
 


