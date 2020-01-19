Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B80DA141E92
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 15:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgASOh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 09:37:58 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:47621 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASOh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 09:37:58 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6F36B5D5;
        Sun, 19 Jan 2020 09:37:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 09:37:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qjgsmI
        29I7dJM1sARo2kpO9xMibW2KXJ7uvR7Sbi+jg=; b=YFweiP47n274Sjp60c0bZP
        hfX0UuDKRTdkA8JZn8KTx1zsCAFLahdLaS1Qf4XzTaq5UlZkYanYFENRai7gp4UV
        5eTVy+qL1gcUcCL9i/Oc5EeXpw5Q63Z29J1/Z23FvJVqdqkmwyMu2YRmedS4c3d7
        EcfV1kVRvJswgs2jOhkN5c+BfKXtrd1NuQdQUhwhmYliekqBiToNnv4WJedFAOkV
        UjSwzPM+KQykhyvj43CpStf44siTQfq+dxUUXRFJ+3coNFDjdoh8se2lYvjI0Mhw
        mxhx0jqC6DXbdsO4IrTO3lnOcEkI2X8vGOfcwbbT6Z/GjzIiH0RektRY21gauQUQ
        ==
X-ME-Sender: <xms:xGkkXj5CMg_EYHgiqg-4ZaEdzZlcHXR7uwUIxDx9KNo2JYp7Tbff_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:xGkkXlfP3exqFuqQ6TNsIRU5GE-4E8Kpm1ofG1oVVq8CT9DHde0IgA>
    <xmx:xGkkXu6qkyw8g5prs03IiK14cW9rc3y6SmavgLOuleBwCLT97bUMcg>
    <xmx:xGkkXq-cTs611nu38VUkWrh31hCkdrfvZVoyKdQoSQP5dJqO0_DQTQ>
    <xmx:xWkkXhUGMgZTZ-6Tvn1IO29HVxIudtEUVuuedjJOcObcymu2mzo22w>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 685F68005B;
        Sun, 19 Jan 2020 09:37:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] ptrace: reintroduce usage of subjective credentials in" failed to apply to 4.4-stable tree
To:     christian.brauner@ubuntu.com, eparis@redhat.com, jannh@google.com,
        keescook@chromium.org, oleg@redhat.com, serge@hallyn.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 15:37:53 +0100
Message-ID: <15794446731020@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

