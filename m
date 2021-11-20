Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159C7457E4D
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 13:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237147AbhKTMnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 07:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbhKTMnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 07:43:17 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0671AC061574
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 04:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1637412007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rqDcyACbX/YmfL60LhCXw6iEA/3B6JBSEF6Oe6bJ/Yk=;
        b=ZnjAVfrvfb+W36Q+aAEnqeest9JvriWt63lihLgBe8ezPKzBlmKN49EHTkL03jbW0TirMF
        i7M9Drh2cWrBGEQI/EQ8JOXVMNTPQN9IKtzEzQUp5U33+S3guYhNhXgz2b6orRaakzMlS0
        RwiRy07ob3qJ8h+80vpJ+pGhXJRgUF8=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.9 3/7] batman-adv: mcast: fix duplicate mcast packets in BLA backbone from LAN
Date:   Sat, 20 Nov 2021 13:39:54 +0100
Message-Id: <20211120123958.260826-4-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211120123958.260826-1-sven@narfation.org>
References: <20211120123958.260826-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

commit 3236d215ad38a3f5372e65cd1e0a52cf93d3c6a2 upstream.

Scenario:
* Multicast frame send from a BLA backbone (multiple nodes with
  their bat0 bridged together, with BLA enabled)

Issue:
* BLA backbone nodes receive the frame multiple times on bat0

For multicast frames received via batman-adv broadcast packets the
originator of the broadcast packet is checked before decapsulating and
forwarding the frame to bat0 (batadv_bla_is_backbone_gw()->
batadv_recv_bcast_packet()). If it came from a node which shares the
same BLA backbone with us then it is not forwarded to bat0 to avoid a
loop.

When sending a multicast frame in a non-4-address batman-adv unicast
packet we are currently missing this check - and cannot do so because
the batman-adv unicast packet has no originator address field.

However, we can simply fix this on the sender side by only sending the
multicast frame via unicasts to interested nodes which do not share the
same BLA backbone with us. This also nicely avoids some unnecessary
transmissions on mesh side.

Note that no infinite loop was observed, probably because of dropping
via batadv_interface_tx()->batadv_bla_tx(). However the duplicates still
utterly confuse switches/bridges, ICMPv6 duplicate address detection and
neighbor discovery and therefore leads to long delays before being able
to establish TCP connections, for instance. And it also leads to the Linux
bridge printing messages like:
"br-lan: received packet on eth1 with own address as source address ..."

Fixes: fe2da6ff27c7 ("batman-adv: Modified forwarding behaviour for multicast packets")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[ bp: 4.9 backport: drop usage in non-existing batadv_mcast_forw_*. ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/multicast.c      | 31 +++++++++++++++++++++++++++++++
 net/batman-adv/multicast.h      | 15 +++++++++++++++
 net/batman-adv/soft-interface.c |  5 ++---
 3 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 5a2aac17805b..283ac3fb9429 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -53,10 +53,12 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 
+#include "bridge_loop_avoidance.h"
 #include "hard-interface.h"
 #include "hash.h"
 #include "log.h"
 #include "packet.h"
+#include "send.h"
 #include "translation-table.h"
 #include "tvlv.h"
 
@@ -1251,6 +1253,35 @@ void batadv_mcast_free(struct batadv_priv *bat_priv)
 	spin_unlock_bh(&bat_priv->tt.commit_lock);
 }
 
+/**
+ * batadv_mcast_forw_send_orig() - send a multicast packet to an originator
+ * @bat_priv: the bat priv with all the soft interface information
+ * @skb: the multicast packet to send
+ * @vid: the vlan identifier
+ * @orig_node: the originator to send the packet to
+ *
+ * Return: NET_XMIT_DROP in case of error or NET_XMIT_SUCCESS otherwise.
+ */
+int batadv_mcast_forw_send_orig(struct batadv_priv *bat_priv,
+				struct sk_buff *skb,
+				unsigned short vid,
+				struct batadv_orig_node *orig_node)
+{
+	/* Avoid sending multicast-in-unicast packets to other BLA
+	 * gateways - they already got the frame from the LAN side
+	 * we share with them.
+	 * TODO: Refactor to take BLA into account earlier, to avoid
+	 * reducing the mcast_fanout count.
+	 */
+	if (batadv_bla_is_backbone_gw_orig(bat_priv, orig_node->orig, vid)) {
+		dev_kfree_skb(skb);
+		return NET_XMIT_SUCCESS;
+	}
+
+	return batadv_send_skb_unicast(bat_priv, skb, BATADV_UNICAST, 0,
+				       orig_node, vid);
+}
+
 /**
  * batadv_mcast_purge_orig - reset originator global mcast state modifications
  * @orig: the originator which is going to get purged
diff --git a/net/batman-adv/multicast.h b/net/batman-adv/multicast.h
index 1fb00ba84907..751f54756164 100644
--- a/net/batman-adv/multicast.h
+++ b/net/batman-adv/multicast.h
@@ -45,6 +45,11 @@ enum batadv_forw_mode
 batadv_mcast_forw_mode(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		       struct batadv_orig_node **mcast_single_orig);
 
+int batadv_mcast_forw_send_orig(struct batadv_priv *bat_priv,
+				struct sk_buff *skb,
+				unsigned short vid,
+				struct batadv_orig_node *orig_node);
+
 void batadv_mcast_init(struct batadv_priv *bat_priv);
 
 int batadv_mcast_flags_seq_print_text(struct seq_file *seq, void *offset);
@@ -71,6 +76,16 @@ static inline int batadv_mcast_init(struct batadv_priv *bat_priv)
 	return 0;
 }
 
+static inline int
+batadv_mcast_forw_send_orig(struct batadv_priv *bat_priv,
+			    struct sk_buff *skb,
+			    unsigned short vid,
+			    struct batadv_orig_node *orig_node)
+{
+	kfree_skb(skb);
+	return NET_XMIT_DROP;
+}
+
 static inline void batadv_mcast_free(struct batadv_priv *bat_priv)
 {
 }
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index af0a8439cf08..4805c98588dc 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -356,9 +356,8 @@ static int batadv_interface_tx(struct sk_buff *skb,
 				goto dropped;
 			ret = batadv_send_skb_via_gw(bat_priv, skb, vid);
 		} else if (mcast_single_orig) {
-			ret = batadv_send_skb_unicast(bat_priv, skb,
-						      BATADV_UNICAST, 0,
-						      mcast_single_orig, vid);
+			ret = batadv_mcast_forw_send_orig(bat_priv, skb, vid,
+							  mcast_single_orig);
 		} else {
 			if (batadv_dat_snoop_outgoing_arp_request(bat_priv,
 								  skb))
-- 
2.30.2

