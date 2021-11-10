Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C86B44CD68
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 00:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbhKJXC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 18:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbhKJXC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 18:02:56 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25190C06127A
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 15:00:08 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id a127-20020a627f85000000b0047feae4a8d9so2725774pfd.19
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 15:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NNtCs/5Asdgm6ZFGpEfa7ooseuLLQp0DNLVc8QA+Qxc=;
        b=nhsM5qNip0GWTl9WLxLWO7V0RpbBb3DBIwEXUFpkD8bnYnN5+ssWx72X1tjMx/FB70
         Pbrlo9F3YwOPaIWGQ7mdUTMjeaXwxUvGKli9we7tCM8rn20LRx/C7bkrGiqPRgCSC/OT
         4ixMSL2lX1R93/wddvuP+Vow7Ep2d91vRYRvrWypAQSOkzx4E/uoZubrqAceVibTbN87
         cZl9jCnBh4PhjmAp8YbYLd/AOQX0Xl9fn1AcjMVZaxvTWab0jdm9emKpjBV6OGDK7dWv
         QmykrhmJ6dE3IC67Ddq9P7YSEkF461dxqnvDPTenO3G05XbTTwKjLSCKgM/77nJgS9TR
         OYgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NNtCs/5Asdgm6ZFGpEfa7ooseuLLQp0DNLVc8QA+Qxc=;
        b=JhH+8OnpOpz+/qC/IS+ku3uqQocZ0GxjWzMTgzGz4xB+tPuefhzcmNQW/sqU66y1T/
         YESofUjSfwYfJhbnsFlhcCdoCPVMpDGEewRCxs50HxSq+sPaWtOKjdzqEpTdhatZPxJf
         nzjC+WiSfdxfyDrDaOwS+H5GxOfTqxi/02ZAIb6LGqTlqhmNLPYmfTKgNj5AFFkaZVap
         qaXIxPYBkqLRruZ2tuxQTdnj/e6bZbIrHd71Hata+KCuP4TX4yk5SgsmP1QMxdihYM5/
         8eioS90aZYuYQZUrMLIDcxkZqWYw5g6bdwwFy1x95ZnE6R8i04fkI5rTYKYtSOJwpGvs
         A4xQ==
X-Gm-Message-State: AOAM5317XBY0zgzmDEuGaOA1zBQtBHMANaHBvD3JYnDgJNvxtPv6J34t
        7XVYsnB1kAjY+Otym6Tm0Db4SGO7vo/Bn541WQGrx7Zo/G3i+U8z+R8A1Qsk17XpeQrtjDEw37i
        6C4UQOLbuUrFcJbEjlaXWX2MlVhIxWHyJbqTV9/JbOyKKh6YKnX8Go/4QR3s=
X-Google-Smtp-Source: ABdhPJzfmbvcdwiBN03d/zTSOvM+WMgFuMWfvsDrxxruIbYfM1j+IsSOPHJf8XD7UM0mYdGHjZn/SQr4hQ==
X-Received: from tkjos-desktop.mtv.corp.google.com ([2620:15c:211:200:4a73:99b6:9694:8c4d])
 (user=tkjos job=sendgmr) by 2002:a05:6a00:2391:b0:47c:2747:b1f5 with SMTP id
 f17-20020a056a00239100b0047c2747b1f5mr2682892pfc.44.1636585207324; Wed, 10
 Nov 2021 15:00:07 -0800 (PST)
Date:   Wed, 10 Nov 2021 15:00:02 -0800
Message-Id: <20211110230003.3270335-1-tkjos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 4.14 1/2] binder: use euid from cred instead of using task
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
 drivers/android/binder.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 0db4b5646036..332b4a2cbb94 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -484,6 +484,9 @@ enum binder_deferred_state {
  * @files                 files_struct for process
  *                        (protected by @files_lock)
  * @files_lock            mutex to protect @files
+ * @cred                  struct cred associated with the `struct file`
+ *                        in binder_open()
+ *                        (invariant after initialized)
  * @deferred_work_node:   element for binder_deferred_list
  *                        (protected by binder_deferred_lock)
  * @deferred_work:        bitmap of deferred work to perform
@@ -532,6 +535,7 @@ struct binder_proc {
 	struct task_struct *tsk;
 	struct files_struct *files;
 	struct mutex files_lock;
+	const struct cred *cred;
 	struct hlist_node deferred_work_node;
 	int deferred_work;
 	bool is_dead;
@@ -2890,7 +2894,7 @@ static void binder_transaction(struct binder_proc *proc,
 		t->from = thread;
 	else
 		t->from = NULL;
-	t->sender_euid = task_euid(proc->tsk);
+	t->sender_euid = proc->cred->euid;
 	t->to_proc = target_proc;
 	t->to_thread = target_thread;
 	t->code = tr->code;
@@ -4261,6 +4265,7 @@ static void binder_free_proc(struct binder_proc *proc)
 	BUG_ON(!list_empty(&proc->delivered_death));
 	binder_alloc_deferred_release(&proc->alloc);
 	put_task_struct(proc->tsk);
+	put_cred(proc->cred);
 	binder_stats_deleted(BINDER_STAT_PROC);
 	kfree(proc);
 }
@@ -4717,6 +4722,7 @@ static int binder_open(struct inode *nodp, struct file *filp)
 	get_task_struct(current->group_leader);
 	proc->tsk = current->group_leader;
 	mutex_init(&proc->files_lock);
+	proc->cred = get_cred(filp->f_cred);
 	INIT_LIST_HEAD(&proc->todo);
 	proc->default_priority = task_nice(current);
 	binder_dev = container_of(filp->private_data, struct binder_device,
-- 
2.34.0.rc0.344.g81b53c2807-goog

