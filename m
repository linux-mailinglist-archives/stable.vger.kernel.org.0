Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF53615911
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiKBDEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiKBDDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:03:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D2F23173
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:03:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8A96617BC
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B25BC433D6;
        Wed,  2 Nov 2022 03:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358227;
        bh=3Nf7en4LjVRsNB7DRuO87tZ/Uzoqchv8KOZdkoQ5zc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiS4eFu1SRlz0twoQilATErcrRCwAyLkhBnHsRLW+YNL6ychUUQhhzpbpB8cjP3eo
         XQw0QIWb6IO3r2d7udSZa8UPCBM8BfnxLWWk4dLMuXEHj4B8rl/xZmCbA1WXEK2Nsd
         iYdNpAaI7JeDldyBrMou0k8i+3Xwu8TSpzJitcXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lin Shengwang <linshengwang1@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/132] sched/core: Fix comparison in sched_group_cookie_match()
Date:   Wed,  2 Nov 2022 03:32:48 +0100
Message-Id: <20221102022101.237638455@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Shengwang <linshengwang1@huawei.com>

[ Upstream commit e705968dd687574b6ca3ebe772683d5642759132 ]

In commit 97886d9dcd86 ("sched: Migration changes for core scheduling"),
sched_group_cookie_match() was added to help determine if a cookie
matches the core state.

However, while it iterates the SMT group, it fails to actually use the
RQ for each of the CPUs iterated, use cpu_rq(cpu) instead of rq to fix
things.

Fixes: 97886d9dcd86 ("sched: Migration changes for core scheduling")
Signed-off-by: Lin Shengwang <linshengwang1@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20221008022709.642-1-linshengwang1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/sched.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e49902898253..7a3fcd70aa86 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1148,6 +1148,14 @@ static inline bool is_migration_disabled(struct task_struct *p)
 #endif
 }
 
+DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
+
+#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
+#define this_rq()		this_cpu_ptr(&runqueues)
+#define task_rq(p)		cpu_rq(task_cpu(p))
+#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
+#define raw_rq()		raw_cpu_ptr(&runqueues)
+
 struct sched_group;
 #ifdef CONFIG_SCHED_CORE
 static inline struct cpumask *sched_group_span(struct sched_group *sg);
@@ -1235,7 +1243,7 @@ static inline bool sched_group_cookie_match(struct rq *rq,
 		return true;
 
 	for_each_cpu_and(cpu, sched_group_span(group), p->cpus_ptr) {
-		if (sched_core_cookie_match(rq, p))
+		if (sched_core_cookie_match(cpu_rq(cpu), p))
 			return true;
 	}
 	return false;
@@ -1361,14 +1369,6 @@ static inline void update_idle_core(struct rq *rq)
 static inline void update_idle_core(struct rq *rq) { }
 #endif
 
-DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
-
-#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
-#define this_rq()		this_cpu_ptr(&runqueues)
-#define task_rq(p)		cpu_rq(task_cpu(p))
-#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
-#define raw_rq()		raw_cpu_ptr(&runqueues)
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static inline struct task_struct *task_of(struct sched_entity *se)
 {
-- 
2.35.1



