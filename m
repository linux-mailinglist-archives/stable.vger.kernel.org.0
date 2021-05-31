Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA70395D13
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhEaNlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232667AbhEaNjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:39:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 501536140D;
        Mon, 31 May 2021 13:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467616;
        bh=7alTiTLdYHQmL3pMlblMGxuJCwT5bbNm54MEl33uXXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaQdl7+CBt3r8s/n1mLPoAiEkNA1206thm5SOdgYvzuWyBq4WJyaaSYuwcdAP90NK
         PlyOV9iKtiCGS03b10XIY7nQ6Xz1uEH2STuMDOJSGTKEpqX3c4f+5SpuBL1dUxURX8
         yRIS/Omxk8sxWDdG63JMaV34AeIuld078sWSSJdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 16/79] mac80211: check defrag PN against current frame
Date:   Mon, 31 May 2021 15:14:01 +0200
Message-Id: <20210531130636.525832903@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |   11 +++++++++--
 net/mac80211/rx.c          |    5 ++---
 net/mac80211/wpa.c         |   13 +++++++++----
 3 files changed, 20 insertions(+), 9 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -242,8 +242,15 @@ struct ieee80211_rx_data {
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
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2063,7 +2063,6 @@ ieee80211_rx_h_defragment(struct ieee802
 	if (entry->check_sequential_pn) {
 		int i;
 		u8 pn[IEEE80211_CCMP_PN_LEN], *rpn;
-		int queue;
 
 		if (!requires_sequential_pn(rx, fc))
 			return RX_DROP_UNUSABLE;
@@ -2078,8 +2077,8 @@ ieee80211_rx_h_defragment(struct ieee802
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
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -2,6 +2,7 @@
  * Copyright 2002-2004, Instant802 Networks, Inc.
  * Copyright 2008, Jouni Malinen <j@w1.fi>
  * Copyright (C) 2016 Intel Deutschland GmbH
+ * Copyright (C) 2020-2021 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -162,8 +163,8 @@ ieee80211_rx_h_michael_mic_verify(struct
 
 update_iv:
 	/* update IV in key information to be able to detect replays */
-	rx->key->u.tkip.rx[rx->security_idx].iv32 = rx->tkip_iv32;
-	rx->key->u.tkip.rx[rx->security_idx].iv16 = rx->tkip_iv16;
+	rx->key->u.tkip.rx[rx->security_idx].iv32 = rx->tkip.iv32;
+	rx->key->u.tkip.rx[rx->security_idx].iv16 = rx->tkip.iv16;
 
 	return RX_CONTINUE;
 
@@ -289,8 +290,8 @@ ieee80211_crypto_tkip_decrypt(struct iee
 					  key, skb->data + hdrlen,
 					  skb->len - hdrlen, rx->sta->sta.addr,
 					  hdr->addr1, hwaccel, rx->security_idx,
-					  &rx->tkip_iv32,
-					  &rx->tkip_iv16);
+					  &rx->tkip.iv32,
+					  &rx->tkip.iv16);
 	if (res != TKIP_DECRYPT_OK)
 		return RX_DROP_UNUSABLE;
 
@@ -548,6 +549,8 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 		}
 
 		memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+		if (unlikely(ieee80211_is_frag(hdr)))
+			memcpy(rx->ccm_gcm.pn, pn, IEEE80211_CCMP_PN_LEN);
 	}
 
 	/* Remove CCMP header and MIC */
@@ -777,6 +780,8 @@ ieee80211_crypto_gcmp_decrypt(struct iee
 		}
 
 		memcpy(key->u.gcmp.rx_pn[queue], pn, IEEE80211_GCMP_PN_LEN);
+		if (unlikely(ieee80211_is_frag(hdr)))
+			memcpy(rx->ccm_gcm.pn, pn, IEEE80211_CCMP_PN_LEN);
 	}
 
 	/* Remove GCMP header and MIC */


