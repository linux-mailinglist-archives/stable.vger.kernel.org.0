Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE3240A6D9
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 08:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240084AbhINGru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 02:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240054AbhINGrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 02:47:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A80061159;
        Tue, 14 Sep 2021 06:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631601992;
        bh=mrqyMg3pEg8Gt243tr7ewmAyFoQ5qJ3l1/iqi5lPC4c=;
        h=Subject:To:From:Date:From;
        b=voRhN24lKfFD9j6XIPJtiujndu0Tw+2ZwiZCG5rBhu/OWcckJUmhaaDGMafoq/Mob
         JA3l1uy31A6yu0XJF5SYaFeU/GyQU+rPujQmC54hhxmqvZgqH28FxW20CZYzonNGWD
         ELHJZeIVxaYsbHJSVM6ZN7NtmnreuBBfPdiN3yPQ=
Subject: patch "binder: fix freeze race" added to char-misc-linus
To:     dualli@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tkjos@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Sep 2021 08:46:30 +0200
Message-ID: <1631601990224246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    binder: fix freeze race

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b564171ade70570b7f335fa8ed17adb28409e3ac Mon Sep 17 00:00:00 2001
From: Li Li <dualli@google.com>
Date: Fri, 10 Sep 2021 09:42:10 -0700
Subject: binder: fix freeze race

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
 drivers/android/binder.c            | 35 ++++++++++++++++++++++++-----
 drivers/android/binder_internal.h   |  2 ++
 include/uapi/linux/android/binder.h |  7 ++++++
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index d9030cb6b1e4..1a68c2f590cf 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3038,9 +3038,8 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -4648,6 +4647,22 @@ static int binder_ioctl_get_node_debug_info(struct binder_proc *proc,
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
@@ -4679,8 +4694,13 @@ static int binder_ioctl_freeze(struct binder_freeze_info *info,
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
@@ -4696,6 +4716,7 @@ static int binder_ioctl_get_freezer_info(
 {
 	struct binder_proc *target_proc;
 	bool found = false;
+	__u32 txns_pending;
 
 	info->sync_recv = 0;
 	info->async_recv = 0;
@@ -4705,7 +4726,9 @@ static int binder_ioctl_get_freezer_info(
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
diff --git a/drivers/android/binder_internal.h b/drivers/android/binder_internal.h
index 810c0b84d3f8..402c4d4362a8 100644
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
diff --git a/include/uapi/linux/android/binder.h b/include/uapi/linux/android/binder.h
index 20e435fe657a..3246f2c74696 100644
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
 
-- 
2.33.0


