Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4010B13FEEB
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389402AbgAPX2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:28:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388978AbgAPX2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:28:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBF9A20684;
        Thu, 16 Jan 2020 23:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217313;
        bh=731Jyjc6vyJ/rqhogrJ6R4mYSPuNveajWAz9g1nszgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxFyTNweknNqOx5QRxCGAcjeJEGtLO4Ge6zvuOaNVMoxzC8nAPu1XEoRFfDNBMbCy
         hKtTHWFJD0vOhPt77F/keM9ornjJfvfS8LoRz6mPGyDZHzmpTXZl78WGyWuf9OR46y
         t328vD54vnsPeZOmXN8Jvu3+NEIyPF29eguYUVPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dedy Lansky <dlansky@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 06/84] cfg80211/mac80211: make ieee80211_send_layer2_update a public function
Date:   Fri, 17 Jan 2020 00:17:40 +0100
Message-Id: <20200116231714.199910561@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
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
[bwh: Backported to 4.19 as dependency of commit 3e493173b784
 "mac80211: Do not send Layer 2 Update frame before authorization"]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/cfg80211.h |   11 +++++++++++
 net/mac80211/cfg.c     |   48 ++----------------------------------------------
 net/wireless/util.c    |   45 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 46 deletions(-)

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4734,6 +4734,17 @@ const u8 *cfg80211_find_vendor_ie(unsign
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
@@ -1096,50 +1096,6 @@ static int ieee80211_stop_ap(struct wiph
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
-	msg = skb_put(skb, sizeof(*msg));
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
@@ -1508,7 +1464,7 @@ static int ieee80211_add_station(struct
 	}
 
 	if (layer2_update)
-		ieee80211_send_layer2_update(sta);
+		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
 
 	rcu_read_unlock();
 
@@ -1610,7 +1566,7 @@ static int ieee80211_change_station(stru
 		if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
 			ieee80211_vif_inc_num_mcast(sta->sdata);
 
-		ieee80211_send_layer2_update(sta);
+		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
 	}
 
 	err = sta_apply_parameters(local, sta, params);
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1919,3 +1919,48 @@ bool cfg80211_iftype_allowed(struct wiph
 	return false;
 }
 EXPORT_SYMBOL(cfg80211_iftype_allowed);
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
+	msg = skb_put(skb, sizeof(*msg));
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


