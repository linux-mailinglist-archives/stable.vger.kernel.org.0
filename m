Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90ED253CED3
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345156AbiFCRsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345305AbiFCRsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:48:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF1357B04;
        Fri,  3 Jun 2022 10:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B3BD61AD7;
        Fri,  3 Jun 2022 17:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F64C385A9;
        Fri,  3 Jun 2022 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278276;
        bh=Cx8j6TGNcfOGltVh+shM90sXuC6xABAuTb/pYwuK17Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdCAdSsW5XTKkN+Y1ds2ZnHEZu+zDa5e0K/Uhtl/ikeH/VH94EoWc0+i+68ITqdcV
         yyPtFFySYXW6lTKocvD4ORK+awp1hZ7azMqW4zrd7Nd4mlEqGYTP61SolyBsw9Ailj
         7mmEu9DI7fhgypKpek8WQ0kV7F9cD2CG6ZOVAR0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.4 06/34] secure_seq: use the 64 bits of the siphash for port offset calculation
Date:   Fri,  3 Jun 2022 19:43:02 +0200
Message-Id: <20220603173816.180109481@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.990072516@linuxfoundation.org>
References: <20220603173815.990072516@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

commit b2d057560b8107c633b39aabe517ff9d93f285e3 upstream.

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
[SG: Adjusted context]
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet_hashtables.h |    2 +-
 include/net/secure_seq.h      |    4 ++--
 net/core/secure_seq.c         |    4 ++--
 net/ipv4/inet_hashtables.c    |   10 ++++++----
 net/ipv6/inet6_hashtables.c   |    4 ++--
 5 files changed, 13 insertions(+), 11 deletions(-)

--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -420,7 +420,7 @@ static inline void sk_rcv_saddr_set(stru
 }
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-			struct sock *sk, u32 port_offset,
+			struct sock *sk, u64 port_offset,
 			int (*check_established)(struct inet_timewait_death_row *,
 						 struct sock *, __u16,
 						 struct inet_timewait_sock **));
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
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -97,7 +97,7 @@ u32 secure_tcpv6_seq(const __be32 *saddr
 }
 EXPORT_SYMBOL(secure_tcpv6_seq);
 
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport)
 {
 	const struct {
@@ -147,7 +147,7 @@ u32 secure_tcp_seq(__be32 saddr, __be32
 }
 EXPORT_SYMBOL_GPL(secure_tcp_seq);
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
 {
 	net_secret_init();
 	return siphash_4u32((__force u32)saddr, (__force u32)daddr,
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -464,7 +464,7 @@ not_unique:
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet_sk_port_offset(const struct sock *sk)
+static u64 inet_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -683,7 +683,7 @@ EXPORT_SYMBOL_GPL(inet_unhash);
 static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-		struct sock *sk, u32 port_offset,
+		struct sock *sk, u64 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
 			struct sock *, __u16, struct inet_timewait_sock **))
 {
@@ -726,7 +726,9 @@ int __inet_hash_connect(struct inet_time
 	net_get_random_once(table_perturb, sizeof(table_perturb));
 	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
 
-	offset = (READ_ONCE(table_perturb[index]) + port_offset) % remaining;
+	offset = READ_ONCE(table_perturb[index]) + port_offset;
+	offset %= remaining;
+
 	/* In first pass we try ports of @low parity.
 	 * inet_csk_get_port() does the opposite choice.
 	 */
@@ -803,7 +805,7 @@ ok:
 int inet_hash_connect(struct inet_timewait_death_row *death_row,
 		      struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet_sk_port_offset(sk);
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -262,7 +262,7 @@ not_unique:
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet6_sk_port_offset(const struct sock *sk)
+static u64 inet6_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -274,7 +274,7 @@ static u32 inet6_sk_port_offset(const st
 int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 		       struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet6_sk_port_offset(sk);


