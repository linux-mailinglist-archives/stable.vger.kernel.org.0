Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D691B6770
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgDWXG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:06:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48134 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727063AbgDWXG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-0004ZN-Vo; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-00E6ef-I1; Fri, 24 Apr 2020 00:06:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johannes Berg" <johannes.berg@intel.com>,
        "Dedy Lansky" <dlansky@codeaurora.org>
Date:   Fri, 24 Apr 2020 00:03:54 +0100
Message-ID: <lsq.1587683028.558647797@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 007/245] cfg80211/mac80211: make ieee80211_send_layer2_update
 a public function
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dedy Lansky <dlansky@codeaurora.org>

commit 30ca1aa536211f5ac3de0173513a7a99a98a97f3 upstream.

Make ieee80211_send_layer2_update() a common function so other drivers
can re-use it.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 3.16 as dependency of commit 3e493173b784
 "mac80211: Do not send Layer 2 Update frame before authorization":
 - Retain type-casting of skb_put() return value
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/cfg80211.h | 11 ++++++++++
 net/mac80211/cfg.c     | 48 ++----------------------------------------
 net/wireless/util.c    | 45 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 46 deletions(-)

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3627,6 +3627,17 @@ const u8 *cfg80211_find_vendor_ie(unsign
 				  const u8 *ies, int len);
 
 /**
+ * cfg80211_send_layer2_update - send layer 2 update frame
+ *
+ * @dev: network device
+ * @addr: STA MAC address
+ *
+ * Wireless drivers can use this function to update forwarding tables in bridge
+ * devices upon STA association.
+ */
+void cfg80211_send_layer2_update(struct net_device *dev, const u8 *addr);
+
+/**
  * DOC: Regulatory enforcement infrastructure
  *
  * TODO
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1196,50 +1196,6 @@ static int ieee80211_stop_ap(struct wiph
 	return 0;
 }
 
-/* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */
-struct iapp_layer2_update {
-	u8 da[ETH_ALEN];	/* broadcast */
-	u8 sa[ETH_ALEN];	/* STA addr */
-	__be16 len;		/* 6 */
-	u8 dsap;		/* 0 */
-	u8 ssap;		/* 0 */
-	u8 control;
-	u8 xid_info[3];
-} __packed;
-
-static void ieee80211_send_layer2_update(struct sta_info *sta)
-{
-	struct iapp_layer2_update *msg;
-	struct sk_buff *skb;
-
-	/* Send Level 2 Update Frame to update forwarding tables in layer 2
-	 * bridge devices */
-
-	skb = dev_alloc_skb(sizeof(*msg));
-	if (!skb)
-		return;
-	msg = (struct iapp_layer2_update *)skb_put(skb, sizeof(*msg));
-
-	/* 802.2 Type 1 Logical Link Control (LLC) Exchange Identifier (XID)
-	 * Update response frame; IEEE Std 802.2-1998, 5.4.1.2.1 */
-
-	eth_broadcast_addr(msg->da);
-	memcpy(msg->sa, sta->sta.addr, ETH_ALEN);
-	msg->len = htons(6);
-	msg->dsap = 0;
-	msg->ssap = 0x01;	/* NULL LSAP, CR Bit: Response */
-	msg->control = 0xaf;	/* XID response lsb.1111F101.
-				 * F=0 (no poll command; unsolicited frame) */
-	msg->xid_info[0] = 0x81;	/* XID format identifier */
-	msg->xid_info[1] = 1;	/* LLC types/classes: Type 1 LLC */
-	msg->xid_info[2] = 0;	/* XID sender's receive window size (RW) */
-
-	skb->dev = sta->sdata->dev;
-	skb->protocol = eth_type_trans(skb, sta->sdata->dev);
-	memset(skb->cb, 0, sizeof(skb->cb));
-	netif_rx_ni(skb);
-}
-
 static int sta_apply_auth_flags(struct ieee80211_local *local,
 				struct sta_info *sta,
 				u32 mask, u32 set)
@@ -1535,7 +1491,7 @@ static int ieee80211_add_station(struct
 	}
 
 	if (layer2_update)
-		ieee80211_send_layer2_update(sta);
+		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
 
 	rcu_read_unlock();
 
@@ -1640,7 +1596,7 @@ static int ieee80211_change_station(stru
 				atomic_inc(&sta->sdata->bss->num_mcast_sta);
 		}
 
-		ieee80211_send_layer2_update(sta);
+		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
 	}
 
 	err = sta_apply_parameters(local, sta, params);
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1583,3 +1583,48 @@ EXPORT_SYMBOL(rfc1042_header);
 const unsigned char bridge_tunnel_header[] __aligned(2) =
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 EXPORT_SYMBOL(bridge_tunnel_header);
+
+/* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */
+struct iapp_layer2_update {
+	u8 da[ETH_ALEN];	/* broadcast */
+	u8 sa[ETH_ALEN];	/* STA addr */
+	__be16 len;		/* 6 */
+	u8 dsap;		/* 0 */
+	u8 ssap;		/* 0 */
+	u8 control;
+	u8 xid_info[3];
+} __packed;
+
+void cfg80211_send_layer2_update(struct net_device *dev, const u8 *addr)
+{
+	struct iapp_layer2_update *msg;
+	struct sk_buff *skb;
+
+	/* Send Level 2 Update Frame to update forwarding tables in layer 2
+	 * bridge devices */
+
+	skb = dev_alloc_skb(sizeof(*msg));
+	if (!skb)
+		return;
+	msg = (struct iapp_layer2_update *)skb_put(skb, sizeof(*msg));
+
+	/* 802.2 Type 1 Logical Link Control (LLC) Exchange Identifier (XID)
+	 * Update response frame; IEEE Std 802.2-1998, 5.4.1.2.1 */
+
+	eth_broadcast_addr(msg->da);
+	ether_addr_copy(msg->sa, addr);
+	msg->len = htons(6);
+	msg->dsap = 0;
+	msg->ssap = 0x01;	/* NULL LSAP, CR Bit: Response */
+	msg->control = 0xaf;	/* XID response lsb.1111F101.
+				 * F=0 (no poll command; unsolicited frame) */
+	msg->xid_info[0] = 0x81;	/* XID format identifier */
+	msg->xid_info[1] = 1;	/* LLC types/classes: Type 1 LLC */
+	msg->xid_info[2] = 0;	/* XID sender's receive window size (RW) */
+
+	skb->dev = dev;
+	skb->protocol = eth_type_trans(skb, dev);
+	memset(skb->cb, 0, sizeof(skb->cb));
+	netif_rx_ni(skb);
+}
+EXPORT_SYMBOL(cfg80211_send_layer2_update);

