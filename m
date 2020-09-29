Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE4027CA93
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbgI2MUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbgI2Lfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CCCE23D6C;
        Tue, 29 Sep 2020 11:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379030;
        bh=9KvlT9fTMtLdfbAiIpcUl4ob27dQPLm8ewART6R65pM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRy2qDkS/4csd4wYJo/uQUIni7RQRyDB4IE2mi3i07BDpPDYqRCd2mnfCAmRW4gst
         z90sO682Wx2I3ngBf2I9Sgdli20QCaaypPQ3IwkzkafITS2iMvdRquz9QlJvdGlR92
         9hqZodHXe4CDu7RblDTWNkvb/rwWWkhNQvzQX83c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 228/245] batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh
Date:   Tue, 29 Sep 2020 13:01:19 +0200
Message-Id: <20200929105958.081545049@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

[ Upstream commit 74c09b7275126da1b642b90c9cdc3ae8b729ad4b ]

Scenario:
* Multicast frame send from mesh to a BLA backbone (multiple nodes
  with their bat0 bridged together, with BLA enabled)

Issue:
* BLA backbone nodes receive the frame multiple times on bat0,
  once from mesh->bat0 and once from each backbone_gw from LAN

For unicast, a node will send only to the best backbone gateway
according to the TQ. However for multicast we currently cannot determine
if multiple destination nodes share the same backbone if they don't share
the same backbone with us. So we need to keep sending the unicasts to
all backbone gateways and let the backbone gateways decide which one
will forward the frame. We can use the CLAIM mechanism to make this
decision.

One catch: The batman-adv gateway feature for DHCP packets potentially
sends multicast packets in the same batman-adv unicast header as the
multicast optimizations code. And we are not allowed to drop those even
if we did not claim the source address of the sender, as for such
packets there is only this one multicast-in-unicast packet.

How can we distinguish the two cases?

The gateway feature uses a batman-adv unicast 4 address header. While
the multicast-to-unicasts feature uses a simple, 3 address batman-adv
unicast header. So let's use this to distinguish.

Fixes: fe2da6ff27c7 ("batman-adv: check incoming packet type for bla")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bridge_loop_avoidance.c | 34 +++++++++++++++++++-------
 net/batman-adv/bridge_loop_avoidance.h |  4 +--
 net/batman-adv/soft-interface.c        |  6 ++---
 3 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 557d7fdf0b8dc..3f76872d411bc 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1827,7 +1827,7 @@ batadv_bla_loopdetect_check(struct batadv_priv *bat_priv, struct sk_buff *skb,
  * @bat_priv: the bat priv with all the soft interface information
  * @skb: the frame to be checked
  * @vid: the VLAN ID of the frame
- * @is_bcast: the packet came in a broadcast packet type.
+ * @packet_type: the batman packet type this frame came in
  *
  * batadv_bla_rx avoidance checks if:
  *  * we have to race for a claim
@@ -1839,7 +1839,7 @@ batadv_bla_loopdetect_check(struct batadv_priv *bat_priv, struct sk_buff *skb,
  * further process the skb.
  */
 bool batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
-		   unsigned short vid, bool is_bcast)
+		   unsigned short vid, int packet_type)
 {
 	struct batadv_bla_backbone_gw *backbone_gw;
 	struct ethhdr *ethhdr;
@@ -1861,9 +1861,24 @@ bool batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		goto handled;
 
 	if (unlikely(atomic_read(&bat_priv->bla.num_requests)))
-		/* don't allow broadcasts while requests are in flight */
-		if (is_multicast_ether_addr(ethhdr->h_dest) && is_bcast)
-			goto handled;
+		/* don't allow multicast packets while requests are in flight */
+		if (is_multicast_ether_addr(ethhdr->h_dest))
+			/* Both broadcast flooding or multicast-via-unicasts
+			 * delivery might send to multiple backbone gateways
+			 * sharing the same LAN and therefore need to coordinate
+			 * which backbone gateway forwards into the LAN,
+			 * by claiming the payload source address.
+			 *
+			 * Broadcast flooding and multicast-via-unicasts
+			 * delivery use the following two batman packet types.
+			 * Note: explicitly exclude BATADV_UNICAST_4ADDR,
+			 * as the DHCP gateway feature will send explicitly
+			 * to only one BLA gateway, so the claiming process
+			 * should be avoided there.
+			 */
+			if (packet_type == BATADV_BCAST ||
+			    packet_type == BATADV_UNICAST)
+				goto handled;
 
 	ether_addr_copy(search_claim.addr, ethhdr->h_source);
 	search_claim.vid = vid;
@@ -1898,13 +1913,14 @@ bool batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		goto allow;
 	}
 
-	/* if it is a broadcast ... */
-	if (is_multicast_ether_addr(ethhdr->h_dest) && is_bcast) {
+	/* if it is a multicast ... */
+	if (is_multicast_ether_addr(ethhdr->h_dest) &&
+	    (packet_type == BATADV_BCAST || packet_type == BATADV_UNICAST)) {
 		/* ... drop it. the responsible gateway is in charge.
 		 *
-		 * We need to check is_bcast because with the gateway
+		 * We need to check packet type because with the gateway
 		 * feature, broadcasts (like DHCP requests) may be sent
-		 * using a unicast packet type.
+		 * using a unicast 4 address packet type. See comment above.
 		 */
 		goto handled;
 	} else {
diff --git a/net/batman-adv/bridge_loop_avoidance.h b/net/batman-adv/bridge_loop_avoidance.h
index 71f95a3e4d3f3..af28fdb01467c 100644
--- a/net/batman-adv/bridge_loop_avoidance.h
+++ b/net/batman-adv/bridge_loop_avoidance.h
@@ -48,7 +48,7 @@ static inline bool batadv_bla_is_loopdetect_mac(const uint8_t *mac)
 
 #ifdef CONFIG_BATMAN_ADV_BLA
 bool batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
-		   unsigned short vid, bool is_bcast);
+		   unsigned short vid, int packet_type);
 bool batadv_bla_tx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		   unsigned short vid);
 bool batadv_bla_is_backbone_gw(struct sk_buff *skb,
@@ -79,7 +79,7 @@ bool batadv_bla_check_claim(struct batadv_priv *bat_priv, u8 *addr,
 
 static inline bool batadv_bla_rx(struct batadv_priv *bat_priv,
 				 struct sk_buff *skb, unsigned short vid,
-				 bool is_bcast)
+				 int packet_type)
 {
 	return false;
 }
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index a2976adeeedce..6ff78080ec7fb 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -426,10 +426,10 @@ void batadv_interface_rx(struct net_device *soft_iface,
 	struct vlan_ethhdr *vhdr;
 	struct ethhdr *ethhdr;
 	unsigned short vid;
-	bool is_bcast;
+	int packet_type;
 
 	batadv_bcast_packet = (struct batadv_bcast_packet *)skb->data;
-	is_bcast = (batadv_bcast_packet->packet_type == BATADV_BCAST);
+	packet_type = batadv_bcast_packet->packet_type;
 
 	skb_pull_rcsum(skb, hdr_size);
 	skb_reset_mac_header(skb);
@@ -472,7 +472,7 @@ void batadv_interface_rx(struct net_device *soft_iface,
 	/* Let the bridge loop avoidance check the packet. If will
 	 * not handle it, we can safely push it up.
 	 */
-	if (batadv_bla_rx(bat_priv, skb, vid, is_bcast))
+	if (batadv_bla_rx(bat_priv, skb, vid, packet_type))
 		goto out;
 
 	if (orig_node)
-- 
2.25.1



