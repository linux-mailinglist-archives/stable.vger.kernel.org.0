Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E368610201
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 21:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbiJ0TyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 15:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbiJ0TyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 15:54:08 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D1C8680E
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 12:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666900447; x=1698436447;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y9ddZtIiIUz4UZzcJb5qkkEe8SWrZJFD7ahWSi8FUEM=;
  b=kvDeWCJ8l/DP/UfFDFsoa8TaCnU9D4BpceUvhFKyWF2spKqjDzBWxHCQ
   86VtJEP6e9luRakTe1I2uG5rSeN2zDBi8XKKfw3m4h5BdgnK7wnaJPtkX
   V5TrxoynCanv7k3fXLGFHAvLnBDNt4yNiyAScB7FB+hTtnn1Ct3hb5oP7
   U=;
X-IronPort-AV: E=Sophos;i="5.95,218,1661817600"; 
   d="scan'208";a="257133236"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 19:54:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com (Postfix) with ESMTPS id DB8872226D6;
        Thu, 27 Oct 2022 19:54:02 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 27 Oct 2022 19:54:01 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Thu, 27 Oct 2022 19:53:59 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>
CC:     <daniel@iogearbox.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuniyu@amazon.co.jp>, <patches@lists.linux.dev>,
        <stable@vger.kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 5.10 35/79] tcp: Add num_closed_socks to struct sock_reuseport.
Date:   Thu, 27 Oct 2022 12:53:49 -0700
Message-ID: <20221027195349.75736-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221027165055.564998662@linuxfoundation.org>
References: <20221027165055.564998662@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D12UWC004.ant.amazon.com (10.43.162.182) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu, 27 Oct 2022 18:55:45 +0200
> From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> 
> [ Upstream commit 5c040eaf5d1753aafe12989ca712175df0b9c436 ]
> 
> As noted in the following commit, a closed listener has to hold the
> reference to the reuseport group for socket migration. This patch adds a
> field (num_closed_socks) to struct sock_reuseport to manage closed sockets
> within the same reuseport group. Moreover, this and the following commits
> introduce some helper functions to split socks[] into two sections and keep
> TCP_LISTEN and TCP_CLOSE sockets in each section. Like a double-ended
> queue, we will place TCP_LISTEN sockets from the front and TCP_CLOSE
> sockets from the end.
> 
>   TCP_LISTEN---------->       <-------TCP_CLOSE
>   +---+---+  ---  +---+  ---  +---+  ---  +---+
>   | 0 | 1 |  ...  | i |  ...  | j |  ...  | k |
>   +---+---+  ---  +---+  ---  +---+  ---  +---+
> 
>   i = num_socks - 1
>   j = max_socks - num_closed_socks
>   k = max_socks - 1
> 
> This patch also extends reuseport_add_sock() and reuseport_grow() to
> support num_closed_socks.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Link: https://lore.kernel.org/bpf/20210612123224.12525-3-kuniyu@amazon.co.jp
> Stable-dep-of: 69421bf98482 ("udp: Update reuse->has_conns under reuseport_lock.")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I think this patch is backported due to a conflict with the cited commit
69421bf98482 ("udp: Update reuse->has_conns under reuseport_lock.").

The following patch seems to conflicts with some functions which are
introduced in this patch, but the cited commit does not depend on the
functions.

So, we can just remove the functions in this patch and resolve the
conflict in the next patch like below. (based on the v5.10.150 branch)

Thank you.

---8<---


From 6e86345a1e6f501188236148f78aeb1be07edf74 Mon Sep 17 00:00:00 2001
From: Kuniyuki Iwashima <kuniyu@amazon.com>
Date: Fri, 14 Oct 2022 11:26:25 -0700
Subject: [PATCH] udp: Update reuse->has_conns under reuseport_lock.

When we call connect() for a UDP socket in a reuseport group, we have
to update sk->sk_reuseport_cb->has_conns to 1.  Otherwise, the kernel
could select a unconnected socket wrongly for packets sent to the
connected socket.

However, the current way to set has_conns is illegal and possible to
trigger that problem.  reuseport_has_conns() changes has_conns under
rcu_read_lock(), which upgrades the RCU reader to the updater.  Then,
it must do the update under the updater's lock, reuseport_lock, but
it doesn't for now.

For this reason, there is a race below where we fail to set has_conns
resulting in the wrong socket selection.  To avoid the race, let's split
the reader and updater with proper locking.

 cpu1                               cpu2
+----+                             +----+

__ip[46]_datagram_connect()        reuseport_grow()
.                                  .
|- reuseport_has_conns(sk, true)   |- more_reuse = __reuseport_alloc(more_socks_size)
|  .                               |
|  |- rcu_read_lock()
|  |- reuse = rcu_dereference(sk->sk_reuseport_cb)
|  |
|  |                               |  /* reuse->has_conns == 0 here */
|  |                               |- more_reuse->has_conns = reuse->has_conns
|  |- reuse->has_conns = 1         |  /* more_reuse->has_conns SHOULD BE 1 HERE */
|  |                               |
|  |                               |- rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
|  |                               |                     more_reuse)
|  `- rcu_read_unlock()            `- kfree_rcu(reuse, rcu)
|
|- sk->sk_state = TCP_ESTABLISHED

Note the likely(reuse) in reuseport_has_conns_set() is always true,
but we put the test there for ease of review.  [0]

For the record, usually, sk_reuseport_cb is changed under lock_sock().
The only exception is reuseport_grow() & TCP reqsk migration case.

  1) shutdown() TCP listener, which is moved into the latter part of
     reuse->socks[] to migrate reqsk.

  2) New listen() overflows reuse->socks[] and call reuseport_grow().

  3) reuse->max_socks overflows u16 with the new listener.

  4) reuseport_grow() pops the old shutdown()ed listener from the array
     and update its sk->sk_reuseport_cb as NULL without lock_sock().

shutdown()ed TCP sk->sk_reuseport_cb can be changed without lock_sock(),
but, reuseport_has_conns_set() is called only for UDP under lock_sock(),
so likely(reuse) never be false in reuseport_has_conns_set().

[0]: https://lore.kernel.org/netdev/CANn89iLja=eQHbsM_Ta2sQF0tOGU8vAGrh_izRuuHjuO1ouUag@mail.gmail.com/

Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20221014182625.89913-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/sock_reuseport.h | 11 +++++------
 net/core/sock_reuseport.c    | 16 ++++++++++++++++
 net/ipv4/datagram.c          |  2 +-
 net/ipv4/udp.c               |  2 +-
 net/ipv6/datagram.c          |  2 +-
 net/ipv6/udp.c               |  2 +-
 6 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 505f1e18e9bf..3eac185ae2e8 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -38,21 +38,20 @@ extern struct sock *reuseport_select_sock(struct sock *sk,
 extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
 extern int reuseport_detach_prog(struct sock *sk);
 
-static inline bool reuseport_has_conns(struct sock *sk, bool set)
+static inline bool reuseport_has_conns(struct sock *sk)
 {
 	struct sock_reuseport *reuse;
 	bool ret = false;
 
 	rcu_read_lock();
 	reuse = rcu_dereference(sk->sk_reuseport_cb);
-	if (reuse) {
-		if (set)
-			reuse->has_conns = 1;
-		ret = reuse->has_conns;
-	}
+	if (reuse && reuse->has_conns)
+		ret = true;
 	rcu_read_unlock();
 
 	return ret;
 }
 
+void reuseport_has_conns_set(struct sock *sk);
+
 #endif  /* _SOCK_REUSEPORT_H */
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index b065f0a103ed..49f9c2c4ffd5 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -18,6 +18,22 @@ DEFINE_SPINLOCK(reuseport_lock);
 
 static DEFINE_IDA(reuseport_ida);
 
+void reuseport_has_conns_set(struct sock *sk)
+{
+	struct sock_reuseport *reuse;
+
+	if (!rcu_access_pointer(sk->sk_reuseport_cb))
+		return;
+
+	spin_lock_bh(&reuseport_lock);
+	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
+					  lockdep_is_held(&reuseport_lock));
+	if (likely(reuse))
+		reuse->has_conns = 1;
+	spin_unlock_bh(&reuseport_lock);
+}
+EXPORT_SYMBOL(reuseport_has_conns_set);
+
 static struct sock_reuseport *__reuseport_alloc(unsigned int max_socks)
 {
 	unsigned int size = sizeof(struct sock_reuseport) +
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 4a8550c49202..112c6e892d30 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -70,7 +70,7 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 	}
 	inet->inet_daddr = fl4->daddr;
 	inet->inet_dport = usin->sin_port;
-	reuseport_has_conns(sk, true);
+	reuseport_has_conns_set(sk);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 	inet->inet_id = prandom_u32();
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4446aa8237ff..b093daaa3deb 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -446,7 +446,7 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 			result = lookup_reuseport(net, sk, skb,
 						  saddr, sport, daddr, hnum);
 			/* Fall back to scoring if group has connections */
-			if (result && !reuseport_has_conns(sk, false))
+			if (result && !reuseport_has_conns(sk))
 				return result;
 
 			result = result ? : sk;
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 206f66310a88..f4559e5bc84b 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -256,7 +256,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 		goto out;
 	}
 
-	reuseport_has_conns(sk, true);
+	reuseport_has_conns_set(sk);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 out:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 9b504bf49214..514e6a55959f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -179,7 +179,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 			result = lookup_reuseport(net, sk, skb,
 						  saddr, sport, daddr, hnum);
 			/* Fall back to scoring if group has connections */
-			if (result && !reuseport_has_conns(sk, false))
+			if (result && !reuseport_has_conns(sk))
 				return result;
 
 			result = result ? : sk;
-- 
2.37.1

