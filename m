Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4CB60FE81
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiJ0RF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236968AbiJ0RFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:05:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C5D193EE5
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F19BCE279A
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F213C433D6;
        Thu, 27 Oct 2022 17:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890343;
        bh=YNaaPjuhtL63A7ibS9tbUFu5/pBb1BZSAQ8irGUjPUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0b50vQtSLEnM1OpV7ZY0wmktFVT2xjiz30LUnkXFLmQtbT3+usv6Jn6tc/D09iL8
         PZOg+bw8H577+0dbGNAttT5zoC9FGruYHXus/BauOHR74TLUybSaLgcLQYTv+xmaQw
         /Q7U6ls9+WKFWSVm6yNlmIC65AX76JgbQExK+XcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/79] tcp: Add num_closed_socks to struct sock_reuseport.
Date:   Thu, 27 Oct 2022 18:55:45 +0200
Message-Id: <20221027165055.564998662@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

[ Upstream commit 5c040eaf5d1753aafe12989ca712175df0b9c436 ]

As noted in the following commit, a closed listener has to hold the
reference to the reuseport group for socket migration. This patch adds a
field (num_closed_socks) to struct sock_reuseport to manage closed sockets
within the same reuseport group. Moreover, this and the following commits
introduce some helper functions to split socks[] into two sections and keep
TCP_LISTEN and TCP_CLOSE sockets in each section. Like a double-ended
queue, we will place TCP_LISTEN sockets from the front and TCP_CLOSE
sockets from the end.

  TCP_LISTEN---------->       <-------TCP_CLOSE
  +---+---+  ---  +---+  ---  +---+  ---  +---+
  | 0 | 1 |  ...  | i |  ...  | j |  ...  | k |
  +---+---+  ---  +---+  ---  +---+  ---  +---+

  i = num_socks - 1
  j = max_socks - num_closed_socks
  k = max_socks - 1

This patch also extends reuseport_add_sock() and reuseport_grow() to
support num_closed_socks.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20210612123224.12525-3-kuniyu@amazon.co.jp
Stable-dep-of: 69421bf98482 ("udp: Update reuse->has_conns under reuseport_lock.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock_reuseport.h |  5 ++-
 net/core/sock_reuseport.c    | 75 +++++++++++++++++++++++++++---------
 2 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 505f1e18e9bf..0e558ca7afbf 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -13,8 +13,9 @@ extern spinlock_t reuseport_lock;
 struct sock_reuseport {
 	struct rcu_head		rcu;
 
-	u16			max_socks;	/* length of socks */
-	u16			num_socks;	/* elements in socks */
+	u16			max_socks;		/* length of socks */
+	u16			num_socks;		/* elements in socks */
+	u16			num_closed_socks;	/* closed elements in socks */
 	/* The last synq overflow event timestamp of this
 	 * reuse->socks[] group.
 	 */
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index b065f0a103ed..f478c65a281b 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -18,6 +18,49 @@ DEFINE_SPINLOCK(reuseport_lock);
 
 static DEFINE_IDA(reuseport_ida);
 
+static int reuseport_sock_index(struct sock *sk,
+				const struct sock_reuseport *reuse,
+				bool closed)
+{
+	int left, right;
+
+	if (!closed) {
+		left = 0;
+		right = reuse->num_socks;
+	} else {
+		left = reuse->max_socks - reuse->num_closed_socks;
+		right = reuse->max_socks;
+	}
+
+	for (; left < right; left++)
+		if (reuse->socks[left] == sk)
+			return left;
+	return -1;
+}
+
+static void __reuseport_add_sock(struct sock *sk,
+				 struct sock_reuseport *reuse)
+{
+	reuse->socks[reuse->num_socks] = sk;
+	/* paired with smp_rmb() in reuseport_select_sock() */
+	smp_wmb();
+	reuse->num_socks++;
+}
+
+static bool __reuseport_detach_sock(struct sock *sk,
+				    struct sock_reuseport *reuse)
+{
+	int i = reuseport_sock_index(sk, reuse, false);
+
+	if (i == -1)
+		return false;
+
+	reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
+	reuse->num_socks--;
+
+	return true;
+}
+
 static struct sock_reuseport *__reuseport_alloc(unsigned int max_socks)
 {
 	unsigned int size = sizeof(struct sock_reuseport) +
@@ -72,9 +115,9 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
 	}
 
 	reuse->reuseport_id = id;
+	reuse->bind_inany = bind_inany;
 	reuse->socks[0] = sk;
 	reuse->num_socks = 1;
-	reuse->bind_inany = bind_inany;
 	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
 
 out:
@@ -98,6 +141,7 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
 		return NULL;
 
 	more_reuse->num_socks = reuse->num_socks;
+	more_reuse->num_closed_socks = reuse->num_closed_socks;
 	more_reuse->prog = reuse->prog;
 	more_reuse->reuseport_id = reuse->reuseport_id;
 	more_reuse->bind_inany = reuse->bind_inany;
@@ -105,9 +149,13 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
 
 	memcpy(more_reuse->socks, reuse->socks,
 	       reuse->num_socks * sizeof(struct sock *));
+	memcpy(more_reuse->socks +
+	       (more_reuse->max_socks - more_reuse->num_closed_socks),
+	       reuse->socks + (reuse->max_socks - reuse->num_closed_socks),
+	       reuse->num_closed_socks * sizeof(struct sock *));
 	more_reuse->synq_overflow_ts = READ_ONCE(reuse->synq_overflow_ts);
 
-	for (i = 0; i < reuse->num_socks; ++i)
+	for (i = 0; i < reuse->max_socks; ++i)
 		rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
 				   more_reuse);
 
@@ -158,7 +206,7 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 		return -EBUSY;
 	}
 
-	if (reuse->num_socks == reuse->max_socks) {
+	if (reuse->num_socks + reuse->num_closed_socks == reuse->max_socks) {
 		reuse = reuseport_grow(reuse);
 		if (!reuse) {
 			spin_unlock_bh(&reuseport_lock);
@@ -166,10 +214,7 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 		}
 	}
 
-	reuse->socks[reuse->num_socks] = sk;
-	/* paired with smp_rmb() in reuseport_select_sock() */
-	smp_wmb();
-	reuse->num_socks++;
+	__reuseport_add_sock(sk, reuse);
 	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
 
 	spin_unlock_bh(&reuseport_lock);
@@ -183,7 +228,6 @@ EXPORT_SYMBOL(reuseport_add_sock);
 void reuseport_detach_sock(struct sock *sk)
 {
 	struct sock_reuseport *reuse;
-	int i;
 
 	spin_lock_bh(&reuseport_lock);
 	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
@@ -200,16 +244,11 @@ void reuseport_detach_sock(struct sock *sk)
 	bpf_sk_reuseport_detach(sk);
 
 	rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
+	__reuseport_detach_sock(sk, reuse);
+
+	if (reuse->num_socks + reuse->num_closed_socks == 0)
+		call_rcu(&reuse->rcu, reuseport_free_rcu);
 
-	for (i = 0; i < reuse->num_socks; i++) {
-		if (reuse->socks[i] == sk) {
-			reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
-			reuse->num_socks--;
-			if (reuse->num_socks == 0)
-				call_rcu(&reuse->rcu, reuseport_free_rcu);
-			break;
-		}
-	}
 	spin_unlock_bh(&reuseport_lock);
 }
 EXPORT_SYMBOL(reuseport_detach_sock);
@@ -274,7 +313,7 @@ struct sock *reuseport_select_sock(struct sock *sk,
 	prog = rcu_dereference(reuse->prog);
 	socks = READ_ONCE(reuse->num_socks);
 	if (likely(socks)) {
-		/* paired with smp_wmb() in reuseport_add_sock() */
+		/* paired with smp_wmb() in __reuseport_add_sock() */
 		smp_rmb();
 
 		if (!prog || !skb)
-- 
2.35.1



