Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A926DEF3E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjDLItO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjDLItI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:49:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E8686BB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E00CD6312C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BE1C433D2;
        Wed, 12 Apr 2023 08:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289303;
        bh=KHKwuqNiQZW7i5IE2YIZOPwZWn03z/1ZlGFehvxyssg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZVFjYkXmD6mJWM+fEx9fY2bimxmkVfTmylqEyGNAEb7AlWvU56s4EU5t32lhwVN0
         TTEDv95eD+UqX7gN7amVMTyQhE0t1i6qDvdwjKdgtEk9AgCunFUWJcBH8Rj7n0DS+E
         rQjTiTZquNHL3fZ+AKHJoFV1j/h/6pTNNny7d05s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 047/173] raw: use net_hash_mix() in hash function
Date:   Wed, 12 Apr 2023 10:32:53 +0200
Message-Id: <20230412082840.017340718@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6579f5bacc2c4cbc5ef6abb45352416939d1f844 ]

Some applications seem to rely on RAW sockets.

If they use private netns, we can avoid piling all RAW
sockets bound to a given protocol into a single bucket.

Also place (struct raw_hashinfo).lock into its own
cache line to limit false sharing.

Alternative would be to have per-netns hashtables,
but this seems too expensive for most netns
where RAW sockets are not used.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0a78cf7264d2 ("raw: Fix NULL deref in raw_get_next().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/raw.h | 13 +++++++++++--
 net/ipv4/raw.c    | 13 +++++++------
 net/ipv6/raw.c    |  4 ++--
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/net/raw.h b/include/net/raw.h
index 5e665934ebc7c..2c004c20ed996 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -15,6 +15,8 @@
 
 #include <net/inet_sock.h>
 #include <net/protocol.h>
+#include <net/netns/hash.h>
+#include <linux/hash.h>
 #include <linux/icmp.h>
 
 extern struct proto raw_prot;
@@ -29,13 +31,20 @@ int raw_local_deliver(struct sk_buff *, int);
 
 int raw_rcv(struct sock *, struct sk_buff *);
 
-#define RAW_HTABLE_SIZE	MAX_INET_PROTOS
+#define RAW_HTABLE_LOG	8
+#define RAW_HTABLE_SIZE	(1U << RAW_HTABLE_LOG)
 
 struct raw_hashinfo {
 	spinlock_t lock;
-	struct hlist_nulls_head ht[RAW_HTABLE_SIZE];
+
+	struct hlist_nulls_head ht[RAW_HTABLE_SIZE] ____cacheline_aligned;
 };
 
+static inline u32 raw_hashfunc(const struct net *net, u32 proto)
+{
+	return hash_32(net_hash_mix(net) ^ proto, RAW_HTABLE_LOG);
+}
+
 static inline void raw_hashinfo_init(struct raw_hashinfo *hashinfo)
 {
 	int i;
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 006c1f0ed8b47..2a53a0bf29232 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -93,7 +93,7 @@ int raw_hash_sk(struct sock *sk)
 	struct raw_hashinfo *h = sk->sk_prot->h.raw_hash;
 	struct hlist_nulls_head *hlist;
 
-	hlist = &h->ht[inet_sk(sk)->inet_num & (RAW_HTABLE_SIZE - 1)];
+	hlist = &h->ht[raw_hashfunc(sock_net(sk), inet_sk(sk)->inet_num)];
 
 	spin_lock(&h->lock);
 	__sk_nulls_add_node_rcu(sk, hlist);
@@ -160,9 +160,9 @@ static int icmp_filter(const struct sock *sk, const struct sk_buff *skb)
  * RFC 1122: SHOULD pass TOS value up to the transport layer.
  * -> It does. And not only TOS, but all IP header.
  */
-static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
+static int raw_v4_input(struct net *net, struct sk_buff *skb,
+			const struct iphdr *iph, int hash)
 {
-	struct net *net = dev_net(skb->dev);
 	struct hlist_nulls_head *hlist;
 	struct hlist_nulls_node *hnode;
 	int sdif = inet_sdif(skb);
@@ -193,9 +193,10 @@ static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 
 int raw_local_deliver(struct sk_buff *skb, int protocol)
 {
-	int hash = protocol & (RAW_HTABLE_SIZE - 1);
+	struct net *net = dev_net(skb->dev);
 
-	return raw_v4_input(skb, ip_hdr(skb), hash);
+	return raw_v4_input(net, skb, ip_hdr(skb),
+			    raw_hashfunc(net, protocol));
 }
 
 static void raw_err(struct sock *sk, struct sk_buff *skb, u32 info)
@@ -271,7 +272,7 @@ void raw_icmp_error(struct sk_buff *skb, int protocol, u32 info)
 	struct sock *sk;
 	int hash;
 
-	hash = protocol & (RAW_HTABLE_SIZE - 1);
+	hash = raw_hashfunc(net, protocol);
 	hlist = &raw_v4_hashinfo.ht[hash];
 
 	rcu_read_lock();
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index ada087b50541a..45b35b5f893c5 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -152,7 +152,7 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 	saddr = &ipv6_hdr(skb)->saddr;
 	daddr = saddr + 1;
 
-	hash = nexthdr & (RAW_HTABLE_SIZE - 1);
+	hash = raw_hashfunc(net, nexthdr);
 	hlist = &raw_v6_hashinfo.ht[hash];
 	rcu_read_lock();
 	sk_nulls_for_each(sk, hnode, hlist) {
@@ -338,7 +338,7 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 	struct sock *sk;
 	int hash;
 
-	hash = nexthdr & (RAW_HTABLE_SIZE - 1);
+	hash = raw_hashfunc(net, nexthdr);
 	hlist = &raw_v6_hashinfo.ht[hash];
 	rcu_read_lock();
 	sk_nulls_for_each(sk, hnode, hlist) {
-- 
2.39.2



