Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6767B642DD2
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 17:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiLEQvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 11:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiLEQuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 11:50:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D02F20F4E
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 08:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670258930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4KZ/zgtG2GkdUtgg8vJDdSHxlbgaAY07w0uujmcN/Po=;
        b=E6KV408sIpAmR9r74OjvZCD3GIq4NlzJuuNA4nVy7LRv7AFMH/qcckAtOxaWlXsiYRIqsC
        Sc+i01exm9ohnNzuX0/ZptoLIVLC8zJGVPpXGWwRBpmoK91qWfqUN/ufIRlsyynNaQ5PzF
        pEwVwNKa7Ft3CFd5IsdvWVw+rve5Lus=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-P58rRdR5NlCDBAphtSryZw-1; Mon, 05 Dec 2022 11:48:47 -0500
X-MC-Unique: P58rRdR5NlCDBAphtSryZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 976B638164D3;
        Mon,  5 Dec 2022 16:48:46 +0000 (UTC)
Received: from llong.com (unknown [10.22.9.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D570A17595;
        Mon,  5 Dec 2022 16:48:45 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     Phil Auld <pauld@redhat.com>,
        Wenjie Li <wenjieli@qti.qualcomm.com>,
        =?UTF-8?q?David=20Wang=20=E7=8E=8B=E6=A0=87?= 
        <wangbiao3@xiaomi.com>, linux-kernel@vger.kernel.org,
        Waiman Long <longman@redhat.com>, stable@vger.kernel.org
Subject: [PATCH-tip v2] sched: Fix use-after-free bug in dup_user_cpus_ptr()
Date:   Mon,  5 Dec 2022 11:48:32 -0500
Message-Id: <20221205164832.2151247-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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
protection. When racing with the clearing of user_cpus_ptr in
__set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
double-free in arm64 kernel.

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

 [v2: Use data_race() macro as suggested by Will]

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 78b2d5cabcc5..57e5932f81a9 100644
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

