Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA96945C17E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344894AbhKXNTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:19:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345683AbhKXNRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:17:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B1F861AE0;
        Wed, 24 Nov 2021 12:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757914;
        bh=6SPqLZZkeRib2ZXVx8rKUFTSnAPT5l01zq1gDgH69MU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l09dkyDzJ68RcU+tHzI56A+/EHZz/OeFyGwvJGiXW7cwPoU0S4xMJBpZqA3ilus4G
         MXFSzI9yn1k5D0J/VrXkhXSeabz+uXSYdem+Vixg+0e7TqXNsC1XfuMvIonZQrhDZ+
         QBkZLm2i2lqnTqyIa444dfyYYbXccqQNMw8IdCHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.19 318/323] batman-adv: Reserve needed_*room for fragments
Date:   Wed, 24 Nov 2021 12:58:28 +0100
Message-Id: <20211124115729.654328758@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit c5cbfc87558168ef4c3c27ce36eba6b83391db19 upstream.

The batadv net_device is trying to propagate the needed_headroom and
needed_tailroom from the lower devices. This is needed to avoid cost
intensive reallocations using pskb_expand_head during the transmission.

But the fragmentation code split the skb's without adding extra room at the
end/beginning of the various fragments. This reduced the performance of
transmissions over complex scenarios (batadv on vxlan on wireguard) because
the lower devices had to perform the reallocations at least once.

Fixes: ee75ed88879a ("batman-adv: Fragment and send skbs larger than mtu")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[ bp: 4.19 backported: adjust context. ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -403,6 +403,7 @@ out:
 
 /**
  * batadv_frag_create() - create a fragment from skb
+ * @net_dev: outgoing device for fragment
  * @skb: skb to create fragment from
  * @frag_head: header to use in new fragment
  * @fragment_size: size of new fragment
@@ -413,22 +414,25 @@ out:
  *
  * Return: the new fragment, NULL on error.
  */
-static struct sk_buff *batadv_frag_create(struct sk_buff *skb,
+static struct sk_buff *batadv_frag_create(struct net_device *net_dev,
+					  struct sk_buff *skb,
 					  struct batadv_frag_packet *frag_head,
 					  unsigned int fragment_size)
 {
+	unsigned int ll_reserved = LL_RESERVED_SPACE(net_dev);
+	unsigned int tailroom = net_dev->needed_tailroom;
 	struct sk_buff *skb_fragment;
 	unsigned int header_size = sizeof(*frag_head);
 	unsigned int mtu = fragment_size + header_size;
 
-	skb_fragment = netdev_alloc_skb(NULL, mtu + ETH_HLEN);
+	skb_fragment = dev_alloc_skb(ll_reserved + mtu + tailroom);
 	if (!skb_fragment)
 		goto err;
 
 	skb_fragment->priority = skb->priority;
 
 	/* Eat the last mtu-bytes of the skb */
-	skb_reserve(skb_fragment, header_size + ETH_HLEN);
+	skb_reserve(skb_fragment, ll_reserved + header_size);
 	skb_split(skb, skb_fragment, skb->len - fragment_size);
 
 	/* Add the header */
@@ -451,11 +455,12 @@ int batadv_frag_send_packet(struct sk_bu
 			    struct batadv_orig_node *orig_node,
 			    struct batadv_neigh_node *neigh_node)
 {
+	struct net_device *net_dev = neigh_node->if_incoming->net_dev;
 	struct batadv_priv *bat_priv;
 	struct batadv_hard_iface *primary_if = NULL;
 	struct batadv_frag_packet frag_header;
 	struct sk_buff *skb_fragment;
-	unsigned int mtu = neigh_node->if_incoming->net_dev->mtu;
+	unsigned int mtu = net_dev->mtu;
 	unsigned int header_size = sizeof(frag_header);
 	unsigned int max_fragment_size, num_fragments;
 	int ret;
@@ -515,7 +520,7 @@ int batadv_frag_send_packet(struct sk_bu
 			goto put_primary_if;
 		}
 
-		skb_fragment = batadv_frag_create(skb, &frag_header,
+		skb_fragment = batadv_frag_create(net_dev, skb, &frag_header,
 						  max_fragment_size);
 		if (!skb_fragment) {
 			ret = -ENOMEM;


