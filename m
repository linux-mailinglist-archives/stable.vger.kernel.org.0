Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377EE594877
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243949AbiHOXJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353254AbiHOXHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:07:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2E586B7B;
        Mon, 15 Aug 2022 12:59:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55C3E61226;
        Mon, 15 Aug 2022 19:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6105FC433D6;
        Mon, 15 Aug 2022 19:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593573;
        bh=JS66pYgxtcebIxprTYSV0gPkrW5D2hGNzWn3UMetqOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JID7JC6hxUVgpcC7z8XSxLDsvBCe5VYBAu8JE1yLbwhc1dAoesVYnYt8KX8Vs+wgs
         KYlRVeyqjprbij54J9Sf0cgHNNyLS5ZGmJDLMGLoobtr5jhBJAdscBalHbAF5RI+6p
         7kqHr73QHQcTpaLV3EBAz/j2ZtK6v6cxayY87C/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0290/1157] sched: only perform capability check on privileged operation
Date:   Mon, 15 Aug 2022 19:54:06 +0200
Message-Id: <20220815180451.220086470@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian Göttsche <cgzones@googlemail.com>

[ Upstream commit 700a78335fc28a59c307f420857fd2d4521549f8 ]

sched_setattr(2) issues via kernel/sched/core.c:__sched_setscheduler()
a CAP_SYS_NICE audit event unconditionally, even when the requested
operation does not require that capability / is unprivileged, i.e. for
reducing niceness.
This is relevant in connection with SELinux, where a capability check
results in a policy decision and by default a denial message on
insufficient permission is issued.
It can lead to three undesired cases:
  1. A denial message is generated, even in case the operation was an
     unprivileged one and thus the syscall succeeded, creating noise.
  2. To avoid the noise from 1. the policy writer adds a rule to ignore
     those denial messages, hiding future syscalls, where the task
     performs an actual privileged operation, leading to hidden limited
     functionality of that task.
  3. To avoid the noise from 1. the policy writer adds a rule to allow
     the task the capability CAP_SYS_NICE, while it does not need it,
     violating the principle of least privilege.

Conduct privilged/unprivileged categorization first and perform a
capable test (and at most once) only if needed.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220615152505.310488-1-cgzones@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 138 ++++++++++++++++++++++++++------------------
 1 file changed, 83 insertions(+), 55 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 410b04decb90..f1e070551aa9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7002,17 +7002,29 @@ void set_user_nice(struct task_struct *p, long nice)
 EXPORT_SYMBOL(set_user_nice);
 
 /*
- * can_nice - check if a task can reduce its nice value
+ * is_nice_reduction - check if nice value is an actual reduction
+ *
+ * Similar to can_nice() but does not perform a capability check.
+ *
  * @p: task
  * @nice: nice value
  */
-int can_nice(const struct task_struct *p, const int nice)
+static bool is_nice_reduction(const struct task_struct *p, const int nice)
 {
 	/* Convert nice value [19,-20] to rlimit style value [1,40]: */
 	int nice_rlim = nice_to_rlimit(nice);
 
-	return (nice_rlim <= task_rlimit(p, RLIMIT_NICE) ||
-		capable(CAP_SYS_NICE));
+	return (nice_rlim <= task_rlimit(p, RLIMIT_NICE));
+}
+
+/*
+ * can_nice - check if a task can reduce its nice value
+ * @p: task
+ * @nice: nice value
+ */
+int can_nice(const struct task_struct *p, const int nice)
+{
+	return is_nice_reduction(p, nice) || capable(CAP_SYS_NICE);
 }
 
 #ifdef __ARCH_WANT_SYS_NICE
@@ -7291,6 +7303,69 @@ static bool check_same_owner(struct task_struct *p)
 	return match;
 }
 
+/*
+ * Allow unprivileged RT tasks to decrease priority.
+ * Only issue a capable test if needed and only once to avoid an audit
+ * event on permitted non-privileged operations:
+ */
+static int user_check_sched_setscheduler(struct task_struct *p,
+					 const struct sched_attr *attr,
+					 int policy, int reset_on_fork)
+{
+	if (fair_policy(policy)) {
+		if (attr->sched_nice < task_nice(p) &&
+		    !is_nice_reduction(p, attr->sched_nice))
+			goto req_priv;
+	}
+
+	if (rt_policy(policy)) {
+		unsigned long rlim_rtprio = task_rlimit(p, RLIMIT_RTPRIO);
+
+		/* Can't set/change the rt policy: */
+		if (policy != p->policy && !rlim_rtprio)
+			goto req_priv;
+
+		/* Can't increase priority: */
+		if (attr->sched_priority > p->rt_priority &&
+		    attr->sched_priority > rlim_rtprio)
+			goto req_priv;
+	}
+
+	/*
+	 * Can't set/change SCHED_DEADLINE policy at all for now
+	 * (safest behavior); in the future we would like to allow
+	 * unprivileged DL tasks to increase their relative deadline
+	 * or reduce their runtime (both ways reducing utilization)
+	 */
+	if (dl_policy(policy))
+		goto req_priv;
+
+	/*
+	 * Treat SCHED_IDLE as nice 20. Only allow a switch to
+	 * SCHED_NORMAL if the RLIMIT_NICE would normally permit it.
+	 */
+	if (task_has_idle_policy(p) && !idle_policy(policy)) {
+		if (!is_nice_reduction(p, task_nice(p)))
+			goto req_priv;
+	}
+
+	/* Can't change other user's priorities: */
+	if (!check_same_owner(p))
+		goto req_priv;
+
+	/* Normal users shall not reset the sched_reset_on_fork flag: */
+	if (p->sched_reset_on_fork && !reset_on_fork)
+		goto req_priv;
+
+	return 0;
+
+req_priv:
+	if (!capable(CAP_SYS_NICE))
+		return -EPERM;
+
+	return 0;
+}
+
 static int __sched_setscheduler(struct task_struct *p,
 				const struct sched_attr *attr,
 				bool user, bool pi)
@@ -7332,58 +7407,11 @@ static int __sched_setscheduler(struct task_struct *p,
 	    (rt_policy(policy) != (attr->sched_priority != 0)))
 		return -EINVAL;
 
-	/*
-	 * Allow unprivileged RT tasks to decrease priority:
-	 */
-	if (user && !capable(CAP_SYS_NICE)) {
-		if (fair_policy(policy)) {
-			if (attr->sched_nice < task_nice(p) &&
-			    !can_nice(p, attr->sched_nice))
-				return -EPERM;
-		}
-
-		if (rt_policy(policy)) {
-			unsigned long rlim_rtprio =
-					task_rlimit(p, RLIMIT_RTPRIO);
-
-			/* Can't set/change the rt policy: */
-			if (policy != p->policy && !rlim_rtprio)
-				return -EPERM;
-
-			/* Can't increase priority: */
-			if (attr->sched_priority > p->rt_priority &&
-			    attr->sched_priority > rlim_rtprio)
-				return -EPERM;
-		}
-
-		 /*
-		  * Can't set/change SCHED_DEADLINE policy at all for now
-		  * (safest behavior); in the future we would like to allow
-		  * unprivileged DL tasks to increase their relative deadline
-		  * or reduce their runtime (both ways reducing utilization)
-		  */
-		if (dl_policy(policy))
-			return -EPERM;
-
-		/*
-		 * Treat SCHED_IDLE as nice 20. Only allow a switch to
-		 * SCHED_NORMAL if the RLIMIT_NICE would normally permit it.
-		 */
-		if (task_has_idle_policy(p) && !idle_policy(policy)) {
-			if (!can_nice(p, task_nice(p)))
-				return -EPERM;
-		}
-
-		/* Can't change other user's priorities: */
-		if (!check_same_owner(p))
-			return -EPERM;
-
-		/* Normal users shall not reset the sched_reset_on_fork flag: */
-		if (p->sched_reset_on_fork && !reset_on_fork)
-			return -EPERM;
-	}
-
 	if (user) {
+		retval = user_check_sched_setscheduler(p, attr, policy, reset_on_fork);
+		if (retval)
+			return retval;
+
 		if (attr->sched_flags & SCHED_FLAG_SUGOV)
 			return -EINVAL;
 
-- 
2.35.1



