Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BAF37AD8D
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 20:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhEKSEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 14:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhEKSEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 14:04:21 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA198C06174A;
        Tue, 11 May 2021 11:03:10 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lgWiq-007aAS-OQ; Tue, 11 May 2021 20:03:08 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>, stable@vger.kernel.org
Subject: [PATCH 01/18] mac80211: assure all fragments are encrypted
Date:   Tue, 11 May 2021 20:02:42 +0200
Message-Id: <20210511200110.30c4394bb835.I5acfdb552cc1d20c339c262315950b3eac491397@changeid>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511180259.159598-1-johannes@sipsolutions.net>
References: <20210511180259.159598-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>

Do not mix plaintext and encrypted fragments in protected Wi-Fi
networks. This fixes CVE-2020-26147.

Previously, an attacker was able to first forward a legitimate encrypted
fragment towards a victim, followed by a plaintext fragment. The
encrypted and plaintext fragment would then be reassembled. For further
details see Section 6.3 and Appendix D in the paper "Fragment and Forge:
Breaking Wi-Fi Through Frame Aggregation and Fragmentation".

Because of this change there are now two equivalent conditions in the
code to determine if a received fragment requires sequential PNs, so we
also move this test to a separate function to make the code easier to
maintain.

Cc: stable@vger.kernel.org
Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 62047e93e217..65fc674e27cc 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2194,6 +2194,16 @@ ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
 	return NULL;
 }
 
+static bool requires_sequential_pn(struct ieee80211_rx_data *rx, __le16 fc)
+{
+	return rx->key &&
+		(rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP ||
+		 rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP_256 ||
+		 rx->key->conf.cipher == WLAN_CIPHER_SUITE_GCMP ||
+		 rx->key->conf.cipher == WLAN_CIPHER_SUITE_GCMP_256) &&
+		ieee80211_has_protected(fc);
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 {
@@ -2238,12 +2248,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		/* This is the first fragment of a new frame. */
 		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
 						 rx->seqno_idx, &(rx->skb));
-		if (rx->key &&
-		    (rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP ||
-		     rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP_256 ||
-		     rx->key->conf.cipher == WLAN_CIPHER_SUITE_GCMP ||
-		     rx->key->conf.cipher == WLAN_CIPHER_SUITE_GCMP_256) &&
-		    ieee80211_has_protected(fc)) {
+		if (requires_sequential_pn(rx, fc)) {
 			int queue = rx->security_idx;
 
 			/* Store CCMP/GCMP PN so that we can verify that the
@@ -2285,11 +2290,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		u8 pn[IEEE80211_CCMP_PN_LEN], *rpn;
 		int queue;
 
-		if (!rx->key ||
-		    (rx->key->conf.cipher != WLAN_CIPHER_SUITE_CCMP &&
-		     rx->key->conf.cipher != WLAN_CIPHER_SUITE_CCMP_256 &&
-		     rx->key->conf.cipher != WLAN_CIPHER_SUITE_GCMP &&
-		     rx->key->conf.cipher != WLAN_CIPHER_SUITE_GCMP_256))
+		if (!requires_sequential_pn(rx, fc))
 			return RX_DROP_UNUSABLE;
 		memcpy(pn, entry->last_pn, IEEE80211_CCMP_PN_LEN);
 		for (i = IEEE80211_CCMP_PN_LEN - 1; i >= 0; i--) {
-- 
2.30.2

