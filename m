Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17BAE172DBF
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 01:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbgB1A6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 19:58:15 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:32476 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730155AbgB1A6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 19:58:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582851494; x=1614387494;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=+26UKzxlUN4EVAyF/OYB/8RCGqTKNyic6tJjp8D1FfE=;
  b=tAkhLslfULoWwapgBa8Yg9eys64O8oJ0dPhJxDCMmn1EEI4Ljrn7UDEu
   /I2EFvxtUmAU21ROqBZRRxw469Y4xxEuhHI2I5Oir8KADjPFcQWZc7zdy
   rcnypZL2moY1kfsEZt79eL1MiacWOxlHrXmwC00HlfIWZWnu81ptu4X6w
   A=;
IronPort-SDR: NpQ6RmQf4Ok3PHd0ta/c6LIKP7ry6ftsxewilpBIX0vtEKRMXAOaECNbn8VOSIWItiBkt1kgl3
 uiGjBiJ8gukQ==
X-IronPort-AV: E=Sophos;i="5.70,493,1574121600"; 
   d="scan'208";a="19629493"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 28 Feb 2020 00:58:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id B7436A3096;
        Fri, 28 Feb 2020 00:58:11 +0000 (UTC)
Received: from EX13D35UWB004.ant.amazon.com (10.43.161.230) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Feb 2020 00:58:11 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D35UWB004.ant.amazon.com (10.43.161.230) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 28 Feb 2020 00:58:11 +0000
Received: from dev-dsk-astroh-2c-c797f0e8.us-west-2.amazon.com (172.22.47.82)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Fri, 28 Feb 2020 00:58:03 +0000
Received: by dev-dsk-astroh-2c-c797f0e8.us-west-2.amazon.com (Postfix, from userid 11196724)
        id 99F8926905; Fri, 28 Feb 2020 00:58:03 +0000 (UTC)
From:   Andy Strohman <astroh@amazon.com>
CC:     <stable@vger.kernel.org>, <davem@davemloft.net>,
        Martynas Pumputis <martynas@weave.works>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Andy Strohman" <astroh@amazon.com>
Subject: [PATCH 4.14] netfilter: nf_conntrack: resolve clash for matching conntracks
Date:   Fri, 28 Feb 2020 00:57:38 +0000
Message-ID: <20200228005738.26667-1-astroh@amazon.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
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
---
 net/netfilter/nf_conntrack_core.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5123e91b1982..4ced7c7102b6 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -632,6 +632,18 @@ nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
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
@@ -825,19 +837,21 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
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
2.16.6

