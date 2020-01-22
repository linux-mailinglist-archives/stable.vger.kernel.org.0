Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31AC11450BC
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbgAVJlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:41:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387512AbgAVJlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:41:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C600D2467B;
        Wed, 22 Jan 2020 09:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686068;
        bh=ot8hwp/8hLHyv9MugBNFzAVIWfg9WE2OdwpixT40Vds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x409G7Y6aLPzwaap795B30+wmxvsMB4/GkaK6OircKlGQ/M6Ud7usYU8f16oGKbU5
         aAtwVlgmTlnNbpxJLsKgT4TAZmmJ10FT7qdPZ+4qZZNUG/suETdQTce5vr7xygBJ6R
         AA5VeqA921J+/mXBtOFk4i9fBfRXiHIlJGBgNiiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge@hallyn.com>, Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 4.19 031/103] ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()
Date:   Wed, 22 Jan 2020 10:28:47 +0100
Message-Id: <20200122092808.505127306@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 6b3ad6649a4c75504edeba242d3fd36b3096a57f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/ptrace.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -258,12 +258,17 @@ static int ptrace_check_attach(struct ta
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
@@ -315,7 +320,7 @@ static int __ptrace_may_access(struct ta
 	    gid_eq(caller_gid, tcred->sgid) &&
 	    gid_eq(caller_gid, tcred->gid))
 		goto ok;
-	if (ptrace_has_cap(tcred->user_ns, mode))
+	if (ptrace_has_cap(cred, tcred->user_ns, mode))
 		goto ok;
 	rcu_read_unlock();
 	return -EPERM;
@@ -334,7 +339,7 @@ ok:
 	mm = task->mm;
 	if (mm &&
 	    ((get_dumpable(mm) != SUID_DUMP_USER) &&
-	     !ptrace_has_cap(mm->user_ns, mode)))
+	     !ptrace_has_cap(cred, mm->user_ns, mode)))
 	    return -EPERM;
 
 	return security_ptrace_access_check(task, mode);


