Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2619B6E4F1D
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 19:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjDQRV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 13:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjDQRV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 13:21:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95B4172C
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 10:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681752015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=p46ubHQ8sFDAMthWSbB5CMOH3MQgGm0+ig1RjfDkryA=;
        b=KwwgbQW5TdekPANcjFc4+G+vncdgQeO+ZVVLMCoBDCC57NCukgcCJHW5FV8+pwbcX2J8T8
        Y1corbXcmzmZh9k+ZA7Ux+ucOTg03mWZH1+9/pbUn/FjU9ItneuK/llo/kfa81HMM+3sma
        O5g/BY4jI0PK54w4AjZIZ7qbKemLat0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-0nofwSZHOV2zUCfDayZzKQ-1; Mon, 17 Apr 2023 13:20:09 -0400
X-MC-Unique: 0nofwSZHOV2zUCfDayZzKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 666353811F5A;
        Mon, 17 Apr 2023 17:20:09 +0000 (UTC)
Received: from llong.com (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2306D40C20FA;
        Mon, 17 Apr 2023 17:20:09 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH 5.10 1/4] cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem
Date:   Mon, 17 Apr 2023 13:19:55 -0400
Message-Id: <20230417171958.3389333-1-longman@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit b94f9ac79a7395c2d6171cc753cc27942df0be73 upstream.

Since commit 1243dc518c9d ("cgroup/cpuset: Convert cpuset_mutex to
percpu_rwsem"), cpuset_mutex has been replaced by cpuset_rwsem which is
a percpu rwsem. However, the comments in kernel/cgroup/cpuset.c still
reference cpuset_mutex which are now incorrect.

Change all the references of cpuset_mutex to cpuset_rwsem.

Fixes: 1243dc518c9d ("cgroup/cpuset: Convert cpuset_mutex to percpu_rwsem")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cpuset.c | 56 ++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 43270b07b2e0..fc6aedb84b80 100644
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
@@ -410,7 +412,7 @@ static void guarantee_online_cpus(struct cpuset *cs, struct cpumask *pmask)
  * One way or another, we guarantee to return some non-empty subset
  * of node_states[N_MEMORY].
  *
- * Call with callback_lock or cpuset_mutex held.
+ * Call with callback_lock or cpuset_rwsem held.
  */
 static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 {
@@ -422,7 +424,7 @@ static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 /*
  * update task's spread flag if cpuset's page/slab spread flag is set
  *
- * Call with callback_lock or cpuset_mutex held.
+ * Call with callback_lock or cpuset_rwsem held.
  */
 static void cpuset_update_task_spread_flag(struct cpuset *cs,
 					struct task_struct *tsk)
@@ -443,7 +445,7 @@ static void cpuset_update_task_spread_flag(struct cpuset *cs,
  *
  * One cpuset is a subset of another if all its allowed CPUs and
  * Memory Nodes are a subset of the other, and its exclusive flags
- * are only set if the other's are set.  Call holding cpuset_mutex.
+ * are only set if the other's are set.  Call holding cpuset_rwsem.
  */
 
 static int is_cpuset_subset(const struct cpuset *p, const struct cpuset *q)
@@ -552,7 +554,7 @@ static inline void free_cpuset(struct cpuset *cs)
  * If we replaced the flag and mask values of the current cpuset
  * (cur) with those values in the trial cpuset (trial), would
  * our various subset and exclusive rules still be valid?  Presumes
- * cpuset_mutex held.
+ * cpuset_rwsem held.
  *
  * 'cur' is the address of an actual, in-use cpuset.  Operations
  * such as list traversal that depend on the actual address of the
@@ -675,7 +677,7 @@ static void update_domain_attr_tree(struct sched_domain_attr *dattr,
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
@@ -980,7 +982,7 @@ partition_and_rebuild_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
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
@@ -1328,7 +1330,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
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
 
@@ -1706,7 +1708,7 @@ static void update_tasks_nodemask(struct cpuset *cs)
 	 * take while holding tasklist_lock.  Forks can happen - the
 	 * mpol_dup() cpuset_being_rebound check will catch such forks,
 	 * and rebind their vma mempolicies too.  Because we still hold
-	 * the global cpuset_mutex, we know that no other rebind effort
+	 * the global cpuset_rwsem, we know that no other rebind effort
 	 * will be contending for the global variable cpuset_being_rebound.
 	 * It's ok if we rebind the same mm twice; mpol_rebind_mm()
 	 * is idempotent.  Also migrate pages in each mm to new nodes.
@@ -1752,7 +1754,7 @@ static void update_tasks_nodemask(struct cpuset *cs)
  *
  * On legacy hiearchy, effective_mems will be the same with mems_allowed.
  *
- * Called with cpuset_mutex held
+ * Called with cpuset_rwsem held
  */
 static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 {
@@ -1805,7 +1807,7 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
  * mempolicies and if the cpuset is marked 'memory_migrate',
  * migrate the tasks pages to the new memory.
  *
- * Call with cpuset_mutex held. May take callback_lock during call.
+ * Call with cpuset_rwsem held. May take callback_lock during call.
  * Will take tasklist_lock, scan tasklist for tasks in cpuset cs,
  * lock each such tasks mm->mmap_lock, scan its vma's and rebind
  * their mempolicies to the cpusets new mems_allowed.
@@ -1895,7 +1897,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
  * @cs: the cpuset in which each task's spread flags needs to be changed
  *
  * Iterate through each task of @cs updating its spread flags.  As this
- * function is called with cpuset_mutex held, cpuset membership stays
+ * function is called with cpuset_rwsem held, cpuset membership stays
  * stable.
  */
 static void update_tasks_flags(struct cpuset *cs)
@@ -1915,7 +1917,7 @@ static void update_tasks_flags(struct cpuset *cs)
  * cs:		the cpuset to update
  * turning_on: 	whether the flag is being set or cleared
  *
- * Call with cpuset_mutex held.
+ * Call with cpuset_rwsem held.
  */
 
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
@@ -1964,7 +1966,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
  * cs: the cpuset to update
  * new_prs: new partition root state
  *
- * Call with cpuset_mutex held.
+ * Call with cpuset_rwsem held.
  */
 static int update_prstate(struct cpuset *cs, int new_prs)
 {
@@ -2145,7 +2147,7 @@ static int fmeter_getrate(struct fmeter *fmp)
 
 static struct cpuset *cpuset_attach_old_cs;
 
-/* Called by cgroups to determine if a cpuset is usable; cpuset_mutex held */
+/* Called by cgroups to determine if a cpuset is usable; cpuset_rwsem held */
 static int cpuset_can_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
@@ -2197,7 +2199,7 @@ static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 }
 
 /*
- * Protected by cpuset_mutex.  cpus_attach is used only by cpuset_attach()
+ * Protected by cpuset_rwsem.  cpus_attach is used only by cpuset_attach()
  * but we can't allocate it dynamically there.  Define it global and
  * allocate from cpuset_init().
  */
@@ -2205,7 +2207,7 @@ static cpumask_var_t cpus_attach;
 
 static void cpuset_attach(struct cgroup_taskset *tset)
 {
-	/* static buf protected by cpuset_mutex */
+	/* static buf protected by cpuset_rwsem */
 	static nodemask_t cpuset_attach_nodemask_to;
 	struct task_struct *task;
 	struct task_struct *leader;
@@ -2398,7 +2400,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	 * operation like this one can lead to a deadlock through kernfs
 	 * active_ref protection.  Let's break the protection.  Losing the
 	 * protection is okay as we check whether @cs is online after
-	 * grabbing cpuset_mutex anyway.  This only happens on the legacy
+	 * grabbing cpuset_rwsem anyway.  This only happens on the legacy
 	 * hierarchies.
 	 */
 	css_get(&cs->css);
@@ -3637,7 +3639,7 @@ void __cpuset_memory_pressure_bump(void)
  *  - Used for /proc/<pid>/cpuset.
  *  - No need to task_lock(tsk) on this tsk->cpuset reference, as it
  *    doesn't really matter if tsk->cpuset changes after we read it,
- *    and we take cpuset_mutex, keeping cpuset_attach() from changing it
+ *    and we take cpuset_rwsem, keeping cpuset_attach() from changing it
  *    anyway.
  */
 int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,
-- 
2.31.1

