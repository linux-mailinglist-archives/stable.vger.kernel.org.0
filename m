Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4049A68968B
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjBCK1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbjBCK10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:27:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CD0A002F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:26:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DE0161EC3
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8CAC433D2;
        Fri,  3 Feb 2023 10:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419997;
        bh=9x2jeSiQXFOO9vGdbE7GXm0rUtOeJltkXJcR6WfnQ6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMvSdZbknlbqdmfRNtefJJWNJbvGWlYM1B4YpaJzFbt1uUIYOzAkCF1x7aX5zrrz6
         1nlzkoymW0URyEFYYlsIWlf4cBoOCu5N0CSrPK962FBoyqUvlvTIlyhKrZ1kRkl/j0
         KviTY+jrH0G4E05orHnprp8i9hLHXST65JMusIeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jason Xing <kernelxing@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/134] tcp: avoid the lookup process failing to get sk in ehash table
Date:   Fri,  3 Feb 2023 11:12:31 +0100
Message-Id: <20230203101025.958696878@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 3f4ca5fafc08881d7a57daa20449d171f2887043 ]

While one cpu is working on looking up the right socket from ehash
table, another cpu is done deleting the request socket and is about
to add (or is adding) the big socket from the table. It means that
we could miss both of them, even though it has little chance.

Let me draw a call trace map of the server side.
   CPU 0                           CPU 1
   -----                           -----
tcp_v4_rcv()                  syn_recv_sock()
                            inet_ehash_insert()
                            -> sk_nulls_del_node_init_rcu(osk)
__inet_lookup_established()
                            -> __sk_nulls_add_node_rcu(sk, list)

Notice that the CPU 0 is receiving the data after the final ack
during 3-way shakehands and CPU 1 is still handling the final ack.

Why could this be a real problem?
This case is happening only when the final ack and the first data
receiving by different CPUs. Then the server receiving data with
ACK flag tries to search one proper established socket from ehash
table, but apparently it fails as my map shows above. After that,
the server fetches a listener socket and then sends a RST because
it finds a ACK flag in the skb (data), which obeys RST definition
in RFC 793.

Besides, Eric pointed out there's one more race condition where it
handles tw socket hashdance. Only by adding to the tail of the list
before deleting the old one can we avoid the race if the reader has
already begun the bucket traversal and it would possibly miss the head.

Many thanks to Eric for great help from beginning to end.

Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/lkml/20230112065336.41034-1-kerneljasonxing@gmail.com/
Link: https://lore.kernel.org/r/20230118015941.1313-1-kerneljasonxing@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c    | 17 +++++++++++++++--
 net/ipv4/inet_timewait_sock.c |  8 ++++----
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 25334aa3da04..33292983b8cf 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -536,8 +536,20 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	spin_lock(lock);
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
-		ret = sk_nulls_del_node_init_rcu(osk);
-	} else if (found_dup_sk) {
+		ret = sk_hashed(osk);
+		if (ret) {
+			/* Before deleting the node, we insert a new one to make
+			 * sure that the look-up-sk process would not miss either
+			 * of them and that at least one node would exist in ehash
+			 * table all the time. Otherwise there's a tiny chance
+			 * that lookup process could find nothing in ehash table.
+			 */
+			__sk_nulls_add_node_tail_rcu(sk, list);
+			sk_nulls_del_node_init_rcu(osk);
+		}
+		goto unlock;
+	}
+	if (found_dup_sk) {
 		*found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
 		if (*found_dup_sk)
 			ret = false;
@@ -546,6 +558,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	if (ret)
 		__sk_nulls_add_node_rcu(sk, list);
 
+unlock:
 	spin_unlock(lock);
 
 	return ret;
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index c411c87ae865..a00102d7c7fd 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -81,10 +81,10 @@ void inet_twsk_put(struct inet_timewait_sock *tw)
 }
 EXPORT_SYMBOL_GPL(inet_twsk_put);
 
-static void inet_twsk_add_node_rcu(struct inet_timewait_sock *tw,
-				   struct hlist_nulls_head *list)
+static void inet_twsk_add_node_tail_rcu(struct inet_timewait_sock *tw,
+					struct hlist_nulls_head *list)
 {
-	hlist_nulls_add_head_rcu(&tw->tw_node, list);
+	hlist_nulls_add_tail_rcu(&tw->tw_node, list);
 }
 
 static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
@@ -120,7 +120,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 
 	spin_lock(lock);
 
-	inet_twsk_add_node_rcu(tw, &ehead->chain);
+	inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
 
 	/* Step 3: Remove SK from hash chain */
 	if (__sk_nulls_del_node_init_rcu(sk))
-- 
2.39.0



