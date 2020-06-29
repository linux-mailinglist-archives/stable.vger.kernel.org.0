Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF6020DA13
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731118AbgF2Txd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387683AbgF2Tk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D788124859;
        Mon, 29 Jun 2020 15:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444357;
        bh=cCvb0wU/go86K+rFchBAPCLlGwUBH2iAtLmr/T8MDiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSomqep/eITcPQH5DXe3PcvpA4D/2kVKTM6dUTGmBc+xxVR5zAcn1tj9e2qPPcyhH
         6lismS+vW4RQfcofApQbiOWaKNJ4BBTvhqHzZxHrmQinIuIvmksHGPlGCbg4dsWK9y
         bzr2X5JKLhx0wxAPb+jhBmyezA1Psl5qHCNa9yak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Todd Kjos <tkjos@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 033/178] binder: fix null deref of proc->context
Date:   Mon, 29 Jun 2020 11:22:58 -0400
Message-Id: <20200629152523.2494198-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

commit d35d3660e065b69fdb8bf512f3d899f350afce52 upstream.

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
index 34a6de65aa7ee..5e6586af21b71 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4688,8 +4688,15 @@ static struct binder_thread *binder_get_thread(struct binder_proc *proc)
 
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
@@ -5408,7 +5415,6 @@ static int binder_node_release(struct binder_node *node, int refs)
 static void binder_deferred_release(struct binder_proc *proc)
 {
 	struct binder_context *context = proc->context;
-	struct binder_device *device;
 	struct rb_node *n;
 	int threads, nodes, incoming_refs, outgoing_refs, active_transactions;
 
@@ -5425,12 +5431,6 @@ static void binder_deferred_release(struct binder_proc *proc)
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
2.25.1

