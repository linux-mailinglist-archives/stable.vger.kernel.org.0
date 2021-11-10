Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF2844CD56
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 23:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhKJXCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 18:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbhKJXCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 18:02:02 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0FBC06127A
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 14:59:14 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 65-20020a630344000000b002d9865f61efso2227849pgd.16
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 14:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=p1cUwGeUQEoJHf6xV2cI3doT5ZXMV67Wi7GVtUTV4SQ=;
        b=OUzrqS4gMaapy3MUtH5lYIQp3NZRI7ZMZWiBxjefaOKXav7J0oDqev/jUipr14Zp8M
         8p6OEgK5TTKJ1nYhAEb9krLQ2AgxnESBejstYj7qa/RlTQeIqfM7zHSmLZ9lGYNmRVFn
         eWjhAl0bvZ3rhYG8LxZn+F4lLJw/4ib0WdDpydux216zEXMhOuMohzCins0Y/K91L/8R
         GDNSJ8Asfbp63BEq/XySRIF9tuZbHlPGjcIjwZgOXe+Vqc58cbdqPw60cZj/vAZrLvzo
         L5JMaci9MrCophJR6GffVcY6lEuEFpnd2Q04gKB8O8JMF+5v2iwaReFBWCoMs6afCyP5
         IRZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=p1cUwGeUQEoJHf6xV2cI3doT5ZXMV67Wi7GVtUTV4SQ=;
        b=vNWzaQzmE54Q4aGW6zIYdAu/E2bvxgm0DXoNKOFLf1Qfzta4ygcaVlcDP0fdQuV1gM
         VR3Rn/dvNa2qFw9jl2mjrpB2c5rK1qMLm77spVp6ititXi0h4uaxo0Ah0Qfp7VGirk+V
         r1972gaAWT+Hk3FCt5sd5OL/YjC8C0OML3YKmjUI4fa285Qas+KxObPxfKB+5wcD+V2+
         x3f8RibLVMlVLKPLfc/RVLXeKK/e1MQagaLiFLYuaSohvRWIDmm4A4g5RKBUcVb9TXwc
         rzBMXvFX28k61nFKP2YQjq6XFcUmVjnJ5bedMflPhvCdrJPeNnKbNfl85Z0T66yexA0g
         9zwg==
X-Gm-Message-State: AOAM533NTEwFesnrh6Y9EuUZ8AXl3SoYYms863d5y9LIHx2F3mZVmHRL
        LTo6DPyqVkhrRBA82Aw93ieWIC3fGWpq7czagIoWizPllATDmymB7MmSAPrsv8sxhG3ks7QuPlb
        O9f+jjwFbsdEjo7iU9/teLfGM9Ut26eAG2z9ldkhvH5sKbSyuQbaJFwYYQjU=
X-Google-Smtp-Source: ABdhPJx8OM9lbwEHeee/6MmNE9uSeAsDUzkWj+Kh/NMxddkxbhM/xrWica1uv/CKrpAZRNhmuTexqemMjA==
X-Received: from tkjos-desktop.mtv.corp.google.com ([2620:15c:211:200:4a73:99b6:9694:8c4d])
 (user=tkjos job=sendgmr) by 2002:a05:6a00:99e:b0:49f:f9e2:c116 with SMTP id
 u30-20020a056a00099e00b0049ff9e2c116mr2608493pfg.83.1636585153738; Wed, 10
 Nov 2021 14:59:13 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:59:09 -0800
Message-Id: <20211110225910.3268106-1-tkjos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 4.4 1/2] binder: use euid from cred instead of using task
From:   Todd Kjos <tkjos@google.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, keescook@chromium.org, jannh@google.com,
        jeffv@google.com, zohar@linux.ibm.com,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc:     joel@joelfernandes.org, kernel-team@android.com,
        Todd Kjos <tkjos@google.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 29bc22ac5e5bc63275e850f0c8fc549e3d0e306b upstream.

Save the 'struct cred' associated with a binder process
at initial open to avoid potential race conditions
when converting to an euid.

Set a transaction's sender_euid from the 'struct cred'
saved at binder_open() instead of looking up the euid
from the binder proc's 'struct task'. This ensures
the euid is associated with the security context that
of the task that opened binder.

Cc: stable@vger.kernel.org # 4.4+
Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Signed-off-by: Todd Kjos <tkjos@google.com>
Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Suggested-by: Jann Horn <jannh@google.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Change-Id: I91922e7f359df5901749f1b09094c3c68d45aed4
---
 drivers/android/binder.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 3bc5a7caccbf..0b27238b42c7 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -303,6 +303,7 @@ struct binder_proc {
 	struct mm_struct *vma_vm_mm;
 	struct task_struct *tsk;
 	struct files_struct *files;
+	const struct cred *cred;
 	struct hlist_node deferred_work_node;
 	int deferred_work;
 	void *buffer;
@@ -1493,7 +1494,7 @@ static void binder_transaction(struct binder_proc *proc,
 		t->from = thread;
 	else
 		t->from = NULL;
-	t->sender_euid = task_euid(proc->tsk);
+	t->sender_euid = proc->cred->euid;
 	t->to_proc = target_proc;
 	t->to_thread = target_thread;
 	t->code = tr->code;
@@ -3015,6 +3016,7 @@ static int binder_open(struct inode *nodp, struct file *filp)
 		return -ENOMEM;
 	get_task_struct(current->group_leader);
 	proc->tsk = current->group_leader;
+	proc->cred = get_cred(filp->f_cred);
 	INIT_LIST_HEAD(&proc->todo);
 	init_waitqueue_head(&proc->wait);
 	proc->default_priority = task_nice(current);
@@ -3220,6 +3222,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 	}
 
 	put_task_struct(proc->tsk);
+	put_cred(proc->cred);
 
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
 		     "%s: %d threads %d, nodes %d (ref %d), refs %d, active transactions %d, buffers %d, pages %d\n",
-- 
2.34.0.rc0.344.g81b53c2807-goog

