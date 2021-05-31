Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3036E3968C3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhEaUa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbhEaUaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:30:21 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12E6C061761;
        Mon, 31 May 2021 13:28:40 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnoWd-000F0y-40; Mon, 31 May 2021 22:28:39 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org, Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Subject: [PATCH v4.4 03/10] mac80211: properly handle A-MSDUs that start with an RFC 1042 header
Date:   Mon, 31 May 2021 22:28:27 +0200
Message-Id: <20210531202834.179810-4-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531202834.179810-1-johannes@sipsolutions.net>
References: <20210531202834.179810-1-johannes@sipsolutions.net>
MIME-Version: 1.0
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
---
 net/wireless/util.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 156a2a6337b9..0c7b9de1e7f1 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -409,8 +409,8 @@ unsigned int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 }
 EXPORT_SYMBOL(ieee80211_get_mesh_hdrlen);
 
-int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
-			   enum nl80211_iftype iftype)
+static int __ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
+				    enum nl80211_iftype iftype, bool is_amsdu)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u16 hdrlen, ethertype;
@@ -504,7 +504,7 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 	payload = skb->data + hdrlen;
 	ethertype = (payload[6] << 8) | payload[7];
 
-	if (likely((ether_addr_equal(payload, rfc1042_header) &&
+	if (likely((!is_amsdu && ether_addr_equal(payload, rfc1042_header) &&
 		    ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
 		   ether_addr_equal(payload, bridge_tunnel_header))) {
 		/* remove RFC1042 or Bridge-Tunnel encapsulation and
@@ -525,6 +525,12 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 	}
 	return 0;
 }
+
+int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
+			   enum nl80211_iftype iftype)
+{
+	return __ieee80211_data_to_8023(skb, addr, iftype, false);
+}
 EXPORT_SYMBOL(ieee80211_data_to_8023);
 
 int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
-- 
2.31.1

