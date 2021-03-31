Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A5534C6D5
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhC2IKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231706AbhC2IJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4975161601;
        Mon, 29 Mar 2021 08:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005366;
        bh=TP4zeBRUBdIsc+fkyDmprUtkTMUB7ZTuBL/akwnofPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSNHMVv9GaJ5xSAn2sj+sV4Ucs994motYtg+9TyDFKdYsd0j1GaLwRNFE0zhIxv8g
         vivYy0ymkLqISWlHUC+iWNqiar8NCk4zjffqaThWkOXcRTRFNgOjPOmRgQ9l1q1hIJ
         Y/YRXtraM4mimQ4gur5SseHxe6djuQgFvBZv8G2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 56/72] Revert "netfilter: x_tables: Switch synchronization to RCU"
Date:   Mon, 29 Mar 2021 09:58:32 +0200
Message-Id: <20210329075612.126238742@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit d3d40f237480abf3268956daf18cdc56edd32834 ]

This reverts commit cc00bcaa589914096edef7fb87ca5cee4a166b5c.

This (and the preceding) patch basically re-implemented the RCU
mechanisms of patch 784544739a25. That patch was replaced because of the
performance problems that it created when replacing tables. Now, we have
the same issue: the call to synchronize_rcu() makes replacing tables
slower by as much as an order of magnitude.

Prior to using RCU a script calling "iptables" approx. 200 times was
taking 1.16s. With RCU this increased to 11.59s.

Revert these patches and fix the issue in a different way.

Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/x_tables.h |  5 +--
 net/ipv4/netfilter/arp_tables.c    | 14 ++++-----
 net/ipv4/netfilter/ip_tables.c     | 14 ++++-----
 net/ipv6/netfilter/ip6_tables.c    | 14 ++++-----
 net/netfilter/x_tables.c           | 49 +++++++++++++++++++++---------
 5 files changed, 56 insertions(+), 40 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 728d7716bf4f..9077b3ebea08 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -227,7 +227,7 @@ struct xt_table {
 	unsigned int valid_hooks;
 
 	/* Man behind the curtain... */
-	struct xt_table_info __rcu *private;
+	struct xt_table_info *private;
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
@@ -449,9 +449,6 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 
 struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
 
-struct xt_table_info
-*xt_table_get_private_protected(const struct xt_table *table);
-
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index a2cae543a285..b1106d4507fd 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -202,7 +202,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = rcu_access_pointer(table->private);
+	private = READ_ONCE(table->private); /* Address dependency. */
 	cpu     = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct arpt_entry **)private->jumpstack[cpu];
@@ -648,7 +648,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	 * (other than comefrom, which userspace doesn't care
@@ -672,7 +672,7 @@ static int copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct arpt_entry *e;
 	struct xt_counters *counters;
-	struct xt_table_info *private = xt_table_get_private_protected(table);
+	struct xt_table_info *private = table->private;
 	int ret = 0;
 	void *loc_cpu_entry;
 
@@ -807,7 +807,7 @@ static int get_info(struct net *net, void __user *user,
 	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
 	if (!IS_ERR(t)) {
 		struct arpt_getinfo info;
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -860,7 +860,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
@@ -1019,7 +1019,7 @@ static int do_add_counters(struct net *net, const void __user *user,
 	}
 
 	local_bh_disable();
-	private = xt_table_get_private_protected(t);
+	private = t->private;
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
@@ -1356,7 +1356,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 				       void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 6672172a7512..2c1d66bef720 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -261,7 +261,7 @@ ipt_do_table(struct sk_buff *skb,
 	WARN_ON(!(table->valid_hooks & (1 << hook)));
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = rcu_access_pointer(table->private);
+	private = READ_ONCE(table->private); /* Address dependency. */
 	cpu        = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
@@ -794,7 +794,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -818,7 +818,7 @@ copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct ipt_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 	int ret = 0;
 	const void *loc_cpu_entry;
 
@@ -968,7 +968,7 @@ static int get_info(struct net *net, void __user *user,
 	t = xt_request_find_table_lock(net, AF_INET, name);
 	if (!IS_ERR(t)) {
 		struct ipt_getinfo info;
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -1022,7 +1022,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
@@ -1178,7 +1178,7 @@ do_add_counters(struct net *net, const void __user *user,
 	}
 
 	local_bh_disable();
-	private = xt_table_get_private_protected(t);
+	private = t->private;
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
@@ -1573,7 +1573,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 			    void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 3b067d5a62ee..19eb40355dd1 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -283,7 +283,7 @@ ip6t_do_table(struct sk_buff *skb,
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = rcu_access_pointer(table->private);
+	private = READ_ONCE(table->private); /* Address dependency. */
 	cpu        = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct ip6t_entry **)private->jumpstack[cpu];
@@ -810,7 +810,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -834,7 +834,7 @@ copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct ip6t_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 	int ret = 0;
 	const void *loc_cpu_entry;
 
@@ -984,7 +984,7 @@ static int get_info(struct net *net, void __user *user,
 	t = xt_request_find_table_lock(net, AF_INET6, name);
 	if (!IS_ERR(t)) {
 		struct ip6t_getinfo info;
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -1039,7 +1039,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
-		struct xt_table_info *private = xt_table_get_private_protected(t);
+		struct xt_table_info *private = t->private;
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
@@ -1194,7 +1194,7 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 	}
 
 	local_bh_disable();
-	private = xt_table_get_private_protected(t);
+	private = t->private;
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
@@ -1582,7 +1582,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 			    void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 1314de5f317f..8b83806f4f8c 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1356,14 +1356,6 @@ struct xt_counters *xt_counters_alloc(unsigned int counters)
 }
 EXPORT_SYMBOL(xt_counters_alloc);
 
-struct xt_table_info
-*xt_table_get_private_protected(const struct xt_table *table)
-{
-	return rcu_dereference_protected(table->private,
-					 mutex_is_locked(&xt[table->af].mutex));
-}
-EXPORT_SYMBOL(xt_table_get_private_protected);
-
 struct xt_table_info *
 xt_replace_table(struct xt_table *table,
 	      unsigned int num_counters,
@@ -1371,6 +1363,7 @@ xt_replace_table(struct xt_table *table,
 	      int *error)
 {
 	struct xt_table_info *private;
+	unsigned int cpu;
 	int ret;
 
 	ret = xt_jumpstack_alloc(newinfo);
@@ -1380,20 +1373,47 @@ xt_replace_table(struct xt_table *table,
 	}
 
 	/* Do the substitution. */
-	private = xt_table_get_private_protected(table);
+	local_bh_disable();
+	private = table->private;
 
 	/* Check inside lock: is the old number correct? */
 	if (num_counters != private->number) {
 		pr_debug("num_counters != table->private->number (%u/%u)\n",
 			 num_counters, private->number);
+		local_bh_enable();
 		*error = -EAGAIN;
 		return NULL;
 	}
 
 	newinfo->initial_entries = private->initial_entries;
+	/*
+	 * Ensure contents of newinfo are visible before assigning to
+	 * private.
+	 */
+	smp_wmb();
+	table->private = newinfo;
+
+	/* make sure all cpus see new ->private value */
+	smp_wmb();
 
-	rcu_assign_pointer(table->private, newinfo);
-	synchronize_rcu();
+	/*
+	 * Even though table entries have now been swapped, other CPU's
+	 * may still be using the old entries...
+	 */
+	local_bh_enable();
+
+	/* ... so wait for even xt_recseq on all cpus */
+	for_each_possible_cpu(cpu) {
+		seqcount_t *s = &per_cpu(xt_recseq, cpu);
+		u32 seq = raw_read_seqcount(s);
+
+		if (seq & 1) {
+			do {
+				cond_resched();
+				cpu_relax();
+			} while (seq == raw_read_seqcount(s));
+		}
+	}
 
 #ifdef CONFIG_AUDIT
 	if (audit_enabled) {
@@ -1434,12 +1454,12 @@ struct xt_table *xt_register_table(struct net *net,
 	}
 
 	/* Simplifies replace_table code. */
-	rcu_assign_pointer(table->private, bootstrap);
+	table->private = bootstrap;
 
 	if (!xt_replace_table(table, 0, newinfo, &ret))
 		goto unlock;
 
-	private = xt_table_get_private_protected(table);
+	private = table->private;
 	pr_debug("table->private->number = %u\n", private->number);
 
 	/* save number of initial entries */
@@ -1462,8 +1482,7 @@ void *xt_unregister_table(struct xt_table *table)
 	struct xt_table_info *private;
 
 	mutex_lock(&xt[table->af].mutex);
-	private = xt_table_get_private_protected(table);
-	RCU_INIT_POINTER(table->private, NULL);
+	private = table->private;
 	list_del(&table->list);
 	mutex_unlock(&xt[table->af].mutex);
 	kfree(table);
-- 
2.30.1



