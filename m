Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF406E62F0
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjDRMgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbjDRMgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:36:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8766D1CFA3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:36:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBBE76329E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A699C433D2;
        Tue, 18 Apr 2023 12:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821406;
        bh=Mm2rEEx2hyEpBLAKeS/Lejbac1rsPNS4FbFGOlXlyUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EilBoBi7iJm19/8Nb8sIfKxXj1Uhou0qeQjM7YBEwgMpGkKnTbMUL21mEOtAd//XD
         jZfCI/XEF22EVQNV1H56Ss4t79LEhTIvleI0mvBnYHi56me5+ZQMkULW9V7AW8F/W6
         GOBYMLjTWOHIHqlUMreWU0yDlnG3TbpUb5l89l2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.10 114/124] cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
Date:   Tue, 18 Apr 2023 14:22:13 +0200
Message-Id: <20230418120313.936253661@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit eee87853794187f6adbe19533ed79c8b44b36a91 upstream.

In the case of CLONE_INTO_CGROUP, not all cpusets are ready to accept
new tasks. It is too late to check that in cpuset_fork(). So we need
to add the cpuset_can_fork() and cpuset_cancel_fork() methods to
pre-check it before we can allow attachment to a different cpuset.

We also need to set the attach_in_progress flag to alert other code
that a new task is going to be added to the cpuset.

Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 83 insertions(+), 5 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2151,6 +2151,18 @@ static int fmeter_getrate(struct fmeter
 
 static struct cpuset *cpuset_attach_old_cs;
 
+/*
+ * Check to see if a cpuset can accept a new task
+ * For v1, cpus_allowed and mems_allowed can't be empty.
+ */
+static int cpuset_can_attach_check(struct cpuset *cs)
+{
+	if (!is_in_v2_mode() &&
+	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
+		return -ENOSPC;
+	return 0;
+}
+
 /* Called by cgroups to determine if a cpuset is usable; cpuset_rwsem held */
 static int cpuset_can_attach(struct cgroup_taskset *tset)
 {
@@ -2165,10 +2177,8 @@ static int cpuset_can_attach(struct cgro
 
 	percpu_down_write(&cpuset_rwsem);
 
-	/* allow moving tasks into an empty cpuset if on default hierarchy */
-	ret = -ENOSPC;
-	if (!is_in_v2_mode() &&
-	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
+	ret = cpuset_can_attach_check(cs);
+	if (ret)
 		goto out_unlock;
 
 	cgroup_taskset_for_each(task, css, tset) {
@@ -2185,7 +2195,6 @@ static int cpuset_can_attach(struct cgro
 	 * changes which zero cpus/mems_allowed.
 	 */
 	cs->attach_in_progress++;
-	ret = 0;
 out_unlock:
 	percpu_up_write(&cpuset_rwsem);
 	return ret;
@@ -2913,6 +2922,68 @@ static void cpuset_bind(struct cgroup_su
 }
 
 /*
+ * In case the child is cloned into a cpuset different from its parent,
+ * additional checks are done to see if the move is allowed.
+ */
+static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
+{
+	struct cpuset *cs = css_cs(cset->subsys[cpuset_cgrp_id]);
+	bool same_cs;
+	int ret;
+
+	rcu_read_lock();
+	same_cs = (cs == task_cs(current));
+	rcu_read_unlock();
+
+	if (same_cs)
+		return 0;
+
+	lockdep_assert_held(&cgroup_mutex);
+	percpu_down_write(&cpuset_rwsem);
+
+	/* Check to see if task is allowed in the cpuset */
+	ret = cpuset_can_attach_check(cs);
+	if (ret)
+		goto out_unlock;
+
+	ret = task_can_attach(task, cs->effective_cpus);
+	if (ret)
+		goto out_unlock;
+
+	ret = security_task_setscheduler(task);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * Mark attach is in progress.  This makes validate_change() fail
+	 * changes which zero cpus/mems_allowed.
+	 */
+	cs->attach_in_progress++;
+out_unlock:
+	percpu_up_write(&cpuset_rwsem);
+	return ret;
+}
+
+static void cpuset_cancel_fork(struct task_struct *task, struct css_set *cset)
+{
+	struct cpuset *cs = css_cs(cset->subsys[cpuset_cgrp_id]);
+	bool same_cs;
+
+	rcu_read_lock();
+	same_cs = (cs == task_cs(current));
+	rcu_read_unlock();
+
+	if (same_cs)
+		return;
+
+	percpu_down_write(&cpuset_rwsem);
+	cs->attach_in_progress--;
+	if (!cs->attach_in_progress)
+		wake_up(&cpuset_attach_wq);
+	percpu_up_write(&cpuset_rwsem);
+}
+
+/*
  * Make sure the new task conform to the current state of its parent,
  * which could have been changed by cpuset just after it inherits the
  * state from the parent and before it sits on the cgroup's task list.
@@ -2946,6 +3017,11 @@ static void cpuset_fork(struct task_stru
 	else
 		guarantee_online_cpus(cs, cpus_attach);
 	cpuset_attach_task(cs, task);
+
+	cs->attach_in_progress--;
+	if (!cs->attach_in_progress)
+		wake_up(&cpuset_attach_wq);
+
 	percpu_up_write(&cpuset_rwsem);
 }
 
@@ -2959,6 +3035,8 @@ struct cgroup_subsys cpuset_cgrp_subsys
 	.attach		= cpuset_attach,
 	.post_attach	= cpuset_post_attach,
 	.bind		= cpuset_bind,
+	.can_fork	= cpuset_can_fork,
+	.cancel_fork	= cpuset_cancel_fork,
 	.fork		= cpuset_fork,
 	.legacy_cftypes	= legacy_files,
 	.dfl_cftypes	= dfl_files,


