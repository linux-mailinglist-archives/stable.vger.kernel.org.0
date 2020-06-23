Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC8120495F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 07:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbgFWF4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 01:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730081AbgFWF4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 01:56:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F38720771;
        Tue, 23 Jun 2020 05:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592891770;
        bh=p/NOqy6tQny5pDQDzHpTYYLMa38Zhl8+225K4tFgGEk=;
        h=Subject:To:From:Date:From;
        b=fRdAmYAkWt/mlKiOZhPt2oxpe5iafcdMwzG1BXmOvOvQEnw7UwwKEAsKU6Qx3OxmJ
         CHL/XMOxcyoMJ1oDrBrc8phNif6YF/5bylqV1SXcHGqCl3LcSNa3n7ymSbYoZOAPRT
         pwZVTq31/v5qQhkDl0kwogEilEPMa9h9wGraIQ04=
Subject: patch "binder: fix null deref of proc->context" added to char-misc-linus
To:     tkjos@google.com, christian.brauner@ubuntu.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 07:56:04 +0200
Message-ID: <159289176465144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    binder: fix null deref of proc->context

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d35d3660e065b69fdb8bf512f3d899f350afce52 Mon Sep 17 00:00:00 2001
From: Todd Kjos <tkjos@google.com>
Date: Mon, 22 Jun 2020 13:07:15 -0700
Subject: binder: fix null deref of proc->context

The binder driver makes the assumption proc->context pointer is invariant after
initialization (as documented in the kerneldoc header for struct proc).
However, in commit f0fe2c0f050d ("binder: prevent UAF for binderfs devices II")
proc->context is set to NULL during binder_deferred_release().

Another proc was in the middle of setting up a transaction to the dying
process and crashed on a NULL pointer deref on "context" which is a local
set to &proc->context:

    new_ref->data.desc = (node == context->binder_context_mgr_node) ? 0 : 1;

Here's the stack:

[ 5237.855435] Call trace:
[ 5237.855441] binder_get_ref_for_node_olocked+0x100/0x2ec
[ 5237.855446] binder_inc_ref_for_node+0x140/0x280
[ 5237.855451] binder_translate_binder+0x1d0/0x388
[ 5237.855456] binder_transaction+0x2228/0x3730
[ 5237.855461] binder_thread_write+0x640/0x25bc
[ 5237.855466] binder_ioctl_write_read+0xb0/0x464
[ 5237.855471] binder_ioctl+0x30c/0x96c
[ 5237.855477] do_vfs_ioctl+0x3e0/0x700
[ 5237.855482] __arm64_sys_ioctl+0x78/0xa4
[ 5237.855488] el0_svc_common+0xb4/0x194
[ 5237.855493] el0_svc_handler+0x74/0x98
[ 5237.855497] el0_svc+0x8/0xc

The fix is to move the kfree of the binder_device to binder_free_proc()
so the binder_device is freed when we know there are no references
remaining on the binder_proc.

Fixes: f0fe2c0f050d ("binder: prevent UAF for binderfs devices II")
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200622200715.114382-1-tkjos@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index e47c8a4c83db..f50c5f182bb5 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4686,8 +4686,15 @@ static struct binder_thread *binder_get_thread(struct binder_proc *proc)
 
 static void binder_free_proc(struct binder_proc *proc)
 {
+	struct binder_device *device;
+
 	BUG_ON(!list_empty(&proc->todo));
 	BUG_ON(!list_empty(&proc->delivered_death));
+	device = container_of(proc->context, struct binder_device, context);
+	if (refcount_dec_and_test(&device->ref)) {
+		kfree(proc->context->name);
+		kfree(device);
+	}
 	binder_alloc_deferred_release(&proc->alloc);
 	put_task_struct(proc->tsk);
 	binder_stats_deleted(BINDER_STAT_PROC);
@@ -5406,7 +5413,6 @@ static int binder_node_release(struct binder_node *node, int refs)
 static void binder_deferred_release(struct binder_proc *proc)
 {
 	struct binder_context *context = proc->context;
-	struct binder_device *device;
 	struct rb_node *n;
 	int threads, nodes, incoming_refs, outgoing_refs, active_transactions;
 
@@ -5423,12 +5429,6 @@ static void binder_deferred_release(struct binder_proc *proc)
 		context->binder_context_mgr_node = NULL;
 	}
 	mutex_unlock(&context->context_mgr_node_lock);
-	device = container_of(proc->context, struct binder_device, context);
-	if (refcount_dec_and_test(&device->ref)) {
-		kfree(context->name);
-		kfree(device);
-	}
-	proc->context = NULL;
 	binder_inner_proc_lock(proc);
 	/*
 	 * Make sure proc stays alive after we
-- 
2.27.0


