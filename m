Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B1139510F
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 15:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhE3Nnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 09:43:41 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:38216 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhE3Nnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 09:43:40 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 May 2021 09:43:40 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1622381610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hxcehSV8QaHK1iGq8z5tSsnm6CF6iHJbAMOXME7h/rQ=;
        b=0Tuf7z7kk1GIWRlDFKkUjN1vBE2VHW7ZrT0CwnZXFkrD1Gw8SoCzrYo/Kzz4T/4uJTMRZV
        6JkoJaukex6HxrZojmoCTbhY0IhDAplfUJUIZIVEyRsjN0YU3tBBWgLWyuUlqyMOMP0aAY
        aKh54Epp2nalu76qua+SNQAFSVTZ3eI=
From:   Sven Eckelmann <sven@narfation.org>
To:     linux-wireless@vger.kernel.org
Cc:     Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>, stable@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH] mac80211: Fix NULL ptr deref for injected rate info
Date:   Sun, 30 May 2021 15:32:26 +0200
Message-Id: <20210530133226.40587-1-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>

The commit cb17ed29a7a5 ("mac80211: parse radiotap header when selecting Tx
queue") moved the code to validate the radiotap header from
ieee80211_monitor_start_xmit to ieee80211_parse_tx_radiotap. This made is
possible to share more code with the new Tx queue selection code for
injected frames. But at the same time, it now required the call of
ieee80211_parse_tx_radiotap at the beginning of functions which wanted to
handle the radiotap header. And this broke the rate parser for radiotap
header parser.

The radiotap parser for rates is operating most of the time only on the
data in the actual radiotap header. But for the 802.11a/b/g rates, it must
also know the selected band from the chandef information. But this
information is only written to the ieee80211_tx_info at the end of the
ieee80211_monitor_start_xmit - long after ieee80211_parse_tx_radiotap was
already called. The info->band information was therefore always 0
(NL80211_BAND_2GHZ) when the parser code tried to access it.

For a 5GHz only device, injecting a frame with 802.11a rates would cause a
NULL pointer dereference because local->hw.wiphy->bands[NL80211_BAND_2GHZ]
would most likely have been NULL when the radiotap parser searched for the
correct rate index of the driver.

Cc: stable@vger.kernel.org
Reported-by: Ben Greear <greearb@candelatech.com>
Fixes: cb17ed29a7a5 ("mac80211: parse radiotap header when selecting Tx queue")
Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
[sven@narfation.org: added commit message]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 include/net/mac80211.h |  7 +++++-
 net/mac80211/tx.c      | 52 +++++++++++++++++++++++++++++-------------
 2 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 445b66c6eb7e..d4a539c70521 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6392,7 +6392,12 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 
 /**
  * ieee80211_parse_tx_radiotap - Sanity-check and parse the radiotap header
- *				 of injected frames
+ *				 of injected frames.
+ *
+ * To accurately parse and take into account rate and retransmission fields,
+ * you must initialize the chandef field in the ieee80211_tx_info structure
+ * of the skb before calling this function.
+ *
  * @skb: packet injected by userspace
  * @dev: the &struct device of this 802.11 device
  */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0b719f3d2dec..2651498d05e8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2014,6 +2014,26 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx(sdata, sta, skb, false);
 }
 
+static bool ieee80211_validate_radiotap_len(struct sk_buff *skb)
+{
+	struct ieee80211_radiotap_header *rthdr =
+		(struct ieee80211_radiotap_header *)skb->data;
+
+	/* check for not even having the fixed radiotap header part */
+	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
+		return false; /* too short to be possibly valid */
+
+	/* is it a header version we can trust to find length from? */
+	if (unlikely(rthdr->it_version))
+		return false; /* only version 0 is supported */
+
+	/* does the skb contain enough to deliver on the alleged length? */
+	if (unlikely(skb->len < ieee80211_get_radiotap_len(skb->data)))
+		return false; /* skb too short for claimed rt header extent */
+
+	return true;
+}
+
 bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 				 struct net_device *dev)
 {
@@ -2022,8 +2042,6 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_supported_band *sband =
-		local->hw.wiphy->bands[info->band];
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
 						   NULL);
 	u16 txflags;
@@ -2036,17 +2054,8 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	u8 vht_mcs = 0, vht_nss = 0;
 	int i;
 
-	/* check for not even having the fixed radiotap header part */
-	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
-		return false; /* too short to be possibly valid */
-
-	/* is it a header version we can trust to find length from? */
-	if (unlikely(rthdr->it_version))
-		return false; /* only version 0 is supported */
-
-	/* does the skb contain enough to deliver on the alleged length? */
-	if (unlikely(skb->len < ieee80211_get_radiotap_len(skb->data)))
-		return false; /* skb too short for claimed rt header extent */
+	if (!ieee80211_validate_radiotap_len(skb))
+		return false;
 
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 		       IEEE80211_TX_CTL_DONTFRAG;
@@ -2186,6 +2195,9 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 		return false;
 
 	if (rate_found) {
+		struct ieee80211_supported_band *sband =
+			local->hw.wiphy->bands[info->band];
+
 		info->control.flags |= IEEE80211_TX_CTRL_RATE_INJECT;
 
 		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
@@ -2199,7 +2211,7 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 		} else if (rate_flags & IEEE80211_TX_RC_VHT_MCS) {
 			ieee80211_rate_set_vht(info->control.rates, vht_mcs,
 					       vht_nss);
-		} else {
+		} else if (sband) {
 			for (i = 0; i < sband->n_bitrates; i++) {
 				if (rate * 5 != sband->bitrates[i].bitrate)
 					continue;
@@ -2236,8 +2248,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
 		      IEEE80211_TX_CTL_INJECTED;
 
-	/* Sanity-check and process the injection radiotap header */
-	if (!ieee80211_parse_tx_radiotap(skb, dev))
+	/* Sanity-check the length of the radiotap header */
+	if (!ieee80211_validate_radiotap_len(skb))
 		goto fail;
 
 	/* we now know there is a radiotap header with a length we can use */
@@ -2351,6 +2363,14 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	ieee80211_select_queue_80211(sdata, skb, hdr);
 	skb_set_queue_mapping(skb, ieee80211_ac_from_tid(skb->priority));
 
+	/*
+	 * Process the radiotap header. This will now take into account the
+	 * selected chandef above to accurately set injection rates and
+	 * retransmissions.
+	 */
+	if (!ieee80211_parse_tx_radiotap(skb, dev))
+		goto fail_rcu;
+
 	/* remove the injection radiotap header */
 	skb_pull(skb, len_rthdr);
 
-- 
2.30.2

