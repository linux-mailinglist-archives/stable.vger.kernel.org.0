Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85C5657DB2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbiL1PqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiL1Pp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:45:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD38F18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:45:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41920B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A64C433F0;
        Wed, 28 Dec 2022 15:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242354;
        bh=J8TCHGeBdJGrmvalgf8GnMBQDIhOljKweMv8IfNZ2H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxZDVyMix+KW7oXhSEF8FjOS1wCiiuakhW/5EAk0cNEpWRqAw3u7Zj3XPrVVlb1ly
         oSkkDqQtKQWIGLP/fP9xllTs4bxgMDVOu5IMUk+gFXmaUXP1LKOZRzv7LM7hu9woEn
         dLVHyqLw3NdiA4zUWz5xINdt5MKt6dTXZdnnsJh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0360/1146] udp: Clean up some functions.
Date:   Wed, 28 Dec 2022 15:31:39 +0100
Message-Id: <20221228144339.939795646@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 919dfa0b20ae56060dce0436eb710717f8987d18 ]

This patch adds no functional change and cleans up some functions
that the following patches touch around so that we make them tidy
and easy to review/revert.  The change is mainly to keep reverse
christmas tree order.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7a7160edf1bf ("net: Return errno in sk->sk_prot->get_port().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 39 +++++++++++++++++++++++----------------
 net/ipv6/udp.c | 12 ++++++++----
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 6a320a614e54..83fdd2b8afd6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -232,16 +232,16 @@ static int udp_reuseport_add_sock(struct sock *sk, struct udp_hslot *hslot)
 int udp_lib_get_port(struct sock *sk, unsigned short snum,
 		     unsigned int hash2_nulladdr)
 {
-	struct udp_hslot *hslot, *hslot2;
 	struct udp_table *udptable = sk->sk_prot->h.udp_table;
-	int    error = 1;
+	struct udp_hslot *hslot, *hslot2;
 	struct net *net = sock_net(sk);
+	int error = 1;
 
 	if (!snum) {
+		DECLARE_BITMAP(bitmap, PORTS_PER_CHAIN);
+		unsigned short first, last;
 		int low, high, remaining;
 		unsigned int rand;
-		unsigned short first, last;
-		DECLARE_BITMAP(bitmap, PORTS_PER_CHAIN);
 
 		inet_get_local_port_range(net, &low, &high);
 		remaining = (high - low) + 1;
@@ -2518,10 +2518,13 @@ static struct sock *__udp4_lib_mcast_demux_lookup(struct net *net,
 						  __be16 rmt_port, __be32 rmt_addr,
 						  int dif, int sdif)
 {
-	struct sock *sk, *result;
 	unsigned short hnum = ntohs(loc_port);
-	unsigned int slot = udp_hashfn(net, hnum, udp_table.mask);
-	struct udp_hslot *hslot = &udp_table.hash[slot];
+	struct sock *sk, *result;
+	struct udp_hslot *hslot;
+	unsigned int slot;
+
+	slot = udp_hashfn(net, hnum, udp_table.mask);
+	hslot = &udp_table.hash[slot];
 
 	/* Do not bother scanning a too big list */
 	if (hslot->count > 10)
@@ -2549,14 +2552,18 @@ static struct sock *__udp4_lib_demux_lookup(struct net *net,
 					    __be16 rmt_port, __be32 rmt_addr,
 					    int dif, int sdif)
 {
-	unsigned short hnum = ntohs(loc_port);
-	unsigned int hash2 = ipv4_portaddr_hash(net, loc_addr, hnum);
-	unsigned int slot2 = hash2 & udp_table.mask;
-	struct udp_hslot *hslot2 = &udp_table.hash2[slot2];
 	INET_ADDR_COOKIE(acookie, rmt_addr, loc_addr);
-	const __portpair ports = INET_COMBINED_PORTS(rmt_port, hnum);
+	unsigned short hnum = ntohs(loc_port);
+	unsigned int hash2, slot2;
+	struct udp_hslot *hslot2;
+	__portpair ports;
 	struct sock *sk;
 
+	hash2 = ipv4_portaddr_hash(net, loc_addr, hnum);
+	slot2 = hash2 & udp_table.mask;
+	hslot2 = &udp_table.hash2[slot2];
+	ports = INET_COMBINED_PORTS(rmt_port, hnum);
+
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
 		if (inet_match(net, sk, acookie, ports, dif, sdif))
 			return sk;
@@ -2957,10 +2964,10 @@ EXPORT_SYMBOL(udp_prot);
 
 static struct sock *udp_get_first(struct seq_file *seq, int start)
 {
-	struct sock *sk;
-	struct udp_seq_afinfo *afinfo;
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
+	struct udp_seq_afinfo *afinfo;
+	struct sock *sk;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
@@ -2991,9 +2998,9 @@ static struct sock *udp_get_first(struct seq_file *seq, int start)
 
 static struct sock *udp_get_next(struct seq_file *seq, struct sock *sk)
 {
-	struct udp_seq_afinfo *afinfo;
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
+	struct udp_seq_afinfo *afinfo;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
@@ -3049,8 +3056,8 @@ EXPORT_SYMBOL(udp_seq_next);
 
 void udp_seq_stop(struct seq_file *seq, void *v)
 {
-	struct udp_seq_afinfo *afinfo;
 	struct udp_iter_state *state = seq->private;
+	struct udp_seq_afinfo *afinfo;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index bc65e5b7195b..98a64e8d9bda 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1063,12 +1063,16 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 			int dif, int sdif)
 {
 	unsigned short hnum = ntohs(loc_port);
-	unsigned int hash2 = ipv6_portaddr_hash(net, loc_addr, hnum);
-	unsigned int slot2 = hash2 & udp_table.mask;
-	struct udp_hslot *hslot2 = &udp_table.hash2[slot2];
-	const __portpair ports = INET_COMBINED_PORTS(rmt_port, hnum);
+	unsigned int hash2, slot2;
+	struct udp_hslot *hslot2;
+	__portpair ports;
 	struct sock *sk;
 
+	hash2 = ipv6_portaddr_hash(net, loc_addr, hnum);
+	slot2 = hash2 & udp_table.mask;
+	hslot2 = &udp_table.hash2[slot2];
+	ports = INET_COMBINED_PORTS(rmt_port, hnum);
+
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
 		if (sk->sk_state == TCP_ESTABLISHED &&
 		    inet6_match(net, sk, rmt_addr, loc_addr, ports, dif, sdif))
-- 
2.35.1



