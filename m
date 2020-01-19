Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82D1141E91
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 15:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgASOhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 09:37:53 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:49173 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASOhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 09:37:53 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 57A2A5CA;
        Sun, 19 Jan 2020 09:37:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 09:37:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KzimsM
        /MRoGX3zTvkIHrhi06uAJTfBWVR0osqq8wS7w=; b=fnXuXgCFv7FM6RZlZ+cjt0
        Nu5yhSt2f6qy5N8wW7tVX2T+eNzVbXxT8CK2A/1lFmftAyzHvb1kDHKGldkjplv6
        2jKLBZwXLNvJkKlaboO5RwRjhQQ3h/CNc/sodPjZMW0PWvWYJJf9L9hyNIMiCLtb
        ShxQtt7MVrZlUvASGOdXdN4bBms/IXNTMpMrJruTwdXfSD6reGnIjCdviFWMzQHj
        QD58d+XgEq+JuxN+izdHCD4pa8w2s3aZB25J1DbHWQdokH+CM5sqaUl3HnjKlFCE
        EXRLWv2RoPXW1/Xtp3sAuMrEmV/2pImXJ5XCK7k9/FTNY/FmJOC1dcV6CTuTdQTw
        ==
X-ME-Sender: <xms:v2kkXv-f607nIYPClMJa5sVO-Bbebz1X1XF0RgH3xJdYOwByrxgtew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:v2kkXtCSbokTOHtfwdytKoxfzv-tR1IEpEdea_xIIB4rksmfq-Jz0A>
    <xmx:v2kkXvep5WElrB98qoyV5L7wdotg-a2hq8fcVQXDG1UkFW7V6_dcUg>
    <xmx:v2kkXhGI7i82iS7C5KJe0xWONf3C2FDNnNEEelTzNck-XFyYwAnIzA>
    <xmx:v2kkXjCUyLJDBcBhbK2qir5_0uWRFDuSYRXZvQXtoGV0bAUarwm_pA>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 332F53060AA0;
        Sun, 19 Jan 2020 09:37:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] ptrace: reintroduce usage of subjective credentials in" failed to apply to 4.9-stable tree
To:     christian.brauner@ubuntu.com, eparis@redhat.com, jannh@google.com,
        keescook@chromium.org, oleg@redhat.com, serge@hallyn.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 15:37:48 +0100
Message-ID: <157944466812038@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6b3ad6649a4c75504edeba242d3fd36b3096a57f Mon Sep 17 00:00:00 2001
From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Wed, 15 Jan 2020 14:42:34 +0100
Subject: [PATCH] ptrace: reintroduce usage of subjective credentials in
 ptrace_has_cap()

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

