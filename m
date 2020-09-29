Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA4827C79B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgI2Lyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:54:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730975AbgI2Lpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 593D12083B;
        Tue, 29 Sep 2020 11:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379939;
        bh=h5qrVAfmAwMgqJMRySasq9XNnzDGn9dyxIsZ0VWF0CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=feFrXY+i1f0OYlodjR6YKpeQeStOLLfUKbZ1uIdGXpPqhglvLzofYKH8orybxD4Qv
         8KzSYl8PwBxafXw8mPdIE2taWa8I33SS/jg4RSbPM1Mf5Ssgq4ZchQmOUpxp+dhkq3
         ux3Ic29JcPlDrg+dNsGjZSivJAO9DJ/JQNV/2sZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 355/388] batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh
Date:   Tue, 29 Sep 2020 13:01:26 +0200
Message-Id: <20200929110027.649974774@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
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
index fe406c17b2c0a..ffa44d7f7ee5d 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1814,7 +1814,7 @@ batadv_bla_loopdetect_check(struct batadv_priv *bat_priv, struct sk_buff *skb,
  * @bat_priv: the bat priv with all the soft interface information
  * @skb: the frame to be checked
  * @vid: the VLAN ID of the frame
- * @is_bcast: the packet came in a broadcast packet type.
+ * @packet_type: the batman packet type this frame came in
  *
  * batadv_bla_rx avoidance checks if:
  *  * we have to race for a claim
@@ -1826,7 +1826,7 @@ batadv_bla_loopdetect_check(struct batadv_priv *bat_priv, struct sk_buff *skb,
  * further process the skb.
  */
 bool batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
-		   unsigned short vid, bool is_bcast)
+		   unsigned short vid, int packet_type)
 {
 	struct batadv_bla_backbone_gw *backbone_gw;
 	struct ethhdr *ethhdr;
@@ -1848,9 +1848,24 @@ bool batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
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
@@ -1885,13 +1900,14 @@ bool batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
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
index 02b24a861a854..9370be0158130 100644
--- a/net/batman-adv/bridge_loop_avoidance.h
+++ b/net/batman-adv/bridge_loop_avoidance.h
@@ -35,7 +35,7 @@ static inline bool batadv_bla_is_loopdetect_mac(const uint8_t *mac)
 
 #ifdef CONFIG_BATMAN_ADV_BLA
 bool batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
-		   unsigned short vid, bool is_bcast);
+		   unsigned short vid, int packet_type);
 bool batadv_bla_tx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		   unsigned short vid);
 bool batadv_bla_is_backbone_gw(struct sk_buff *skb,
@@ -66,7 +66,7 @@ bool batadv_bla_check_claim(struct batadv_priv *bat_priv, u8 *addr,
 
 static inline bool batadv_bla_rx(struct batadv_priv *bat_priv,
 				 struct sk_buff *skb, unsigned short vid,
-				 bool is_bcast)
+				 int packet_type)
 {
 	return false;
 }
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index cf1a8ef7464f5..7f209390069ea 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -424,10 +424,10 @@ void batadv_interface_rx(struct net_device *soft_iface,
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
@@ -470,7 +470,7 @@ void batadv_interface_rx(struct net_device *soft_iface,
 	/* Let the bridge loop avoidance check the packet. If will
 	 * not handle it, we can safely push it up.
 	 */
-	if (batadv_bla_rx(bat_priv, skb, vid, is_bcast))
+	if (batadv_bla_rx(bat_priv, skb, vid, packet_type))
 		goto out;
 
 	if (orig_node)
-- 
2.25.1



