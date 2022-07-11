Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0182F56FF75
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiGKKuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiGKKuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:50:25 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8962AB23E8
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 02:56:42 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id j22so7951791ejs.2
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 02:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NSX/xBW7DHrHfSXMNRO6m8CDGZud++GK38COgrvyniE=;
        b=ez2P5ISDEvP1f4GJ3fb2hWnTTsI27B7NKky1W68XGRznubQSEgKdbJG3aK+d6LGLSP
         KyPsZxBEZR5HmWCUD4wzGDsTdD60yWGa3HglBtNGyy8wLaBJqBrO7kWLCPCNbIvDMCPq
         MbMA1T0pHJzzS1EwmNYmPHk64w7jgKMZakeZNHs/H2CfQU0ebWMZafMcvzOXUdRjT3tA
         rqucYszmuGGR2p/UdbcB/oIc2H1VwN5/7JbbDkFyEhxKrXAzQxFZKIe8OiFFXd89INKT
         wumvV9/MwdFA8ttdCx2iNySK/Erl04Ge3BEaq2nNRFodQWeA6b3orWggE9mQQ4/yCt8U
         J/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NSX/xBW7DHrHfSXMNRO6m8CDGZud++GK38COgrvyniE=;
        b=G5uou7aYkn3qggNZDjij3aAV3a41HC0TfSguvoruc2PI8RnT9w4hlJn+ks3dEZvL6q
         ywakh84GbPe0BbQyVUCDvoHihMX1uLq20rJUojiS/s4j/MV5P7e3n4zm6anTCkDESTbI
         6pHPsPESE7/kWUGJPnkPKzauKw9ClDJiI5wjLAyC7YSMsGFHj/pptMQ3+P+sgxUx0cUS
         UGSrFfDJJH+nbs4FciemBPdhHIIHbgRTAHtFLhB0WNASSvCzQrQ1UoUf/07RySUJy246
         KXsD7F/dx6DrjYjhdhNSXwiPFQTQjBi8S5shUI9eV3skuXBSog7miVvV0jMnD7egvMl6
         dhDA==
X-Gm-Message-State: AJIora9/PdqG9uQ4liIqugcm34gaqzPhz4t5/8DfiCnXaT73GFKWv5dA
        IlXyg9gi4pRcYmvsvsHZN+ylyGuODwO1cQ==
X-Google-Smtp-Source: AGRyM1sPWIS6+gnFbwwqeI+OsThQfVidkiUR3t6A4ftr9SxdBaVwyO/y2WIYMaXXHWt0xVM1q3rHVg==
X-Received: by 2002:a17:907:7242:b0:726:f510:4bfa with SMTP id ds2-20020a170907724200b00726f5104bfamr17442631ejc.219.1657533400726;
        Mon, 11 Jul 2022 02:56:40 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af09360009b69b4e98d64e49.dip0.t-ipconnect.de. [2003:f6:af09:3600:9b6:9b4e:98d6:4e49])
        by smtp.googlemail.com with ESMTPSA id vs24-20020a170907139800b00703671ebe65sm2480557ejb.198.2022.07.11.02.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 02:56:39 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 1/1] security,selinux,smack: kill security_task_wait hook
Date:   Mon, 11 Jul 2022 11:56:08 +0200
Message-Id: <20220711095608.4723-2-theflamefire89@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220711095608.4723-1-theflamefire89@gmail.com>
References: <20220711095608.4723-1-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
---
 include/linux/lsm_hooks.h  |  7 -------
 include/linux/security.h   |  6 ------
 kernel/exit.c              | 19 ++-----------------
 security/security.c        |  6 ------
 security/selinux/hooks.c   |  6 ------
 security/smack/smack_lsm.c | 20 --------------------
 6 files changed, 2 insertions(+), 62 deletions(-)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 53ac461f342b..491385a8a69d 100644
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
diff --git a/include/linux/security.h b/include/linux/security.h
index 2f5d282bd3ec..472822a1e02b 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -332,7 +332,6 @@ int security_task_getscheduler(struct task_struct *p);
 int security_task_movememory(struct task_struct *p);
 int security_task_kill(struct task_struct *p, struct siginfo *info,
 			int sig, u32 secid);
-int security_task_wait(struct task_struct *p);
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
@@ -980,11 +979,6 @@ static inline int security_task_kill(struct task_struct *p,
 	return 0;
 }
 
-static inline int security_task_wait(struct task_struct *p)
-{
-	return 0;
-}
-
 static inline int security_task_prctl(int option, unsigned long arg2,
 				      unsigned long arg3,
 				      unsigned long arg4,
diff --git a/kernel/exit.c b/kernel/exit.c
index 8716f0780fe3..e0db254a405b 100644
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
@@ -1342,7 +1341,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
  * Returns nonzero for a final return, when we have unlocked tasklist_lock.
  * Returns zero if the search for a child should continue;
  * then ->notask_error is 0 if @p is an eligible child,
- * or another error from security_task_wait(), or still -ECHILD.
+ * or still -ECHILD.
  */
 static int wait_consider_task(struct wait_opts *wo, int ptrace,
 				struct task_struct *p)
@@ -1362,20 +1361,6 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
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
@@ -1468,7 +1453,7 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
  * Returns nonzero for a final return, when we have unlocked tasklist_lock.
  * Returns zero if the search for a child should continue; then
  * ->notask_error is 0 if there were any eligible children,
- * or another error from security_task_wait(), or still -ECHILD.
+ * or still -ECHILD.
  */
 static int do_wait_thread(struct wait_opts *wo, struct task_struct *tsk)
 {
diff --git a/security/security.c b/security/security.c
index 9a13d72a6446..5171c3cd1d30 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1032,11 +1032,6 @@ int security_task_kill(struct task_struct *p, struct siginfo *info,
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
@@ -1776,7 +1771,6 @@ struct security_hook_heads security_hook_heads = {
 	.task_movememory =
 		LIST_HEAD_INIT(security_hook_heads.task_movememory),
 	.task_kill =	LIST_HEAD_INIT(security_hook_heads.task_kill),
-	.task_wait =	LIST_HEAD_INIT(security_hook_heads.task_wait),
 	.task_prctl =	LIST_HEAD_INIT(security_hook_heads.task_prctl),
 	.task_to_inode =
 		LIST_HEAD_INIT(security_hook_heads.task_to_inode),
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index eb9e2b4e81d9..eb503eccbacc 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3951,11 +3951,6 @@ static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
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
@@ -6220,7 +6215,6 @@ static struct security_hook_list selinux_hooks[] = {
 	LSM_HOOK_INIT(task_getscheduler, selinux_task_getscheduler),
 	LSM_HOOK_INIT(task_movememory, selinux_task_movememory),
 	LSM_HOOK_INIT(task_kill, selinux_task_kill),
-	LSM_HOOK_INIT(task_wait, selinux_task_wait),
 	LSM_HOOK_INIT(task_to_inode, selinux_task_to_inode),
 
 	LSM_HOOK_INIT(ipc_permission, selinux_ipc_permission),
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 84ed47195cdd..f01b69ead47e 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2276,25 +2276,6 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 	return rc;
 }
 
-/**
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
 /**
  * smack_task_to_inode - copy task smack into the inode blob
  * @p: task to copy from
@@ -4686,7 +4667,6 @@ static struct security_hook_list smack_hooks[] = {
 	LSM_HOOK_INIT(task_getscheduler, smack_task_getscheduler),
 	LSM_HOOK_INIT(task_movememory, smack_task_movememory),
 	LSM_HOOK_INIT(task_kill, smack_task_kill),
-	LSM_HOOK_INIT(task_wait, smack_task_wait),
 	LSM_HOOK_INIT(task_to_inode, smack_task_to_inode),
 
 	LSM_HOOK_INIT(ipc_permission, smack_ipc_permission),
-- 
2.25.1

