Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE6B5947D6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344991AbiHOX36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353375AbiHOX2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:28:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D0E14D737;
        Mon, 15 Aug 2022 13:07:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A288FB81155;
        Mon, 15 Aug 2022 20:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED93C433D6;
        Mon, 15 Aug 2022 20:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594049;
        bh=qeb5GrAM5tjHD+f6qoo0ZN7mzMf6nXXjTVEBx2JIzE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHBGL22viRw6ClJknetEj+OL111etGQB8YZJMVuWBTALdZrRCliZs/IiqOXQ4srQh
         IQsrZOQM9Kdt444fMUmdFUS11NNH2yUbCJcxFj7jiDNYwSnOMk/smeiOiXL1+9PL5e
         umLKLrhcq5yPDSdadzAuASnTKTODVusZga4Ma+3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0367/1157] ping: convert to RCU lookups, get rid of rwlock
Date:   Mon, 15 Aug 2022 19:55:23 +0200
Message-Id: <20220815180454.402115916@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dbca1596bbb08318f5e3b3b99f8ca0a0d3830a65 ]

Using rwlock in networking code is extremely risky.
writers can starve if enough readers are constantly
grabing the rwlock.

I thought rwlock were at fault and sent this patch:

https://lkml.org/lkml/2022/6/17/272

But Peter and Linus essentially told me rwlock had to be unfair.

We need to get rid of rwlock in networking code.

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ping.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 3c6101def7d6..b83c2bd9d722 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -50,7 +50,7 @@
 
 struct ping_table {
 	struct hlist_nulls_head	hash[PING_HTABLE_SIZE];
-	rwlock_t		lock;
+	spinlock_t		lock;
 };
 
 static struct ping_table ping_table;
@@ -82,7 +82,7 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 	struct sock *sk2 = NULL;
 
 	isk = inet_sk(sk);
-	write_lock_bh(&ping_table.lock);
+	spin_lock(&ping_table.lock);
 	if (ident == 0) {
 		u32 i;
 		u16 result = ping_port_rover + 1;
@@ -128,14 +128,15 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 	if (sk_unhashed(sk)) {
 		pr_debug("was not hashed\n");
 		sock_hold(sk);
-		hlist_nulls_add_head(&sk->sk_nulls_node, hlist);
+		sock_set_flag(sk, SOCK_RCU_FREE);
+		hlist_nulls_add_head_rcu(&sk->sk_nulls_node, hlist);
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 	}
-	write_unlock_bh(&ping_table.lock);
+	spin_unlock(&ping_table.lock);
 	return 0;
 
 fail:
-	write_unlock_bh(&ping_table.lock);
+	spin_unlock(&ping_table.lock);
 	return 1;
 }
 EXPORT_SYMBOL_GPL(ping_get_port);
@@ -153,19 +154,19 @@ void ping_unhash(struct sock *sk)
 	struct inet_sock *isk = inet_sk(sk);
 
 	pr_debug("ping_unhash(isk=%p,isk->num=%u)\n", isk, isk->inet_num);
-	write_lock_bh(&ping_table.lock);
+	spin_lock(&ping_table.lock);
 	if (sk_hashed(sk)) {
-		hlist_nulls_del(&sk->sk_nulls_node);
-		sk_nulls_node_init(&sk->sk_nulls_node);
+		hlist_nulls_del_init_rcu(&sk->sk_nulls_node);
 		sock_put(sk);
 		isk->inet_num = 0;
 		isk->inet_sport = 0;
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 	}
-	write_unlock_bh(&ping_table.lock);
+	spin_unlock(&ping_table.lock);
 }
 EXPORT_SYMBOL_GPL(ping_unhash);
 
+/* Called under rcu_read_lock() */
 static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 {
 	struct hlist_nulls_head *hslot = ping_hashslot(&ping_table, net, ident);
@@ -190,8 +191,6 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		return NULL;
 	}
 
-	read_lock_bh(&ping_table.lock);
-
 	ping_portaddr_for_each_entry(sk, hnode, hslot) {
 		isk = inet_sk(sk);
 
@@ -230,13 +229,11 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		    sk->sk_bound_dev_if != sdif)
 			continue;
 
-		sock_hold(sk);
 		goto exit;
 	}
 
 	sk = NULL;
 exit:
-	read_unlock_bh(&ping_table.lock);
 
 	return sk;
 }
@@ -592,7 +589,7 @@ void ping_err(struct sk_buff *skb, int offset, u32 info)
 	sk->sk_err = err;
 	sk_error_report(sk);
 out:
-	sock_put(sk);
+	return;
 }
 EXPORT_SYMBOL_GPL(ping_err);
 
@@ -998,7 +995,6 @@ enum skb_drop_reason ping_rcv(struct sk_buff *skb)
 			reason = __ping_queue_rcv_skb(sk, skb2);
 		else
 			reason = SKB_DROP_REASON_NOMEM;
-		sock_put(sk);
 	}
 
 	if (reason)
@@ -1084,13 +1080,13 @@ static struct sock *ping_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 void *ping_seq_start(struct seq_file *seq, loff_t *pos, sa_family_t family)
-	__acquires(ping_table.lock)
+	__acquires(RCU)
 {
 	struct ping_iter_state *state = seq->private;
 	state->bucket = 0;
 	state->family = family;
 
-	read_lock_bh(&ping_table.lock);
+	rcu_read_lock();
 
 	return *pos ? ping_get_idx(seq, *pos-1) : SEQ_START_TOKEN;
 }
@@ -1116,9 +1112,9 @@ void *ping_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 EXPORT_SYMBOL_GPL(ping_seq_next);
 
 void ping_seq_stop(struct seq_file *seq, void *v)
-	__releases(ping_table.lock)
+	__releases(RCU)
 {
-	read_unlock_bh(&ping_table.lock);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ping_seq_stop);
 
@@ -1202,5 +1198,5 @@ void __init ping_init(void)
 
 	for (i = 0; i < PING_HTABLE_SIZE; i++)
 		INIT_HLIST_NULLS_HEAD(&ping_table.hash[i], i);
-	rwlock_init(&ping_table.lock);
+	spin_lock_init(&ping_table.lock);
 }
-- 
2.35.1



