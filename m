Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5600E4520C1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242404AbhKPA4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343554AbhKOTVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4118B6330F;
        Mon, 15 Nov 2021 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001726;
        bh=eBbeKwCfNUPbAgH5kAzgZ+WD9X72XLIuHaf0/fPHfTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4BSr52d7TQUQPqAE/mIw8WGGyWsKOjRCkIsI/ROUFwv31Kkh4gJY1hW1cvPS8kVx
         J5WuXm9kIbnH6JvVFqPzetJhDibejTHWHnG+K2JVbZelMHaqS66KdZLKjy1SvFPULT
         JHd/JJL46LkTw6vrWJDBdLKWynFW5vIs6XYclY7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 297/917] vrf: run conntrack only in context of lower/physdev for locally generated packets
Date:   Mon, 15 Nov 2021 17:56:32 +0100
Message-Id: <20211115165438.834798151@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8c9c296adfae9ea05f655d69e9f6e13daa86fb4a ]

The VRF driver invokes netfilter for output+postrouting hooks so that users
can create rules that check for 'oif $vrf' rather than lower device name.

This is a problem when NAT rules are configured.

To avoid any conntrack involvement in round 1, tag skbs as 'untracked'
to prevent conntrack from picking them up.

This gets cleared before the packet gets handed to the ip stack so
conntrack will be active on the second iteration.

One remaining issue is that a rule like

  output ... oif $vrfname notrack

won't propagate to the second round because we can't tell
'notrack set via ruleset' and 'notrack set by vrf driver' apart.
However, this isn't a regression: the 'notrack' removal happens
instead of unconditional nf_reset_ct().
I'd also like to avoid leaking more vrf specific conditionals into the
netfilter infra.

For ingress, conntrack has already been done before the packet makes it
to the vrf driver, with this patch egress does connection tracking with
lower/physical device as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 662e261173539..ccf677015d5bc 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -35,6 +35,7 @@
 #include <net/l3mdev.h>
 #include <net/fib_rules.h>
 #include <net/netns/generic.h>
+#include <net/netfilter/nf_conntrack.h>
 
 #define DRV_NAME	"vrf"
 #define DRV_VERSION	"1.1"
@@ -424,12 +425,26 @@ static int vrf_local_xmit(struct sk_buff *skb, struct net_device *dev,
 	return NETDEV_TX_OK;
 }
 
+static void vrf_nf_set_untracked(struct sk_buff *skb)
+{
+	if (skb_get_nfct(skb) == 0)
+		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+}
+
+static void vrf_nf_reset_ct(struct sk_buff *skb)
+{
+	if (skb_get_nfct(skb) == IP_CT_UNTRACKED)
+		nf_reset_ct(skb);
+}
+
 #if IS_ENABLED(CONFIG_IPV6)
 static int vrf_ip6_local_out(struct net *net, struct sock *sk,
 			     struct sk_buff *skb)
 {
 	int err;
 
+	vrf_nf_reset_ct(skb);
+
 	err = nf_hook(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net,
 		      sk, skb, NULL, skb_dst(skb)->dev, dst_output);
 
@@ -508,6 +523,8 @@ static int vrf_ip_local_out(struct net *net, struct sock *sk,
 {
 	int err;
 
+	vrf_nf_reset_ct(skb);
+
 	err = nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT, net, sk,
 		      skb, NULL, skb_dst(skb)->dev, dst_output);
 	if (likely(err == 1))
@@ -626,8 +643,7 @@ static void vrf_finish_direct(struct sk_buff *skb)
 		skb_pull(skb, ETH_HLEN);
 	}
 
-	/* reset skb device */
-	nf_reset_ct(skb);
+	vrf_nf_reset_ct(skb);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -641,7 +657,7 @@ static int vrf_finish_output6(struct net *net, struct sock *sk,
 	struct neighbour *neigh;
 	int ret;
 
-	nf_reset_ct(skb);
+	vrf_nf_reset_ct(skb);
 
 	skb->protocol = htons(ETH_P_IPV6);
 	skb->dev = dev;
@@ -752,6 +768,8 @@ static struct sk_buff *vrf_ip6_out_direct(struct net_device *vrf_dev,
 
 	skb->dev = vrf_dev;
 
+	vrf_nf_set_untracked(skb);
+
 	err = nf_hook(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk,
 		      skb, NULL, vrf_dev, vrf_ip6_out_direct_finish);
 
@@ -858,7 +876,7 @@ static int vrf_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 	struct neighbour *neigh;
 	bool is_v6gw = false;
 
-	nf_reset_ct(skb);
+	vrf_nf_reset_ct(skb);
 
 	/* Be paranoid, rather than too clever. */
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
@@ -980,6 +998,8 @@ static struct sk_buff *vrf_ip_out_direct(struct net_device *vrf_dev,
 
 	skb->dev = vrf_dev;
 
+	vrf_nf_set_untracked(skb);
+
 	err = nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT, net, sk,
 		      skb, NULL, vrf_dev, vrf_ip_out_direct_finish);
 
-- 
2.33.0



