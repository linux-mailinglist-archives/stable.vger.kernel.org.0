Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109BF48918F
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239727AbiAJHdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:33:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58728 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240563AbiAJHb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:31:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC3A7B81161;
        Mon, 10 Jan 2022 07:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB4CC36AED;
        Mon, 10 Jan 2022 07:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799884;
        bh=juyG7wIek7e2lL5Btww5qkya4KtE0VKhzueh0Rce5OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQDPCalW9xg7wxZe7GGRUSTmt0ZHrL80ZDR0HhG0u6DXbw39/mphhCnFwn1BfcjXf
         XqGB453yBqt1yfIRfghmoQyRxZaCvkfssgjTmDNoBkZlIp7KOehpIPSVdvWfZzySUj
         qoP6m69OGf5bKL+nt+ceQPx6ZnAMqX4/mhej/OUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.10 22/43] batman-adv: mcast: dont send link-local multicast to mcast routers
Date:   Mon, 10 Jan 2022 08:23:19 +0100
Message-Id: <20220110071818.092635692@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

commit 938f2e0b57ffe8a6df71e1e177b2978b1b33fe5e upstream.

The addition of routable multicast TX handling introduced a
bug/regression for packets with a link-local multicast destination:
These packets would be sent to all batman-adv nodes with a multicast
router and to all batman-adv nodes with an old version without multicast
router detection.

This even disregards the batman-adv multicast fanout setting, which can
potentially lead to an unwanted, high number of unicast transmissions or
even congestion.

Fixing this by avoiding to send link-local multicast packets to nodes in
the multicast router list.

Fixes: 11d458c1cb9b ("batman-adv: mcast: apply optimizations for routable packets, too")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/multicast.c      |   15 ++++++++++-----
 net/batman-adv/multicast.h      |   10 ++++++----
 net/batman-adv/soft-interface.c |    7 +++++--
 3 files changed, 21 insertions(+), 11 deletions(-)

--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -1373,6 +1373,7 @@ batadv_mcast_forw_rtr_node_get(struct ba
  * @bat_priv: the bat priv with all the soft interface information
  * @skb: The multicast packet to check
  * @orig: an originator to be set to forward the skb to
+ * @is_routable: stores whether the destination is routable
  *
  * Return: the forwarding mode as enum batadv_forw_mode and in case of
  * BATADV_FORW_SINGLE set the orig to the single originator the skb
@@ -1380,17 +1381,16 @@ batadv_mcast_forw_rtr_node_get(struct ba
  */
 enum batadv_forw_mode
 batadv_mcast_forw_mode(struct batadv_priv *bat_priv, struct sk_buff *skb,
-		       struct batadv_orig_node **orig)
+		       struct batadv_orig_node **orig, int *is_routable)
 {
 	int ret, tt_count, ip_count, unsnoop_count, total_count;
 	bool is_unsnoopable = false;
 	unsigned int mcast_fanout;
 	struct ethhdr *ethhdr;
-	int is_routable = 0;
 	int rtr_count = 0;
 
 	ret = batadv_mcast_forw_mode_check(bat_priv, skb, &is_unsnoopable,
-					   &is_routable);
+					   is_routable);
 	if (ret == -ENOMEM)
 		return BATADV_FORW_NONE;
 	else if (ret < 0)
@@ -1403,7 +1403,7 @@ batadv_mcast_forw_mode(struct batadv_pri
 	ip_count = batadv_mcast_forw_want_all_ip_count(bat_priv, ethhdr);
 	unsnoop_count = !is_unsnoopable ? 0 :
 			atomic_read(&bat_priv->mcast.num_want_all_unsnoopables);
-	rtr_count = batadv_mcast_forw_rtr_count(bat_priv, is_routable);
+	rtr_count = batadv_mcast_forw_rtr_count(bat_priv, *is_routable);
 
 	total_count = tt_count + ip_count + unsnoop_count + rtr_count;
 
@@ -1723,6 +1723,7 @@ batadv_mcast_forw_want_rtr(struct batadv
  * @bat_priv: the bat priv with all the soft interface information
  * @skb: the multicast packet to transmit
  * @vid: the vlan identifier
+ * @is_routable: stores whether the destination is routable
  *
  * Sends copies of a frame with multicast destination to any node that signaled
  * interest in it, that is either via the translation table or the according
@@ -1735,7 +1736,7 @@ batadv_mcast_forw_want_rtr(struct batadv
  * is neither IPv4 nor IPv6. NET_XMIT_SUCCESS otherwise.
  */
 int batadv_mcast_forw_send(struct batadv_priv *bat_priv, struct sk_buff *skb,
-			   unsigned short vid)
+			   unsigned short vid, int is_routable)
 {
 	int ret;
 
@@ -1751,12 +1752,16 @@ int batadv_mcast_forw_send(struct batadv
 		return ret;
 	}
 
+	if (!is_routable)
+		goto skip_mc_router;
+
 	ret = batadv_mcast_forw_want_rtr(bat_priv, skb, vid);
 	if (ret != NET_XMIT_SUCCESS) {
 		kfree_skb(skb);
 		return ret;
 	}
 
+skip_mc_router:
 	consume_skb(skb);
 	return ret;
 }
--- a/net/batman-adv/multicast.h
+++ b/net/batman-adv/multicast.h
@@ -44,7 +44,8 @@ enum batadv_forw_mode {
 
 enum batadv_forw_mode
 batadv_mcast_forw_mode(struct batadv_priv *bat_priv, struct sk_buff *skb,
-		       struct batadv_orig_node **mcast_single_orig);
+		       struct batadv_orig_node **mcast_single_orig,
+		       int *is_routable);
 
 int batadv_mcast_forw_send_orig(struct batadv_priv *bat_priv,
 				struct sk_buff *skb,
@@ -52,7 +53,7 @@ int batadv_mcast_forw_send_orig(struct b
 				struct batadv_orig_node *orig_node);
 
 int batadv_mcast_forw_send(struct batadv_priv *bat_priv, struct sk_buff *skb,
-			   unsigned short vid);
+			   unsigned short vid, int is_routable);
 
 void batadv_mcast_init(struct batadv_priv *bat_priv);
 
@@ -71,7 +72,8 @@ void batadv_mcast_purge_orig(struct bata
 
 static inline enum batadv_forw_mode
 batadv_mcast_forw_mode(struct batadv_priv *bat_priv, struct sk_buff *skb,
-		       struct batadv_orig_node **mcast_single_orig)
+		       struct batadv_orig_node **mcast_single_orig,
+		       int *is_routable)
 {
 	return BATADV_FORW_ALL;
 }
@@ -88,7 +90,7 @@ batadv_mcast_forw_send_orig(struct batad
 
 static inline int
 batadv_mcast_forw_send(struct batadv_priv *bat_priv, struct sk_buff *skb,
-		       unsigned short vid)
+		       unsigned short vid, int is_routable)
 {
 	kfree_skb(skb);
 	return NET_XMIT_DROP;
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -200,6 +200,7 @@ static netdev_tx_t batadv_interface_tx(s
 	int gw_mode;
 	enum batadv_forw_mode forw_mode = BATADV_FORW_SINGLE;
 	struct batadv_orig_node *mcast_single_orig = NULL;
+	int mcast_is_routable = 0;
 	int network_offset = ETH_HLEN;
 	__be16 proto;
 
@@ -302,7 +303,8 @@ static netdev_tx_t batadv_interface_tx(s
 send:
 		if (do_bcast && !is_broadcast_ether_addr(ethhdr->h_dest)) {
 			forw_mode = batadv_mcast_forw_mode(bat_priv, skb,
-							   &mcast_single_orig);
+							   &mcast_single_orig,
+							   &mcast_is_routable);
 			if (forw_mode == BATADV_FORW_NONE)
 				goto dropped;
 
@@ -367,7 +369,8 @@ send:
 			ret = batadv_mcast_forw_send_orig(bat_priv, skb, vid,
 							  mcast_single_orig);
 		} else if (forw_mode == BATADV_FORW_SOME) {
-			ret = batadv_mcast_forw_send(bat_priv, skb, vid);
+			ret = batadv_mcast_forw_send(bat_priv, skb, vid,
+						     mcast_is_routable);
 		} else {
 			if (batadv_dat_snoop_outgoing_arp_request(bat_priv,
 								  skb))


