Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BC64120E9
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356428AbhITR7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347668AbhITR5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:57:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB71D61C57;
        Mon, 20 Sep 2021 17:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158086;
        bh=iuEAgtJWjNiRjmjpWK8roqpyw0cgIsXkutBYX89St98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6EkZKX3c4qaRtEyW6vlM4jAmqNbiFPtRaUsea+/DsuL9WE/NSTs5UcZHoUbTRtOX
         au6DHjsus/LyzcOPBdkOL8hu3FNVZBmhmbNpx3HyIwtyeZYSLHPLcuo/Bfln0+7nQW
         CgksEJwsMnuOyMVR1WKu2vDZPbAQlVF5V36gi2f4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 289/293] netfilter: socket: icmp6: fix use-after-scope
Date:   Mon, 20 Sep 2021 18:44:11 +0200
Message-Id: <20210920163943.324387367@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Hesmans <benjamin.hesmans@tessares.net>

[ Upstream commit 730affed24bffcd1eebd5903171960f5ff9f1f22 ]

Bug reported by KASAN:

BUG: KASAN: use-after-scope in inet6_ehashfn (net/ipv6/inet6_hashtables.c:40)
Call Trace:
(...)
inet6_ehashfn (net/ipv6/inet6_hashtables.c:40)
(...)
nf_sk_lookup_slow_v6 (net/ipv6/netfilter/nf_socket_ipv6.c:91
net/ipv6/netfilter/nf_socket_ipv6.c:146)

It seems that this bug has already been fixed by Eric Dumazet in the
past in:
commit 78296c97ca1f ("netfilter: xt_socket: fix a stack corruption bug")

But a variant of the same issue has been introduced in
commit d64d80a2cde9 ("netfilter: x_tables: don't extract flow keys on early demuxed sks in socket match")

`daddr` and `saddr` potentially hold a reference to ipv6_var that is no
longer in scope when the call to `nf_socket_get_sock_v6` is made.

Fixes: d64d80a2cde9 ("netfilter: x_tables: don't extract flow keys on early demuxed sks in socket match")
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Benjamin Hesmans <benjamin.hesmans@tessares.net>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/nf_socket_ipv6.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index f14de4b6d639..58e839e2ce1d 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -104,7 +104,7 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 {
 	__be16 uninitialized_var(dport), uninitialized_var(sport);
 	const struct in6_addr *daddr = NULL, *saddr = NULL;
-	struct ipv6hdr *iph = ipv6_hdr(skb);
+	struct ipv6hdr *iph = ipv6_hdr(skb), ipv6_var;
 	struct sk_buff *data_skb = NULL;
 	int doff = 0;
 	int thoff = 0, tproto;
@@ -134,8 +134,6 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 			thoff + sizeof(*hp);
 
 	} else if (tproto == IPPROTO_ICMPV6) {
-		struct ipv6hdr ipv6_var;
-
 		if (extract_icmp6_fields(skb, thoff, &tproto, &saddr, &daddr,
 					 &sport, &dport, &ipv6_var))
 			return NULL;
-- 
2.30.2



