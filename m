Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC72A14518A
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731500AbgAVJyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:54:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729585AbgAVJdl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:33:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A6532467E;
        Wed, 22 Jan 2020 09:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685621;
        bh=/wEpG8+rGRpvPsJpHqetDWHO0F3KN8BmiHNTL9nb+Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QodqYnY+2fPX8Uspac2Nxf1YtNGIpnDhROKwz3/IYOv63sP2kLqLp2A64sl1Yvq0I
         dY5AvnfZW4tbFdj93YWTb+I562q56WAJDjY+Bbp/ueKTA+v/5+52hW+mg/7dH5Ecok
         jR4DFJSF6BZ04OrXGVr2jLdoJtATaBh9YaMmTrUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dedy Lansky <dlansky@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 12/97] cfg80211/mac80211: make ieee80211_send_layer2_update a public function
Date:   Wed, 22 Jan 2020 10:28:16 +0100
Message-Id: <20200122092757.795990590@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

commit 30ca1aa536211f5ac3de0173513a7a99a98a97f3 upstream.

Make ieee80211_send_layer2_update() a common function so other drivers
can re-use it.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 4.9 as dependency of commit 3e493173b784
 "mac80211: Do not send Layer 2 Update frame before authorization":
 - Retain type-casting of skb_put() return value
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/cfg80211.h |   11 +++++++++++
 net/mac80211/cfg.c     |   48 ++----------------------------------------------
 net/wireless/util.c    |   45 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 46 deletions(-)

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4182,6 +4182,17 @@ const u8 *cfg80211_find_vendor_ie(unsign
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
@@ -1048,50 +1048,6 @@ static int ieee80211_stop_ap(struct wiph
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
@@ -1455,7 +1411,7 @@ static int ieee80211_add_station(struct
 	}
 
 	if (layer2_update)
-		ieee80211_send_layer2_update(sta);
+		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
 
 	rcu_read_unlock();
 
@@ -1565,7 +1521,7 @@ static int ieee80211_change_station(stru
 				atomic_inc(&sta->sdata->bss->num_mcast_sta);
 		}
 
-		ieee80211_send_layer2_update(sta);
+		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
 	}
 
 	err = sta_apply_parameters(local, sta, params);
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1794,3 +1794,48 @@ EXPORT_SYMBOL(rfc1042_header);
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


