Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C357C541BE9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381601AbiFGVzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382691AbiFGVvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:51:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C808F1912E4;
        Tue,  7 Jun 2022 12:09:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AD0CECE247B;
        Tue,  7 Jun 2022 19:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F59C385A2;
        Tue,  7 Jun 2022 19:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628950;
        bh=CBdFuoxeJZf+Mm7bY+1RL0qKFMs9Tl3D/WttRZfSVUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ra7MJYdQZWoEF/CE2+LyKjFZlMxOnKP0uhLs4ndUScVqvSO1oJNKuFu9Oerz6Zepa
         WeByReq5mpgWZ2DUWVU89p2Ye1a8qneuemBKFMLfJKFRqbeyKrC4WEluN22PU2f3hj
         Y3d5py90GGl8nACc2h9j8j3W7Na1rFgmu0HSSO6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 516/879] rxrpc: Fix locking issue
Date:   Tue,  7 Jun 2022 19:00:34 +0200
Message-Id: <20220607165017.853491574@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit ad25f5cb39872ca14bcbe00816ae65c22fe04b89 ]

There's a locking issue with the per-netns list of calls in rxrpc.  The
pieces of code that add and remove a call from the list use write_lock()
and the calls procfile uses read_lock() to access it.  However, the timer
callback function may trigger a removal by trying to queue a call for
processing and finding that it's already queued - at which point it has a
spare refcount that it has to do something with.  Unfortunately, if it puts
the call and this reduces the refcount to 0, the call will be removed from
the list.  Unfortunately, since the _bh variants of the locking functions
aren't used, this can deadlock.

================================
WARNING: inconsistent lock state
5.18.0-rc3-build4+ #10 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
ksoftirqd/2/25 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffff888107ac4038 (&rxnet->call_lock){+.?.}-{2:2}, at: rxrpc_put_call+0x103/0x14b
{SOFTIRQ-ON-W} state was registered at:
...
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&rxnet->call_lock);
  <Interrupt>
    lock(&rxnet->call_lock);

 *** DEADLOCK ***

1 lock held by ksoftirqd/2/25:
 #0: ffff8881008ffdb0 ((&call->timer)){+.-.}-{0:0}, at: call_timer_fn+0x5/0x23d

Changes
=======
ver #2)
 - Changed to using list_next_rcu() rather than rcu_dereference() directly.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/seq_file.c            | 32 ++++++++++++++++++++++++++++++++
 include/linux/list.h     | 10 ++++++++++
 include/linux/seq_file.h |  4 ++++
 net/rxrpc/ar-internal.h  |  2 +-
 net/rxrpc/call_accept.c  |  6 +++---
 net/rxrpc/call_object.c  | 18 +++++++++---------
 net/rxrpc/net_ns.c       |  2 +-
 net/rxrpc/proc.c         | 10 ++--------
 8 files changed, 62 insertions(+), 22 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 7ab8a58c29b6..9456a2032224 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -931,6 +931,38 @@ struct list_head *seq_list_next(void *v, struct list_head *head, loff_t *ppos)
 }
 EXPORT_SYMBOL(seq_list_next);
 
+struct list_head *seq_list_start_rcu(struct list_head *head, loff_t pos)
+{
+	struct list_head *lh;
+
+	list_for_each_rcu(lh, head)
+		if (pos-- == 0)
+			return lh;
+
+	return NULL;
+}
+EXPORT_SYMBOL(seq_list_start_rcu);
+
+struct list_head *seq_list_start_head_rcu(struct list_head *head, loff_t pos)
+{
+	if (!pos)
+		return head;
+
+	return seq_list_start_rcu(head, pos - 1);
+}
+EXPORT_SYMBOL(seq_list_start_head_rcu);
+
+struct list_head *seq_list_next_rcu(void *v, struct list_head *head,
+				    loff_t *ppos)
+{
+	struct list_head *lh;
+
+	lh = list_next_rcu((struct list_head *)v);
+	++*ppos;
+	return lh == head ? NULL : lh;
+}
+EXPORT_SYMBOL(seq_list_next_rcu);
+
 /**
  * seq_hlist_start - start an iteration of a hlist
  * @head: the head of the hlist
diff --git a/include/linux/list.h b/include/linux/list.h
index dd6c2041d09c..0f7d8ec5b4ed 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -579,6 +579,16 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_for_each(pos, head) \
 	for (pos = (head)->next; !list_is_head(pos, (head)); pos = pos->next)
 
+/**
+ * list_for_each_rcu - Iterate over a list in an RCU-safe fashion
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ */
+#define list_for_each_rcu(pos, head)		  \
+	for (pos = rcu_dereference((head)->next); \
+	     !list_is_head(pos, (head)); \
+	     pos = rcu_dereference(pos->next))
+
 /**
  * list_for_each_continue - continue iteration over a list
  * @pos:	the &struct list_head to use as a loop cursor.
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 60820ab511d2..bd023dd38ae6 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -277,6 +277,10 @@ extern struct list_head *seq_list_start_head(struct list_head *head,
 extern struct list_head *seq_list_next(void *v, struct list_head *head,
 		loff_t *ppos);
 
+extern struct list_head *seq_list_start_rcu(struct list_head *head, loff_t pos);
+extern struct list_head *seq_list_start_head_rcu(struct list_head *head, loff_t pos);
+extern struct list_head *seq_list_next_rcu(void *v, struct list_head *head, loff_t *ppos);
+
 /*
  * Helpers for iteration over hlist_head-s in seq_files
  */
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 969e532f77a9..422558d50571 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -68,7 +68,7 @@ struct rxrpc_net {
 	struct proc_dir_entry	*proc_net;	/* Subdir in /proc/net */
 	u32			epoch;		/* Local epoch for detecting local-end reset */
 	struct list_head	calls;		/* List of calls active in this namespace */
-	rwlock_t		call_lock;	/* Lock for ->calls */
+	spinlock_t		call_lock;	/* Lock for ->calls */
 	atomic_t		nr_calls;	/* Count of allocated calls */
 
 	atomic_t		nr_conns;
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 1ae90fb97936..8b24ffbc72ef 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -140,9 +140,9 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 	write_unlock(&rx->call_lock);
 
 	rxnet = call->rxnet;
-	write_lock(&rxnet->call_lock);
-	list_add_tail(&call->link, &rxnet->calls);
-	write_unlock(&rxnet->call_lock);
+	spin_lock_bh(&rxnet->call_lock);
+	list_add_tail_rcu(&call->link, &rxnet->calls);
+	spin_unlock_bh(&rxnet->call_lock);
 
 	b->call_backlog[call_head] = call;
 	smp_store_release(&b->call_backlog_head, (call_head + 1) & (size - 1));
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 043508fd8d8a..25c9a2cbf048 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -337,9 +337,9 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	write_unlock(&rx->call_lock);
 
 	rxnet = call->rxnet;
-	write_lock(&rxnet->call_lock);
-	list_add_tail(&call->link, &rxnet->calls);
-	write_unlock(&rxnet->call_lock);
+	spin_lock_bh(&rxnet->call_lock);
+	list_add_tail_rcu(&call->link, &rxnet->calls);
+	spin_unlock_bh(&rxnet->call_lock);
 
 	/* From this point on, the call is protected by its own lock. */
 	release_sock(&rx->sk);
@@ -631,9 +631,9 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 		ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 
 		if (!list_empty(&call->link)) {
-			write_lock(&rxnet->call_lock);
+			spin_lock_bh(&rxnet->call_lock);
 			list_del_init(&call->link);
-			write_unlock(&rxnet->call_lock);
+			spin_unlock_bh(&rxnet->call_lock);
 		}
 
 		rxrpc_cleanup_call(call);
@@ -705,7 +705,7 @@ void rxrpc_destroy_all_calls(struct rxrpc_net *rxnet)
 	_enter("");
 
 	if (!list_empty(&rxnet->calls)) {
-		write_lock(&rxnet->call_lock);
+		spin_lock_bh(&rxnet->call_lock);
 
 		while (!list_empty(&rxnet->calls)) {
 			call = list_entry(rxnet->calls.next,
@@ -720,12 +720,12 @@ void rxrpc_destroy_all_calls(struct rxrpc_net *rxnet)
 			       rxrpc_call_states[call->state],
 			       call->flags, call->events);
 
-			write_unlock(&rxnet->call_lock);
+			spin_unlock_bh(&rxnet->call_lock);
 			cond_resched();
-			write_lock(&rxnet->call_lock);
+			spin_lock_bh(&rxnet->call_lock);
 		}
 
-		write_unlock(&rxnet->call_lock);
+		spin_unlock_bh(&rxnet->call_lock);
 	}
 
 	atomic_dec(&rxnet->nr_calls);
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index cc7e30733feb..e4d6d432515b 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -50,7 +50,7 @@ static __net_init int rxrpc_init_net(struct net *net)
 	rxnet->epoch |= RXRPC_RANDOM_EPOCH;
 
 	INIT_LIST_HEAD(&rxnet->calls);
-	rwlock_init(&rxnet->call_lock);
+	spin_lock_init(&rxnet->call_lock);
 	atomic_set(&rxnet->nr_calls, 1);
 
 	atomic_set(&rxnet->nr_conns, 1);
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index e2f990754f88..5a67955cc00f 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -26,29 +26,23 @@ static const char *const rxrpc_conn_states[RXRPC_CONN__NR_STATES] = {
  */
 static void *rxrpc_call_seq_start(struct seq_file *seq, loff_t *_pos)
 	__acquires(rcu)
-	__acquires(rxnet->call_lock)
 {
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
 
 	rcu_read_lock();
-	read_lock(&rxnet->call_lock);
-	return seq_list_start_head(&rxnet->calls, *_pos);
+	return seq_list_start_head_rcu(&rxnet->calls, *_pos);
 }
 
 static void *rxrpc_call_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
 
-	return seq_list_next(v, &rxnet->calls, pos);
+	return seq_list_next_rcu(v, &rxnet->calls, pos);
 }
 
 static void rxrpc_call_seq_stop(struct seq_file *seq, void *v)
-	__releases(rxnet->call_lock)
 	__releases(rcu)
 {
-	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
-
-	read_unlock(&rxnet->call_lock);
 	rcu_read_unlock();
 }
 
-- 
2.35.1



