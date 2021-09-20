Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3D8412494
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353352AbhITSgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380334AbhITSda (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:33:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5050A63303;
        Mon, 20 Sep 2021 17:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158898;
        bh=n8+TiQ4yNKT8/fz9Ul5M3sOI9kFv2BGLFwuALFg8MVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMNALItHOpAz39aeFTGrPv2ZFG0QTB/gBMwbWIboXnbtYG53OISfvfhMCJdhWk78y
         xR3/GH//Yku9614cgYHu+4yX8nIbdHDhXb72z8FfPaJ+2kn6wpOMpw1IDGEmwLaNBe
         +eWwH2Xerd9vrdPwRBP2XeWe4J+KAToivXWzlsqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/122] netfilter: socket: icmp6: fix use-after-scope
Date:   Mon, 20 Sep 2021 18:44:39 +0200
Message-Id: <20210920163919.314979559@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
index 6fd54744cbc3..aa5bb8789ba0 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -99,7 +99,7 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 {
 	__be16 dport, sport;
 	const struct in6_addr *daddr = NULL, *saddr = NULL;
-	struct ipv6hdr *iph = ipv6_hdr(skb);
+	struct ipv6hdr *iph = ipv6_hdr(skb), ipv6_var;
 	struct sk_buff *data_skb = NULL;
 	int doff = 0;
 	int thoff = 0, tproto;
@@ -129,8 +129,6 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 			thoff + sizeof(*hp);
 
 	} else if (tproto == IPPROTO_ICMPV6) {
-		struct ipv6hdr ipv6_var;
-
 		if (extract_icmp6_fields(skb, thoff, &tproto, &saddr, &daddr,
 					 &sport, &dport, &ipv6_var))
 			return NULL;
-- 
2.30.2



