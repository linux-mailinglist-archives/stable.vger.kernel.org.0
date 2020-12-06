Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839DB2D03B5
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgLFLj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:39:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728288AbgLFLj4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:39:56 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 14/32] netfilter: bridge: reset skb->pkt_type after NF_INET_POST_ROUTING traversal
Date:   Sun,  6 Dec 2020 12:17:14 +0100
Message-Id: <20201206111556.448809404@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111555.787862631@linuxfoundation.org>
References: <20201206111555.787862631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 44f64f23bae2f0fad25503bc7ab86cd08d04cd47 ]

Netfilter changes PACKET_OTHERHOST to PACKET_HOST before invoking the
hooks as, while it's an expected value for a bridge, routing expects
PACKET_HOST. The change is undone later on after hook traversal. This
can be seen with pairs of functions updating skb>pkt_type and then
reverting it to its original value:

For hook NF_INET_PRE_ROUTING:
  setup_pre_routing / br_nf_pre_routing_finish

For hook NF_INET_FORWARD:
  br_nf_forward_ip / br_nf_forward_finish

But the third case where netfilter does this, for hook
NF_INET_POST_ROUTING, the packet type is changed in br_nf_post_routing
but never reverted. A comment says:

  /* We assume any code from br_dev_queue_push_xmit onwards doesn't care
   * about the value of skb->pkt_type. */

But when having a tunnel (say vxlan) attached to a bridge we have the
following call trace:

  br_nf_pre_routing
  br_nf_pre_routing_ipv6
     br_nf_pre_routing_finish
  br_nf_forward_ip
     br_nf_forward_finish
  br_nf_post_routing           <- pkt_type is updated to PACKET_HOST
     br_nf_dev_queue_xmit      <- but not reverted to its original value
  vxlan_xmit
     vxlan_xmit_one
        skb_tunnel_check_pmtu  <- a check on pkt_type is performed

In this specific case, this creates issues such as when an ICMPv6 PTB
should be sent back. When CONFIG_BRIDGE_NETFILTER is enabled, the PTB
isn't sent (as skb_tunnel_check_pmtu checks if pkt_type is PACKET_HOST
and returns early).

If the comment is right and no one cares about the value of
skb->pkt_type after br_dev_queue_push_xmit (which isn't true), resetting
it to its original value should be safe.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/20201123174902.622102-1-atenart@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_netfilter_hooks.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -719,6 +719,11 @@ static int br_nf_dev_queue_xmit(struct n
 	mtu_reserved = nf_bridge_mtu_reduction(skb);
 	mtu = skb->dev->mtu;
 
+	if (nf_bridge->pkt_otherhost) {
+		skb->pkt_type = PACKET_OTHERHOST;
+		nf_bridge->pkt_otherhost = false;
+	}
+
 	if (nf_bridge->frag_max_size && nf_bridge->frag_max_size < mtu)
 		mtu = nf_bridge->frag_max_size;
 
@@ -812,8 +817,6 @@ static unsigned int br_nf_post_routing(v
 	else
 		return NF_ACCEPT;
 
-	/* We assume any code from br_dev_queue_push_xmit onwards doesn't care
-	 * about the value of skb->pkt_type. */
 	if (skb->pkt_type == PACKET_OTHERHOST) {
 		skb->pkt_type = PACKET_HOST;
 		nf_bridge->pkt_otherhost = true;


