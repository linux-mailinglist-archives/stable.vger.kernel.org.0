Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF28537CEB5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbhELRGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237994AbhELQtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:49:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C91761D70;
        Wed, 12 May 2021 16:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836165;
        bh=YzsIS8v4mpKmWDdMV6RN/8wpsZ2+pygsMwrWVJ/trx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gm1F8pO0EdzAnHZ3hJMMCrZfSIDKMq7fIMmYGPtBc0IexPeaTNYDGs5X5sROJOZBI
         Hw0fUVPp4oKgZ/FbYE2pbScbPS1pcXS8dicCQvGm7ZyDOxRf6q5K8t32BcnQUO2d9D
         GJnH9lZwJEI4a6/SrhCXsY02kpadr9bUapIw9nfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 635/677] net, xdp: Update pkt_type if generic XDP changes unicast MAC
Date:   Wed, 12 May 2021 16:51:21 +0200
Message-Id: <20210512144858.460538181@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Willi <martin@strongswan.org>

[ Upstream commit 22b6034323fd736f260e00b9ea85c634abeb3446 ]

If a generic XDP program changes the destination MAC address from/to
multicast/broadcast, the skb->pkt_type is updated to properly handle
the packet when passed up the stack. When changing the MAC from/to
the NICs MAC, PACKET_HOST/OTHERHOST is not updated, though, making
the behavior different from that of native XDP.

Remember the PACKET_HOST/OTHERHOST state before calling the program
in generic XDP, and update pkt_type accordingly if the destination
MAC address has changed. As eth_type_trans() assumes a default
pkt_type of PACKET_HOST, restore that before calling it.

The use case for this is when a XDP program wants to push received
packets up the stack by rewriting the MAC to the NICs MAC, for
example by cluster nodes sharing MAC addresses.

Fixes: 297249569932 ("net: fix generic XDP to handle if eth header was mangled")
Signed-off-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/20210419141559.8611-1-martin@strongswan.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 15fe36332fb8..70829c568645 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4672,10 +4672,10 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	void *orig_data, *orig_data_end, *hard_start;
 	struct netdev_rx_queue *rxqueue;
 	u32 metalen, act = XDP_DROP;
+	bool orig_bcast, orig_host;
 	u32 mac_len, frame_sz;
 	__be16 orig_eth_type;
 	struct ethhdr *eth;
-	bool orig_bcast;
 	int off;
 
 	/* Reinjected packets coming from act_mirred or similar should
@@ -4722,6 +4722,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	orig_data_end = xdp->data_end;
 	orig_data = xdp->data;
 	eth = (struct ethhdr *)xdp->data;
+	orig_host = ether_addr_equal_64bits(eth->h_dest, skb->dev->dev_addr);
 	orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
 	orig_eth_type = eth->h_proto;
 
@@ -4749,8 +4750,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	/* check if XDP changed eth hdr such SKB needs update */
 	eth = (struct ethhdr *)xdp->data;
 	if ((orig_eth_type != eth->h_proto) ||
+	    (orig_host != ether_addr_equal_64bits(eth->h_dest,
+						  skb->dev->dev_addr)) ||
 	    (orig_bcast != is_multicast_ether_addr_64bits(eth->h_dest))) {
 		__skb_push(skb, ETH_HLEN);
+		skb->pkt_type = PACKET_HOST;
 		skb->protocol = eth_type_trans(skb, skb->dev);
 	}
 
-- 
2.30.2



