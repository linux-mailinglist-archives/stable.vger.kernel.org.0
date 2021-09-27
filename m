Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C5E419B83
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbhI0RTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236472AbhI0RRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:17:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1950660F70;
        Mon, 27 Sep 2021 17:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762720;
        bh=AO3+DeDbC2yaqh56iwd5N1QDJkQbF0es4tKDhXfyEkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMRaNrX50zIbdKKv3zUH1OMUVW94rOtdKLwq+32QY9R4F+1HswpKcxBZN5KDxIfqv
         9/6gY+ktbS/8XN3lzEYgaanmVVqCcABAP7MsAT8Zuf7esYRTE5xCPLQIKMhl/UfsYv
         pnA3DijQYfbwbQgp87U2eRcQ1T6ZO1I5Ltq2+C0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>,
        Li Li <dualli@google.com>
Subject: [PATCH 5.14 019/162] binder: fix freeze race
Date:   Mon, 27 Sep 2021 19:01:05 +0200
Message-Id: <20210927170234.120773212@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Li <dualli@google.com>

commit b564171ade70570b7f335fa8ed17adb28409e3ac upstream.

Currently cgroup freezer is used to freeze the application threads, and
BINDER_FREEZE is used to freeze the corresponding binder interface.
There's already a mechanism in ioctl(BINDER_FREEZE) to wait for any
existing transactions to drain out before actually freezing the binder
interface.

But freezing an app requires 2 steps, freezing the binder interface with
ioctl(BINDER_FREEZE) and then freezing the application main threads with
cgroupfs. This is not an atomic operation. The following race issue
might happen.

1) Binder interface is frozen by ioctl(BINDER_FREEZE);
2) Main thread A initiates a new sync binder transaction to process B;
3) Main thread A is frozen by "echo 1 > cgroup.freeze";
4) The response from process B reaches the frozen thread, which will
unexpectedly fail.

This patch provides a mechanism to check if there's any new pending
transaction happening between ioctl(BINDER_FREEZE) and freezing the
main thread. If there's any, the main thread freezing operation can
be rolled back to finish the pending transaction.

Furthermore, the response might reach the binder driver before the
rollback actually happens. That will still cause failed transaction.

As the other process doesn't wait for another response of the response,
the response transaction failure can be fixed by treating the response
transaction like an oneway/async one, allowing it to reach the frozen
thread. And it will be consumed when the thread gets unfrozen later.

NOTE: This patch reuses the existing definition of struct
binder_frozen_status_info but expands the bit assignments of __u32
member sync_recv.

To ensure backward compatibility, bit 0 of sync_recv still indicates
there's an outstanding sync binder transaction. This patch adds new
information to bit 1 of sync_recv, indicating the binder transaction
happens exactly when there's a race.

If an existing userspace app runs on a new kernel, a sync binder call
will set bit 0 of sync_recv so ioctl(BINDER_GET_FROZEN_INFO) still
return the expected value (true). The app just doesn't check bit 1
intentionally so it doesn't have the ability to tell if there's a race.
This behavior is aligned with what happens on an old kernel which
doesn't set bit 1 at all.

A new userspace app can 1) check bit 0 to know if there's a sync binder
transaction happened when being frozen - same as before; and 2) check
bit 1 to know if that sync binder transaction happened exactly when
there's a race - a new information for rollback decision.

the same time, confirmed the pending transactions succeeded.

Fixes: 432ff1e91694 ("binder: BINDER_FREEZE ioctl")
Acked-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Li Li <dualli@google.com>
Test: stress test with apps being frozen and initiating binder calls at
Link: https://lore.kernel.org/r/20210910164210.2282716-2-dualli@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c            |   35 +++++++++++++++++++++++++++++------
 drivers/android/binder_internal.h   |    2 ++
 include/uapi/linux/android/binder.h |    7 +++++++
 3 files changed, 38 insertions(+), 6 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3047,9 +3047,8 @@ static void binder_transaction(struct bi
 	if (reply) {
 		binder_enqueue_thread_work(thread, tcomplete);
 		binder_inner_proc_lock(target_proc);
-		if (target_thread->is_dead || target_proc->is_frozen) {
-			return_error = target_thread->is_dead ?
-				BR_DEAD_REPLY : BR_FROZEN_REPLY;
+		if (target_thread->is_dead) {
+			return_error = BR_DEAD_REPLY;
 			binder_inner_proc_unlock(target_proc);
 			goto err_dead_proc_or_thread;
 		}
@@ -4659,6 +4658,22 @@ static int binder_ioctl_get_node_debug_i
 	return 0;
 }
 
+static bool binder_txns_pending_ilocked(struct binder_proc *proc)
+{
+	struct rb_node *n;
+	struct binder_thread *thread;
+
+	if (proc->outstanding_txns > 0)
+		return true;
+
+	for (n = rb_first(&proc->threads); n; n = rb_next(n)) {
+		thread = rb_entry(n, struct binder_thread, rb_node);
+		if (thread->transaction_stack)
+			return true;
+	}
+	return false;
+}
+
 static int binder_ioctl_freeze(struct binder_freeze_info *info,
 			       struct binder_proc *target_proc)
 {
@@ -4690,8 +4705,13 @@ static int binder_ioctl_freeze(struct bi
 			(!target_proc->outstanding_txns),
 			msecs_to_jiffies(info->timeout_ms));
 
-	if (!ret && target_proc->outstanding_txns)
-		ret = -EAGAIN;
+	/* Check pending transactions that wait for reply */
+	if (ret >= 0) {
+		binder_inner_proc_lock(target_proc);
+		if (binder_txns_pending_ilocked(target_proc))
+			ret = -EAGAIN;
+		binder_inner_proc_unlock(target_proc);
+	}
 
 	if (ret < 0) {
 		binder_inner_proc_lock(target_proc);
@@ -4707,6 +4727,7 @@ static int binder_ioctl_get_freezer_info
 {
 	struct binder_proc *target_proc;
 	bool found = false;
+	__u32 txns_pending;
 
 	info->sync_recv = 0;
 	info->async_recv = 0;
@@ -4716,7 +4737,9 @@ static int binder_ioctl_get_freezer_info
 		if (target_proc->pid == info->pid) {
 			found = true;
 			binder_inner_proc_lock(target_proc);
-			info->sync_recv |= target_proc->sync_recv;
+			txns_pending = binder_txns_pending_ilocked(target_proc);
+			info->sync_recv |= target_proc->sync_recv |
+					(txns_pending << 1);
 			info->async_recv |= target_proc->async_recv;
 			binder_inner_proc_unlock(target_proc);
 		}
--- a/drivers/android/binder_internal.h
+++ b/drivers/android/binder_internal.h
@@ -378,6 +378,8 @@ struct binder_ref {
  *                        binder transactions
  *                        (protected by @inner_lock)
  * @sync_recv:            process received sync transactions since last frozen
+ *                        bit 0: received sync transaction after being frozen
+ *                        bit 1: new pending sync transaction during freezing
  *                        (protected by @inner_lock)
  * @async_recv:           process received async transactions since last frozen
  *                        (protected by @inner_lock)
--- a/include/uapi/linux/android/binder.h
+++ b/include/uapi/linux/android/binder.h
@@ -225,7 +225,14 @@ struct binder_freeze_info {
 
 struct binder_frozen_status_info {
 	__u32            pid;
+
+	/* process received sync transactions since last frozen
+	 * bit 0: received sync transaction after being frozen
+	 * bit 1: new pending sync transaction during freezing
+	 */
 	__u32            sync_recv;
+
+	/* process received async transactions since last frozen */
 	__u32            async_recv;
 };
 


