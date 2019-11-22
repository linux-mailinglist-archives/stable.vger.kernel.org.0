Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65BEB106E5A
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbfKVLEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:04:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730950AbfKVLEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4455E2084D;
        Fri, 22 Nov 2019 11:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420679;
        bh=Bb7rzqBJjmBbvr7XAuy08cxKHrBROKdq85oHPWcCyEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7gObVwqSsgOKKeIrBDyO1GqhlwIiIMityrRj21csgSU8z+2/3NGCazgWzPWXdELX
         hd5geR1/3nJ7LybBqZZpZEWhuUltnW/8eWTajW9gGaPr18D1mRRIlshs1g2hzb0MWm
         0GO1hdMWC9+zchP8OaVlNzCQ5Pt7PEnY3O9gQb1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 189/220] net: fix generic XDP to handle if eth header was mangled
Date:   Fri, 22 Nov 2019 11:29:14 +0100
Message-Id: <20191122100927.741135903@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 2972495699320229b55b8e5065a310be5c81485b ]

XDP can modify (and resize) the Ethernet header in the packet.

There is a bug in generic-XDP, because skb->protocol and skb->pkt_type
are setup before reaching (netif_receive_)generic_xdp.

This bug was hit when XDP were popping VLAN headers (changing
eth->h_proto), as skb->protocol still contains VLAN-indication
(ETH_P_8021Q) causing invocation of skb_vlan_untag(skb), which corrupt
the packet (basically popping the VLAN again).

This patch catch if XDP changed eth header in such a way, that SKB
fields needs to be updated.

V2: on request from Song Liu, use ETH_HLEN instead of mac_len,
in __skb_push() as eth_type_trans() use ETH_HLEN in paired skb_pull_inline().

Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4a2ee1ce6c024..e96c88b1465d7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4296,6 +4296,9 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	struct netdev_rx_queue *rxqueue;
 	void *orig_data, *orig_data_end;
 	u32 metalen, act = XDP_DROP;
+	__be16 orig_eth_type;
+	struct ethhdr *eth;
+	bool orig_bcast;
 	int hlen, off;
 	u32 mac_len;
 
@@ -4336,6 +4339,9 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	xdp->data_hard_start = skb->data - skb_headroom(skb);
 	orig_data_end = xdp->data_end;
 	orig_data = xdp->data;
+	eth = (struct ethhdr *)xdp->data;
+	orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
+	orig_eth_type = eth->h_proto;
 
 	rxqueue = netif_get_rxqueue(skb);
 	xdp->rxq = &rxqueue->xdp_rxq;
@@ -4359,6 +4365,14 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 
 	}
 
+	/* check if XDP changed eth hdr such SKB needs update */
+	eth = (struct ethhdr *)xdp->data;
+	if ((orig_eth_type != eth->h_proto) ||
+	    (orig_bcast != is_multicast_ether_addr_64bits(eth->h_dest))) {
+		__skb_push(skb, ETH_HLEN);
+		skb->protocol = eth_type_trans(skb, skb->dev);
+	}
+
 	switch (act) {
 	case XDP_REDIRECT:
 	case XDP_TX:
-- 
2.20.1



