Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D30395FC3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhEaOQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232959AbhEaONc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:13:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 827F361990;
        Mon, 31 May 2021 13:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468520;
        bh=S8M50Q+Qnm9A9PP5c/wurdP8TrU5ZvgOK7CcFShJzcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nL63BWKm7crhqLcpryBNtoK5Oqz8vGF5ggyNySVDcXEeLnwl+RETjE20dPT9oiug0
         TuRdr5H09xbmX+ZcMK0j5bNBq6MuzLW21FoGihm9JCfVNskfAvhOUI0mxzVoaAngD7
         bXe8SfAfawpxWkDKDbXxv8kSh71bZxZZtGvnZB1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 021/177] mac80211: prevent attacks on TKIP/WEP as well
Date:   Mon, 31 May 2021 15:12:58 +0200
Message-Id: <20210531130648.651922496@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
@@ -2234,6 +2234,7 @@ ieee80211_rx_h_defragment(struct ieee802
 			 * next fragment has a sequential PN value.
 			 */
 			entry->check_sequential_pn = true;
+			entry->is_protected = true;
 			entry->key_color = rx->key->color;
 			memcpy(entry->last_pn,
 			       rx->key->u.ccmp.rx_pn[queue],
@@ -2246,6 +2247,9 @@ ieee80211_rx_h_defragment(struct ieee802
 				     sizeof(rx->key->u.gcmp.rx_pn[queue]));
 			BUILD_BUG_ON(IEEE80211_CCMP_PN_LEN !=
 				     IEEE80211_GCMP_PN_LEN);
+		} else if (rx->key && ieee80211_has_protected(fc)) {
+			entry->is_protected = true;
+			entry->key_color = rx->key->color;
 		}
 		return RX_QUEUED;
 	}
@@ -2287,6 +2291,14 @@ ieee80211_rx_h_defragment(struct ieee802
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
@@ -443,7 +443,8 @@ struct ieee80211_fragment_entry {
 	u16 extra_len;
 	u16 last_frag;
 	u8 rx_queue;
-	bool check_sequential_pn; /* needed for CCMP/GCMP */
+	u8 check_sequential_pn:1, /* needed for CCMP/GCMP */
+	   is_protected:1;
 	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
 	unsigned int key_color;
 };


