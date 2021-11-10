Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76AF44CD61
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 23:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhKJXCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 18:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbhKJXCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 18:02:45 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E639C0613F5
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 14:59:57 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id q9-20020ad45749000000b003bdeb0612c5so4046050qvx.8
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 14:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NXQIBC6uYXJLQpdA1ZTQsbPYiMrRJU1fGrC8dl1Rh5Y=;
        b=KUcUkMZCJ1Sxvy3WZCGTCt8+iPcMu+xuZw+WjPAJjkghJkPzi1lfoZeB/cUmvkLi5y
         F/RLcGN2Jq+4dzAqsSJrSbj+tupQEACP7qA2OeLRN9p04ZKzbNZzjM8d2JWSDwgBk/HL
         MqCoM5XeHpxAuguisbs5Ua6wxLmlmlDk6LWazBnln9yqzrRvUokHfiU3HgzR8xpQ9UJV
         hlOOkEczbm4xspdFhyBvEqBIxGGz1pwwY0INUyPrvLMYCdMMxjTpsK6zLf7MEtFVnNco
         RlC1mVyu6NXOh6dxh/qZp0E4USbT9O5LZvKXN8Ijd/q91f1naYGQ9+jOd/ODaN5A/qMq
         xoiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NXQIBC6uYXJLQpdA1ZTQsbPYiMrRJU1fGrC8dl1Rh5Y=;
        b=zClgDELjMEMIZnWeOjGDdi/jnuh6O6mQiAINkYau4a02q1uP28Hsa3vCcQUlKYfZ98
         C/4h32wnDr9EL89CcS6xwXNY6A60XPpjBiRSZGGhCgp+chT9Y42hSF+EAXt8M2X5pUr/
         5Lxl/uOdOcDW2d15J/raBmBkOHsjEuhYLdHcRXAL0XOSDRTZn711A70Rozzw61AgQ1TZ
         MH8hJe9QxFXE6qtNqFEDsBSaQSTQHcdXDGL5IjFXGPTh3m2sLX8VJO1QG/SpRqBIDpRR
         TqYniAgYD1oQQBu7ZUpP+HSHU+SJ/TSkZZiPo5KcJ8imgLrSR26S57ANOzCeRE/yds6J
         3OXw==
X-Gm-Message-State: AOAM532o2Bj+UPMUDCmlEI3DXB51eyiRtL9lxNZdIEIq+FMVXbGgkwRJ
        4Zenos3hs6neP2IouWgGy3bPdOfySA7Za8ItJQemq+1OGibvHvFhOEyvqrj/YVZ0pLyMwrDI8VW
        grkhivcwVvpLvstIMVYvCVR0+bNALWnMcMcpbnavSGS/bFKJxmTU/dyUBVW4=
X-Google-Smtp-Source: ABdhPJw479LzTKWlqeP07bR6w9grHAeEl0pIQEOjZxFUv82cxFBywlg9sTuPiSdwLgkXDAPeaRDz6DzIqg==
X-Received: from tkjos-desktop.mtv.corp.google.com ([2620:15c:211:200:4a73:99b6:9694:8c4d])
 (user=tkjos job=sendgmr) by 2002:a05:622a:1a9b:: with SMTP id
 s27mr2812572qtc.417.1636585196708; Wed, 10 Nov 2021 14:59:56 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:59:52 -0800
Message-Id: <20211110225953.3269439-1-tkjos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 4.9 1/2] binder: use euid from cred instead of using task
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
index f4c0b6295945..fe1a70447c1e 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -303,6 +303,7 @@ struct binder_proc {
 	struct task_struct *tsk;
 	struct files_struct *files;
 	struct mutex files_lock;
+	const struct cred *cred;
 	struct hlist_node deferred_work_node;
 	int deferred_work;
 	void *buffer;
@@ -1505,7 +1506,7 @@ static void binder_transaction(struct binder_proc *proc,
 		t->from = thread;
 	else
 		t->from = NULL;
-	t->sender_euid = task_euid(proc->tsk);
+	t->sender_euid = proc->cred->euid;
 	t->to_proc = target_proc;
 	t->to_thread = target_thread;
 	t->code = tr->code;
@@ -3036,6 +3037,7 @@ static int binder_open(struct inode *nodp, struct file *filp)
 	get_task_struct(current->group_leader);
 	proc->tsk = current->group_leader;
 	mutex_init(&proc->files_lock);
+	proc->cred = get_cred(filp->f_cred);
 	INIT_LIST_HEAD(&proc->todo);
 	init_waitqueue_head(&proc->wait);
 	proc->default_priority = task_nice(current);
@@ -3241,6 +3243,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 	}
 
 	put_task_struct(proc->tsk);
+	put_cred(proc->cred);
 
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
 		     "%s: %d threads %d, nodes %d (ref %d), refs %d, active transactions %d, buffers %d, pages %d\n",
-- 
2.34.0.rc0.344.g81b53c2807-goog

