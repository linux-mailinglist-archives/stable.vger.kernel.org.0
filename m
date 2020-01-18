Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5F3141565
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 02:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgARBTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 20:19:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59277 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbgARBTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 20:19:17 -0500
Received: from ip5f5bf7da.dynamic.kabel-deutschland.de ([95.91.247.218] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1isclf-00023E-LX; Sat, 18 Jan 2020 01:19:15 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>
Cc:     stable@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        avagin@gmail.com, Christian Brauner <christian.brauner@ubuntu.com>,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH v4] ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()
Date:   Sat, 18 Jan 2020 02:19:08 +0100
Message-Id: <20200118011908.23582-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
introduced the ability to opt out of audit messages for accesses to various
proc files since they are not violations of policy.  While doing so it
somehow switched the check from ns_capable() to
has_ns_capability{_noaudit}(). That means it switched from checking the
subjective credentials of the task to using the objective credentials. This
is wrong since. ptrace_has_cap() is currently only used in
ptrace_may_access() And is used to check whether the calling task (subject)
has the CAP_SYS_PTRACE capability in the provided user namespace to operate
on the target task (object). According to the cred.h comments this would
mean the subjective credentials of the calling task need to be used.
This switches ptrace_has_cap() to use security_capable(). Because we only
call ptrace_has_cap() in ptrace_may_access() and in there we already have a
stable reference to the calling task's creds under rcu_read_lock() there's
no need to go through another series of dereferences and rcu locking done
in ns_capable{_noaudit}().

As one example where this might be particularly problematic, Jann pointed
out that in combination with the upcoming IORING_OP_OPENAT feature, this
bug might allow unprivileged users to bypass the capability checks while
asynchronously opening files like /proc/*/mem, because the capability
checks for this would be performed against kernel credentials.

To illustrate on the former point about this being exploitable: When
io_uring creates a new context it records the subjective credentials of the
caller. Later on, when it starts to do work it creates a kernel thread and
registers a callback. The callback runs with kernel creds for
ktask->real_cred and ktask->cred. To prevent this from becoming a
full-blown 0-day io_uring will call override_cred() and override
ktask->cred with the subjective credentials of the creator of the io_uring
instance. With ptrace_has_cap() currently looking at ktask->real_cred this
override will be ineffective and the caller will be able to open arbitray
proc files as mentioned above.
Luckily, this is currently not exploitable but will turn into a 0-day once
IORING_OP_OPENAT{2} land in v5.6. Fix it now!

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Kees Cook <keescook@chromium.org>
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
Link: https://lore.kernel.org/r/20200117105717.29803-1-christian.brauner@ubuntu.com
- Kees Cook <keescook@chromium.org>:
  - remove misleading reference to cread guard mutex from commit message
  - replace if-branches with ternary ?: operator

/* v4 */
- Kees Cook <keescook@chromium.org>:
  - use security_capable() == 0 on return
- Christian Brauner <christian.brauner@ubuntu.com>:
  - replace ?: operator with if-branches since we need to check against 0.
    This makes it more legible.
---
 kernel/ptrace.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index cb9ddcc08119..43d6179508d6 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -264,12 +264,17 @@ static int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 	return ret;
 }
 
-static int ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
+static bool ptrace_has_cap(const struct cred *cred, struct user_namespace *ns,
+			   unsigned int mode)
 {
+	int ret;
+
 	if (mode & PTRACE_MODE_NOAUDIT)
-		return has_ns_capability_noaudit(current, ns, CAP_SYS_PTRACE);
+		ret = security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NOAUDIT);
 	else
-		return has_ns_capability(current, ns, CAP_SYS_PTRACE);
+		ret = security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NONE);
+
+	return ret == 0;
 }
 
 /* Returns 0 on success, -errno on denial. */
@@ -321,7 +326,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	    gid_eq(caller_gid, tcred->sgid) &&
 	    gid_eq(caller_gid, tcred->gid))
 		goto ok;
-	if (ptrace_has_cap(tcred->user_ns, mode))
+	if (ptrace_has_cap(cred, tcred->user_ns, mode))
 		goto ok;
 	rcu_read_unlock();
 	return -EPERM;
@@ -340,7 +345,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
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

