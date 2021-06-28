Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADBF3B60E3
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhF1ObJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234584AbhF1OaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B042861CAD;
        Mon, 28 Jun 2021 14:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890387;
        bh=kEjQhyakOeG6R+mHasGBuiAVWZ8Rwq018d2V1xbB4Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esvHIcNlTRML9i1fdfewPnQHOc6AJVPxBadfdcWRGif3XblJsEm1cVLNJ/+5BIwxb
         v7gqEhGTTSpXODgQDmdpSKzxpi6vSjQWrQiZ+mDMxNRPBPYGOSnXxycumcIik+XRrp
         hSv4loFVCPVibj7SBwmCfRivcCxcLatXoCwEust8ajriDirNQZhfPh4HnY/T/SDL4E
         dWu+ThAsBcMUGBikGM6P1EBO2R8YKjgbjRmCKtItQy6xT4bb5ToKUwat3v7TVO+wyJ
         k9umaYWJIWMG72j7pPOB4Ko3wd1JEhYlXrt9ofKpS/srxR+phClHbbrClX6SbV2SjS
         W4Nwz+tezepzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/101] perf/x86/lbr: Remove cpuc->lbr_xsave allocation from atomic context
Date:   Mon, 28 Jun 2021 10:24:46 -0400
Message-Id: <20210628142607.32218-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

[ Upstream commit 488e13a489e9707a7e81e1991fdd1f20c0f04689 ]

If the kernel is compiled with the CONFIG_LOCKDEP option, the conditional
might_sleep_if() deep in kmem_cache_alloc() will generate the following
trace, and potentially cause a deadlock when another LBR event is added:

  [] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:196
  [] Call Trace:
  []  kmem_cache_alloc+0x36/0x250
  []  intel_pmu_lbr_add+0x152/0x170
  []  x86_pmu_add+0x83/0xd0

Make it symmetric with the release_lbr_buffers() call and mirror the
existing DS buffers.

Fixes: c085fb8774 ("perf/x86/intel/lbr: Support XSAVES for arch LBR read")
Signed-off-by: Like Xu <like.xu@linux.intel.com>
[peterz: simplified]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lkml.kernel.org/r/20210430052247.3079672-2-like.xu@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c       |  6 ++++--
 arch/x86/events/intel/lbr.c  | 26 ++++++++++++++++++++------
 arch/x86/events/perf_event.h |  6 ++++++
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index a88c94d65693..b7f8ed87bfbc 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -372,10 +372,12 @@ int x86_reserve_hardware(void)
 	if (!atomic_inc_not_zero(&pmc_refcount)) {
 		mutex_lock(&pmc_reserve_mutex);
 		if (atomic_read(&pmc_refcount) == 0) {
-			if (!reserve_pmc_hardware())
+			if (!reserve_pmc_hardware()) {
 				err = -EBUSY;
-			else
+			} else {
 				reserve_ds_buffers();
+				reserve_lbr_buffers();
+			}
 		}
 		if (!err)
 			atomic_inc(&pmc_refcount);
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index e2b0efcba101..6c1231837382 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -658,7 +658,6 @@ static inline bool branch_user_callstack(unsigned br_sel)
 
 void intel_pmu_lbr_add(struct perf_event *event)
 {
-	struct kmem_cache *kmem_cache = event->pmu->task_ctx_cache;
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (!x86_pmu.lbr_nr)
@@ -696,11 +695,6 @@ void intel_pmu_lbr_add(struct perf_event *event)
 	perf_sched_cb_inc(event->ctx->pmu);
 	if (!cpuc->lbr_users++ && !event->total_time_running)
 		intel_pmu_lbr_reset();
-
-	if (static_cpu_has(X86_FEATURE_ARCH_LBR) &&
-	    kmem_cache && !cpuc->lbr_xsave &&
-	    (cpuc->lbr_users != cpuc->lbr_pebs_users))
-		cpuc->lbr_xsave = kmem_cache_alloc(kmem_cache, GFP_KERNEL);
 }
 
 void release_lbr_buffers(void)
@@ -721,6 +715,26 @@ void release_lbr_buffers(void)
 	}
 }
 
+void reserve_lbr_buffers(void)
+{
+	struct kmem_cache *kmem_cache;
+	struct cpu_hw_events *cpuc;
+	int cpu;
+
+	if (!static_cpu_has(X86_FEATURE_ARCH_LBR))
+		return;
+
+	for_each_possible_cpu(cpu) {
+		cpuc = per_cpu_ptr(&cpu_hw_events, cpu);
+		kmem_cache = x86_get_pmu(cpu)->task_ctx_cache;
+		if (!kmem_cache || cpuc->lbr_xsave)
+			continue;
+
+		cpuc->lbr_xsave = kmem_cache_alloc_node(kmem_cache, GFP_KERNEL,
+							cpu_to_node(cpu));
+	}
+}
+
 void intel_pmu_lbr_del(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 6a8edfe59b09..d4f2ea2d9a9e 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1122,6 +1122,8 @@ void reserve_ds_buffers(void);
 
 void release_lbr_buffers(void);
 
+void reserve_lbr_buffers(void);
+
 extern struct event_constraint bts_constraint;
 extern struct event_constraint vlbr_constraint;
 
@@ -1267,6 +1269,10 @@ static inline void release_lbr_buffers(void)
 {
 }
 
+static inline void reserve_lbr_buffers(void)
+{
+}
+
 static inline int intel_pmu_init(void)
 {
 	return 0;
-- 
2.30.2

