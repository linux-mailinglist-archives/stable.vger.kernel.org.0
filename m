Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56B742AA16
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 18:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhJLQ60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 12:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbhJLQ6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 12:58:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF8CC061745
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 09:56:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z130-20020a256588000000b005b6b4594129so27995932ybb.15
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 09:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Mwae8Ejzsmbhdp150195SP11OIoOnZHvR8wRYQamjXg=;
        b=RZ/VZBHl1HvOJwMNfn/wyOhkRQ7x7ZEERi3vIgiH1zWADtTrwOSu3msb+uBQ5z/+zo
         3SRgiJvV5Bx+HU9qQk24SooKq+aeGWwJss5ZPBHS18wTHIs5bVhCRZepq/qdObdMRKhb
         L1wunp82irR9mtPFWffaUV6KsDXII0nGdD20NleN0KqbzWVC0208pZOT4d+D6JotJ37o
         UPIzghFGIDn7oYQl0tpPAzhBjUOcRPP9Kw9hiNXU/AnPuXDgVwQKx2bRncxoSta3kYEd
         Vx9wTcnVuNVEYNH+hD6dM+xkjcqPgRqRdXv15pXgw/bjcpW3pwF2Tj7rlUe6rXYhVq4a
         10uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Mwae8Ejzsmbhdp150195SP11OIoOnZHvR8wRYQamjXg=;
        b=fYRd7X784VTtso5L9UWm5BSoDAwJPwKjJJRrzvl/pyPs7wYNgpZXpmGMMV8AoGtvte
         Y62O1F1oJI73/anpLuMEVCcP7qP8ycCJX1YUXViP6BNsaAPZJ7KOn35zy59g1xt4mMNq
         1ycXE22fP+FPirzugmqHTyuOiTPsd5pRT2Q/ZIcBBl8yoqUwmwXEiCkYwsJQdjs9RBR9
         G+ZvKzC5tOX5tFr1igFStGdmr5GbN9QZT6/gZ+JKbZW0ACsqtY9hJBVoVeClceGUIMuT
         TcQ82QwWiFTXWA/eYh4+FMe15kCi9yvVHOvyFZ1UhHK76ziEEerTfnm/RHEHgUQolz6K
         0+0Q==
X-Gm-Message-State: AOAM530/R89jPYvReQ+cQsxLPbrVfvNJChLqNNUGxys0lmncOajDYSgF
        C9ucfzplEj3iZ7fe1lwa5ciPL12K3w==
X-Google-Smtp-Source: ABdhPJzyTWT16jc0uAEpzHgNTjY8P3Cae43hy5GOBsxaWT1o4sIRwdkN+OAgexPrM9Wj0PqxVQ4ruuYa6g==
X-Received: from ava-linux2.mtv.corp.google.com ([2620:15c:211:200:39c7:8168:c0b2:b46e])
 (user=tkjos job=sendgmr) by 2002:a25:d94d:: with SMTP id q74mr29250835ybg.196.1634057781619;
 Tue, 12 Oct 2021 09:56:21 -0700 (PDT)
Date:   Tue, 12 Oct 2021 09:56:12 -0700
In-Reply-To: <20211012165614.2873369-1-tkjos@google.com>
Message-Id: <20211012165614.2873369-2-tkjos@google.com>
Mime-Version: 1.0
References: <20211012165614.2873369-1-tkjos@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v5 1/3] binder: use euid from cred instead of using task
From:   Todd Kjos <tkjos@google.com>
To:     gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com,
        maco@android.com, christian@brauner.io, jmorris@namei.org,
        serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, jannh@google.com, jeffv@google.com,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc:     joel@joelfernandes.org, kernel-team@android.com,
        Todd Kjos <tkjos@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Save the 'struct cred' associated with a binder process
at initial open to avoid potential race conditions
when converting to an euid.

Set a transaction's sender_euid from the 'struct cred'
saved at binder_open() instead of looking up the euid
from the binder proc's 'struct task'. This ensures
the euid is associated with the security context that
of the task that opened binder.

Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Signed-off-by: Todd Kjos <tkjos@google.com>
Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Suggested-by: Jann Horn <jannh@google.com>
Cc: stable@vger.kernel.org # 4.4+
---
v3: added this patch to series (as 3/3)
v5:
- combined with saving of 'struct cred' during binder_open()
- reordered to 1/1 as suggested by Stephen Smalley

 drivers/android/binder.c          | 4 +++-
 drivers/android/binder_internal.h | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 9edacc8b9768..a396015e874a 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2711,7 +2711,7 @@ static void binder_transaction(struct binder_proc *proc,
 		t->from = thread;
 	else
 		t->from = NULL;
-	t->sender_euid = task_euid(proc->tsk);
+	t->sender_euid = proc->cred->euid;
 	t->to_proc = target_proc;
 	t->to_thread = target_thread;
 	t->code = tr->code;
@@ -4353,6 +4353,7 @@ static void binder_free_proc(struct binder_proc *proc)
 	}
 	binder_alloc_deferred_release(&proc->alloc);
 	put_task_struct(proc->tsk);
+	put_cred(proc->cred);
 	binder_stats_deleted(BINDER_STAT_PROC);
 	kfree(proc);
 }
@@ -5055,6 +5056,7 @@ static int binder_open(struct inode *nodp, struct file *filp)
 	spin_lock_init(&proc->outer_lock);
 	get_task_struct(current->group_leader);
 	proc->tsk = current->group_leader;
+	proc->cred = get_cred(filp->f_cred);
 	INIT_LIST_HEAD(&proc->todo);
 	init_waitqueue_head(&proc->freeze_wait);
 	proc->default_priority = task_nice(current);
diff --git a/drivers/android/binder_internal.h b/drivers/android/binder_internal.h
index 402c4d4362a8..d6b6b8cb7346 100644
--- a/drivers/android/binder_internal.h
+++ b/drivers/android/binder_internal.h
@@ -364,6 +364,9 @@ struct binder_ref {
  *                        (invariant after initialized)
  * @tsk                   task_struct for group_leader of process
  *                        (invariant after initialized)
+ * @cred                  struct cred associated with the `struct file`
+ *                        in binder_open()
+ *                        (invariant after initialized)
  * @deferred_work_node:   element for binder_deferred_list
  *                        (protected by binder_deferred_lock)
  * @deferred_work:        bitmap of deferred work to perform
@@ -426,6 +429,7 @@ struct binder_proc {
 	struct list_head waiting_threads;
 	int pid;
 	struct task_struct *tsk;
+	const struct cred *cred;
 	struct hlist_node deferred_work_node;
 	int deferred_work;
 	int outstanding_txns;
-- 
2.33.0.882.g93a45727a2-goog

