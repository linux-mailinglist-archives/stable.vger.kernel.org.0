Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E406B472B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbjCJOtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbjCJOrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:47:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2514108C2E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:47:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A187B822E7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D870DC4339B;
        Fri, 10 Mar 2023 14:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459644;
        bh=eYnGH6XaFfJO7JNnGkMlQddojF3ytL1PC2+eqy1Hu1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPSHVagPGDi3c3hzeVzevx0W7XQvcJqIH5GTXfKd2WXZj+vmrfgWk3rhHNYpvdvre
         FkhUa1rSbBmJGXwU8tvaXOCHDY3tQNBgoZaZEBI6LgiXdAGDgZL6pf697C08SMqGZq
         Bvpjj0gzmbG4yLSHkAo45j76y1mNEY9hicB8LWRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Boqun Feng <boqun.feng@gmail.com>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/529] rcu-tasks: Improve comments explaining tasks_rcu_exit_srcu purpose
Date:   Fri, 10 Mar 2023 14:33:35 +0100
Message-Id: <20230310133808.297341522@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit e4e1e8089c5fd948da12cb9f4adc93821036945f ]

Make sure we don't need to look again into the depths of git blame in
order not to miss a subtle part about how rcu-tasks is dealing with
exiting tasks.

Suggested-by: Boqun Feng <boqun.feng@gmail.com>
Suggested-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 28319d6dc5e2 ("rcu-tasks: Fix synchronize_rcu_tasks() VS zap_pid_ns_processes()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 8b51e6a5b3869..372644126b0de 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -416,11 +416,21 @@ static void rcu_tasks_pertask(struct task_struct *t, struct list_head *hop)
 static void rcu_tasks_postscan(struct list_head *hop)
 {
 	/*
-	 * Wait for tasks that are in the process of exiting.  This
-	 * does only part of the job, ensuring that all tasks that were
-	 * previously exiting reach the point where they have disabled
-	 * preemption, allowing the later synchronize_rcu() to finish
-	 * the job.
+	 * Exiting tasks may escape the tasklist scan. Those are vulnerable
+	 * until their final schedule() with TASK_DEAD state. To cope with
+	 * this, divide the fragile exit path part in two intersecting
+	 * read side critical sections:
+	 *
+	 * 1) An _SRCU_ read side starting before calling exit_notify(),
+	 *    which may remove the task from the tasklist, and ending after
+	 *    the final preempt_disable() call in do_exit().
+	 *
+	 * 2) An _RCU_ read side starting with the final preempt_disable()
+	 *    call in do_exit() and ending with the final call to schedule()
+	 *    with TASK_DEAD state.
+	 *
+	 * This handles the part 1). And postgp will handle part 2) with a
+	 * call to synchronize_rcu().
 	 */
 	synchronize_srcu(&tasks_rcu_exit_srcu);
 }
@@ -487,7 +497,10 @@ static void rcu_tasks_postgp(struct rcu_tasks *rtp)
 	 *
 	 * In addition, this synchronize_rcu() waits for exiting tasks
 	 * to complete their final preempt_disable() region of execution,
-	 * cleaning up after the synchronize_srcu() above.
+	 * cleaning up after synchronize_srcu(&tasks_rcu_exit_srcu),
+	 * enforcing the whole region before tasklist removal until
+	 * the final schedule() with TASK_DEAD state to be an RCU TASKS
+	 * read side critical section.
 	 */
 	synchronize_rcu();
 }
@@ -576,7 +589,11 @@ static void show_rcu_tasks_classic_gp_kthread(void)
 }
 #endif /* #ifndef CONFIG_TINY_RCU */
 
-/* Do the srcu_read_lock() for the above synchronize_srcu().  */
+/*
+ * Contribute to protect against tasklist scan blind spot while the
+ * task is exiting and may be removed from the tasklist. See
+ * corresponding synchronize_srcu() for further details.
+ */
 void exit_tasks_rcu_start(void) __acquires(&tasks_rcu_exit_srcu)
 {
 	preempt_disable();
@@ -584,7 +601,11 @@ void exit_tasks_rcu_start(void) __acquires(&tasks_rcu_exit_srcu)
 	preempt_enable();
 }
 
-/* Do the srcu_read_unlock() for the above synchronize_srcu().  */
+/*
+ * Contribute to protect against tasklist scan blind spot while the
+ * task is exiting and may be removed from the tasklist. See
+ * corresponding synchronize_srcu() for further details.
+ */
 void exit_tasks_rcu_finish(void) __releases(&tasks_rcu_exit_srcu)
 {
 	struct task_struct *t = current;
-- 
2.39.2



