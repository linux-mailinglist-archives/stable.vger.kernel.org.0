Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF5A45BAEF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242745AbhKXMP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:15:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239429AbhKXML7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:11:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F7F361055;
        Wed, 24 Nov 2021 12:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755603;
        bh=Z/VNU1RaKqKV/YptkOOxZfQXnN6ycPQy866fdMVVMbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnIDIjPqdli6un8651p9uAgzImdgj5XLQK7tyTBNsL4temYw0MuNZ7YyFjOcLrLlh
         GNjknotf9UCJXz7iH/1lnSgXqQcMOy8xNupQR9pqMVItGFCEZVmsCA5RVsMl82c2dp
         neUI6/HFxpvCLGuubd8L/tWnAYYTwToTnCns7Fh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Linus=20L=FCssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.4 154/162] batman-adv: mcast: fix duplicate mcast packets from BLA backbone to mesh
Date:   Wed, 24 Nov 2021 12:57:37 +0100
Message-Id: <20211124115703.262303418@linuxfoundation.org>
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

From: Linus L�ssing <linus.luessing@c0d3.blue>

commit 2369e827046920ef0599e6a36b975ac5c0a359c2 upstream.

Scenario:
* Multicast frame send from BLA backbone gateways (multiple nodes
  with their bat0 bridged together, with BLA enabled) sharing the same
  LAN to nodes in the mesh

Issue:
* Nodes receive the frame multiple times on bat0 from the mesh,
  once from each foreign BLA backbone gateway which shares the same LAN
  with another

For multicast frames via batman-adv broadcast packets coming from the
same BLA backbone but from different backbone gateways duplicates are
currently detected via a CRC history of previously received packets.

However this CRC so far was not performed for multicast frames received
via batman-adv unicast packets. Fixing this by appyling the same check
for such packets, too.

Room for improvements in the future: Ideally we would introduce the
possibility to not only claim a client, but a complete originator, too.
This would allow us to only send a multicast-in-unicast packet from a BLA
backbone gateway claiming the node and by that avoid potential redundant
transmissions in the first place.

Fixes: fe2da6ff27c7 ("batman-adv: add broadcast duplicate check")
Signed-off-by: Linus L�ssing <linus.luessing@c0d3.blue>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[ bp: 4.4 backported: adjust context, correct fixes line, switch back to
  int return type ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |   99 ++++++++++++++++++++++++++++-----
 1 file changed, 85 insertions(+), 14 deletions(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1370,31 +1370,32 @@ int batadv_bla_init(struct batadv_priv *
 }
 
 /**
- * batadv_bla_check_bcast_duplist
+ * batadv_bla_check_duplist() - Check if a frame is in the broadcast dup.
  * @bat_priv: the bat priv with all the soft interface information
- * @skb: contains the bcast_packet to be checked
+ * @skb: contains the multicast packet to be checked
+ * @payload_ptr: pointer to position inside the head buffer of the skb
+ *  marking the start of the data to be CRC'ed
+ * @orig: originator mac address, NULL if unknown
  *
- * check if it is on our broadcast list. Another gateway might
- * have sent the same packet because it is connected to the same backbone,
- * so we have to remove this duplicate.
+ * Check if it is on our broadcast list. Another gateway might have sent the
+ * same packet because it is connected to the same backbone, so we have to
+ * remove this duplicate.
  *
  * This is performed by checking the CRC, which will tell us
  * with a good chance that it is the same packet. If it is furthermore
  * sent by another host, drop it. We allow equal packets from
  * the same host however as this might be intended.
  */
-int batadv_bla_check_bcast_duplist(struct batadv_priv *bat_priv,
-				   struct sk_buff *skb)
+static int batadv_bla_check_duplist(struct batadv_priv *bat_priv,
+				    struct sk_buff *skb, u8 *payload_ptr,
+				    const u8 *orig)
 {
 	int i, curr, ret = 0;
 	__be32 crc;
-	struct batadv_bcast_packet *bcast_packet;
 	struct batadv_bcast_duplist_entry *entry;
 
-	bcast_packet = (struct batadv_bcast_packet *)skb->data;
-
 	/* calculate the crc ... */
-	crc = batadv_skb_crc32(skb, (u8 *)(bcast_packet + 1));
+	crc = batadv_skb_crc32(skb, payload_ptr);
 
 	spin_lock_bh(&bat_priv->bla.bcast_duplist_lock);
 
@@ -1413,8 +1414,21 @@ int batadv_bla_check_bcast_duplist(struc
 		if (entry->crc != crc)
 			continue;
 
-		if (batadv_compare_eth(entry->orig, bcast_packet->orig))
-			continue;
+		/* are the originators both known and not anonymous? */
+		if (orig && !is_zero_ether_addr(orig) &&
+		    !is_zero_ether_addr(entry->orig)) {
+			/* If known, check if the new frame came from
+			 * the same originator:
+			 * We are safe to take identical frames from the
+			 * same orig, if known, as multiplications in
+			 * the mesh are detected via the (orig, seqno) pair.
+			 * So we can be a bit more liberal here and allow
+			 * identical frames from the same orig which the source
+			 * host might have sent multiple times on purpose.
+			 */
+			if (batadv_compare_eth(entry->orig, orig))
+				continue;
+		}
 
 		/* this entry seems to match: same crc, not too old,
 		 * and from another gw. therefore return 1 to forbid it.
@@ -1430,7 +1444,14 @@ int batadv_bla_check_bcast_duplist(struc
 	entry = &bat_priv->bla.bcast_duplist[curr];
 	entry->crc = crc;
 	entry->entrytime = jiffies;
-	ether_addr_copy(entry->orig, bcast_packet->orig);
+
+	/* known originator */
+	if (orig)
+		ether_addr_copy(entry->orig, orig);
+	/* anonymous originator */
+	else
+		eth_zero_addr(entry->orig);
+
 	bat_priv->bla.bcast_duplist_curr = curr;
 
 out:
@@ -1440,6 +1461,48 @@ out:
 }
 
 /**
+ * batadv_bla_check_ucast_duplist() - Check if a frame is in the broadcast dup.
+ * @bat_priv: the bat priv with all the soft interface information
+ * @skb: contains the multicast packet to be checked, decapsulated from a
+ *  unicast_packet
+ *
+ * Check if it is on our broadcast list. Another gateway might have sent the
+ * same packet because it is connected to the same backbone, so we have to
+ * remove this duplicate.
+ *
+ * Return: true if a packet is in the duplicate list, false otherwise.
+ */
+static bool batadv_bla_check_ucast_duplist(struct batadv_priv *bat_priv,
+					   struct sk_buff *skb)
+{
+	return batadv_bla_check_duplist(bat_priv, skb, (u8 *)skb->data, NULL);
+}
+
+/**
+ * batadv_bla_check_bcast_duplist() - Check if a frame is in the broadcast dup.
+ * @bat_priv: the bat priv with all the soft interface information
+ * @skb: contains the bcast_packet to be checked
+ *
+ * Check if it is on our broadcast list. Another gateway might have sent the
+ * same packet because it is connected to the same backbone, so we have to
+ * remove this duplicate.
+ *
+ * Return: true if a packet is in the duplicate list, false otherwise.
+ */
+int batadv_bla_check_bcast_duplist(struct batadv_priv *bat_priv,
+				   struct sk_buff *skb)
+{
+	struct batadv_bcast_packet *bcast_packet;
+	u8 *payload_ptr;
+
+	bcast_packet = (struct batadv_bcast_packet *)skb->data;
+	payload_ptr = (u8 *)(bcast_packet + 1);
+
+	return batadv_bla_check_duplist(bat_priv, skb, payload_ptr,
+					bcast_packet->orig);
+}
+
+/**
  * batadv_bla_is_backbone_gw_orig
  * @bat_priv: the bat priv with all the soft interface information
  * @orig: originator mac address
@@ -1591,6 +1654,14 @@ int batadv_bla_rx(struct batadv_priv *ba
 			    packet_type == BATADV_UNICAST)
 				goto handled;
 
+	/* potential duplicates from foreign BLA backbone gateways via
+	 * multicast-in-unicast packets
+	 */
+	if (is_multicast_ether_addr(ethhdr->h_dest) &&
+	    packet_type == BATADV_UNICAST &&
+	    batadv_bla_check_ucast_duplist(bat_priv, skb))
+		goto handled;
+
 	ether_addr_copy(search_claim.addr, ethhdr->h_source);
 	search_claim.vid = vid;
 	claim = batadv_claim_hash_find(bat_priv, &search_claim);


