Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758406548B6
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 23:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiLVWug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 17:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiLVWuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 17:50:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AEF165B1
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 14:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671749390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SQesEpyQ/TOk4+yr8stV7fGWHioPa/8NhDL6gLzIvW8=;
        b=MolBnysCn/Z8NKLdlXuUycqBN7pefKrb3fya1LgMrVM7HSJikHy3KM5aozOhronKhfuNT4
        5yXIf1x0QY6ZiQ9M6paXFc3ju69Cnl+q4nEuHP8n67JdgUavCU3TCdJqwI+6R2JTX/tYkM
        Ie0wpXpZP7Z14EWFkJJ+qPjOHRTw3Xc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-lk5-c_k8MmqsXrdt5CaqTQ-1; Thu, 22 Dec 2022 17:49:46 -0500
X-MC-Unique: lk5-c_k8MmqsXrdt5CaqTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3714A101A55E;
        Thu, 22 Dec 2022 22:49:46 +0000 (UTC)
Received: from llong.com (unknown [10.22.32.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CEFB51EF;
        Thu, 22 Dec 2022 22:49:45 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>
Cc:     Phil Auld <pauld@redhat.com>,
        Wenjie Li <wenjieli@qti.qualcomm.com>,
        =?UTF-8?q?David=20Wang=20=E7=8E=8B=E6=A0=87?= 
        <wangbiao3@xiaomi.com>, Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        Waiman Long <longman@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v4 1/2] sched: Fix use-after-free bug in dup_user_cpus_ptr()
Date:   Thu, 22 Dec 2022 17:49:36 -0500
Message-Id: <20221222224937.21028-2-longman@redhat.com>
In-Reply-To: <20221222224937.21028-1-longman@redhat.com>
References: <20221222224937.21028-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
restricted on asymmetric systems"), the setting and clearing of
user_cpus_ptr are done under pi_lock for arm64 architecture. However,
dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
protection. Since sched_setaffinity() can be invoked from another
process, the process being modified may be undergoing fork() at
the same time.  When racing with the clearing of user_cpus_ptr in
__set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
possibly double-free in arm64 kernel.

Commit 8f9ea86fdf99 ("sched: Always preserve the user requested
cpumask") fixes this problem as user_cpus_ptr, once set, will never
be cleared in a task's lifetime. However, this bug was re-introduced
in commit 851a723e45d1 ("sched: Always clear user_cpus_ptr in
do_set_cpus_allowed()") which allows the clearing of user_cpus_ptr in
do_set_cpus_allowed(). This time, it will affect all arches.

Fix this bug by always clearing the user_cpus_ptr of the newly
cloned/forked task before the copying process starts and check the
user_cpus_ptr state of the source task under pi_lock.

Note to stable, this patch won't be applicable to stable releases.
Just copy the new dup_user_cpus_ptr() function over.

Fixes: 07ec77a1d4e8 ("sched: Allow task CPU affinity to be restricted on asymmetric systems")
Fixes: 851a723e45d1 ("sched: Always clear user_cpus_ptr in do_set_cpus_allowed()")
CC: stable@vger.kernel.org
Reported-by: David Wang 王标 <wangbiao3@xiaomi.com>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/sched/core.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 25b582b6ee5f..b93d030b9fd5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2612,19 +2612,43 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src,
 		      int node)
 {
+	cpumask_t *user_mask;
 	unsigned long flags;
 
-	if (!src->user_cpus_ptr)
+	/*
+	 * Always clear dst->user_cpus_ptr first as their user_cpus_ptr's
+	 * may differ by now due to racing.
+	 */
+	dst->user_cpus_ptr = NULL;
+
+	/*
+	 * This check is racy and losing the race is a valid situation.
+	 * It is not worth the extra overhead of taking the pi_lock on
+	 * every fork/clone.
+	 */
+	if (data_race(!src->user_cpus_ptr))
 		return 0;
 
-	dst->user_cpus_ptr = kmalloc_node(cpumask_size(), GFP_KERNEL, node);
-	if (!dst->user_cpus_ptr)
+	user_mask = kmalloc_node(cpumask_size(), GFP_KERNEL, node);
+	if (!user_mask)
 		return -ENOMEM;
 
-	/* Use pi_lock to protect content of user_cpus_ptr */
+	/*
+	 * Use pi_lock to protect content of user_cpus_ptr
+	 *
+	 * Though unlikely, user_cpus_ptr can be reset to NULL by a concurrent
+	 * do_set_cpus_allowed().
+	 */
 	raw_spin_lock_irqsave(&src->pi_lock, flags);
-	cpumask_copy(dst->user_cpus_ptr, src->user_cpus_ptr);
+	if (src->user_cpus_ptr) {
+		swap(dst->user_cpus_ptr, user_mask);
+		cpumask_copy(dst->user_cpus_ptr, src->user_cpus_ptr);
+	}
 	raw_spin_unlock_irqrestore(&src->pi_lock, flags);
+
+	if (unlikely(user_mask))
+		kfree(user_mask);
+
 	return 0;
 }
 
-- 
2.31.1

