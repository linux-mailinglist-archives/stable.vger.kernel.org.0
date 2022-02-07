Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DB84ABD2A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379226AbiBGLjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386249AbiBGLeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:34:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F5DC043181;
        Mon,  7 Feb 2022 03:34:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 642D6B80EBD;
        Mon,  7 Feb 2022 11:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFA6C004E1;
        Mon,  7 Feb 2022 11:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233644;
        bh=uDfKvlFIo9V9/gtSAHiZdG/PPB0gTl8EG/gwzeM/smU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XaRPBxrQ9pNob+pedp846bUTHPTC/XBmVb6jGXg93UjfBnDVxA5UuSd4ONCU1cvZc
         5To4dZgkjDr0HqOApByxgIqzxaSMHYWvvhi538mCTdnSvv8fYsCSqaHBAOUdGk+dN/
         3fvZHsL6aQdxeJor7tQXtdJpsS3CqYzYTJUjdL+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 076/126] net, neigh: Do not trigger immediate probes on NUD_FAILED from neigh_managed_work
Date:   Mon,  7 Feb 2022 12:06:47 +0100
Message-Id: <20220207103806.731818986@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 4a81f6da9cb2d1ef911131a6fd8bd15cb61fc772 upstream.

syzkaller was able to trigger a deadlock for NTF_MANAGED entries [0]:

  kworker/0:16/14617 is trying to acquire lock:
  ffffffff8d4dd370 (&tbl->lock){++-.}-{2:2}, at: ___neigh_create+0x9e1/0x2990 net/core/neighbour.c:652
  [...]
  but task is already holding lock:
  ffffffff8d4dd370 (&tbl->lock){++-.}-{2:2}, at: neigh_managed_work+0x35/0x250 net/core/neighbour.c:1572

The neighbor entry turned to NUD_FAILED state, where __neigh_event_send()
triggered an immediate probe as per commit cd28ca0a3dd1 ("neigh: reduce
arp latency") via neigh_probe() given table lock was held.

One option to fix this situation is to defer the neigh_probe() back to
the neigh_timer_handler() similarly as pre cd28ca0a3dd1. For the case
of NTF_MANAGED, this deferral is acceptable given this only happens on
actual failure state and regular / expected state is NUD_VALID with the
entry already present.

The fix adds a parameter to __neigh_event_send() in order to communicate
whether immediate probe is allowed or disallowed. Existing call-sites
of neigh_event_send() default as-is to immediate probe. However, the
neigh_managed_work() disables it via use of neigh_event_send_probe().

[0] <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
  print_deadlock_bug kernel/locking/lockdep.c:2956 [inline]
  check_deadlock kernel/locking/lockdep.c:2999 [inline]
  validate_chain kernel/locking/lockdep.c:3788 [inline]
  __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5027
  lock_acquire kernel/locking/lockdep.c:5639 [inline]
  lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5604
  __raw_write_lock_bh include/linux/rwlock_api_smp.h:202 [inline]
  _raw_write_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:334
  ___neigh_create+0x9e1/0x2990 net/core/neighbour.c:652
  ip6_finish_output2+0x1070/0x14f0 net/ipv6/ip6_output.c:123
  __ip6_finish_output net/ipv6/ip6_output.c:191 [inline]
  __ip6_finish_output+0x61e/0xe90 net/ipv6/ip6_output.c:170
  ip6_finish_output+0x32/0x200 net/ipv6/ip6_output.c:201
  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
  ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:224
  dst_output include/net/dst.h:451 [inline]
  NF_HOOK include/linux/netfilter.h:307 [inline]
  ndisc_send_skb+0xa99/0x17f0 net/ipv6/ndisc.c:508
  ndisc_send_ns+0x3a9/0x840 net/ipv6/ndisc.c:650
  ndisc_solicit+0x2cd/0x4f0 net/ipv6/ndisc.c:742
  neigh_probe+0xc2/0x110 net/core/neighbour.c:1040
  __neigh_event_send+0x37d/0x1570 net/core/neighbour.c:1201
  neigh_event_send include/net/neighbour.h:470 [inline]
  neigh_managed_work+0x162/0x250 net/core/neighbour.c:1574
  process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
  worker_thread+0x657/0x1110 kernel/workqueue.c:2454
  kthread+0x2e9/0x3a0 kernel/kthread.c:377
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
  </TASK>

Fixes: 7482e3841d52 ("net, neigh: Add NTF_MANAGED flag for managed neighbor entries")
Reported-by: syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
Tested-by: syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220201193942.5055-1-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/neighbour.h |   18 +++++++++++++-----
 net/core/neighbour.c    |   18 ++++++++++++------
 2 files changed, 25 insertions(+), 11 deletions(-)

--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -336,7 +336,8 @@ static inline struct neighbour *neigh_cr
 	return __neigh_create(tbl, pkey, dev, true);
 }
 void neigh_destroy(struct neighbour *neigh);
-int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb);
+int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
+		       const bool immediate_ok);
 int neigh_update(struct neighbour *neigh, const u8 *lladdr, u8 new, u32 flags,
 		 u32 nlmsg_pid);
 void __neigh_set_probe_once(struct neighbour *neigh);
@@ -446,17 +447,24 @@ static inline struct neighbour * neigh_c
 
 #define neigh_hold(n)	refcount_inc(&(n)->refcnt)
 
-static inline int neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
+static __always_inline int neigh_event_send_probe(struct neighbour *neigh,
+						  struct sk_buff *skb,
+						  const bool immediate_ok)
 {
 	unsigned long now = jiffies;
-	
+
 	if (READ_ONCE(neigh->used) != now)
 		WRITE_ONCE(neigh->used, now);
-	if (!(neigh->nud_state&(NUD_CONNECTED|NUD_DELAY|NUD_PROBE)))
-		return __neigh_event_send(neigh, skb);
+	if (!(neigh->nud_state & (NUD_CONNECTED | NUD_DELAY | NUD_PROBE)))
+		return __neigh_event_send(neigh, skb, immediate_ok);
 	return 0;
 }
 
+static inline int neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
+{
+	return neigh_event_send_probe(neigh, skb, true);
+}
+
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 static inline int neigh_hh_bridge(struct hh_cache *hh, struct sk_buff *skb)
 {
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1133,7 +1133,8 @@ out:
 	neigh_release(neigh);
 }
 
-int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
+int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
+		       const bool immediate_ok)
 {
 	int rc;
 	bool immediate_probe = false;
@@ -1154,12 +1155,17 @@ int __neigh_event_send(struct neighbour
 			atomic_set(&neigh->probes,
 				   NEIGH_VAR(neigh->parms, UCAST_PROBES));
 			neigh_del_timer(neigh);
-			neigh->nud_state     = NUD_INCOMPLETE;
+			neigh->nud_state = NUD_INCOMPLETE;
 			neigh->updated = now;
-			next = now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
-					 HZ/100);
+			if (!immediate_ok) {
+				next = now + 1;
+			} else {
+				immediate_probe = true;
+				next = now + max(NEIGH_VAR(neigh->parms,
+							   RETRANS_TIME),
+						 HZ / 100);
+			}
 			neigh_add_timer(neigh, next);
-			immediate_probe = true;
 		} else {
 			neigh->nud_state = NUD_FAILED;
 			neigh->updated = jiffies;
@@ -1571,7 +1577,7 @@ static void neigh_managed_work(struct wo
 
 	write_lock_bh(&tbl->lock);
 	list_for_each_entry(neigh, &tbl->managed_list, managed_list)
-		neigh_event_send(neigh, NULL);
+		neigh_event_send_probe(neigh, NULL, false);
 	queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
 			   NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
 	write_unlock_bh(&tbl->lock);


