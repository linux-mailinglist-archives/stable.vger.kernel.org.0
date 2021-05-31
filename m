Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9360C395DDA
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhEaNv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232812AbhEaNsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C22B961624;
        Mon, 31 May 2021 13:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467871;
        bh=NgRR8mgDNqG5NHLe2RlO4U9I5TZLstaLBSAFI+Uwom0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeHTdeAvTFR2zUqZ7xqAxhneAuWG/ul437hh2T6evxJ/yzOXgEuq4Hm5uhw8QUl8G
         FeqgJT+uq+3S7/LHUu4LO2Y0p53qFmft1ZU6+5b+nG9j6ttFaRH+9U+9IMqBCKPxbO
         1M+Ysk0rbffoGiM8r1/kS7Pvmfqs0+ahNZHC5chs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 030/252] mac80211: prevent attacks on TKIP/WEP as well
Date:   Mon, 31 May 2021 15:11:35 +0200
Message-Id: <20210531130659.005193399@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
@@ -2284,6 +2284,7 @@ ieee80211_rx_h_defragment(struct ieee802
 			 * next fragment has a sequential PN value.
 			 */
 			entry->check_sequential_pn = true;
+			entry->is_protected = true;
 			entry->key_color = rx->key->color;
 			memcpy(entry->last_pn,
 			       rx->key->u.ccmp.rx_pn[queue],
@@ -2296,6 +2297,9 @@ ieee80211_rx_h_defragment(struct ieee802
 				     sizeof(rx->key->u.gcmp.rx_pn[queue]));
 			BUILD_BUG_ON(IEEE80211_CCMP_PN_LEN !=
 				     IEEE80211_GCMP_PN_LEN);
+		} else if (rx->key && ieee80211_has_protected(fc)) {
+			entry->is_protected = true;
+			entry->key_color = rx->key->color;
 		}
 		return RX_QUEUED;
 	}
@@ -2337,6 +2341,14 @@ ieee80211_rx_h_defragment(struct ieee802
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
@@ -453,7 +453,8 @@ struct ieee80211_fragment_entry {
 	u16 extra_len;
 	u16 last_frag;
 	u8 rx_queue;
-	bool check_sequential_pn; /* needed for CCMP/GCMP */
+	u8 check_sequential_pn:1, /* needed for CCMP/GCMP */
+	   is_protected:1;
 	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
 	unsigned int key_color;
 };


