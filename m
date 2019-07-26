Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCF776D87
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389782AbfGZPeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389805AbfGZPeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:34:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07E48218D4;
        Fri, 26 Jul 2019 15:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155254;
        bh=9Vs9GVRd9TJQm5SDEB14JCe59/uTBsjFm7m7oH9GKzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSFa0zOgwQqn5mCd3FWgAuifDJH4yB4hgaUzsrA8t/IPr0KnLrd2sy/DvCGpteQ82
         Acwsm/MaOonzbtc/AtZETqN/CEJ4DQIvMhtKk3xQ844vaYQCko5NSB4JUj8sG+x64B
         LcF0hhtSXJonNtTR0q35arxFE/gZOO1gGYX0jhDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 34/50] net: bridge: dont cache ether dest pointer on input
Date:   Fri, 26 Jul 2019 17:25:09 +0200
Message-Id: <20190726152304.139481279@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit 3d26eb8ad1e9b906433903ce05f775cf038e747f ]

We would cache ether dst pointer on input in br_handle_frame_finish but
after the neigh suppress code that could lead to a stale pointer since
both ipv4 and ipv6 suppress code do pskb_may_pull. This means we have to
always reload it after the suppress code so there's no point in having
it cached just retrieve it directly.

Fixes: 057658cb33fbf ("bridge: suppress arp pkts on BR_NEIGH_SUPPRESS ports")
Fixes: ed842faeb2bd ("bridge: suppress nd pkts on BR_NEIGH_SUPPRESS ports")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_input.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -79,7 +79,6 @@ int br_handle_frame_finish(struct net *n
 	struct net_bridge_fdb_entry *dst = NULL;
 	struct net_bridge_mdb_entry *mdst;
 	bool local_rcv, mcast_hit = false;
-	const unsigned char *dest;
 	struct net_bridge *br;
 	u16 vid = 0;
 
@@ -97,10 +96,9 @@ int br_handle_frame_finish(struct net *n
 		br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, false);
 
 	local_rcv = !!(br->dev->flags & IFF_PROMISC);
-	dest = eth_hdr(skb)->h_dest;
-	if (is_multicast_ether_addr(dest)) {
+	if (is_multicast_ether_addr(eth_hdr(skb)->h_dest)) {
 		/* by definition the broadcast is also a multicast address */
-		if (is_broadcast_ether_addr(dest)) {
+		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
 			pkt_type = BR_PKT_BROADCAST;
 			local_rcv = true;
 		} else {
@@ -150,7 +148,7 @@ int br_handle_frame_finish(struct net *n
 		}
 		break;
 	case BR_PKT_UNICAST:
-		dst = br_fdb_find_rcu(br, dest, vid);
+		dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);
 	default:
 		break;
 	}


