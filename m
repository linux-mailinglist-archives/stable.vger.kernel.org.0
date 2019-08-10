Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73DC988DE1
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfHJUuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:50:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54524 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726728AbfHJUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDS-00053p-B5; Sat, 10 Aug 2019 21:43:54 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-0003mL-FY; Sat, 10 Aug 2019 21:43:51 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.582907231@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 156/157] netfilter: ctnetlink: don't use
 conntrack/expect object addresses as id
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16:
 - Include <net/netns/hash.h> in nf_conntrack_core.c
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -289,6 +289,8 @@ void init_nf_conntrack_hash_rnd(void);
 
 void nf_conntrack_tmpl_insert(struct net *net, struct nf_conn *tmpl);
 
+u32 nf_ct_get_id(const struct nf_conn *ct);
+
 #define NF_CT_STAT_INC(net, count)	  __this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_INC_ATOMIC(net, count) this_cpu_inc((net)->ct.stat->count)
 
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <linux/err.h>
 #include <linux/percpu.h>
 #include <linux/moduleparam.h>
@@ -52,6 +53,7 @@
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_helper.h>
+#include <net/netns/hash.h>
 
 #define NF_CONNTRACK_VERSION	"0.5.0"
 
@@ -232,6 +234,40 @@ nf_ct_invert_tuple(struct nf_conntrack_t
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
@@ -435,7 +436,9 @@ ctnetlink_dump_ct_seq_adj(struct sk_buff
 static inline int
 ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	if (nla_put_be32(skb, CTA_ID, htonl((unsigned long)ct)))
+	__be32 id = (__force __be32)nf_ct_get_id(ct);
+
+	if (nla_put_be32(skb, CTA_ID, id))
 		goto nla_put_failure;
 	return 0;
 
@@ -1047,8 +1050,9 @@ ctnetlink_del_conntrack(struct sock *ctn
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
@@ -2321,6 +2325,25 @@ nla_put_failure:
 
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
@@ -2368,7 +2391,7 @@ ctnetlink_exp_dump_expect(struct sk_buff
 	}
 #endif
 	if (nla_put_be32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout)) ||
-	    nla_put_be32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp)) ||
+	    nla_put_be32(skb, CTA_EXPECT_ID, nf_expect_get_id(exp)) ||
 	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
@@ -2664,7 +2687,8 @@ ctnetlink_get_expect(struct sock *ctnl,
 
 	if (cda[CTA_EXPECT_ID]) {
 		__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
-		if (ntohl(id) != (u32)(unsigned long)exp) {
+
+		if (id != nf_expect_get_id(exp)) {
 			nf_ct_expect_put(exp);
 			return -ENOENT;
 		}

