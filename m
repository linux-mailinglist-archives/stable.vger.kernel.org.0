Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C91E2A05B6
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 13:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgJ3MrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 08:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgJ3MrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 08:47:01 -0400
Received: from smtp-190f.mail.infomaniak.ch (smtp-190f.mail.infomaniak.ch [IPv6:2001:1600:3:17::190f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7E7C0613D2
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 05:47:01 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4CN21F6GMlzlhjZL;
        Fri, 30 Oct 2020 13:38:57 +0100 (CET)
Received: from localhost (unknown [94.23.54.103])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4CN21F2JzKzlh8TF;
        Fri, 30 Oct 2020 13:38:57 +0100 (CET)
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Eric Paris <eparis@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Subject: [PATCH v1 1/2] ptrace: Set PF_SUPERPRIV when checking capability
Date:   Fri, 30 Oct 2020 13:38:48 +0100
Message-Id: <20201030123849.770769-2-mic@digikod.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030123849.770769-1-mic@digikod.net>
References: <20201030123849.770769-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mickaël Salaün <mic@linux.microsoft.com>

Commit 69f594a38967 ("ptrace: do not audit capability check when outputing
/proc/pid/stat") replaced the use of ns_capable() with
has_ns_capability{,_noaudit}() which doesn't set PF_SUPERPRIV.

Commit 6b3ad6649a4c ("ptrace: reintroduce usage of subjective credentials in
ptrace_has_cap()") replaced has_ns_capability{,_noaudit}() with
security_capable(), which doesn't set PF_SUPERPRIV neither.

Since commit 98f368e9e263 ("kernel: Add noaudit variant of ns_capable()"), a
new ns_capable_noaudit() helper is available.  Let's use it!

As a result, the signature of ptrace_has_cap() is restored to its original one.

Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: stable@vger.kernel.org
Fixes: 6b3ad6649a4c ("ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()")
Fixes: 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
---
 kernel/ptrace.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 43d6179508d6..aa3c2fd6e41b 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -264,23 +264,17 @@ static int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 	return ret;
 }
 
-static bool ptrace_has_cap(const struct cred *cred, struct user_namespace *ns,
-			   unsigned int mode)
+static bool ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
 {
-	int ret;
-
 	if (mode & PTRACE_MODE_NOAUDIT)
-		ret = security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NOAUDIT);
-	else
-		ret = security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NONE);
-
-	return ret == 0;
+		return ns_capable_noaudit(ns, CAP_SYS_PTRACE);
+	return ns_capable(ns, CAP_SYS_PTRACE);
 }
 
 /* Returns 0 on success, -errno on denial. */
 static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
-	const struct cred *cred = current_cred(), *tcred;
+	const struct cred *const cred = current_cred(), *tcred;
 	struct mm_struct *mm;
 	kuid_t caller_uid;
 	kgid_t caller_gid;
@@ -326,7 +320,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	    gid_eq(caller_gid, tcred->sgid) &&
 	    gid_eq(caller_gid, tcred->gid))
 		goto ok;
-	if (ptrace_has_cap(cred, tcred->user_ns, mode))
+	if (ptrace_has_cap(tcred->user_ns, mode))
 		goto ok;
 	rcu_read_unlock();
 	return -EPERM;
@@ -345,7 +339,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	mm = task->mm;
 	if (mm &&
 	    ((get_dumpable(mm) != SUID_DUMP_USER) &&
-	     !ptrace_has_cap(cred, mm->user_ns, mode)))
+	     !ptrace_has_cap(mm->user_ns, mode)))
 	    return -EPERM;
 
 	return security_ptrace_access_check(task, mode);
-- 
2.28.0

