Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D66396113
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbhEaOfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231580AbhEaOdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:33:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43AFB61C3C;
        Mon, 31 May 2021 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469013;
        bh=xa/K6wFgLzGSTq/4VmNWFRDp6NsRmw04nMaYGNmWfms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfBCVgp56yyLm3O/+yMGPIRjPhdeypcW4Qj4prJoE/wh5w9NLLrIG/x1e2nWUNtPM
         VqVoKLViGvWoWN116G8nhyjS754JtP3FtWgG39g4Po6mSrXbAQNXY/60LAxLJdilK4
         lC8TcdNbQf3cw+6yFTIMHmqzNsmSVCsu/gjaWFxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.12 037/296] mac80211: properly handle A-MSDUs that start with an RFC 1042 header
Date:   Mon, 31 May 2021 15:11:32 +0200
Message-Id: <20210531130705.064774528@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>

commit a1d5ff5651ea592c67054233b14b30bf4452999c upstream.

Properly parse A-MSDUs whose first 6 bytes happen to equal a rfc1042
header. This can occur in practice when the destination MAC address
equals AA:AA:03:00:00:00. More importantly, this simplifies the next
patch to mitigate A-MSDU injection attacks.

Cc: stable@vger.kernel.org
Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Link: https://lore.kernel.org/r/20210511200110.0b2b886492f0.I23dd5d685fe16d3b0ec8106e8f01b59f499dffed@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/cfg80211.h |    4 ++--
 net/mac80211/rx.c      |    2 +-
 net/wireless/util.c    |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5756,7 +5756,7 @@ unsigned int ieee80211_get_mesh_hdrlen(s
  */
 int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 				  const u8 *addr, enum nl80211_iftype iftype,
-				  u8 data_offset);
+				  u8 data_offset, bool is_amsdu);
 
 /**
  * ieee80211_data_to_8023 - convert an 802.11 data frame to 802.3
@@ -5768,7 +5768,7 @@ int ieee80211_data_to_8023_exthdr(struct
 static inline int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 					 enum nl80211_iftype iftype)
 {
-	return ieee80211_data_to_8023_exthdr(skb, NULL, addr, iftype, 0);
+	return ieee80211_data_to_8023_exthdr(skb, NULL, addr, iftype, 0, false);
 }
 
 /**
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2681,7 +2681,7 @@ __ieee80211_rx_h_amsdu(struct ieee80211_
 	if (ieee80211_data_to_8023_exthdr(skb, &ethhdr,
 					  rx->sdata->vif.addr,
 					  rx->sdata->vif.type,
-					  data_offset))
+					  data_offset, true))
 		return RX_DROP_UNUSABLE;
 
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -542,7 +542,7 @@ EXPORT_SYMBOL(ieee80211_get_mesh_hdrlen)
 
 int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 				  const u8 *addr, enum nl80211_iftype iftype,
-				  u8 data_offset)
+				  u8 data_offset, bool is_amsdu)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct {
@@ -629,7 +629,7 @@ int ieee80211_data_to_8023_exthdr(struct
 	skb_copy_bits(skb, hdrlen, &payload, sizeof(payload));
 	tmp.h_proto = payload.proto;
 
-	if (likely((ether_addr_equal(payload.hdr, rfc1042_header) &&
+	if (likely((!is_amsdu && ether_addr_equal(payload.hdr, rfc1042_header) &&
 		    tmp.h_proto != htons(ETH_P_AARP) &&
 		    tmp.h_proto != htons(ETH_P_IPX)) ||
 		   ether_addr_equal(payload.hdr, bridge_tunnel_header)))


