Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFFF45BAF8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241167AbhKXMPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:15:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242978AbhKXMNP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:13:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F44B61101;
        Wed, 24 Nov 2021 12:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755649;
        bh=g9CVlPlILTGS9BVDOEUMb9P/3PmB6ASZv1w9+5iziP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJcd1AH0JIpgObG1M8VKJ/ofvRFOLwqqoFnaN9L8o94//Ct7pjvoDog0vvJrZF2Ju
         yI61Rix1iqxKZUkblbU/JJ+YRUH1xbKLlCHQy+e0Vt02t0fNNw8Fq9g+3KoGBCkfpG
         JxH4bvcesGDGMpKKBEvd6LNb32sb9ySaDaTonjbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Jann Horn <jannh@google.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.9 001/207] binder: use euid from cred instead of using task
Date:   Wed, 24 Nov 2021 12:54:32 +0100
Message-Id: <20211124115703.989947149@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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
@@ -1505,7 +1506,7 @@ static void binder_transaction(struct bi
 		t->from = thread;
 	else
 		t->from = NULL;
-	t->sender_euid = task_euid(proc->tsk);
+	t->sender_euid = proc->cred->euid;
 	t->to_proc = target_proc;
 	t->to_thread = target_thread;
 	t->code = tr->code;
@@ -3036,6 +3037,7 @@ static int binder_open(struct inode *nod
 	get_task_struct(current->group_leader);
 	proc->tsk = current->group_leader;
 	mutex_init(&proc->files_lock);
+	proc->cred = get_cred(filp->f_cred);
 	INIT_LIST_HEAD(&proc->todo);
 	init_waitqueue_head(&proc->wait);
 	proc->default_priority = task_nice(current);
@@ -3241,6 +3243,7 @@ static void binder_deferred_release(stru
 	}
 
 	put_task_struct(proc->tsk);
+	put_cred(proc->cred);
 
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
 		     "%s: %d threads %d, nodes %d (ref %d), refs %d, active transactions %d, buffers %d, pages %d\n",


