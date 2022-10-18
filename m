Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9507601F76
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiJRAUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiJRASL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:18:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B745B237DF;
        Mon, 17 Oct 2022 17:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC0DD61311;
        Tue, 18 Oct 2022 00:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518C7C433C1;
        Tue, 18 Oct 2022 00:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051789;
        bh=Jyxtq4vMlBtr10QEYyOTMFb/lSjaINEiuYWzhmc+rHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+0tY4qNwoubrxXEQvSDfA9OZ2ufSvxk9a+vX+BqNK1Ix8qjjQaFbxJNKJ0aW5rVx
         iAPNsNJXcwpI6eiO8SFKRBWsUkwuXXPxIJwm+mgJX0MQSi6vh5aEIssStKZgxE86PN
         aXTJ7VnHewbGq0GCc5GX/Qo+pMj8ZkjCzwh1ZCQvMmfa14q8tN0Lrt6th7XloNyTIT
         +WCamEi54uyCHd/4zSIUaa6VQLXVI/hA3Rb4GTHQd76MSeoBl1YE9QMmU5OPeeB3qV
         shTX6t2NY3oelkJS0ox5roEiliUBhpmTuhS9ybu8luFm/O/GCy5ioss/cmebXVz370
         GPvNt+55VNjng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ian Rogers <irogers@google.com>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 04/21] powerpc/hw_breakpoint: Avoid relying on caller synchronization
Date:   Mon, 17 Oct 2022 20:09:23 -0400
Message-Id: <20221018000940.2731329-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000940.2731329-1-sashal@kernel.org>
References: <20221018000940.2731329-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit f95e5a3d59011eec1257d0e76de1e1f8969d426f ]

Internal data structures (cpu_bps, task_bps) of powerpc's hw_breakpoint
implementation have relied on nr_bp_mutex serializing access to them.

Before overhauling synchronization of kernel/events/hw_breakpoint.c,
introduce 2 spinlocks to synchronize cpu_bps and task_bps respectively,
thus avoiding reliance on callers synchronizing powerpc's hw_breakpoint.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20220829124719.675715-10-elver@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/hw_breakpoint.c | 53 ++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index 91a3be14808b..4d99c6523b6d 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
+#include <linux/spinlock.h>
 #include <linux/debugfs.h>
 #include <linux/init.h>
 
@@ -129,7 +130,14 @@ struct breakpoint {
 	bool ptrace_bp;
 };
 
+/*
+ * While kernel/events/hw_breakpoint.c does its own synchronization, we cannot
+ * rely on it safely synchronizing internals here; however, we can rely on it
+ * not requesting more breakpoints than available.
+ */
+static DEFINE_SPINLOCK(cpu_bps_lock);
 static DEFINE_PER_CPU(struct breakpoint *, cpu_bps[HBP_NUM_MAX]);
+static DEFINE_SPINLOCK(task_bps_lock);
 static LIST_HEAD(task_bps);
 
 static struct breakpoint *alloc_breakpoint(struct perf_event *bp)
@@ -174,7 +182,9 @@ static int task_bps_add(struct perf_event *bp)
 	if (IS_ERR(tmp))
 		return PTR_ERR(tmp);
 
+	spin_lock(&task_bps_lock);
 	list_add(&tmp->list, &task_bps);
+	spin_unlock(&task_bps_lock);
 	return 0;
 }
 
@@ -182,6 +192,7 @@ static void task_bps_remove(struct perf_event *bp)
 {
 	struct list_head *pos, *q;
 
+	spin_lock(&task_bps_lock);
 	list_for_each_safe(pos, q, &task_bps) {
 		struct breakpoint *tmp = list_entry(pos, struct breakpoint, list);
 
@@ -191,6 +202,7 @@ static void task_bps_remove(struct perf_event *bp)
 			break;
 		}
 	}
+	spin_unlock(&task_bps_lock);
 }
 
 /*
@@ -200,12 +212,17 @@ static void task_bps_remove(struct perf_event *bp)
 static bool all_task_bps_check(struct perf_event *bp)
 {
 	struct breakpoint *tmp;
+	bool ret = false;
 
+	spin_lock(&task_bps_lock);
 	list_for_each_entry(tmp, &task_bps, list) {
-		if (!can_co_exist(tmp, bp))
-			return true;
+		if (!can_co_exist(tmp, bp)) {
+			ret = true;
+			break;
+		}
 	}
-	return false;
+	spin_unlock(&task_bps_lock);
+	return ret;
 }
 
 /*
@@ -215,13 +232,18 @@ static bool all_task_bps_check(struct perf_event *bp)
 static bool same_task_bps_check(struct perf_event *bp)
 {
 	struct breakpoint *tmp;
+	bool ret = false;
 
+	spin_lock(&task_bps_lock);
 	list_for_each_entry(tmp, &task_bps, list) {
 		if (tmp->bp->hw.target == bp->hw.target &&
-		    !can_co_exist(tmp, bp))
-			return true;
+		    !can_co_exist(tmp, bp)) {
+			ret = true;
+			break;
+		}
 	}
-	return false;
+	spin_unlock(&task_bps_lock);
+	return ret;
 }
 
 static int cpu_bps_add(struct perf_event *bp)
@@ -234,6 +256,7 @@ static int cpu_bps_add(struct perf_event *bp)
 	if (IS_ERR(tmp))
 		return PTR_ERR(tmp);
 
+	spin_lock(&cpu_bps_lock);
 	cpu_bp = per_cpu_ptr(cpu_bps, bp->cpu);
 	for (i = 0; i < nr_wp_slots(); i++) {
 		if (!cpu_bp[i]) {
@@ -241,6 +264,7 @@ static int cpu_bps_add(struct perf_event *bp)
 			break;
 		}
 	}
+	spin_unlock(&cpu_bps_lock);
 	return 0;
 }
 
@@ -249,6 +273,7 @@ static void cpu_bps_remove(struct perf_event *bp)
 	struct breakpoint **cpu_bp;
 	int i = 0;
 
+	spin_lock(&cpu_bps_lock);
 	cpu_bp = per_cpu_ptr(cpu_bps, bp->cpu);
 	for (i = 0; i < nr_wp_slots(); i++) {
 		if (!cpu_bp[i])
@@ -260,19 +285,25 @@ static void cpu_bps_remove(struct perf_event *bp)
 			break;
 		}
 	}
+	spin_unlock(&cpu_bps_lock);
 }
 
 static bool cpu_bps_check(int cpu, struct perf_event *bp)
 {
 	struct breakpoint **cpu_bp;
+	bool ret = false;
 	int i;
 
+	spin_lock(&cpu_bps_lock);
 	cpu_bp = per_cpu_ptr(cpu_bps, cpu);
 	for (i = 0; i < nr_wp_slots(); i++) {
-		if (cpu_bp[i] && !can_co_exist(cpu_bp[i], bp))
-			return true;
+		if (cpu_bp[i] && !can_co_exist(cpu_bp[i], bp)) {
+			ret = true;
+			break;
+		}
 	}
-	return false;
+	spin_unlock(&cpu_bps_lock);
+	return ret;
 }
 
 static bool all_cpu_bps_check(struct perf_event *bp)
@@ -286,10 +317,6 @@ static bool all_cpu_bps_check(struct perf_event *bp)
 	return false;
 }
 
-/*
- * We don't use any locks to serialize accesses to cpu_bps or task_bps
- * because are already inside nr_bp_mutex.
- */
 int arch_reserve_bp_slot(struct perf_event *bp)
 {
 	int ret;
-- 
2.35.1

