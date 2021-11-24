Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9EC45BAB7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242360AbhKXMOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:14:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242522AbhKXMLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:11:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A56EC61053;
        Wed, 24 Nov 2021 12:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755601;
        bh=nJMQcb4i7Xq3qYoWrq8JbAdlxQWO7vjE5guzu8RnY/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9KN0u+CL6RSkMGg6A+Tg1PYEUC8MPh2O7DH30t8xeBWuRHM1EXd5yKdbd25SqCzR
         Gg385fBPo0QjrAH1d3dZs/Ww+TDkQRUbXYEj+2hQNGZStKFTDwgKPVRUtAfHanberN
         JCdh/259PINjxXv9v/bHrENDBbbF4pnKLWGRFARo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Linus=20L=FCssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.4 153/162] batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh
Date:   Wed, 24 Nov 2021 12:57:36 +0100
Message-Id: <20211124115703.231890862@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

commit 74c09b7275126da1b642b90c9cdc3ae8b729ad4b upstream

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

Fixes: 2d3f6ccc4ea5 ("batman-adv: check incoming packet type for bla")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Acked-by: Simon Wunderlich <sw@simonwunderlich.de>
[ bp: 4.4 backported: adjust context, correct fixes line ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |   34 ++++++++++++++++++++++++---------
 net/batman-adv/bridge_loop_avoidance.h |    4 +--
 net/batman-adv/soft-interface.c        |    6 ++---
 3 files changed, 30 insertions(+), 14 deletions(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1542,7 +1542,7 @@ void batadv_bla_free(struct batadv_priv
  * @bat_priv: the bat priv with all the soft interface information
  * @skb: the frame to be checked
  * @vid: the VLAN ID of the frame
- * @is_bcast: the packet came in a broadcast packet type.
+ * @packet_type: the batman packet type this frame came in
  *
  * bla_rx avoidance checks if:
  *  * we have to race for a claim
@@ -1553,7 +1553,7 @@ void batadv_bla_free(struct batadv_priv
  * process the skb.
  */
 int batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
-		  unsigned short vid, bool is_bcast)
+		  unsigned short vid, int packet_type)
 {
 	struct batadv_bla_backbone_gw *backbone_gw;
 	struct ethhdr *ethhdr;
@@ -1572,9 +1572,24 @@ int batadv_bla_rx(struct batadv_priv *ba
 		goto allow;
 
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
@@ -1602,13 +1617,14 @@ int batadv_bla_rx(struct batadv_priv *ba
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
--- a/net/batman-adv/bridge_loop_avoidance.h
+++ b/net/batman-adv/bridge_loop_avoidance.h
@@ -27,7 +27,7 @@ struct sk_buff;
 
 #ifdef CONFIG_BATMAN_ADV_BLA
 int batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
-		  unsigned short vid, bool is_bcast);
+		  unsigned short vid, int packet_type);
 int batadv_bla_tx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		  unsigned short vid);
 int batadv_bla_is_backbone_gw(struct sk_buff *skb,
@@ -50,7 +50,7 @@ void batadv_bla_free(struct batadv_priv
 
 static inline int batadv_bla_rx(struct batadv_priv *bat_priv,
 				struct sk_buff *skb, unsigned short vid,
-				bool is_bcast)
+				int packet_type)
 {
 	return 0;
 }
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -393,10 +393,10 @@ void batadv_interface_rx(struct net_devi
 	struct vlan_ethhdr *vhdr;
 	struct ethhdr *ethhdr;
 	unsigned short vid;
-	bool is_bcast;
+	int packet_type;
 
 	batadv_bcast_packet = (struct batadv_bcast_packet *)skb->data;
-	is_bcast = (batadv_bcast_packet->packet_type == BATADV_BCAST);
+	packet_type = batadv_bcast_packet->packet_type;
 
 	/* check if enough space is available for pulling, and pull */
 	if (!pskb_may_pull(skb, hdr_size))
@@ -444,7 +444,7 @@ void batadv_interface_rx(struct net_devi
 	/* Let the bridge loop avoidance check the packet. If will
 	 * not handle it, we can safely push it up.
 	 */
-	if (batadv_bla_rx(bat_priv, skb, vid, is_bcast))
+	if (batadv_bla_rx(bat_priv, skb, vid, packet_type))
 		goto out;
 
 	if (orig_node)


