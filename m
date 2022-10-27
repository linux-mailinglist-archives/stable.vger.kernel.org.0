Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EEF60FE82
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbiJ0RF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236977AbiJ0RFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:05:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEB95A82B
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E9ACB825F3
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD709C433C1;
        Thu, 27 Oct 2022 17:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890346;
        bh=VTemUNplORkfggZhxdB/8xo4b9Ub2VjhQcsAu7enFds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMZS+WEmal86zSDXVntlphJSHqutTf4ErjC4WzzYAsFXMzCoH30iFuZWnNCVdFLnC
         TlH2sWtGKXji0FMksxTI5ZTWRj91B1Ku8Kox7cBfBIpBHUnqzSsIChwV+qKJuXCTkc
         yIVDrLXZYCpLbHemYWoBFjdtt7M3cPFKnFOops38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 36/79] udp: Update reuse->has_conns under reuseport_lock.
Date:   Thu, 27 Oct 2022 18:55:46 +0200
Message-Id: <20221027165055.592854693@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 69421bf98482d089e50799f45e48b25ce4a8d154 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock_reuseport.h | 11 +++++------
 net/core/sock_reuseport.c    | 16 ++++++++++++++++
 net/ipv4/datagram.c          |  2 +-
 net/ipv4/udp.c               |  2 +-
 net/ipv6/datagram.c          |  2 +-
 net/ipv6/udp.c               |  2 +-
 6 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 0e558ca7afbf..6348c6f26903 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -39,21 +39,20 @@ extern struct sock *reuseport_select_sock(struct sock *sk,
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
index f478c65a281b..364cf6c6912b 100644
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
 static int reuseport_sock_index(struct sock *sk,
 				const struct sock_reuseport *reuse,
 				bool closed)
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
2.35.1



