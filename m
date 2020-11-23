Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505F42C0B76
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389097AbgKWNZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:25:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731212AbgKWMd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:33:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 796142065E;
        Mon, 23 Nov 2020 12:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134805;
        bh=QMmUiflosflNQFXLXUur3KFYJHIusEcaRmsEfAOoN1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToC8Z5AuSKXOdM54r71A2Q0zEMCQvuEdzjFxYaJiQddDMOES4R5TbULIZ5YzvHqOP
         w5dVW0T7Mgqrjnwl0vJxxf2qUt8Bq7LnDt6h95gIm8GQ7hf9lxxDMBMl7GltbTWVO1
         aLRzu4de3fawo2pEFNqHBhG+NZnp79EXTKSACF3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Eric Paris <eparis@redhat.com>, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Subject: [PATCH 4.19 88/91] ptrace: Set PF_SUPERPRIV when checking capability
Date:   Mon, 23 Nov 2020 13:22:48 +0100
Message-Id: <20201123121813.595323104@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mickaël Salaün <mic@linux.microsoft.com>

commit cf23705244c947151179f929774fabf71e239eee upstream.

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
Reviewed-by: Jann Horn <jannh@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20201030123849.770769-2-mic@digikod.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/ptrace.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -258,17 +258,11 @@ static int ptrace_check_attach(struct ta
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
@@ -320,7 +314,7 @@ static int __ptrace_may_access(struct ta
 	    gid_eq(caller_gid, tcred->sgid) &&
 	    gid_eq(caller_gid, tcred->gid))
 		goto ok;
-	if (ptrace_has_cap(cred, tcred->user_ns, mode))
+	if (ptrace_has_cap(tcred->user_ns, mode))
 		goto ok;
 	rcu_read_unlock();
 	return -EPERM;
@@ -339,7 +333,7 @@ ok:
 	mm = task->mm;
 	if (mm &&
 	    ((get_dumpable(mm) != SUID_DUMP_USER) &&
-	     !ptrace_has_cap(cred, mm->user_ns, mode)))
+	     !ptrace_has_cap(mm->user_ns, mode)))
 	    return -EPERM;
 
 	return security_ptrace_access_check(task, mode);


