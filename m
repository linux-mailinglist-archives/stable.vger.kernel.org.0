Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FB499D6B
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404012AbfHVRmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403997AbfHVRXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:48 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B357023439;
        Thu, 22 Aug 2019 17:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494626;
        bh=U5olbrDyZc4oqAZsfWavZ8iVGWY73TcxqiHr19V0r5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3vlDajwR7BYroEJ0pCUKOmutJHf20BQcLrxBaZwAgmimap4D+7euVmvz8/6B8t1L
         poMAQefnlswYRM19EIQZ7QVDm7X/OCu3n+VF5ELh1tAPx3aBLpIMZWllF+opEeAaqb
         X8YwFvWV4Q3R5d13A+ugEFYVSb+ckDUSIM9m3LHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 057/103] netfilter: ctnetlink: dont use conntrack/expect object addresses as id
Date:   Thu, 22 Aug 2019 10:18:45 -0700
Message-Id: <20190822171731.096825895@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 3c79107631db1f7fd32cf3f7368e4672004a3010 upstream.

else, we leak the addresses to userspace via ctnetlink events
and dumps.

Compute an ID on demand based on the immutable parts of nf_conn struct.

Another advantage compared to using an address is that there is no
immediate re-use of the same ID in case the conntrack entry is freed and
reallocated again immediately.

Fixes: 3583240249ef ("[NETFILTER]: nf_conntrack_expect: kill unique ID")
Fixes: 7f85f914721f ("[NETFILTER]: nf_conntrack: kill unique ID")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_conntrack.h |    2 ++
 net/netfilter/nf_conntrack_core.c    |   35 +++++++++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c |   34 +++++++++++++++++++++++++++++-----
 3 files changed, 66 insertions(+), 5 deletions(-)

--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -336,6 +336,8 @@ struct nf_conn *nf_ct_tmpl_alloc(struct
 				 gfp_t flags);
 void nf_ct_tmpl_free(struct nf_conn *tmpl);
 
+u32 nf_ct_get_id(const struct nf_conn *ct);
+
 #define NF_CT_STAT_INC(net, count)	  __this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_INC_ATOMIC(net, count) this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_ADD_ATOMIC(net, count, v) this_cpu_add((net)->ct.stat->count, (v))
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <linux/err.h>
 #include <linux/percpu.h>
 #include <linux/moduleparam.h>
@@ -301,6 +302,40 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 }
 EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
 
+/* Generate a almost-unique pseudo-id for a given conntrack.
+ *
+ * intentionally doesn't re-use any of the seeds used for hash
+ * table location, we assume id gets exposed to userspace.
+ *
+ * Following nf_conn items do not change throughout lifetime
+ * of the nf_conn after it has been committed to main hash table:
+ *
+ * 1. nf_conn address
+ * 2. nf_conn->ext address
+ * 3. nf_conn->master address (normally NULL)
+ * 4. tuple
+ * 5. the associated net namespace
+ */
+u32 nf_ct_get_id(const struct nf_conn *ct)
+{
+	static __read_mostly siphash_key_t ct_id_seed;
+	unsigned long a, b, c, d;
+
+	net_get_random_once(&ct_id_seed, sizeof(ct_id_seed));
+
+	a = (unsigned long)ct;
+	b = (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
+	c = (unsigned long)ct->ext;
+	d = (unsigned long)siphash(&ct->tuplehash, sizeof(ct->tuplehash),
+				   &ct_id_seed);
+#ifdef CONFIG_64BIT
+	return siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &ct_id_seed);
+#else
+	return siphash_4u32((u32)a, (u32)b, (u32)c, (u32)d, &ct_id_seed);
+#endif
+}
+EXPORT_SYMBOL_GPL(nf_ct_get_id);
+
 static void
 clean_from_lists(struct nf_conn *ct)
 {
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/siphash.h>
 
 #include <linux/netfilter.h>
 #include <net/netlink.h>
@@ -441,7 +442,9 @@ static int ctnetlink_dump_ct_seq_adj(str
 
 static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	if (nla_put_be32(skb, CTA_ID, htonl((unsigned long)ct)))
+	__be32 id = (__force __be32)nf_ct_get_id(ct);
+
+	if (nla_put_be32(skb, CTA_ID, id))
 		goto nla_put_failure;
 	return 0;
 
@@ -1166,8 +1169,9 @@ static int ctnetlink_del_conntrack(struc
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	if (cda[CTA_ID]) {
-		u_int32_t id = ntohl(nla_get_be32(cda[CTA_ID]));
-		if (id != (u32)(unsigned long)ct) {
+		__be32 id = nla_get_be32(cda[CTA_ID]);
+
+		if (id != (__force __be32)nf_ct_get_id(ct)) {
 			nf_ct_put(ct);
 			return -ENOENT;
 		}
@@ -2472,6 +2476,25 @@ nla_put_failure:
 
 static const union nf_inet_addr any_addr;
 
+static __be32 nf_expect_get_id(const struct nf_conntrack_expect *exp)
+{
+	static __read_mostly siphash_key_t exp_id_seed;
+	unsigned long a, b, c, d;
+
+	net_get_random_once(&exp_id_seed, sizeof(exp_id_seed));
+
+	a = (unsigned long)exp;
+	b = (unsigned long)exp->helper;
+	c = (unsigned long)exp->master;
+	d = (unsigned long)siphash(&exp->tuple, sizeof(exp->tuple), &exp_id_seed);
+
+#ifdef CONFIG_64BIT
+	return (__force __be32)siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &exp_id_seed);
+#else
+	return (__force __be32)siphash_4u32((u32)a, (u32)b, (u32)c, (u32)d, &exp_id_seed);
+#endif
+}
+
 static int
 ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
@@ -2519,7 +2542,7 @@ ctnetlink_exp_dump_expect(struct sk_buff
 	}
 #endif
 	if (nla_put_be32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout)) ||
-	    nla_put_be32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp)) ||
+	    nla_put_be32(skb, CTA_EXPECT_ID, nf_expect_get_id(exp)) ||
 	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
@@ -2818,7 +2841,8 @@ static int ctnetlink_get_expect(struct n
 
 	if (cda[CTA_EXPECT_ID]) {
 		__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
-		if (ntohl(id) != (u32)(unsigned long)exp) {
+
+		if (id != nf_expect_get_id(exp)) {
 			nf_ct_expect_put(exp);
 			return -ENOENT;
 		}


