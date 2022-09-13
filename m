Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9265B732C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbiIMPEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbiIMPDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:03:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817531173;
        Tue, 13 Sep 2022 07:29:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7585EB80F88;
        Tue, 13 Sep 2022 14:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8563C433D7;
        Tue, 13 Sep 2022 14:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079374;
        bh=IUkKRcrfYCoOFZXpQ3KroPqEK3VxgOEsoEhGsD600ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSYLWhMDpXuz9YCVh3G1Anw6UBCIH/4Qko15xlTvX376UVgag1DfVlp9yccDsLxDB
         czk8tSO3AMyP4Hb9TkuVJ6PT/7vrbVdhZaubOVsqiuGDw5U2gMLw+Ej9VUVnowG9bd
         N6/NPyve8fE4auGbEWSwDBMSscOc/3T5gVRUYX0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/108] cgroup: Optimize single thread migration
Date:   Tue, 13 Sep 2022 16:06:56 +0200
Message-Id: <20220913140357.276352057@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
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

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit 9a3284fad42f66bb43629c6716709ff791aaa457 ]

There are reports of users who use thread migrations between cgroups and
they report performance drop after d59cfc09c32a ("sched, cgroup: replace
signal_struct->group_rwsem with a global percpu_rwsem"). The effect is
pronounced on machines with more CPUs.

The migration is affected by forking noise happening in the background,
after the mentioned commit a migrating thread must wait for all
(forking) processes on the system, not only of its threadgroup.

There are several places that need to synchronize with migration:
	a) do_exit,
	b) de_thread,
	c) copy_process,
	d) cgroup_update_dfl_csses,
	e) parallel migration (cgroup_{proc,thread}s_write).

In the case of self-migrating thread, we relax the synchronization on
cgroup_threadgroup_rwsem to avoid the cost of waiting. d) and e) are
excluded with cgroup_mutex, c) does not matter in case of single thread
migration and the executing thread cannot exec(2) or exit(2) while it is
writing into cgroup.threads. In case of do_exit because of signal
delivery, we either exit before the migration or finish the migration
(of not yet PF_EXITING thread) and die afterwards.

This patch handles only the case of self-migration by writing "0" into
cgroup.threads. For simplicity, we always take cgroup_threadgroup_rwsem
with numeric PIDs.

This change improves migration dependent workload performance similar
to per-signal_struct state.

Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup-internal.h |  5 +++--
 kernel/cgroup/cgroup-v1.c       |  5 +++--
 kernel/cgroup/cgroup.c          | 39 +++++++++++++++++++++++++--------
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 236f290224aae..8dfb2526b3aa2 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -250,9 +250,10 @@ int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 
 int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 		       bool threadgroup);
-struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup)
+struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
+					     bool *locked)
 	__acquires(&cgroup_threadgroup_rwsem);
-void cgroup_procs_write_finish(struct task_struct *task)
+void cgroup_procs_write_finish(struct task_struct *task, bool locked)
 	__releases(&cgroup_threadgroup_rwsem);
 
 void cgroup_lock_and_drain_offline(struct cgroup *cgrp);
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 117d70098cd49..aa7577b189e92 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -498,12 +498,13 @@ static ssize_t __cgroup1_procs_write(struct kernfs_open_file *of,
 	struct task_struct *task;
 	const struct cred *cred, *tcred;
 	ssize_t ret;
+	bool locked;
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
 		return -ENODEV;
 
-	task = cgroup_procs_write_start(buf, threadgroup);
+	task = cgroup_procs_write_start(buf, threadgroup, &locked);
 	ret = PTR_ERR_OR_ZERO(task);
 	if (ret)
 		goto out_unlock;
@@ -526,7 +527,7 @@ static ssize_t __cgroup1_procs_write(struct kernfs_open_file *of,
 	ret = cgroup_attach_task(cgrp, task, threadgroup);
 
 out_finish:
-	cgroup_procs_write_finish(task);
+	cgroup_procs_write_finish(task, locked);
 out_unlock:
 	cgroup_kn_unlock(of->kn);
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 23f0db2900e4b..bc9ee9a18c1e8 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2856,7 +2856,8 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 	return ret;
 }
 
-struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup)
+struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
+					     bool *locked)
 	__acquires(&cgroup_threadgroup_rwsem)
 {
 	struct task_struct *tsk;
@@ -2865,7 +2866,21 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup)
 	if (kstrtoint(strstrip(buf), 0, &pid) || pid < 0)
 		return ERR_PTR(-EINVAL);
 
-	percpu_down_write(&cgroup_threadgroup_rwsem);
+	/*
+	 * If we migrate a single thread, we don't care about threadgroup
+	 * stability. If the thread is `current`, it won't exit(2) under our
+	 * hands or change PID through exec(2). We exclude
+	 * cgroup_update_dfl_csses and other cgroup_{proc,thread}s_write
+	 * callers by cgroup_mutex.
+	 * Therefore, we can skip the global lock.
+	 */
+	lockdep_assert_held(&cgroup_mutex);
+	if (pid || threadgroup) {
+		percpu_down_write(&cgroup_threadgroup_rwsem);
+		*locked = true;
+	} else {
+		*locked = false;
+	}
 
 	rcu_read_lock();
 	if (pid) {
@@ -2896,13 +2911,16 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup)
 	goto out_unlock_rcu;
 
 out_unlock_threadgroup:
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	if (*locked) {
+		percpu_up_write(&cgroup_threadgroup_rwsem);
+		*locked = false;
+	}
 out_unlock_rcu:
 	rcu_read_unlock();
 	return tsk;
 }
 
-void cgroup_procs_write_finish(struct task_struct *task)
+void cgroup_procs_write_finish(struct task_struct *task, bool locked)
 	__releases(&cgroup_threadgroup_rwsem)
 {
 	struct cgroup_subsys *ss;
@@ -2911,7 +2929,8 @@ void cgroup_procs_write_finish(struct task_struct *task)
 	/* release reference from cgroup_procs_write_start() */
 	put_task_struct(task);
 
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	if (locked)
+		percpu_up_write(&cgroup_threadgroup_rwsem);
 	for_each_subsys(ss, ssid)
 		if (ss->post_attach)
 			ss->post_attach();
@@ -4830,12 +4849,13 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	struct task_struct *task;
 	const struct cred *saved_cred;
 	ssize_t ret;
+	bool locked;
 
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!dst_cgrp)
 		return -ENODEV;
 
-	task = cgroup_procs_write_start(buf, true);
+	task = cgroup_procs_write_start(buf, true, &locked);
 	ret = PTR_ERR_OR_ZERO(task);
 	if (ret)
 		goto out_unlock;
@@ -4861,7 +4881,7 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	ret = cgroup_attach_task(dst_cgrp, task, true);
 
 out_finish:
-	cgroup_procs_write_finish(task);
+	cgroup_procs_write_finish(task, locked);
 out_unlock:
 	cgroup_kn_unlock(of->kn);
 
@@ -4881,6 +4901,7 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	struct task_struct *task;
 	const struct cred *saved_cred;
 	ssize_t ret;
+	bool locked;
 
 	buf = strstrip(buf);
 
@@ -4888,7 +4909,7 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	if (!dst_cgrp)
 		return -ENODEV;
 
-	task = cgroup_procs_write_start(buf, false);
+	task = cgroup_procs_write_start(buf, false, &locked);
 	ret = PTR_ERR_OR_ZERO(task);
 	if (ret)
 		goto out_unlock;
@@ -4919,7 +4940,7 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	ret = cgroup_attach_task(dst_cgrp, task, false);
 
 out_finish:
-	cgroup_procs_write_finish(task);
+	cgroup_procs_write_finish(task, locked);
 out_unlock:
 	cgroup_kn_unlock(of->kn);
 
-- 
2.35.1



