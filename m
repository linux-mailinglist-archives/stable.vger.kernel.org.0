Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C17C582A94
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiG0QVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiG0QVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:21:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844884B0DD;
        Wed, 27 Jul 2022 09:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EF9CB821B9;
        Wed, 27 Jul 2022 16:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60452C433D6;
        Wed, 27 Jul 2022 16:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658938884;
        bh=8xn9SkNodxw1bPbX8y0h2pTKciuSRCgCxEkMiLnTFr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKIKe+HuS7rCS/qWGVR1lEIFrzI84fOA20JAUSFJIrF2GJ6lp34X8VHNE+Wby7yHe
         H9aiFtat3UvdyIVOZGxbxEyVQuaRQTsUHY2ftJxWtYyMyDWV2hcbKlANyskUImMiDE
         XcE3Lt74j7T0h5R1AhTZRdnyX85dvBOSVWrH0hVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangshukui <yangshukui@huawei.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 01/26] security,selinux,smack: kill security_task_wait hook
Date:   Wed, 27 Jul 2022 18:10:30 +0200
Message-Id: <20220727160959.177769342@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727160959.122591422@linuxfoundation.org>
References: <20220727160959.122591422@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

commit 3a2f5a59a695a73e0cde9a61e0feae5fa730e936 upstream.

As reported by yangshukui, a permission denial from security_task_wait()
can lead to a soft lockup in zap_pid_ns_processes() since it only expects
sys_wait4() to return 0 or -ECHILD. Further, security_task_wait() can
in general lead to zombies; in the absence of some way to automatically
reparent a child process upon a denial, the hook is not useful.  Remove
the security hook and its implementations in SELinux and Smack.  Smack
already removed its check from its hook.

Reported-by: yangshukui <yangshukui@huawei.com>
Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/lsm_hooks.h  |    7 -------
 include/linux/security.h   |    6 ------
 kernel/exit.c              |   19 ++-----------------
 security/security.c        |    6 ------
 security/selinux/hooks.c   |    6 ------
 security/smack/smack_lsm.c |   20 --------------------
 6 files changed, 2 insertions(+), 62 deletions(-)

--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -666,11 +666,6 @@
  *	@sig contains the signal value.
  *	@secid contains the sid of the process where the signal originated
  *	Return 0 if permission is granted.
- * @task_wait:
- *	Check permission before allowing a process to reap a child process @p
- *	and collect its status information.
- *	@p contains the task_struct for process.
- *	Return 0 if permission is granted.
  * @task_prctl:
  *	Check permission before performing a process control operation on the
  *	current process.
@@ -1507,7 +1502,6 @@ union security_list_options {
 	int (*task_movememory)(struct task_struct *p);
 	int (*task_kill)(struct task_struct *p, struct siginfo *info,
 				int sig, u32 secid);
-	int (*task_wait)(struct task_struct *p);
 	int (*task_prctl)(int option, unsigned long arg2, unsigned long arg3,
 				unsigned long arg4, unsigned long arg5);
 	void (*task_to_inode)(struct task_struct *p, struct inode *inode);
@@ -1768,7 +1762,6 @@ struct security_hook_heads {
 	struct list_head task_getscheduler;
 	struct list_head task_movememory;
 	struct list_head task_kill;
-	struct list_head task_wait;
 	struct list_head task_prctl;
 	struct list_head task_to_inode;
 	struct list_head ipc_permission;
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -332,7 +332,6 @@ int security_task_getscheduler(struct ta
 int security_task_movememory(struct task_struct *p);
 int security_task_kill(struct task_struct *p, struct siginfo *info,
 			int sig, u32 secid);
-int security_task_wait(struct task_struct *p);
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
@@ -979,11 +978,6 @@ static inline int security_task_kill(str
 {
 	return 0;
 }
-
-static inline int security_task_wait(struct task_struct *p)
-{
-	return 0;
-}
 
 static inline int security_task_prctl(int option, unsigned long arg2,
 				      unsigned long arg3,
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -14,7 +14,6 @@
 #include <linux/tty.h>
 #include <linux/iocontext.h>
 #include <linux/key.h>
-#include <linux/security.h>
 #include <linux/cpu.h>
 #include <linux/acct.h>
 #include <linux/tsacct_kern.h>
@@ -1342,7 +1341,7 @@ static int wait_task_continued(struct wa
  * Returns nonzero for a final return, when we have unlocked tasklist_lock.
  * Returns zero if the search for a child should continue;
  * then ->notask_error is 0 if @p is an eligible child,
- * or another error from security_task_wait(), or still -ECHILD.
+ * or still -ECHILD.
  */
 static int wait_consider_task(struct wait_opts *wo, int ptrace,
 				struct task_struct *p)
@@ -1362,20 +1361,6 @@ static int wait_consider_task(struct wai
 	if (!ret)
 		return ret;
 
-	ret = security_task_wait(p);
-	if (unlikely(ret < 0)) {
-		/*
-		 * If we have not yet seen any eligible child,
-		 * then let this error code replace -ECHILD.
-		 * A permission error will give the user a clue
-		 * to look for security policy problems, rather
-		 * than for mysterious wait bugs.
-		 */
-		if (wo->notask_error)
-			wo->notask_error = ret;
-		return 0;
-	}
-
 	if (unlikely(exit_state == EXIT_TRACE)) {
 		/*
 		 * ptrace == 0 means we are the natural parent. In this case
@@ -1468,7 +1453,7 @@ static int wait_consider_task(struct wai
  * Returns nonzero for a final return, when we have unlocked tasklist_lock.
  * Returns zero if the search for a child should continue; then
  * ->notask_error is 0 if there were any eligible children,
- * or another error from security_task_wait(), or still -ECHILD.
+ * or still -ECHILD.
  */
 static int do_wait_thread(struct wait_opts *wo, struct task_struct *tsk)
 {
--- a/security/security.c
+++ b/security/security.c
@@ -1032,11 +1032,6 @@ int security_task_kill(struct task_struc
 	return call_int_hook(task_kill, 0, p, info, sig, secid);
 }
 
-int security_task_wait(struct task_struct *p)
-{
-	return call_int_hook(task_wait, 0, p);
-}
-
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			 unsigned long arg4, unsigned long arg5)
 {
@@ -1776,7 +1771,6 @@ struct security_hook_heads security_hook
 	.task_movememory =
 		LIST_HEAD_INIT(security_hook_heads.task_movememory),
 	.task_kill =	LIST_HEAD_INIT(security_hook_heads.task_kill),
-	.task_wait =	LIST_HEAD_INIT(security_hook_heads.task_wait),
 	.task_prctl =	LIST_HEAD_INIT(security_hook_heads.task_prctl),
 	.task_to_inode =
 		LIST_HEAD_INIT(security_hook_heads.task_to_inode),
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3951,11 +3951,6 @@ static int selinux_task_kill(struct task
 	return rc;
 }
 
-static int selinux_task_wait(struct task_struct *p)
-{
-	return task_has_perm(p, current, PROCESS__SIGCHLD);
-}
-
 static void selinux_task_to_inode(struct task_struct *p,
 				  struct inode *inode)
 {
@@ -6220,7 +6215,6 @@ static struct security_hook_list selinux
 	LSM_HOOK_INIT(task_getscheduler, selinux_task_getscheduler),
 	LSM_HOOK_INIT(task_movememory, selinux_task_movememory),
 	LSM_HOOK_INIT(task_kill, selinux_task_kill),
-	LSM_HOOK_INIT(task_wait, selinux_task_wait),
 	LSM_HOOK_INIT(task_to_inode, selinux_task_to_inode),
 
 	LSM_HOOK_INIT(ipc_permission, selinux_ipc_permission),
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2277,25 +2277,6 @@ static int smack_task_kill(struct task_s
 }
 
 /**
- * smack_task_wait - Smack access check for waiting
- * @p: task to wait for
- *
- * Returns 0
- */
-static int smack_task_wait(struct task_struct *p)
-{
-	/*
-	 * Allow the operation to succeed.
-	 * Zombies are bad.
-	 * In userless environments (e.g. phones) programs
-	 * get marked with SMACK64EXEC and even if the parent
-	 * and child shouldn't be talking the parent still
-	 * may expect to know when the child exits.
-	 */
-	return 0;
-}
-
-/**
  * smack_task_to_inode - copy task smack into the inode blob
  * @p: task to copy from
  * @inode: inode to copy to
@@ -4686,7 +4667,6 @@ static struct security_hook_list smack_h
 	LSM_HOOK_INIT(task_getscheduler, smack_task_getscheduler),
 	LSM_HOOK_INIT(task_movememory, smack_task_movememory),
 	LSM_HOOK_INIT(task_kill, smack_task_kill),
-	LSM_HOOK_INIT(task_wait, smack_task_wait),
 	LSM_HOOK_INIT(task_to_inode, smack_task_to_inode),
 
 	LSM_HOOK_INIT(ipc_permission, smack_ipc_permission),


