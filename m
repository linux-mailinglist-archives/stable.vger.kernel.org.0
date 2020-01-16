Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAF413FC60
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 23:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgAPWqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 17:46:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52793 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729261AbgAPWqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 17:46:53 -0500
Received: from ip5f5bd663.dynamic.kabel-deutschland.de ([95.91.214.99] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1isDud-0002el-3a; Thu, 16 Jan 2020 22:46:51 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>
Cc:     stable@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Eric Paris <eparis@redhat.com>
Subject: [REVIEW PATCH v2] ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()
Date:   Thu, 16 Jan 2020 23:45:18 +0100
Message-Id: <20200116224518.30598-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
introduced the ability to opt out of audit messages for accesses to
various proc files since they are not violations of policy.
While doing so it somehow switched the check from ns_capable() to
has_ns_capability{_noaudit}(). That means it switched from checking the
subjective credentials of the task to using the objective credentials. I
couldn't find the original lkml thread and so I don't know why this switch
was done. But it seems wrong since ptrace_has_cap() is currently only used
in ptrace_may_access(). And it's used to check whether the calling task
(subject) has the CAP_SYS_PTRACE capability in the provided user namespace
to operate on the target task (object). According to the cred.h comments
this would mean the subjective credentials of the calling task need to be
used.
This switches it to use security_capable() because we only call
ptrace_has_cap() in ptrace_may_access() and in there we already have a
stable reference to the calling tasks creds under cred_guard_mutex so
there's no need to go through another series of dereferences and rcu
locking done in ns_capable{_noaudit}().

As one example where this might be particularly problematic, Jann pointed
out that in combination with the upcoming IORING_OP_OPENAT feature, this
bug might allow unprivileged users to bypass the capability checks while
asynchronously opening files like /proc/*/mem, because the capability
checks for this would be performed against kernel credentials.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Serge Hallyn <serge@hallyn.com>
Reviewed-by: Jann Horn <jannh@google.com>
Fixes: 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 kernel/ptrace.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index cb9ddcc08119..d146133e97f1 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -264,12 +264,13 @@ static int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 	return ret;
 }
 
-static int ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
+static int ptrace_has_cap(const struct cred *cred, struct user_namespace *ns,
+			  unsigned int mode)
 {
 	if (mode & PTRACE_MODE_NOAUDIT)
-		return has_ns_capability_noaudit(current, ns, CAP_SYS_PTRACE);
+		return security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NOAUDIT);
 	else
-		return has_ns_capability(current, ns, CAP_SYS_PTRACE);
+		return security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NONE);
 }
 
 /* Returns 0 on success, -errno on denial. */
@@ -321,7 +322,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	    gid_eq(caller_gid, tcred->sgid) &&
 	    gid_eq(caller_gid, tcred->gid))
 		goto ok;
-	if (ptrace_has_cap(tcred->user_ns, mode))
+	if (ptrace_has_cap(cred, tcred->user_ns, mode))
 		goto ok;
 	rcu_read_unlock();
 	return -EPERM;
@@ -340,7 +341,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	mm = task->mm;
 	if (mm &&
 	    ((get_dumpable(mm) != SUID_DUMP_USER) &&
-	     !ptrace_has_cap(mm->user_ns, mode)))
+	     !ptrace_has_cap(cred, mm->user_ns, mode)))
 	    return -EPERM;
 
 	return security_ptrace_access_check(task, mode);

base-commit: b3a987b0264d3ddbb24293ebff10eddfc472f653
-- 
2.25.0

