Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE3917FA81
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgCJNFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727721AbgCJNFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:05:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8543724693;
        Tue, 10 Mar 2020 13:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845534;
        bh=jZwp9oI17+t2+5P+loI5tsUoPSq83EYLbtUqSb/Eugc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KoaWwCH+JpH+pFjXe4ny+Kf1dXkHHL5DUemf4FdnuJzjSxkZ98SMOF/dpoZuFmyxy
         yzVzOBzlBZhqhsUU+nxBnhoMUaQawqb0mASJOGPiOW4rBsreKo1M0vmI4Rj0DG8RbK
         PaxxcSQ0nyHsOBK2sHR0tANcPSCqM5XBcy5sp81Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martynas Pumputis <martynas@weave.works>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Andy Strohman <astroh@amazon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 002/126] netfilter: nf_conntrack: resolve clash for matching conntracks
Date:   Tue, 10 Mar 2020 13:40:23 +0100
Message-Id: <20200310124203.853827816@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martynas Pumputis <martynas@weave.works>

[ Upstream commit ed07d9a021df6da53456663a76999189badc432a ]

This patch enables the clash resolution for NAT (disabled in
"590b52e10d41") if clashing conntracks match (i.e. both tuples are equal)
and a protocol allows it.

The clash might happen for a connections-less protocol (e.g. UDP) when
two threads in parallel writes to the same socket and consequent calls
to "get_unique_tuple" return the same tuples (incl. reply tuples).

In this case it is safe to perform the resolution, as the losing CT
describes the same mangling as the winning CT, so no modifications to
the packet are needed, and the result of rules traversal for the loser's
packet stays valid.

Signed-off-by: Martynas Pumputis <martynas@weave.works>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Andy Strohman <astroh@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2e65271bed01f..a79f5a89cab14 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -543,6 +543,18 @@ nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
 	       net_eq(net, nf_ct_net(ct));
 }
 
+static inline bool
+nf_ct_match(const struct nf_conn *ct1, const struct nf_conn *ct2)
+{
+	return nf_ct_tuple_equal(&ct1->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				 &ct2->tuplehash[IP_CT_DIR_ORIGINAL].tuple) &&
+	       nf_ct_tuple_equal(&ct1->tuplehash[IP_CT_DIR_REPLY].tuple,
+				 &ct2->tuplehash[IP_CT_DIR_REPLY].tuple) &&
+	       nf_ct_zone_equal(ct1, nf_ct_zone(ct2), IP_CT_DIR_ORIGINAL) &&
+	       nf_ct_zone_equal(ct1, nf_ct_zone(ct2), IP_CT_DIR_REPLY) &&
+	       net_eq(nf_ct_net(ct1), nf_ct_net(ct2));
+}
+
 /* caller must hold rcu readlock and none of the nf_conntrack_locks */
 static void nf_ct_gc_expired(struct nf_conn *ct)
 {
@@ -736,19 +748,21 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
 	/* This is the conntrack entry already in hashes that won race. */
 	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 	const struct nf_conntrack_l4proto *l4proto;
+	enum ip_conntrack_info oldinfo;
+	struct nf_conn *loser_ct = nf_ct_get(skb, &oldinfo);
 
 	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
 	if (l4proto->allow_clash &&
-	    ((ct->status & IPS_NAT_DONE_MASK) == 0) &&
 	    !nf_ct_is_dying(ct) &&
 	    atomic_inc_not_zero(&ct->ct_general.use)) {
-		enum ip_conntrack_info oldinfo;
-		struct nf_conn *loser_ct = nf_ct_get(skb, &oldinfo);
-
-		nf_ct_acct_merge(ct, ctinfo, loser_ct);
-		nf_conntrack_put(&loser_ct->ct_general);
-		nf_ct_set(skb, ct, oldinfo);
-		return NF_ACCEPT;
+		if (((ct->status & IPS_NAT_DONE_MASK) == 0) ||
+		    nf_ct_match(ct, loser_ct)) {
+			nf_ct_acct_merge(ct, ctinfo, loser_ct);
+			nf_conntrack_put(&loser_ct->ct_general);
+			nf_ct_set(skb, ct, oldinfo);
+			return NF_ACCEPT;
+		}
+		nf_ct_put(ct);
 	}
 	NF_CT_STAT_INC(net, drop);
 	return NF_DROP;
-- 
2.20.1



