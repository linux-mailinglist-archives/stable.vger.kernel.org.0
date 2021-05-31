Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178F53968C7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhEaUab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbhEaUaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:30:24 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE67C0613CE;
        Mon, 31 May 2021 13:28:42 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnoWe-000F0y-9x; Mon, 31 May 2021 22:28:40 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v4.4 07/10] mac80211: check defrag PN against current frame
Date:   Mon, 31 May 2021 22:28:31 +0200
Message-Id: <20210531202834.179810-8-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531202834.179810-1-johannes@sipsolutions.net>
References: <20210531202834.179810-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit bf30ca922a0c0176007e074b0acc77ed345e9990 upstream.

As pointed out by Mathy Vanhoef, we implement the RX PN check
on fragmented frames incorrectly - we check against the last
received PN prior to the new frame, rather than to the one in
this frame itself.

Prior patches addressed the security issue here, but in order
to be able to reason better about the code, fix it to really
compare against the current frame's PN, not the last stored
one.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210511200110.bfbc340ff071.Id0b690e581da7d03d76df90bb0e3fd55930bc8a0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h  | 10 ++++++++++
 net/mac80211/ieee80211_i.h | 11 +++++++++--
 net/mac80211/rx.c          |  5 ++---
 net/mac80211/wpa.c         | 12 ++++++++----
 4 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index e7a278ca1fde..a5bbec4c176f 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -638,6 +638,16 @@ static inline bool ieee80211_is_first_frag(__le16 seq_ctrl)
 	return (seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)) == 0;
 }
 
+/**
+ * ieee80211_is_frag - check if a frame is a fragment
+ * @hdr: 802.11 header of the frame
+ */
+static inline bool ieee80211_is_frag(struct ieee80211_hdr *hdr)
+{
+	return ieee80211_has_morefrags(hdr->frame_control) ||
+	       hdr->seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG);
+}
+
 struct ieee80211s_hdr {
 	u8 flags;
 	u8 ttl;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3f270fe15779..e293b2fbf855 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -218,8 +218,15 @@ struct ieee80211_rx_data {
 	 */
 	int security_idx;
 
-	u32 tkip_iv32;
-	u16 tkip_iv16;
+	union {
+		struct {
+			u32 iv32;
+			u16 iv16;
+		} tkip;
+		struct {
+			u8 pn[IEEE80211_CCMP_PN_LEN];
+		} ccm_gcm;
+	};
 };
 
 struct ieee80211_csa_settings {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a93dd83b77af..350b2035f37a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1922,7 +1922,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	if (entry->check_sequential_pn) {
 		int i;
 		u8 pn[IEEE80211_CCMP_PN_LEN], *rpn;
-		int queue;
 
 		if (!requires_sequential_pn(rx, fc))
 			return RX_DROP_UNUSABLE;
@@ -1937,8 +1936,8 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 			if (pn[i])
 				break;
 		}
-		queue = rx->security_idx;
-		rpn = rx->key->u.ccmp.rx_pn[queue];
+
+		rpn = rx->ccm_gcm.pn;
 		if (memcmp(pn, rpn, IEEE80211_CCMP_PN_LEN))
 			return RX_DROP_UNUSABLE;
 		memcpy(entry->last_pn, pn, IEEE80211_CCMP_PN_LEN);
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index cb439e06919f..921115327ec8 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -161,8 +161,8 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 
 update_iv:
 	/* update IV in key information to be able to detect replays */
-	rx->key->u.tkip.rx[rx->security_idx].iv32 = rx->tkip_iv32;
-	rx->key->u.tkip.rx[rx->security_idx].iv16 = rx->tkip_iv16;
+	rx->key->u.tkip.rx[rx->security_idx].iv32 = rx->tkip.iv32;
+	rx->key->u.tkip.rx[rx->security_idx].iv16 = rx->tkip.iv16;
 
 	return RX_CONTINUE;
 
@@ -292,8 +292,8 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 					  key, skb->data + hdrlen,
 					  skb->len - hdrlen, rx->sta->sta.addr,
 					  hdr->addr1, hwaccel, rx->security_idx,
-					  &rx->tkip_iv32,
-					  &rx->tkip_iv16);
+					  &rx->tkip.iv32,
+					  &rx->tkip.iv16);
 	if (res != TKIP_DECRYPT_OK)
 		return RX_DROP_UNUSABLE;
 
@@ -553,6 +553,8 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 		}
 
 		memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+		if (unlikely(ieee80211_is_frag(hdr)))
+			memcpy(rx->ccm_gcm.pn, pn, IEEE80211_CCMP_PN_LEN);
 	}
 
 	/* Remove CCMP header and MIC */
@@ -784,6 +786,8 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 		}
 
 		memcpy(key->u.gcmp.rx_pn[queue], pn, IEEE80211_GCMP_PN_LEN);
+		if (unlikely(ieee80211_is_frag(hdr)))
+			memcpy(rx->ccm_gcm.pn, pn, IEEE80211_CCMP_PN_LEN);
 	}
 
 	/* Remove GCMP header and MIC */
-- 
2.31.1

