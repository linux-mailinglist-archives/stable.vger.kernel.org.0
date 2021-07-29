Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789753DA52A
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238137AbhG2N6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238378AbhG2N6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43AC660F46;
        Thu, 29 Jul 2021 13:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567082;
        bh=Fw2AW1ii5fKwndVHNB6bVaQYY921I0uv6T5xXJUP04g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3XkbMykdtgkFAYBQ5E6J3aW1a0UIXA1R1x4UJMn79Ioxbqdp+gNB4D/czgACTZVF
         WkcJWz38mbX2/S+a9Za/vRJjGLap0OMOOxlel7Ge+kCw0W053HJi6In//qOStYCm0q
         ViWHfRjchYTwmd/+KvJWb7Mh1y8ET9DLgoGkPhFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/24] ipv6: allocate enough headroom in ip6_finish_output2()
Date:   Thu, 29 Jul 2021 15:54:33 +0200
Message-Id: <20210729135137.680910375@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
References: <20210729135137.267680390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 5796015fa968a3349027a27dcd04c71d95c53ba5 ]

When TEE target mirrors traffic to another interface, sk_buff may
not have enough headroom to be processed correctly.
ip_finish_output2() detect this situation for ipv4 and allocates
new skb with enogh headroom. However ipv6 lacks this logic in
ip_finish_output2 and it leads to skb_under_panic:

 skbuff: skb_under_panic: text:ffffffffc0866ad4 len:96 put:24
 head:ffff97be85e31800 data:ffff97be85e317f8 tail:0x58 end:0xc0 dev:gre0
 ------------[ cut here ]------------
 kernel BUG at net/core/skbuff.c:110!
 invalid opcode: 0000 [#1] SMP PTI
 CPU: 2 PID: 393 Comm: kworker/2:2 Tainted: G           OE     5.13.0 #13
 Hardware name: Virtuozzo KVM, BIOS 1.11.0-2.vz7.4 04/01/2014
 Workqueue: ipv6_addrconf addrconf_dad_work
 RIP: 0010:skb_panic+0x48/0x4a
 Call Trace:
  skb_push.cold.111+0x10/0x10
  ipgre_header+0x24/0xf0 [ip_gre]
  neigh_connected_output+0xae/0xf0
  ip6_finish_output2+0x1a8/0x5a0
  ip6_output+0x5c/0x110
  nf_dup_ipv6+0x158/0x1000 [nf_dup_ipv6]
  tee_tg6+0x2e/0x40 [xt_TEE]
  ip6t_do_table+0x294/0x470 [ip6_tables]
  nf_hook_slow+0x44/0xc0
  nf_hook.constprop.34+0x72/0xe0
  ndisc_send_skb+0x20d/0x2e0
  ndisc_send_ns+0xd1/0x210
  addrconf_dad_work+0x3c8/0x540
  process_one_work+0x1d1/0x370
  worker_thread+0x30/0x390
  kthread+0x116/0x130
  ret_from_fork+0x22/0x30

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 341d0c7acc8b..781d3bc64b71 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -60,10 +60,38 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device *dev = dst->dev;
+	unsigned int hh_len = LL_RESERVED_SPACE(dev);
+	int delta = hh_len - skb_headroom(skb);
 	const struct in6_addr *nexthop;
 	struct neighbour *neigh;
 	int ret;
 
+	/* Be paranoid, rather than too clever. */
+	if (unlikely(delta > 0) && dev->header_ops) {
+		/* pskb_expand_head() might crash, if skb is shared */
+		if (skb_shared(skb)) {
+			struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
+
+			if (likely(nskb)) {
+				if (skb->sk)
+					skb_set_owner_w(skb, skb->sk);
+				consume_skb(skb);
+			} else {
+				kfree_skb(skb);
+			}
+			skb = nskb;
+		}
+		if (skb &&
+		    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
+			kfree_skb(skb);
+			skb = NULL;
+		}
+		if (!skb) {
+			IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTDISCARDS);
+			return -ENOMEM;
+		}
+	}
+
 	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr)) {
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
 
-- 
2.30.2



