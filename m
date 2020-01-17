Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDEC614087A
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 11:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgAQK5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 05:57:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41441 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgAQK5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 05:57:43 -0500
Received: from ip5f5bd679.dynamic.kabel-deutschland.de ([95.91.214.121] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1isPJt-0006EA-BV; Fri, 17 Jan 2020 10:57:41 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>
Cc:     stable@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH v3] ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()
Date:   Fri, 17 Jan 2020 11:57:18 +0100
Message-Id: <20200117105717.29803-1-christian.brauner@ubuntu.com>
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
stable reference to the calling tasks creds under rcu_read_lock() so
there's no need to go through another series of dereferences and rcu
locking done in ns_capable{_noaudit}().

As one example where this might be particularly problematic, Jann pointed
out that in combination with the upcoming IORING_OP_OPENAT feature, this
bug might allow unprivileged users to bypass the capability checks while
asynchronously opening files like /proc/*/mem, because the capability
checks for this would be performed against kernel credentials.

Cc: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Serge Hallyn <serge@hallyn.com>
Reviewed-by: Jann Horn <jannh@google.com>
Fixes: 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v1 */
Link: https://lore.kernel.org/r/20200115171736.16994-1-christian.brauner@ubuntu.com

/* v2 */
Link: https://lore.kernel.org/r/20200116224518.30598-1-christian.brauner@ubuntu.com
- Christian Brauner <christian.brauner@ubuntu.com>:
  - fix incorrect CAP_OPT_NOAUDIT, CAPT_OPT_NONE order

/* v3 */
- Kees Cook <keescook@chromium.org>:
  - remove misleading reference to cread guard mutex from commit message
  - replace if-branches with ternary ?: operator
---
 kernel/ptrace.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index cb9ddcc08119..6eb3ccf180e0 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -264,12 +264,12 @@ static int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 	return ret;
 }
 
-static int ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
+static int ptrace_has_cap(const struct cred *cred, struct user_namespace *ns,
+			  unsigned int mode)
 {
-	if (mode & PTRACE_MODE_NOAUDIT)
-		return has_ns_capability_noaudit(current, ns, CAP_SYS_PTRACE);
-	else
-		return has_ns_capability(current, ns, CAP_SYS_PTRACE);
+	return security_capable(cred, ns, CAP_SYS_PTRACE,
+				(mode & PTRACE_MODE_NOAUDIT) ? CAP_OPT_NOAUDIT :
+							       CAP_OPT_NONE);
 }
 
 /* Returns 0 on success, -errno on denial. */
@@ -321,7 +321,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	    gid_eq(caller_gid, tcred->sgid) &&
 	    gid_eq(caller_gid, tcred->gid))
 		goto ok;
-	if (ptrace_has_cap(tcred->user_ns, mode))
+	if (ptrace_has_cap(cred, tcred->user_ns, mode))
 		goto ok;
 	rcu_read_unlock();
 	return -EPERM;
@@ -340,7 +340,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
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

