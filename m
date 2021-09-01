Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6DB3FDA4F
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244517AbhIAMbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244528AbhIAMbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:31:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 923A661090;
        Wed,  1 Sep 2021 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499413;
        bh=UXnPXI1cTXaNjcJpROv7owWl0W840oE9wPlrQJQJ1R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abeJJyggLif4wE/76Juoest1c7wZI2kmRSmRuGU0L6a8v+k3g68eUOk3TSY59ELK7
         x70wEb/Ae1AWLXQPC9EiShvrn9WE9caV7igx/rF54t5Q4HyzkXEgniZ7nyBNja1Kvw
         BAqcaG4nYBRb4WLm7Hjwri5TwTE0rezzBj9lQ3Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/33] netfilter: conntrack: collect all entries in one cycle
Date:   Wed,  1 Sep 2021 14:27:55 +0200
Message-Id: <20210901122250.993208505@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
References: <20210901122250.752620302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 4608fdfc07e116f9fc0895beb40abad7cdb5ee3d ]

Michal Kubecek reports that conntrack gc is responsible for frequent
wakeups (every 125ms) on idle systems.

On busy systems, timed out entries are evicted during lookup.
The gc worker is only needed to remove entries after system becomes idle
after a busy period.

To resolve this, always scan the entire table.
If the scan is taking too long, reschedule so other work_structs can run
and resume from next bucket.

After a completed scan, wait for 2 minutes before the next cycle.
Heuristics for faster re-schedule are removed.

GC_SCAN_INTERVAL could be exposed as a sysctl in the future to allow
tuning this as-needed or even turn the gc worker off.

Reported-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 71 ++++++++++---------------------
 1 file changed, 22 insertions(+), 49 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c5590d36b775..a38caf317dbb 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -70,10 +70,9 @@ EXPORT_SYMBOL_GPL(nf_conntrack_hash);
 
 struct conntrack_gc_work {
 	struct delayed_work	dwork;
-	u32			last_bucket;
+	u32			next_bucket;
 	bool			exiting;
 	bool			early_drop;
-	long			next_gc_run;
 };
 
 static __read_mostly struct kmem_cache *nf_conntrack_cachep;
@@ -81,12 +80,8 @@ static __read_mostly spinlock_t nf_conntrack_locks_all_lock;
 static __read_mostly DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
 
-/* every gc cycle scans at most 1/GC_MAX_BUCKETS_DIV part of table */
-#define GC_MAX_BUCKETS_DIV	128u
-/* upper bound of full table scan */
-#define GC_MAX_SCAN_JIFFIES	(16u * HZ)
-/* desired ratio of entries found to be expired */
-#define GC_EVICT_RATIO	50u
+#define GC_SCAN_INTERVAL	(120u * HZ)
+#define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 
 static struct conntrack_gc_work conntrack_gc_work;
 
@@ -1198,17 +1193,13 @@ static void nf_ct_offload_timeout(struct nf_conn *ct)
 
 static void gc_worker(struct work_struct *work)
 {
-	unsigned int min_interval = max(HZ / GC_MAX_BUCKETS_DIV, 1u);
-	unsigned int i, goal, buckets = 0, expired_count = 0;
-	unsigned int nf_conntrack_max95 = 0;
+	unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
+	unsigned int i, hashsz, nf_conntrack_max95 = 0;
+	unsigned long next_run = GC_SCAN_INTERVAL;
 	struct conntrack_gc_work *gc_work;
-	unsigned int ratio, scanned = 0;
-	unsigned long next_run;
-
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
-	goal = nf_conntrack_htable_size / GC_MAX_BUCKETS_DIV;
-	i = gc_work->last_bucket;
+	i = gc_work->next_bucket;
 	if (gc_work->early_drop)
 		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
 
@@ -1216,22 +1207,21 @@ static void gc_worker(struct work_struct *work)
 		struct nf_conntrack_tuple_hash *h;
 		struct hlist_nulls_head *ct_hash;
 		struct hlist_nulls_node *n;
-		unsigned int hashsz;
 		struct nf_conn *tmp;
 
-		i++;
 		rcu_read_lock();
 
 		nf_conntrack_get_ht(&ct_hash, &hashsz);
-		if (i >= hashsz)
-			i = 0;
+		if (i >= hashsz) {
+			rcu_read_unlock();
+			break;
+		}
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			struct net *net;
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
-			scanned++;
 			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
 				nf_ct_offload_timeout(tmp);
 				continue;
@@ -1239,7 +1229,6 @@ static void gc_worker(struct work_struct *work)
 
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
-				expired_count++;
 				continue;
 			}
 
@@ -1271,7 +1260,14 @@ static void gc_worker(struct work_struct *work)
 		 */
 		rcu_read_unlock();
 		cond_resched();
-	} while (++buckets < goal);
+		i++;
+
+		if (time_after(jiffies, end_time) && i < hashsz) {
+			gc_work->next_bucket = i;
+			next_run = 0;
+			break;
+		}
+	} while (i < hashsz);
 
 	if (gc_work->exiting)
 		return;
@@ -1282,40 +1278,17 @@ static void gc_worker(struct work_struct *work)
 	 *
 	 * This worker is only here to reap expired entries when system went
 	 * idle after a busy period.
-	 *
-	 * The heuristics below are supposed to balance conflicting goals:
-	 *
-	 * 1. Minimize time until we notice a stale entry
-	 * 2. Maximize scan intervals to not waste cycles
-	 *
-	 * Normally, expire ratio will be close to 0.
-	 *
-	 * As soon as a sizeable fraction of the entries have expired
-	 * increase scan frequency.
 	 */
-	ratio = scanned ? expired_count * 100 / scanned : 0;
-	if (ratio > GC_EVICT_RATIO) {
-		gc_work->next_gc_run = min_interval;
-	} else {
-		unsigned int max = GC_MAX_SCAN_JIFFIES / GC_MAX_BUCKETS_DIV;
-
-		BUILD_BUG_ON((GC_MAX_SCAN_JIFFIES / GC_MAX_BUCKETS_DIV) == 0);
-
-		gc_work->next_gc_run += min_interval;
-		if (gc_work->next_gc_run > max)
-			gc_work->next_gc_run = max;
+	if (next_run) {
+		gc_work->early_drop = false;
+		gc_work->next_bucket = 0;
 	}
-
-	next_run = gc_work->next_gc_run;
-	gc_work->last_bucket = i;
-	gc_work->early_drop = false;
 	queue_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
 }
 
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 {
 	INIT_DEFERRABLE_WORK(&gc_work->dwork, gc_worker);
-	gc_work->next_gc_run = HZ;
 	gc_work->exiting = false;
 }
 
-- 
2.30.2



