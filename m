Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E106E62EC
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbjDRMgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjDRMgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:36:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8634F12C93
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:36:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 123F66329D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A4EC4339B;
        Tue, 18 Apr 2023 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821398;
        bh=Q8RWFHbSW+5hPnOz1GH2LlvuuSmZsbpztsw5AK906Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gq1xg55K8IgXE6V9RmZ+6H8a5KQnv0ma9X0Bcv5FuL/164wGecm2zYybuTXM6CsjY
         YLfHdaaEQoo2dL3L973LmixNBylHgNURHUOorzOn7h1oTJsVRRtOk5LpjLQjDo12w6
         oWSJxs9F7v5SMCfQUhXCPxBzQA9Ev04fb6PudhXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Waiman Long <longman@redhat.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.10 111/124] cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem
Date:   Tue, 18 Apr 2023 14:22:10 +0200
Message-Id: <20230418120313.827182358@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

Commit b94f9ac79a7395c2d6171cc753cc27942df0be73 upstream.

Since commit 1243dc518c9d ("cgroup/cpuset: Convert cpuset_mutex to
percpu_rwsem"), cpuset_mutex has been replaced by cpuset_rwsem which is
a percpu rwsem. However, the comments in kernel/cgroup/cpuset.c still
reference cpuset_mutex which are now incorrect.

Change all the references of cpuset_mutex to cpuset_rwsem.

Fixes: 1243dc518c9d ("cgroup/cpuset: Convert cpuset_mutex to percpu_rwsem")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |   56 +++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -299,17 +299,19 @@ static struct cpuset top_cpuset = {
 		if (is_cpuset_online(((des_cs) = css_cs((pos_css)))))
 
 /*
- * There are two global locks guarding cpuset structures - cpuset_mutex and
+ * There are two global locks guarding cpuset structures - cpuset_rwsem and
  * callback_lock. We also require taking task_lock() when dereferencing a
  * task's cpuset pointer. See "The task_lock() exception", at the end of this
- * comment.
+ * comment.  The cpuset code uses only cpuset_rwsem write lock.  Other
+ * kernel subsystems can use cpuset_read_lock()/cpuset_read_unlock() to
+ * prevent change to cpuset structures.
  *
  * A task must hold both locks to modify cpusets.  If a task holds
- * cpuset_mutex, then it blocks others wanting that mutex, ensuring that it
+ * cpuset_rwsem, it blocks others wanting that rwsem, ensuring that it
  * is the only task able to also acquire callback_lock and be able to
  * modify cpusets.  It can perform various checks on the cpuset structure
  * first, knowing nothing will change.  It can also allocate memory while
- * just holding cpuset_mutex.  While it is performing these checks, various
+ * just holding cpuset_rwsem.  While it is performing these checks, various
  * callback routines can briefly acquire callback_lock to query cpusets.
  * Once it is ready to make the changes, it takes callback_lock, blocking
  * everyone else.
@@ -380,7 +382,7 @@ static inline bool is_in_v2_mode(void)
  * One way or another, we guarantee to return some non-empty subset
  * of cpu_online_mask.
  *
- * Call with callback_lock or cpuset_mutex held.
+ * Call with callback_lock or cpuset_rwsem held.
  */
 static void guarantee_online_cpus(struct cpuset *cs, struct cpumask *pmask)
 {
@@ -410,7 +412,7 @@ static void guarantee_online_cpus(struct
  * One way or another, we guarantee to return some non-empty subset
  * of node_states[N_MEMORY].
  *
- * Call with callback_lock or cpuset_mutex held.
+ * Call with callback_lock or cpuset_rwsem held.
  */
 static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 {
@@ -422,7 +424,7 @@ static void guarantee_online_mems(struct
 /*
  * update task's spread flag if cpuset's page/slab spread flag is set
  *
- * Call with callback_lock or cpuset_mutex held.
+ * Call with callback_lock or cpuset_rwsem held.
  */
 static void cpuset_update_task_spread_flag(struct cpuset *cs,
 					struct task_struct *tsk)
@@ -443,7 +445,7 @@ static void cpuset_update_task_spread_fl
  *
  * One cpuset is a subset of another if all its allowed CPUs and
  * Memory Nodes are a subset of the other, and its exclusive flags
- * are only set if the other's are set.  Call holding cpuset_mutex.
+ * are only set if the other's are set.  Call holding cpuset_rwsem.
  */
 
 static int is_cpuset_subset(const struct cpuset *p, const struct cpuset *q)
@@ -552,7 +554,7 @@ static inline void free_cpuset(struct cp
  * If we replaced the flag and mask values of the current cpuset
  * (cur) with those values in the trial cpuset (trial), would
  * our various subset and exclusive rules still be valid?  Presumes
- * cpuset_mutex held.
+ * cpuset_rwsem held.
  *
  * 'cur' is the address of an actual, in-use cpuset.  Operations
  * such as list traversal that depend on the actual address of the
@@ -675,7 +677,7 @@ static void update_domain_attr_tree(stru
 	rcu_read_unlock();
 }
 
-/* Must be called with cpuset_mutex held.  */
+/* Must be called with cpuset_rwsem held.  */
 static inline int nr_cpusets(void)
 {
 	/* jump label reference count + the top-level cpuset */
@@ -701,7 +703,7 @@ static inline int nr_cpusets(void)
  * domains when operating in the severe memory shortage situations
  * that could cause allocation failures below.
  *
- * Must be called with cpuset_mutex held.
+ * Must be called with cpuset_rwsem held.
  *
  * The three key local variables below are:
  *    cp - cpuset pointer, used (together with pos_css) to perform a
@@ -980,7 +982,7 @@ partition_and_rebuild_sched_domains(int
  * 'cpus' is removed, then call this routine to rebuild the
  * scheduler's dynamic sched domains.
  *
- * Call with cpuset_mutex held.  Takes get_online_cpus().
+ * Call with cpuset_rwsem held.  Takes get_online_cpus().
  */
 static void rebuild_sched_domains_locked(void)
 {
@@ -1053,7 +1055,7 @@ void rebuild_sched_domains(void)
  * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
  *
  * Iterate through each task of @cs updating its cpus_allowed to the
- * effective cpuset's.  As this function is called with cpuset_mutex held,
+ * effective cpuset's.  As this function is called with cpuset_rwsem held,
  * cpuset membership stays stable.
  */
 static void update_tasks_cpumask(struct cpuset *cs)
@@ -1328,7 +1330,7 @@ static int update_parent_subparts_cpumas
  *
  * On legacy hierachy, effective_cpus will be the same with cpu_allowed.
  *
- * Called with cpuset_mutex held
+ * Called with cpuset_rwsem held
  */
 static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 {
@@ -1688,12 +1690,12 @@ static void *cpuset_being_rebound;
  * @cs: the cpuset in which each task's mems_allowed mask needs to be changed
  *
  * Iterate through each task of @cs updating its mems_allowed to the
- * effective cpuset's.  As this function is called with cpuset_mutex held,
+ * effective cpuset's.  As this function is called with cpuset_rwsem held,
  * cpuset membership stays stable.
  */
 static void update_tasks_nodemask(struct cpuset *cs)
 {
-	static nodemask_t newmems;	/* protected by cpuset_mutex */
+	static nodemask_t newmems;	/* protected by cpuset_rwsem */
 	struct css_task_iter it;
 	struct task_struct *task;
 
@@ -1706,7 +1708,7 @@ static void update_tasks_nodemask(struct
 	 * take while holding tasklist_lock.  Forks can happen - the
 	 * mpol_dup() cpuset_being_rebound check will catch such forks,
 	 * and rebind their vma mempolicies too.  Because we still hold
-	 * the global cpuset_mutex, we know that no other rebind effort
+	 * the global cpuset_rwsem, we know that no other rebind effort
 	 * will be contending for the global variable cpuset_being_rebound.
 	 * It's ok if we rebind the same mm twice; mpol_rebind_mm()
 	 * is idempotent.  Also migrate pages in each mm to new nodes.
@@ -1752,7 +1754,7 @@ static void update_tasks_nodemask(struct
  *
  * On legacy hiearchy, effective_mems will be the same with mems_allowed.
  *
- * Called with cpuset_mutex held
+ * Called with cpuset_rwsem held
  */
 static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 {
@@ -1805,7 +1807,7 @@ static void update_nodemasks_hier(struct
  * mempolicies and if the cpuset is marked 'memory_migrate',
  * migrate the tasks pages to the new memory.
  *
- * Call with cpuset_mutex held. May take callback_lock during call.
+ * Call with cpuset_rwsem held. May take callback_lock during call.
  * Will take tasklist_lock, scan tasklist for tasks in cpuset cs,
  * lock each such tasks mm->mmap_lock, scan its vma's and rebind
  * their mempolicies to the cpusets new mems_allowed.
@@ -1895,7 +1897,7 @@ static int update_relax_domain_level(str
  * @cs: the cpuset in which each task's spread flags needs to be changed
  *
  * Iterate through each task of @cs updating its spread flags.  As this
- * function is called with cpuset_mutex held, cpuset membership stays
+ * function is called with cpuset_rwsem held, cpuset membership stays
  * stable.
  */
 static void update_tasks_flags(struct cpuset *cs)
@@ -1915,7 +1917,7 @@ static void update_tasks_flags(struct cp
  * cs:		the cpuset to update
  * turning_on: 	whether the flag is being set or cleared
  *
- * Call with cpuset_mutex held.
+ * Call with cpuset_rwsem held.
  */
 
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
@@ -1964,7 +1966,7 @@ out:
  * cs: the cpuset to update
  * new_prs: new partition root state
  *
- * Call with cpuset_mutex held.
+ * Call with cpuset_rwsem held.
  */
 static int update_prstate(struct cpuset *cs, int new_prs)
 {
@@ -2145,7 +2147,7 @@ static int fmeter_getrate(struct fmeter
 
 static struct cpuset *cpuset_attach_old_cs;
 
-/* Called by cgroups to determine if a cpuset is usable; cpuset_mutex held */
+/* Called by cgroups to determine if a cpuset is usable; cpuset_rwsem held */
 static int cpuset_can_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
@@ -2201,7 +2203,7 @@ static void cpuset_cancel_attach(struct
 }
 
 /*
- * Protected by cpuset_mutex.  cpus_attach is used only by cpuset_attach()
+ * Protected by cpuset_rwsem.  cpus_attach is used only by cpuset_attach()
  * but we can't allocate it dynamically there.  Define it global and
  * allocate from cpuset_init().
  */
@@ -2209,7 +2211,7 @@ static cpumask_var_t cpus_attach;
 
 static void cpuset_attach(struct cgroup_taskset *tset)
 {
-	/* static buf protected by cpuset_mutex */
+	/* static buf protected by cpuset_rwsem */
 	static nodemask_t cpuset_attach_nodemask_to;
 	struct task_struct *task;
 	struct task_struct *leader;
@@ -2402,7 +2404,7 @@ static ssize_t cpuset_write_resmask(stru
 	 * operation like this one can lead to a deadlock through kernfs
 	 * active_ref protection.  Let's break the protection.  Losing the
 	 * protection is okay as we check whether @cs is online after
-	 * grabbing cpuset_mutex anyway.  This only happens on the legacy
+	 * grabbing cpuset_rwsem anyway.  This only happens on the legacy
 	 * hierarchies.
 	 */
 	css_get(&cs->css);
@@ -3641,7 +3643,7 @@ void __cpuset_memory_pressure_bump(void)
  *  - Used for /proc/<pid>/cpuset.
  *  - No need to task_lock(tsk) on this tsk->cpuset reference, as it
  *    doesn't really matter if tsk->cpuset changes after we read it,
- *    and we take cpuset_mutex, keeping cpuset_attach() from changing it
+ *    and we take cpuset_rwsem, keeping cpuset_attach() from changing it
  *    anyway.
  */
 int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,


