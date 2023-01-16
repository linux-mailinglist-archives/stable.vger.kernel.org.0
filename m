Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B9866C4BA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjAPP55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbjAPP5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E2422A0B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7AB36102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB938C433D2;
        Mon, 16 Jan 2023 15:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884652;
        bh=9n7iOmKjYiUM48hry9NGOKRL0Lz89ppHiWO6NqrgA1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zo75LzWrflbA55mOctTSZMuWq0UakiR24FNxgvDsLoL6Bri57KLXudmQI2xOEK9vn
         OS8dLNEyu8NnIB/w/JT9pjlOBwkaFLX7f6ORv9APW0GfmQKkD4DKx9oCvFxJZZ6wbK
         uASzK2MZIa0aqQ7pBwv9gpGcfNOuYVDxkxk03xaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?David=20Wang=20=E7=8E=8B=E6=A0=87?= 
        <wangbiao3@xiaomi.com>, Waiman Long <longman@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.1 088/183] sched/core: Fix use-after-free bug in dup_user_cpus_ptr()
Date:   Mon, 16 Jan 2023 16:50:11 +0100
Message-Id: <20230116154807.145821027@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Waiman Long <longman@redhat.com>

commit 87ca4f9efbd7cc649ff43b87970888f2812945b8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |   37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2587,14 +2587,43 @@ void do_set_cpus_allowed(struct task_str
 int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src,
 		      int node)
 {
-	if (!src->user_cpus_ptr)
+	cpumask_t *user_mask;
+	unsigned long flags;
+
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
 
-	cpumask_copy(dst->user_cpus_ptr, src->user_cpus_ptr);
+	/*
+	 * Use pi_lock to protect content of user_cpus_ptr
+	 *
+	 * Though unlikely, user_cpus_ptr can be reset to NULL by a concurrent
+	 * do_set_cpus_allowed().
+	 */
+	raw_spin_lock_irqsave(&src->pi_lock, flags);
+	if (src->user_cpus_ptr) {
+		swap(dst->user_cpus_ptr, user_mask);
+		cpumask_copy(dst->user_cpus_ptr, src->user_cpus_ptr);
+	}
+	raw_spin_unlock_irqrestore(&src->pi_lock, flags);
+
+	if (unlikely(user_mask))
+		kfree(user_mask);
+
 	return 0;
 }
 


