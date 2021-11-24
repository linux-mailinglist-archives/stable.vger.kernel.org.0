Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F6D45C388
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349217AbhKXNkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:40:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:32976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352804AbhKXNiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:38:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 591EE6321E;
        Wed, 24 Nov 2021 12:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758562;
        bh=xlBGGWGa58vMdw+39Z0hWWgou9/QocQKoD52Ly1naoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTpuowA3taOIUmGx+pXBTkf76QFjMJauSTUomSMHcNAVmEfrH7rJ6ecNnOq0E64dc
         fmN00IH4bCI9P+7SAxzteCY/u81Xo9HgsjYmBJcN/Z7ZpGtb4K4gZf6pCS+vIHa8E4
         EnaW7FuJ4wylIdiEHlGe6zTpkp9bCpGi3QLVj/8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/154] net: reduce indentation level in sk_clone_lock()
Date:   Wed, 24 Nov 2021 12:57:53 +0100
Message-Id: <20211124115704.820626901@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bbc20b70424aeb3c84f833860f6340adda5141fc ]

Rework initial test to jump over init code
if memory allocation has failed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210127152731.748663-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 189 ++++++++++++++++++++++++------------------------
 1 file changed, 93 insertions(+), 96 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index f9c835167391d..3da4cd632ba8e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1883,123 +1883,120 @@ static void sk_init_common(struct sock *sk)
 struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 {
 	struct proto *prot = READ_ONCE(sk->sk_prot);
-	struct sock *newsk;
+	struct sk_filter *filter;
 	bool is_charged = true;
+	struct sock *newsk;
 
 	newsk = sk_prot_alloc(prot, priority, sk->sk_family);
-	if (newsk != NULL) {
-		struct sk_filter *filter;
+	if (!newsk)
+		goto out;
 
-		sock_copy(newsk, sk);
+	sock_copy(newsk, sk);
 
-		newsk->sk_prot_creator = prot;
+	newsk->sk_prot_creator = prot;
 
-		/* SANITY */
-		if (likely(newsk->sk_net_refcnt))
-			get_net(sock_net(newsk));
-		sk_node_init(&newsk->sk_node);
-		sock_lock_init(newsk);
-		bh_lock_sock(newsk);
-		newsk->sk_backlog.head	= newsk->sk_backlog.tail = NULL;
-		newsk->sk_backlog.len = 0;
+	/* SANITY */
+	if (likely(newsk->sk_net_refcnt))
+		get_net(sock_net(newsk));
+	sk_node_init(&newsk->sk_node);
+	sock_lock_init(newsk);
+	bh_lock_sock(newsk);
+	newsk->sk_backlog.head	= newsk->sk_backlog.tail = NULL;
+	newsk->sk_backlog.len = 0;
 
-		atomic_set(&newsk->sk_rmem_alloc, 0);
-		/*
-		 * sk_wmem_alloc set to one (see sk_free() and sock_wfree())
-		 */
-		refcount_set(&newsk->sk_wmem_alloc, 1);
-		atomic_set(&newsk->sk_omem_alloc, 0);
-		sk_init_common(newsk);
+	atomic_set(&newsk->sk_rmem_alloc, 0);
 
-		newsk->sk_dst_cache	= NULL;
-		newsk->sk_dst_pending_confirm = 0;
-		newsk->sk_wmem_queued	= 0;
-		newsk->sk_forward_alloc = 0;
-		atomic_set(&newsk->sk_drops, 0);
-		newsk->sk_send_head	= NULL;
-		newsk->sk_userlocks	= sk->sk_userlocks & ~SOCK_BINDPORT_LOCK;
-		atomic_set(&newsk->sk_zckey, 0);
+	/* sk_wmem_alloc set to one (see sk_free() and sock_wfree()) */
+	refcount_set(&newsk->sk_wmem_alloc, 1);
 
-		sock_reset_flag(newsk, SOCK_DONE);
+	atomic_set(&newsk->sk_omem_alloc, 0);
+	sk_init_common(newsk);
 
-		/* sk->sk_memcg will be populated at accept() time */
-		newsk->sk_memcg = NULL;
+	newsk->sk_dst_cache	= NULL;
+	newsk->sk_dst_pending_confirm = 0;
+	newsk->sk_wmem_queued	= 0;
+	newsk->sk_forward_alloc = 0;
+	atomic_set(&newsk->sk_drops, 0);
+	newsk->sk_send_head	= NULL;
+	newsk->sk_userlocks	= sk->sk_userlocks & ~SOCK_BINDPORT_LOCK;
+	atomic_set(&newsk->sk_zckey, 0);
 
-		cgroup_sk_clone(&newsk->sk_cgrp_data);
+	sock_reset_flag(newsk, SOCK_DONE);
 
-		rcu_read_lock();
-		filter = rcu_dereference(sk->sk_filter);
-		if (filter != NULL)
-			/* though it's an empty new sock, the charging may fail
-			 * if sysctl_optmem_max was changed between creation of
-			 * original socket and cloning
-			 */
-			is_charged = sk_filter_charge(newsk, filter);
-		RCU_INIT_POINTER(newsk->sk_filter, filter);
-		rcu_read_unlock();
+	/* sk->sk_memcg will be populated at accept() time */
+	newsk->sk_memcg = NULL;
 
-		if (unlikely(!is_charged || xfrm_sk_clone_policy(newsk, sk))) {
-			/* We need to make sure that we don't uncharge the new
-			 * socket if we couldn't charge it in the first place
-			 * as otherwise we uncharge the parent's filter.
-			 */
-			if (!is_charged)
-				RCU_INIT_POINTER(newsk->sk_filter, NULL);
-			sk_free_unlock_clone(newsk);
-			newsk = NULL;
-			goto out;
-		}
-		RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
+	cgroup_sk_clone(&newsk->sk_cgrp_data);
 
-		if (bpf_sk_storage_clone(sk, newsk)) {
-			sk_free_unlock_clone(newsk);
-			newsk = NULL;
-			goto out;
-		}
+	rcu_read_lock();
+	filter = rcu_dereference(sk->sk_filter);
+	if (filter != NULL)
+		/* though it's an empty new sock, the charging may fail
+		 * if sysctl_optmem_max was changed between creation of
+		 * original socket and cloning
+		 */
+		is_charged = sk_filter_charge(newsk, filter);
+	RCU_INIT_POINTER(newsk->sk_filter, filter);
+	rcu_read_unlock();
 
-		/* Clear sk_user_data if parent had the pointer tagged
-		 * as not suitable for copying when cloning.
+	if (unlikely(!is_charged || xfrm_sk_clone_policy(newsk, sk))) {
+		/* We need to make sure that we don't uncharge the new
+		 * socket if we couldn't charge it in the first place
+		 * as otherwise we uncharge the parent's filter.
 		 */
-		if (sk_user_data_is_nocopy(newsk))
-			newsk->sk_user_data = NULL;
+		if (!is_charged)
+			RCU_INIT_POINTER(newsk->sk_filter, NULL);
+		sk_free_unlock_clone(newsk);
+		newsk = NULL;
+		goto out;
+	}
+	RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
 
-		newsk->sk_err	   = 0;
-		newsk->sk_err_soft = 0;
-		newsk->sk_priority = 0;
-		newsk->sk_incoming_cpu = raw_smp_processor_id();
-		if (likely(newsk->sk_net_refcnt))
-			sock_inuse_add(sock_net(newsk), 1);
+	if (bpf_sk_storage_clone(sk, newsk)) {
+		sk_free_unlock_clone(newsk);
+		newsk = NULL;
+		goto out;
+	}
 
-		/*
-		 * Before updating sk_refcnt, we must commit prior changes to memory
-		 * (Documentation/RCU/rculist_nulls.rst for details)
-		 */
-		smp_wmb();
-		refcount_set(&newsk->sk_refcnt, 2);
+	/* Clear sk_user_data if parent had the pointer tagged
+	 * as not suitable for copying when cloning.
+	 */
+	if (sk_user_data_is_nocopy(newsk))
+		newsk->sk_user_data = NULL;
 
-		/*
-		 * Increment the counter in the same struct proto as the master
-		 * sock (sk_refcnt_debug_inc uses newsk->sk_prot->socks, that
-		 * is the same as sk->sk_prot->socks, as this field was copied
-		 * with memcpy).
-		 *
-		 * This _changes_ the previous behaviour, where
-		 * tcp_create_openreq_child always was incrementing the
-		 * equivalent to tcp_prot->socks (inet_sock_nr), so this have
-		 * to be taken into account in all callers. -acme
-		 */
-		sk_refcnt_debug_inc(newsk);
-		sk_set_socket(newsk, NULL);
-		sk_tx_queue_clear(newsk);
-		RCU_INIT_POINTER(newsk->sk_wq, NULL);
+	newsk->sk_err	   = 0;
+	newsk->sk_err_soft = 0;
+	newsk->sk_priority = 0;
+	newsk->sk_incoming_cpu = raw_smp_processor_id();
+	if (likely(newsk->sk_net_refcnt))
+		sock_inuse_add(sock_net(newsk), 1);
 
-		if (newsk->sk_prot->sockets_allocated)
-			sk_sockets_allocated_inc(newsk);
+	/* Before updating sk_refcnt, we must commit prior changes to memory
+	 * (Documentation/RCU/rculist_nulls.rst for details)
+	 */
+	smp_wmb();
+	refcount_set(&newsk->sk_refcnt, 2);
 
-		if (sock_needs_netstamp(sk) &&
-		    newsk->sk_flags & SK_FLAGS_TIMESTAMP)
-			net_enable_timestamp();
-	}
+	/* Increment the counter in the same struct proto as the master
+	 * sock (sk_refcnt_debug_inc uses newsk->sk_prot->socks, that
+	 * is the same as sk->sk_prot->socks, as this field was copied
+	 * with memcpy).
+	 *
+	 * This _changes_ the previous behaviour, where
+	 * tcp_create_openreq_child always was incrementing the
+	 * equivalent to tcp_prot->socks (inet_sock_nr), so this have
+	 * to be taken into account in all callers. -acme
+	 */
+	sk_refcnt_debug_inc(newsk);
+	sk_set_socket(newsk, NULL);
+	sk_tx_queue_clear(newsk);
+	RCU_INIT_POINTER(newsk->sk_wq, NULL);
+
+	if (newsk->sk_prot->sockets_allocated)
+		sk_sockets_allocated_inc(newsk);
+
+	if (sock_needs_netstamp(sk) && newsk->sk_flags & SK_FLAGS_TIMESTAMP)
+		net_enable_timestamp();
 out:
 	return newsk;
 }
-- 
2.33.0



