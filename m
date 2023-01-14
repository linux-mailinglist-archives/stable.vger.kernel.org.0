Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9389566AAC7
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjANJx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjANJxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:53:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E170195
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:53:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA2EEB808C0
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D75FC433D2;
        Sat, 14 Jan 2023 09:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673690000;
        bh=sm0UzgU6BU+jafHjU93/iVfqtKN5HG+wl9FM8v1T6Wg=;
        h=Subject:To:Cc:From:Date:From;
        b=ZPSv2LrNERJL/GncEVpRMOfgZlM/UH4crYdnkqf7TYjMw2cFmWLG+D2Z6vxSlJhih
         da6FWku/8GVQEDC4ujnL4rFtcCDUh8gI3PsTlJA2H5zYx9cdDTjU0z3CjVFWIR4Fhh
         v4UXg34kDAx9YaD0GYF8rqnRaR7d4NEaf8349X0k=
Subject: FAILED: patch "[PATCH] sched/core: Fix use-after-free bug in dup_user_cpus_ptr()" failed to apply to 6.1-stable tree
To:     longman@redhat.com, mingo@kernel.org, peterz@infradead.org,
        wangbiao3@xiaomi.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:53:17 +0100
Message-ID: <167368999799102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

87ca4f9efbd7 ("sched/core: Fix use-after-free bug in dup_user_cpus_ptr()")
8f9ea86fdf99 ("sched: Always preserve the user requested cpumask")
713a2e21a513 ("sched: Introduce affinity_context")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 87ca4f9efbd7cc649ff43b87970888f2812945b8 Mon Sep 17 00:00:00 2001
From: Waiman Long <longman@redhat.com>
Date: Fri, 30 Dec 2022 23:11:19 -0500
Subject: [PATCH] sched/core: Fix use-after-free bug in dup_user_cpus_ptr()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Reported-by: David Wang 王标 <wangbiao3@xiaomi.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221231041120.440785-2-longman@redhat.com

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 965d813c28ad..f9f6e5413dcf 100644
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
 

