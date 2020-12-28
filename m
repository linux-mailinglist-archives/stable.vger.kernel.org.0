Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88A02E6645
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393335AbgL1QLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:11:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731708AbgL1NW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:22:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6837B22A84;
        Mon, 28 Dec 2020 13:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161735;
        bh=YxORaY4z6FyKFZTb49FBxvg4ROEFYfs0Rkv7POCaFHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fuMtfnGat8jWG8nLSI/o+AyVyJhNqhbk2tUkWvpMpbATcPcF+/FIdaWwg5SsNyMaM
         +R2MRmTPvh57J22rYwBCiq1aspr+/dTSJduDEHipGIgij1iPD4mIV+oHLXAj33bgYJ
         3B0e1080dtpEBKdU+lD8QXLP3q+BfBhGnM9pxxk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        kernel test robot <lkp@intel.com>,
        Florian Westphal <fw@strlen.de>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/346] netfilter: x_tables: Switch synchronization to RCU
Date:   Mon, 28 Dec 2020 13:46:23 +0100
Message-Id: <20201228124922.892081731@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

[ Upstream commit cc00bcaa589914096edef7fb87ca5cee4a166b5c ]

When running concurrent iptables rules replacement with data, the per CPU
sequence count is checked after the assignment of the new information.
The sequence count is used to synchronize with the packet path without the
use of any explicit locking. If there are any packets in the packet path using
the table information, the sequence count is incremented to an odd value and
is incremented to an even after the packet process completion.

The new table value assignment is followed by a write memory barrier so every
CPU should see the latest value. If the packet path has started with the old
table information, the sequence counter will be odd and the iptables
replacement will wait till the sequence count is even prior to freeing the
old table info.

However, this assumes that the new table information assignment and the memory
barrier is actually executed prior to the counter check in the replacement
thread. If CPU decides to execute the assignment later as there is no user of
the table information prior to the sequence check, the packet path in another
CPU may use the old table information. The replacement thread would then free
the table information under it leading to a use after free in the packet
processing context-

Unable to handle kernel NULL pointer dereference at virtual
address 000000000000008e
pc : ip6t_do_table+0x5d0/0x89c
lr : ip6t_do_table+0x5b8/0x89c
ip6t_do_table+0x5d0/0x89c
ip6table_filter_hook+0x24/0x30
nf_hook_slow+0x84/0x120
ip6_input+0x74/0xe0
ip6_rcv_finish+0x7c/0x128
ipv6_rcv+0xac/0xe4
__netif_receive_skb+0x84/0x17c
process_backlog+0x15c/0x1b8
napi_poll+0x88/0x284
net_rx_action+0xbc/0x23c
__do_softirq+0x20c/0x48c

This could be fixed by forcing instruction order after the new table
information assignment or by switching to RCU for the synchronization.

Fixes: 80055dab5de0 ("netfilter: x_tables: make xt_replace_table wait until old rules are not used anymore")
Reported-by: Sean Tranchetti <stranche@codeaurora.org>
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/x_tables.h |  5 ++-
 net/ipv4/netfilter/arp_tables.c    | 14 ++++-----
 net/ipv4/netfilter/ip_tables.c     | 14 ++++-----
 net/ipv6/netfilter/ip6_tables.c    | 14 ++++-----
 net/netfilter/x_tables.c           | 49 +++++++++---------------------
 5 files changed, 40 insertions(+), 56 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 9077b3ebea08c..728d7716bf4f4 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -227,7 +227,7 @@ struct xt_table {
 	unsigned int valid_hooks;
 
 	/* Man behind the curtain... */
-	struct xt_table_info *private;
+	struct xt_table_info __rcu *private;
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
@@ -449,6 +449,9 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 
 struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
 
+struct xt_table_info
+*xt_table_get_private_protected(const struct xt_table *table);
+
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 10d8f95eb7712..ca20efe775ee4 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -202,7 +202,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = READ_ONCE(table->private); /* Address dependency. */
+	private = rcu_access_pointer(table->private);
 	cpu     = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct arpt_entry **)private->jumpstack[cpu];
@@ -648,7 +648,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	 * (other than comefrom, which userspace doesn't care
@@ -672,7 +672,7 @@ static int copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct arpt_entry *e;
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	struct xt_table_info *private = xt_table_get_private_protected(table);
 	int ret = 0;
 	void *loc_cpu_entry;
 
@@ -807,7 +807,7 @@ static int get_info(struct net *net, void __user *user,
 	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
 	if (!IS_ERR(t)) {
 		struct arpt_getinfo info;
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -860,7 +860,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
@@ -1019,7 +1019,7 @@ static int do_add_counters(struct net *net, const void __user *user,
 	}
 
 	local_bh_disable();
-	private = t->private;
+	private = xt_table_get_private_protected(t);
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
@@ -1356,7 +1356,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 				       void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index e77872c93c206..115d48049686f 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -261,7 +261,7 @@ ipt_do_table(struct sk_buff *skb,
 	WARN_ON(!(table->valid_hooks & (1 << hook)));
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = READ_ONCE(table->private); /* Address dependency. */
+	private = rcu_access_pointer(table->private);
 	cpu        = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
@@ -794,7 +794,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -818,7 +818,7 @@ copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct ipt_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	int ret = 0;
 	const void *loc_cpu_entry;
 
@@ -968,7 +968,7 @@ static int get_info(struct net *net, void __user *user,
 	t = xt_request_find_table_lock(net, AF_INET, name);
 	if (!IS_ERR(t)) {
 		struct ipt_getinfo info;
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -1022,7 +1022,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
@@ -1178,7 +1178,7 @@ do_add_counters(struct net *net, const void __user *user,
 	}
 
 	local_bh_disable();
-	private = t->private;
+	private = xt_table_get_private_protected(t);
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
@@ -1573,7 +1573,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 			    void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index daf2e9e9193d1..b1441349e1517 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -283,7 +283,7 @@ ip6t_do_table(struct sk_buff *skb,
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = READ_ONCE(table->private); /* Address dependency. */
+	private = rcu_access_pointer(table->private);
 	cpu        = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct ip6t_entry **)private->jumpstack[cpu];
@@ -810,7 +810,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -834,7 +834,7 @@ copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct ip6t_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	int ret = 0;
 	const void *loc_cpu_entry;
 
@@ -984,7 +984,7 @@ static int get_info(struct net *net, void __user *user,
 	t = xt_request_find_table_lock(net, AF_INET6, name);
 	if (!IS_ERR(t)) {
 		struct ip6t_getinfo info;
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -1039,7 +1039,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
+		struct xt_table_info *private = xt_table_get_private_protected(t);
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
@@ -1194,7 +1194,7 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 	}
 
 	local_bh_disable();
-	private = t->private;
+	private = xt_table_get_private_protected(t);
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
@@ -1582,7 +1582,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 			    void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 3bab89dbc3717..6a7d0303d058f 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1354,6 +1354,14 @@ struct xt_counters *xt_counters_alloc(unsigned int counters)
 }
 EXPORT_SYMBOL(xt_counters_alloc);
 
+struct xt_table_info
+*xt_table_get_private_protected(const struct xt_table *table)
+{
+	return rcu_dereference_protected(table->private,
+					 mutex_is_locked(&xt[table->af].mutex));
+}
+EXPORT_SYMBOL(xt_table_get_private_protected);
+
 struct xt_table_info *
 xt_replace_table(struct xt_table *table,
 	      unsigned int num_counters,
@@ -1361,7 +1369,6 @@ xt_replace_table(struct xt_table *table,
 	      int *error)
 {
 	struct xt_table_info *private;
-	unsigned int cpu;
 	int ret;
 
 	ret = xt_jumpstack_alloc(newinfo);
@@ -1371,47 +1378,20 @@ xt_replace_table(struct xt_table *table,
 	}
 
 	/* Do the substitution. */
-	local_bh_disable();
-	private = table->private;
+	private = xt_table_get_private_protected(table);
 
 	/* Check inside lock: is the old number correct? */
 	if (num_counters != private->number) {
 		pr_debug("num_counters != table->private->number (%u/%u)\n",
 			 num_counters, private->number);
-		local_bh_enable();
 		*error = -EAGAIN;
 		return NULL;
 	}
 
 	newinfo->initial_entries = private->initial_entries;
-	/*
-	 * Ensure contents of newinfo are visible before assigning to
-	 * private.
-	 */
-	smp_wmb();
-	table->private = newinfo;
-
-	/* make sure all cpus see new ->private value */
-	smp_wmb();
 
-	/*
-	 * Even though table entries have now been swapped, other CPU's
-	 * may still be using the old entries...
-	 */
-	local_bh_enable();
-
-	/* ... so wait for even xt_recseq on all cpus */
-	for_each_possible_cpu(cpu) {
-		seqcount_t *s = &per_cpu(xt_recseq, cpu);
-		u32 seq = raw_read_seqcount(s);
-
-		if (seq & 1) {
-			do {
-				cond_resched();
-				cpu_relax();
-			} while (seq == raw_read_seqcount(s));
-		}
-	}
+	rcu_assign_pointer(table->private, newinfo);
+	synchronize_rcu();
 
 #ifdef CONFIG_AUDIT
 	if (audit_enabled) {
@@ -1452,12 +1432,12 @@ struct xt_table *xt_register_table(struct net *net,
 	}
 
 	/* Simplifies replace_table code. */
-	table->private = bootstrap;
+	rcu_assign_pointer(table->private, bootstrap);
 
 	if (!xt_replace_table(table, 0, newinfo, &ret))
 		goto unlock;
 
-	private = table->private;
+	private = xt_table_get_private_protected(table);
 	pr_debug("table->private->number = %u\n", private->number);
 
 	/* save number of initial entries */
@@ -1480,7 +1460,8 @@ void *xt_unregister_table(struct xt_table *table)
 	struct xt_table_info *private;
 
 	mutex_lock(&xt[table->af].mutex);
-	private = table->private;
+	private = xt_table_get_private_protected(table);
+	RCU_INIT_POINTER(table->private, NULL);
 	list_del(&table->list);
 	mutex_unlock(&xt[table->af].mutex);
 	kfree(table);
-- 
2.27.0



