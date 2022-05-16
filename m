Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02EE3529021
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346789AbiEPUL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350919AbiEPUBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956E54B43B;
        Mon, 16 May 2022 12:56:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7E5860A1C;
        Mon, 16 May 2022 19:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE7CC34100;
        Mon, 16 May 2022 19:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730965;
        bh=I7fFtDTNT19Q0vnW9LieIV7IFg1MDaf2fd/dTIAvN+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBWzhzdhNnLF44KDfFnDq7weaZJUgtMUQBmNTGqdgZ8SyJm0BUXlfUyGd0olE4GGH
         +NePZyKnVA101bu7wc2/N9BJRAThoDWjf0fOzYuWoma7CnmZIsVkNAoz+AEqMpOvai
         j+yUddUyfXFRS2Km7xkzxpyHEhcHFliZFuZSwUlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 061/114] secure_seq: use the 64 bits of the siphash for port offset calculation
Date:   Mon, 16 May 2022 21:36:35 +0200
Message-Id: <20220516193627.245226907@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit b2d057560b8107c633b39aabe517ff9d93f285e3 ]

SipHash replaced MD5 in secure_ipv{4,6}_port_ephemeral() via commit
7cd23e5300c1 ("secure_seq: use SipHash in place of MD5"), but the output
remained truncated to 32-bit only. In order to exploit more bits from the
hash, let's make the functions return the full 64-bit of siphash_3u32().
We also make sure the port offset calculation in __inet_hash_connect()
remains done on 32-bit to avoid the need for div_u64_rem() and an extra
cost on 32-bit systems.

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Cc: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_hashtables.h |  2 +-
 include/net/secure_seq.h      |  4 ++--
 net/core/secure_seq.c         |  4 ++--
 net/ipv4/inet_hashtables.c    | 10 ++++++----
 net/ipv6/inet6_hashtables.c   |  4 ++--
 5 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index f72ec113ae56..98e1ec1a14f0 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -425,7 +425,7 @@ static inline void sk_rcv_saddr_set(struct sock *sk, __be32 addr)
 }
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-			struct sock *sk, u32 port_offset,
+			struct sock *sk, u64 port_offset,
 			int (*check_established)(struct inet_timewait_death_row *,
 						 struct sock *, __u16,
 						 struct inet_timewait_sock **));
diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
index d7d2495f83c2..dac91aa38c5a 100644
--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@ -4,8 +4,8 @@
 
 #include <linux/types.h>
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
+u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport);
 u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 		   __be16 sport, __be16 dport);
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 9b8443774449..55aa5cc258e3 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -94,7 +94,7 @@ u32 secure_tcpv6_seq(const __be32 *saddr, const __be32 *daddr,
 }
 EXPORT_SYMBOL(secure_tcpv6_seq);
 
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport)
 {
 	const struct {
@@ -142,7 +142,7 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 }
 EXPORT_SYMBOL_GPL(secure_tcp_seq);
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
 {
 	net_secret_init();
 	return siphash_3u32((__force u32)saddr, (__force u32)daddr,
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 17440840a791..9d24d9319f3d 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -504,7 +504,7 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet_sk_port_offset(const struct sock *sk)
+static u64 inet_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -734,7 +734,7 @@ EXPORT_SYMBOL_GPL(inet_unhash);
 static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-		struct sock *sk, u32 port_offset,
+		struct sock *sk, u64 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
 			struct sock *, __u16, struct inet_timewait_sock **))
 {
@@ -777,7 +777,9 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	net_get_random_once(table_perturb, sizeof(table_perturb));
 	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
 
-	offset = (READ_ONCE(table_perturb[index]) + port_offset) % remaining;
+	offset = READ_ONCE(table_perturb[index]) + port_offset;
+	offset %= remaining;
+
 	/* In first pass we try ports of @low parity.
 	 * inet_csk_get_port() does the opposite choice.
 	 */
@@ -859,7 +861,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 int inet_hash_connect(struct inet_timewait_death_row *death_row,
 		      struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet_sk_port_offset(sk);
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 4740afecf7c6..32ccac10bd62 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -308,7 +308,7 @@ static int __inet6_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet6_sk_port_offset(const struct sock *sk)
+static u64 inet6_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -320,7 +320,7 @@ static u32 inet6_sk_port_offset(const struct sock *sk)
 int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 		       struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet6_sk_port_offset(sk);
-- 
2.35.1



