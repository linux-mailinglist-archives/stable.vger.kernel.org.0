Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAF527C79C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgI2Lyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730970AbgI2Lpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 265B82074A;
        Tue, 29 Sep 2020 11:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379937;
        bh=cZ2tbxth4Mk4moZckChFCWivyag5Ri0GoPERLYhW2vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVFbIqlFDYrtjoFUwnVFj/Zw/LeheFSCsd2RZiI4chudT1YyCyuhIzs3pxuoqxN/1
         gYbZ7Qaw0AWA7jEGkY9exQd49skN1lHRRuTA32cNe2zCI5GVDqqSIdCxf8i56ZUCO7
         lzl1Gr82Be95Vi2SYuE3WylO3weE/nCcK8NFS1ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 354/388] batman-adv: mcast: fix duplicate mcast packets in BLA backbone from LAN
Date:   Tue, 29 Sep 2020 13:01:25 +0200
Message-Id: <20200929110027.602126275@linuxfoundation.org>
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

[ Upstream commit 3236d215ad38a3f5372e65cd1e0a52cf93d3c6a2 ]

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

Fixes: 2d3f6ccc4ea5 ("batman-adv: Modified forwarding behaviour for multicast packets")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/multicast.c      | 46 ++++++++++++++++++++++++++-------
 net/batman-adv/multicast.h      | 15 +++++++++++
 net/batman-adv/soft-interface.c |  5 ++--
 3 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 1d5bdf3a4b655..f5bf931252c4b 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -51,6 +51,7 @@
 #include <uapi/linux/batadv_packet.h>
 #include <uapi/linux/batman_adv.h>
 
+#include "bridge_loop_avoidance.h"
 #include "hard-interface.h"
 #include "hash.h"
 #include "log.h"
@@ -1434,6 +1435,35 @@ batadv_mcast_forw_mode(struct batadv_priv *bat_priv, struct sk_buff *skb,
 	return BATADV_FORW_ALL;
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
  * batadv_mcast_forw_tt() - forwards a packet to multicast listeners
  * @bat_priv: the bat priv with all the soft interface information
@@ -1471,8 +1501,8 @@ batadv_mcast_forw_tt(struct batadv_priv *bat_priv, struct sk_buff *skb,
 			break;
 		}
 
-		batadv_send_skb_unicast(bat_priv, newskb, BATADV_UNICAST, 0,
-					orig_entry->orig_node, vid);
+		batadv_mcast_forw_send_orig(bat_priv, newskb, vid,
+					    orig_entry->orig_node);
 	}
 	rcu_read_unlock();
 
@@ -1513,8 +1543,7 @@ batadv_mcast_forw_want_all_ipv4(struct batadv_priv *bat_priv,
 			break;
 		}
 
-		batadv_send_skb_unicast(bat_priv, newskb, BATADV_UNICAST, 0,
-					orig_node, vid);
+		batadv_mcast_forw_send_orig(bat_priv, newskb, vid, orig_node);
 	}
 	rcu_read_unlock();
 	return ret;
@@ -1551,8 +1580,7 @@ batadv_mcast_forw_want_all_ipv6(struct batadv_priv *bat_priv,
 			break;
 		}
 
-		batadv_send_skb_unicast(bat_priv, newskb, BATADV_UNICAST, 0,
-					orig_node, vid);
+		batadv_mcast_forw_send_orig(bat_priv, newskb, vid, orig_node);
 	}
 	rcu_read_unlock();
 	return ret;
@@ -1618,8 +1646,7 @@ batadv_mcast_forw_want_all_rtr4(struct batadv_priv *bat_priv,
 			break;
 		}
 
-		batadv_send_skb_unicast(bat_priv, newskb, BATADV_UNICAST, 0,
-					orig_node, vid);
+		batadv_mcast_forw_send_orig(bat_priv, newskb, vid, orig_node);
 	}
 	rcu_read_unlock();
 	return ret;
@@ -1656,8 +1683,7 @@ batadv_mcast_forw_want_all_rtr6(struct batadv_priv *bat_priv,
 			break;
 		}
 
-		batadv_send_skb_unicast(bat_priv, newskb, BATADV_UNICAST, 0,
-					orig_node, vid);
+		batadv_mcast_forw_send_orig(bat_priv, newskb, vid, orig_node);
 	}
 	rcu_read_unlock();
 	return ret;
diff --git a/net/batman-adv/multicast.h b/net/batman-adv/multicast.h
index 5d9e2bb29c971..403929013ac47 100644
--- a/net/batman-adv/multicast.h
+++ b/net/batman-adv/multicast.h
@@ -46,6 +46,11 @@ enum batadv_forw_mode
 batadv_mcast_forw_mode(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		       struct batadv_orig_node **mcast_single_orig);
 
+int batadv_mcast_forw_send_orig(struct batadv_priv *bat_priv,
+				struct sk_buff *skb,
+				unsigned short vid,
+				struct batadv_orig_node *orig_node);
+
 int batadv_mcast_forw_send(struct batadv_priv *bat_priv, struct sk_buff *skb,
 			   unsigned short vid);
 
@@ -71,6 +76,16 @@ batadv_mcast_forw_mode(struct batadv_priv *bat_priv, struct sk_buff *skb,
 	return BATADV_FORW_ALL;
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
 static inline int
 batadv_mcast_forw_send(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		       unsigned short vid)
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 5ee8e9a100f90..cf1a8ef7464f5 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -364,9 +364,8 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 				goto dropped;
 			ret = batadv_send_skb_via_gw(bat_priv, skb, vid);
 		} else if (mcast_single_orig) {
-			ret = batadv_send_skb_unicast(bat_priv, skb,
-						      BATADV_UNICAST, 0,
-						      mcast_single_orig, vid);
+			ret = batadv_mcast_forw_send_orig(bat_priv, skb, vid,
+							  mcast_single_orig);
 		} else if (forw_mode == BATADV_FORW_SOME) {
 			ret = batadv_mcast_forw_send(bat_priv, skb, vid);
 		} else {
-- 
2.25.1



