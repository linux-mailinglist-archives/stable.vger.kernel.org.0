Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCEF657BB7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbiL1PYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbiL1PYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:24:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362241401E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:24:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6F506155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A41C433F2;
        Wed, 28 Dec 2022 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241077;
        bh=DCBszqVRaFLPfp+przbJLAFJLPGuWz0Afjeld/dHs/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpSZsndEwY1Ab+LfVFnmev5UKnvPiPPb9THdck45I6f9vRQ5JwjG1MwEuNZBZ2bU4
         kBKfeKbU75SDLaf1emUdgLgInVoQE1vqxff0Sw+w+EA/C3kBkFF5UdSHITulxi/7fj
         l1TnMBrOgtrcIhlGjW0GK49djNx+TMwax71SDCR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kazuho Oku <kazuhooku@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0237/1073] soreuseport: Fix socket selection for SO_INCOMING_CPU.
Date:   Wed, 28 Dec 2022 15:30:25 +0100
Message-Id: <20221228144334.466535940@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit b261eda84ec136240a9ca753389853a3a1bccca2 ]

Kazuho Oku reported that setsockopt(SO_INCOMING_CPU) does not work
with setsockopt(SO_REUSEPORT) since v4.6.

With the combination of SO_REUSEPORT and SO_INCOMING_CPU, we could
build a highly efficient server application.

setsockopt(SO_INCOMING_CPU) associates a CPU with a TCP listener
or UDP socket, and then incoming packets processed on the CPU will
likely be distributed to the socket.  Technically, a socket could
even receive packets handled on another CPU if no sockets in the
reuseport group have the same CPU receiving the flow.

The logic exists in compute_score() so that a socket will get a higher
score if it has the same CPU with the flow.  However, the score gets
ignored after the blamed two commits, which introduced a faster socket
selection algorithm for SO_REUSEPORT.

This patch introduces a counter of sockets with SO_INCOMING_CPU in
a reuseport group to check if we should iterate all sockets to find
a proper one.  We increment the counter when

  * calling listen() if the socket has SO_INCOMING_CPU and SO_REUSEPORT

  * enabling SO_INCOMING_CPU if the socket is in a reuseport group

Also, we decrement it when

  * detaching a socket out of the group to apply SO_INCOMING_CPU to
    migrated TCP requests

  * disabling SO_INCOMING_CPU if the socket is in a reuseport group

When the counter reaches 0, we can get back to the O(1) selection
algorithm.

The overall changes are negligible for the non-SO_INCOMING_CPU case,
and the only notable thing is that we have to update sk_incomnig_cpu
under reuseport_lock.  Otherwise, the race prevents transitioning to
the O(n) algorithm and results in the wrong socket selection.

 cpu1 (setsockopt)               cpu2 (listen)
+-----------------+             +-------------+

lock_sock(sk1)                  lock_sock(sk2)

reuseport_update_incoming_cpu(sk1, val)
.
|  /* set CPU as 0 */
|- WRITE_ONCE(sk1->incoming_cpu, val)
|
|                               spin_lock_bh(&reuseport_lock)
|                               reuseport_grow(sk2, reuse)
|                               .
|                               |- more_socks_size = reuse->max_socks * 2U;
|                               |- if (more_socks_size > U16_MAX &&
|                               |       reuse->num_closed_socks)
|                               |  .
|                               |  |- RCU_INIT_POINTER(sk1->sk_reuseport_cb, NULL);
|                               |  `- __reuseport_detach_closed_sock(sk1, reuse)
|                               |     .
|                               |     `- reuseport_put_incoming_cpu(sk1, reuse)
|                               |        .
|                               |        |  /* Read shutdown()ed sk1's sk_incoming_cpu
|                               |        |   * without lock_sock().
|                               |        |   */
|                               |        `- if (sk1->sk_incoming_cpu >= 0)
|                               |           .
|                               |           |  /* decrement not-yet-incremented
|                               |           |   * count, which is never incremented.
|                               |           |   */
|                               |           `- __reuseport_put_incoming_cpu(reuse);
|                               |
|                               `- spin_lock_bh(&reuseport_lock)
|
|- spin_lock_bh(&reuseport_lock)
|
|- reuse = rcu_dereference_protected(sk1->sk_reuseport_cb, ...)
|- if (!reuse)
|  .
|  |  /* Cannot increment reuse->incoming_cpu. */
|  `- goto out;
|
`- spin_unlock_bh(&reuseport_lock)

Fixes: e32ea7e74727 ("soreuseport: fast reuseport UDP socket selection")
Fixes: c125e80b8868 ("soreuseport: fast reuseport TCP socket selection")
Reported-by: Kazuho Oku <kazuhooku@gmail.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock_reuseport.h |  2 +
 net/core/sock.c              |  2 +-
 net/core/sock_reuseport.c    | 94 ++++++++++++++++++++++++++++++++++--
 3 files changed, 92 insertions(+), 6 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index efc9085c6892..6ec140b0a61b 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -16,6 +16,7 @@ struct sock_reuseport {
 	u16			max_socks;		/* length of socks */
 	u16			num_socks;		/* elements in socks */
 	u16			num_closed_socks;	/* closed elements in socks */
+	u16			incoming_cpu;
 	/* The last synq overflow event timestamp of this
 	 * reuse->socks[] group.
 	 */
@@ -58,5 +59,6 @@ static inline bool reuseport_has_conns(struct sock *sk)
 }
 
 void reuseport_has_conns_set(struct sock *sk);
+void reuseport_update_incoming_cpu(struct sock *sk, int val);
 
 #endif  /* _SOCK_REUSEPORT_H */
diff --git a/net/core/sock.c b/net/core/sock.c
index 788c1372663c..f0eaa5d406b3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1400,7 +1400,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 		}
 	case SO_INCOMING_CPU:
-		WRITE_ONCE(sk->sk_incoming_cpu, val);
+		reuseport_update_incoming_cpu(sk, val);
 		break;
 
 	case SO_CNX_ADVICE:
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index fb90e1e00773..5a165286e4d8 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -37,6 +37,70 @@ void reuseport_has_conns_set(struct sock *sk)
 }
 EXPORT_SYMBOL(reuseport_has_conns_set);
 
+static void __reuseport_get_incoming_cpu(struct sock_reuseport *reuse)
+{
+	/* Paired with READ_ONCE() in reuseport_select_sock_by_hash(). */
+	WRITE_ONCE(reuse->incoming_cpu, reuse->incoming_cpu + 1);
+}
+
+static void __reuseport_put_incoming_cpu(struct sock_reuseport *reuse)
+{
+	/* Paired with READ_ONCE() in reuseport_select_sock_by_hash(). */
+	WRITE_ONCE(reuse->incoming_cpu, reuse->incoming_cpu - 1);
+}
+
+static void reuseport_get_incoming_cpu(struct sock *sk, struct sock_reuseport *reuse)
+{
+	if (sk->sk_incoming_cpu >= 0)
+		__reuseport_get_incoming_cpu(reuse);
+}
+
+static void reuseport_put_incoming_cpu(struct sock *sk, struct sock_reuseport *reuse)
+{
+	if (sk->sk_incoming_cpu >= 0)
+		__reuseport_put_incoming_cpu(reuse);
+}
+
+void reuseport_update_incoming_cpu(struct sock *sk, int val)
+{
+	struct sock_reuseport *reuse;
+	int old_sk_incoming_cpu;
+
+	if (unlikely(!rcu_access_pointer(sk->sk_reuseport_cb))) {
+		/* Paired with REAE_ONCE() in sk_incoming_cpu_update()
+		 * and compute_score().
+		 */
+		WRITE_ONCE(sk->sk_incoming_cpu, val);
+		return;
+	}
+
+	spin_lock_bh(&reuseport_lock);
+
+	/* This must be done under reuseport_lock to avoid a race with
+	 * reuseport_grow(), which accesses sk->sk_incoming_cpu without
+	 * lock_sock() when detaching a shutdown()ed sk.
+	 *
+	 * Paired with READ_ONCE() in reuseport_select_sock_by_hash().
+	 */
+	old_sk_incoming_cpu = sk->sk_incoming_cpu;
+	WRITE_ONCE(sk->sk_incoming_cpu, val);
+
+	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
+					  lockdep_is_held(&reuseport_lock));
+
+	/* reuseport_grow() has detached a closed sk. */
+	if (!reuse)
+		goto out;
+
+	if (old_sk_incoming_cpu < 0 && val >= 0)
+		__reuseport_get_incoming_cpu(reuse);
+	else if (old_sk_incoming_cpu >= 0 && val < 0)
+		__reuseport_put_incoming_cpu(reuse);
+
+out:
+	spin_unlock_bh(&reuseport_lock);
+}
+
 static int reuseport_sock_index(struct sock *sk,
 				const struct sock_reuseport *reuse,
 				bool closed)
@@ -64,6 +128,7 @@ static void __reuseport_add_sock(struct sock *sk,
 	/* paired with smp_rmb() in reuseport_(select|migrate)_sock() */
 	smp_wmb();
 	reuse->num_socks++;
+	reuseport_get_incoming_cpu(sk, reuse);
 }
 
 static bool __reuseport_detach_sock(struct sock *sk,
@@ -76,6 +141,7 @@ static bool __reuseport_detach_sock(struct sock *sk,
 
 	reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
 	reuse->num_socks--;
+	reuseport_put_incoming_cpu(sk, reuse);
 
 	return true;
 }
@@ -86,6 +152,7 @@ static void __reuseport_add_closed_sock(struct sock *sk,
 	reuse->socks[reuse->max_socks - reuse->num_closed_socks - 1] = sk;
 	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
 	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks + 1);
+	reuseport_get_incoming_cpu(sk, reuse);
 }
 
 static bool __reuseport_detach_closed_sock(struct sock *sk,
@@ -99,6 +166,7 @@ static bool __reuseport_detach_closed_sock(struct sock *sk,
 	reuse->socks[i] = reuse->socks[reuse->max_socks - reuse->num_closed_socks];
 	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
 	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks - 1);
+	reuseport_put_incoming_cpu(sk, reuse);
 
 	return true;
 }
@@ -166,6 +234,7 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
 	reuse->bind_inany = bind_inany;
 	reuse->socks[0] = sk;
 	reuse->num_socks = 1;
+	reuseport_get_incoming_cpu(sk, reuse);
 	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
 
 out:
@@ -209,6 +278,7 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
 	more_reuse->reuseport_id = reuse->reuseport_id;
 	more_reuse->bind_inany = reuse->bind_inany;
 	more_reuse->has_conns = reuse->has_conns;
+	more_reuse->incoming_cpu = reuse->incoming_cpu;
 
 	memcpy(more_reuse->socks, reuse->socks,
 	       reuse->num_socks * sizeof(struct sock *));
@@ -458,18 +528,32 @@ static struct sock *run_bpf_filter(struct sock_reuseport *reuse, u16 socks,
 static struct sock *reuseport_select_sock_by_hash(struct sock_reuseport *reuse,
 						  u32 hash, u16 num_socks)
 {
+	struct sock *first_valid_sk = NULL;
 	int i, j;
 
 	i = j = reciprocal_scale(hash, num_socks);
-	while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
+	do {
+		struct sock *sk = reuse->socks[i];
+
+		if (sk->sk_state != TCP_ESTABLISHED) {
+			/* Paired with WRITE_ONCE() in __reuseport_(get|put)_incoming_cpu(). */
+			if (!READ_ONCE(reuse->incoming_cpu))
+				return sk;
+
+			/* Paired with WRITE_ONCE() in reuseport_update_incoming_cpu(). */
+			if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
+				return sk;
+
+			if (!first_valid_sk)
+				first_valid_sk = sk;
+		}
+
 		i++;
 		if (i >= num_socks)
 			i = 0;
-		if (i == j)
-			return NULL;
-	}
+	} while (i != j);
 
-	return reuse->socks[i];
+	return first_valid_sk;
 }
 
 /**
-- 
2.35.1



