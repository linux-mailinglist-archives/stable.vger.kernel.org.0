Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DA7395C36
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhEaN37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232117AbhEaN1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:27:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 572696136D;
        Mon, 31 May 2021 13:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467310;
        bh=hTHCB/7lrd/K/irSitZqwKir4FVZAQ/EegWIgIcO7as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vuMwTP3QNHASjek0CMum+ei++y90aTjI64C5uEjd2UR2RELbwhoF9UuooiFn+jP9p
         LFJ26Kc818wDWzvMCfzB87GRn4hrbpFB17K5FSZ+6Ew64uAKDRsikqKN58juyH85yZ
         nGGvL85aqwTSrrMQB0gWNQUsg/vj+7817gpnr15Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 018/116] mac80211: prevent attacks on TKIP/WEP as well
Date:   Mon, 31 May 2021 15:13:14 +0200
Message-Id: <20210531130640.777596703@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 7e44a0b597f04e67eee8cdcbe7ee706c6f5de38b upstream.

Similar to the issues fixed in previous patches, TKIP and WEP
should be protected even if for TKIP we have the Michael MIC
protecting it, and WEP is broken anyway.

However, this also somewhat protects potential other algorithms
that drivers might implement.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210511200110.430e8c202313.Ia37e4e5b6b3eaab1a5ae050e015f6c92859dbe27@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c       |   12 ++++++++++++
 net/mac80211/sta_info.h |    3 ++-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2158,6 +2158,7 @@ ieee80211_rx_h_defragment(struct ieee802
 			 * next fragment has a sequential PN value.
 			 */
 			entry->check_sequential_pn = true;
+			entry->is_protected = true;
 			entry->key_color = rx->key->color;
 			memcpy(entry->last_pn,
 			       rx->key->u.ccmp.rx_pn[queue],
@@ -2170,6 +2171,9 @@ ieee80211_rx_h_defragment(struct ieee802
 				     sizeof(rx->key->u.gcmp.rx_pn[queue]));
 			BUILD_BUG_ON(IEEE80211_CCMP_PN_LEN !=
 				     IEEE80211_GCMP_PN_LEN);
+		} else if (rx->key && ieee80211_has_protected(fc)) {
+			entry->is_protected = true;
+			entry->key_color = rx->key->color;
 		}
 		return RX_QUEUED;
 	}
@@ -2211,6 +2215,14 @@ ieee80211_rx_h_defragment(struct ieee802
 		if (memcmp(pn, rpn, IEEE80211_CCMP_PN_LEN))
 			return RX_DROP_UNUSABLE;
 		memcpy(entry->last_pn, pn, IEEE80211_CCMP_PN_LEN);
+	} else if (entry->is_protected &&
+		   (!rx->key || !ieee80211_has_protected(fc) ||
+		    rx->key->color != entry->key_color)) {
+		/* Drop this as a mixed key or fragment cache attack, even
+		 * if for TKIP Michael MIC should protect us, and WEP is a
+		 * lost cause anyway.
+		 */
+		return RX_DROP_UNUSABLE;
 	}
 
 	skb_pull(rx->skb, ieee80211_hdrlen(fc));
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -429,7 +429,8 @@ struct ieee80211_fragment_entry {
 	u16 extra_len;
 	u16 last_frag;
 	u8 rx_queue;
-	bool check_sequential_pn; /* needed for CCMP/GCMP */
+	u8 check_sequential_pn:1, /* needed for CCMP/GCMP */
+	   is_protected:1;
 	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
 	unsigned int key_color;
 };


