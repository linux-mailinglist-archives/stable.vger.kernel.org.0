Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4C8D133288
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbgAGVLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:11:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729808AbgAGVLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:11:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDA1C2077B;
        Tue,  7 Jan 2020 21:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431493;
        bh=Y5q8VHegwVHT2dXvZf2Mf+fu0BhmtH0aE8VudM/V+7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FelhNbghX7+rKJrq1k3GhOin+L5loM9n43ExVOIeQ+QIawdPSoCU8KIf+gXGNF/F+
         8VtMPrCAVQCceD8OjmFWBqwkNedzUzlGgS7fesJKdhB8CupC/SDhhhj6oIBgjugNe/
         EZ3JrfMqFXJt1YGa/bY2SHtXMioijlnxuqoWOFio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 71/74] net: add annotations on hh->hh_len lockless accesses
Date:   Tue,  7 Jan 2020 21:55:36 +0100
Message-Id: <20200107205235.071680962@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c305c6ae79e2ce20c22660ceda94f0d86d639a82 ]

KCSAN reported a data-race [1]

While we can use READ_ONCE() on the read sides,
we need to make sure hh->hh_len is written last.

[1]

BUG: KCSAN: data-race in eth_header_cache / neigh_resolve_output

write to 0xffff8880b9dedcb8 of 4 bytes by task 29760 on cpu 0:
 eth_header_cache+0xa9/0xd0 net/ethernet/eth.c:247
 neigh_hh_init net/core/neighbour.c:1463 [inline]
 neigh_resolve_output net/core/neighbour.c:1480 [inline]
 neigh_resolve_output+0x415/0x470 net/core/neighbour.c:1470
 neigh_output include/net/neighbour.h:511 [inline]
 ip6_finish_output2+0x7a2/0xec0 net/ipv6/ip6_output.c:116
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ndisc_send_skb+0x459/0x5f0 net/ipv6/ndisc.c:505
 ndisc_send_ns+0x207/0x430 net/ipv6/ndisc.c:647
 rt6_probe_deferred+0x98/0xf0 net/ipv6/route.c:615
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

read to 0xffff8880b9dedcb8 of 4 bytes by task 29572 on cpu 1:
 neigh_resolve_output net/core/neighbour.c:1479 [inline]
 neigh_resolve_output+0x113/0x470 net/core/neighbour.c:1470
 neigh_output include/net/neighbour.h:511 [inline]
 ip6_finish_output2+0x7a2/0xec0 net/ipv6/ip6_output.c:116
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ndisc_send_skb+0x459/0x5f0 net/ipv6/ndisc.c:505
 ndisc_send_ns+0x207/0x430 net/ipv6/ndisc.c:647
 rt6_probe_deferred+0x98/0xf0 net/ipv6/route.c:615
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 29572 Comm: kworker/1:4 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events rt6_probe_deferred

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/net.c  | 6 +++++-
 include/net/neighbour.h | 2 +-
 net/core/neighbour.c    | 4 ++--
 net/ethernet/eth.c      | 7 ++++++-
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 242359c2d1f1..215f4f71b943 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -249,7 +249,11 @@ static int fwnet_header_cache(const struct neighbour *neigh,
 	h = (struct fwnet_header *)((u8 *)hh->hh_data + HH_DATA_OFF(sizeof(*h)));
 	h->h_proto = type;
 	memcpy(h->h_dest, neigh->ha, net->addr_len);
-	hh->hh_len = FWNET_HLEN;
+
+	/* Pairs with the READ_ONCE() in neigh_resolve_output(),
+	 * neigh_hh_output() and neigh_update_hhs().
+	 */
+	smp_store_release(&hh->hh_len, FWNET_HLEN);
 
 	return 0;
 }
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 1d6b98119a1d..e89273f9a0bc 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -458,7 +458,7 @@ static inline int neigh_hh_output(const struct hh_cache *hh, struct sk_buff *skb
 
 	do {
 		seq = read_seqbegin(&hh->hh_lock);
-		hh_len = hh->hh_len;
+		hh_len = READ_ONCE(hh->hh_len);
 		if (likely(hh_len <= HH_DATA_MOD)) {
 			hh_alen = HH_DATA_MOD;
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 2664ad58e5c0..16ac50b1b9a7 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1094,7 +1094,7 @@ static void neigh_update_hhs(struct neighbour *neigh)
 
 	if (update) {
 		hh = &neigh->hh;
-		if (hh->hh_len) {
+		if (READ_ONCE(hh->hh_len)) {
 			write_seqlock_bh(&hh->hh_lock);
 			update(hh, neigh->dev, neigh->ha);
 			write_sequnlock_bh(&hh->hh_lock);
@@ -1355,7 +1355,7 @@ int neigh_resolve_output(struct neighbour *neigh, struct sk_buff *skb)
 		struct net_device *dev = neigh->dev;
 		unsigned int seq;
 
-		if (dev->header_ops->cache && !neigh->hh.hh_len)
+		if (dev->header_ops->cache && !READ_ONCE(neigh->hh.hh_len))
 			neigh_hh_init(neigh);
 
 		do {
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index eaeba9b99a73..7e0e5f2706ba 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -239,7 +239,12 @@ int eth_header_cache(const struct neighbour *neigh, struct hh_cache *hh, __be16
 	eth->h_proto = type;
 	memcpy(eth->h_source, dev->dev_addr, ETH_ALEN);
 	memcpy(eth->h_dest, neigh->ha, ETH_ALEN);
-	hh->hh_len = ETH_HLEN;
+
+	/* Pairs with READ_ONCE() in neigh_resolve_output(),
+	 * neigh_hh_output() and neigh_update_hhs().
+	 */
+	smp_store_release(&hh->hh_len, ETH_HLEN);
+
 	return 0;
 }
 EXPORT_SYMBOL(eth_header_cache);
-- 
2.20.1



