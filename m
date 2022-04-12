Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99974FDB07
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351687AbiDLH2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354305AbiDLHRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:17:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB5D4BBA6;
        Mon, 11 Apr 2022 23:58:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F055FB81B4F;
        Tue, 12 Apr 2022 06:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1FDC385A1;
        Tue, 12 Apr 2022 06:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746725;
        bh=V8vgsRr3fQDz1xt+xFEVNrILEov2rb/lBYNY+bveKK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcqmqJmbwiMR1MTJborqNZEtUbszcdOolXNsw4kAHebnLyMkQVjJvzC8F4LL22KYF
         J3pdcxnPY4lrrZnC1FLuZX+fOYR29f5VWAH8ef8UlZrkizr+Hit+rQyXyKmq2n8TMT
         +om6Pd58mmnsl9n+sZY5ww3BDTRy3rnMZwYAIxXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karel Rericha <karel@maxtel.cz>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 107/285] netfilter: conntrack: revisit gc autotuning
Date:   Tue, 12 Apr 2022 08:29:24 +0200
Message-Id: <20220412062946.752383290@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 2cfadb761d3d0219412fd8150faea60c7e863833 ]

as of commit 4608fdfc07e1
("netfilter: conntrack: collect all entries in one cycle")
conntrack gc was changed to run every 2 minutes.

On systems where conntrack hash table is set to large value, most evictions
happen from gc worker rather than the packet path due to hash table
distribution.

This causes netlink event overflows when events are collected.

This change collects average expiry of scanned entries and
reschedules to the average remaining value, within 1 to 60 second interval.

To avoid event overflows, reschedule after each bucket and add a
limit for both run time and number of evictions per run.

If more entries have to be evicted, reschedule and restart 1 jiffy
into the future.

Reported-by: Karel Rericha <karel@maxtel.cz>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 85 ++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 917e708a4561..3a98a1316307 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -66,6 +66,8 @@ EXPORT_SYMBOL_GPL(nf_conntrack_hash);
 struct conntrack_gc_work {
 	struct delayed_work	dwork;
 	u32			next_bucket;
+	u32			avg_timeout;
+	u32			start_time;
 	bool			exiting;
 	bool			early_drop;
 };
@@ -77,8 +79,19 @@ static __read_mostly bool nf_conntrack_locks_all;
 /* serialize hash resizes and nf_ct_iterate_cleanup */
 static DEFINE_MUTEX(nf_conntrack_mutex);
 
-#define GC_SCAN_INTERVAL	(120u * HZ)
+#define GC_SCAN_INTERVAL_MAX	(60ul * HZ)
+#define GC_SCAN_INTERVAL_MIN	(1ul * HZ)
+
+/* clamp timeouts to this value (TCP unacked) */
+#define GC_SCAN_INTERVAL_CLAMP	(300ul * HZ)
+
+/* large initial bias so that we don't scan often just because we have
+ * three entries with a 1s timeout.
+ */
+#define GC_SCAN_INTERVAL_INIT	INT_MAX
+
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
+#define GC_SCAN_EXPIRED_MAX	(64000u / HZ)
 
 #define MIN_CHAINLEN	8u
 #define MAX_CHAINLEN	(32u - MIN_CHAINLEN)
@@ -1420,16 +1433,28 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 
 static void gc_worker(struct work_struct *work)
 {
-	unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
 	unsigned int i, hashsz, nf_conntrack_max95 = 0;
-	unsigned long next_run = GC_SCAN_INTERVAL;
+	u32 end_time, start_time = nfct_time_stamp;
 	struct conntrack_gc_work *gc_work;
+	unsigned int expired_count = 0;
+	unsigned long next_run;
+	s32 delta_time;
+
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
 	i = gc_work->next_bucket;
 	if (gc_work->early_drop)
 		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
 
+	if (i == 0) {
+		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
+		gc_work->start_time = start_time;
+	}
+
+	next_run = gc_work->avg_timeout;
+
+	end_time = start_time + GC_SCAN_MAX_DURATION;
+
 	do {
 		struct nf_conntrack_tuple_hash *h;
 		struct hlist_nulls_head *ct_hash;
@@ -1446,6 +1471,7 @@ static void gc_worker(struct work_struct *work)
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			struct nf_conntrack_net *cnet;
+			unsigned long expires;
 			struct net *net;
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
@@ -1455,11 +1481,29 @@ static void gc_worker(struct work_struct *work)
 				continue;
 			}
 
+			if (expired_count > GC_SCAN_EXPIRED_MAX) {
+				rcu_read_unlock();
+
+				gc_work->next_bucket = i;
+				gc_work->avg_timeout = next_run;
+
+				delta_time = nfct_time_stamp - gc_work->start_time;
+
+				/* re-sched immediately if total cycle time is exceeded */
+				next_run = delta_time < (s32)GC_SCAN_INTERVAL_MAX;
+				goto early_exit;
+			}
+
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
+				expired_count++;
 				continue;
 			}
 
+			expires = clamp(nf_ct_expires(tmp), GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
+			next_run += expires;
+			next_run /= 2u;
+
 			if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
 				continue;
 
@@ -1477,8 +1521,10 @@ static void gc_worker(struct work_struct *work)
 				continue;
 			}
 
-			if (gc_worker_can_early_drop(tmp))
+			if (gc_worker_can_early_drop(tmp)) {
 				nf_ct_kill(tmp);
+				expired_count++;
+			}
 
 			nf_ct_put(tmp);
 		}
@@ -1491,33 +1537,38 @@ static void gc_worker(struct work_struct *work)
 		cond_resched();
 		i++;
 
-		if (time_after(jiffies, end_time) && i < hashsz) {
+		delta_time = nfct_time_stamp - end_time;
+		if (delta_time > 0 && i < hashsz) {
+			gc_work->avg_timeout = next_run;
 			gc_work->next_bucket = i;
 			next_run = 0;
-			break;
+			goto early_exit;
 		}
 	} while (i < hashsz);
 
+	gc_work->next_bucket = 0;
+
+	next_run = clamp(next_run, GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_MAX);
+
+	delta_time = max_t(s32, nfct_time_stamp - gc_work->start_time, 1);
+	if (next_run > (unsigned long)delta_time)
+		next_run -= delta_time;
+	else
+		next_run = 1;
+
+early_exit:
 	if (gc_work->exiting)
 		return;
 
-	/*
-	 * Eviction will normally happen from the packet path, and not
-	 * from this gc worker.
-	 *
-	 * This worker is only here to reap expired entries when system went
-	 * idle after a busy period.
-	 */
-	if (next_run) {
+	if (next_run)
 		gc_work->early_drop = false;
-		gc_work->next_bucket = 0;
-	}
+
 	queue_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
 }
 
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 {
-	INIT_DEFERRABLE_WORK(&gc_work->dwork, gc_worker);
+	INIT_DELAYED_WORK(&gc_work->dwork, gc_worker);
 	gc_work->exiting = false;
 }
 
-- 
2.35.1



