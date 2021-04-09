Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A8535A7D4
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbhDIU1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhDIU1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 16:27:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D88E61007;
        Fri,  9 Apr 2021 20:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618000050;
        bh=YGC9Pvf473zr0zi3Ecg30zMYak7MQT5YIzwQHvlltq0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lGvAj5DcPP4xyMnlIbLKv3FVWLwuVemEgiDhJrUjOf/kcg7eb+3FUZGhNHUky2brh
         OORxem6ix+Mu3tMVGUJHArliE2rJc49pDEeWWJR2ca0hXuZA4EFca77N3N5peoKFSn
         Bvyx8vo4us7AwbSKU97JUEHzjr0Ep0bbpzF28zjc=
Date:   Fri, 09 Apr 2021 13:27:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        wen.gang.wang@oracle.com
Subject:  [patch 10/16] ocfs2: fix deadlock between setattr and
 dio_end_io_write
Message-ID: <20210409202729.4CXpdnX6s%akpm@linux-foundation.org>
In-Reply-To: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: fix deadlock between setattr and dio_end_io_write

The following deadlock is detected:

truncate -> setattr path is waiting for pending direct IO to be done (
inode->i_dio_count become zero) with inode->i_rwsem held (down_write).

PID: 14827  TASK: ffff881686a9af80  CPU: 20  COMMAND: "ora_p005_hrltd9"
#0 [ffffc9000bcf3c08] __schedule at ffffffff818667cc
#1 [ffffc9000bcf3ca0] schedule at ffffffff81866de6
#2 [ffffc9000bcf3cb8] inode_dio_wait at ffffffff812a2d04
#3 [ffffc9000bcf3d28] ocfs2_setattr at ffffffffc05f322e [ocfs2]
#4 [ffffc9000bcf3e18] notify_change at ffffffff812a5a09
#5 [ffffc9000bcf3e60] do_truncate at ffffffff812808f5
#6 [ffffc9000bcf3ed8] do_sys_ftruncate.constprop.18 at ffffffff81280cf2
#7 [ffffc9000bcf3f18] sys_ftruncate at ffffffff81280d8e
#8 [ffffc9000bcf3f28] do_syscall_64 at ffffffff81003949
#9 [ffffc9000bcf3f50] entry_SYSCALL_64_after_hwframe at ffffffff81a001ad

dio completion path is going to complete one direct IO (decrement
inode->i_dio_count), but before that it hang at locking inode->i_rwsem.

 #0 [ffffc90009b47b40] __schedule+700 at ffffffff818667cc
 #1 [ffffc90009b47bd8] schedule+54 at ffffffff81866de6
 #2 [ffffc90009b47bf0] rwsem_down_write_failed+536 at ffffffff8186aa28
 #3 [ffffc90009b47c88] call_rwsem_down_write_failed+23 at ffffffff8185a1b7
 #4 [ffffc90009b47cd0] down_write+45 at ffffffff81869c9d
 #5 [ffffc90009b47ce8] ocfs2_dio_end_io_write+180 at ffffffffc05d5444 [ocfs2]
 #6 [ffffc90009b47dd8] ocfs2_dio_end_io+85 at ffffffffc05d5a85 [ocfs2]
 #7 [ffffc90009b47e18] dio_complete+140 at ffffffff812c873c
 #8 [ffffc90009b47e50] dio_aio_complete_work+25 at ffffffff812c89f9
 #9 [ffffc90009b47e60] process_one_work+361 at ffffffff810b1889
#10 [ffffc90009b47ea8] worker_thread+77 at ffffffff810b233d
#11 [ffffc90009b47f08] kthread+261 at ffffffff810b7fd5
#12 [ffffc90009b47f50] ret_from_fork+62 at ffffffff81a0035e

Thus above forms ABBA deadlock.  The same deadlock was mentioned in
upstream commit 28f5a8a7c033cbf3e32277f4cc9c6afd74f05300.  well, it seems
that that commit just removed cluster lock (the victim of above dead lock)
from the ABBA deadlock party.

End-user visible effects: Process hang in truncate -> ocfs2_setattr path
and other processes hang at ocfs2_dio_end_io_write path.

This is to fix the deadlock itself.  It removes inode_lock() call from dio
completion path to remove the deadlock and add ip_alloc_sem lock in
setattr path to synchronize the inode modifications.

[wen.gang.wang@oracle.com: remove the "had_alloc_lock" as suggested]
  Link: https://lkml.kernel.org/r/20210402171344.1605-1-wen.gang.wang@oracle.com
Link: https://lkml.kernel.org/r/20210331203654.3911-1-wen.gang.wang@oracle.com
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   11 +----------
 fs/ocfs2/file.c |    8 ++++++--
 2 files changed, 7 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write
+++ a/fs/ocfs2/aops.c
@@ -2295,7 +2295,7 @@ static int ocfs2_dio_end_io_write(struct
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	handle_t *handle = NULL;
 	loff_t end = offset + bytes;
-	int ret = 0, credits = 0, locked = 0;
+	int ret = 0, credits = 0;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
@@ -2306,13 +2306,6 @@ static int ocfs2_dio_end_io_write(struct
 	    !dwc->dw_orphaned)
 		goto out;
 
-	/* ocfs2_file_write_iter will get i_mutex, so we need not lock if we
-	 * are in that context. */
-	if (dwc->dw_writer_pid != task_pid_nr(current)) {
-		inode_lock(inode);
-		locked = 1;
-	}
-
 	ret = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -2393,8 +2386,6 @@ out:
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
 	ocfs2_run_deallocs(osb, &dealloc);
-	if (locked)
-		inode_unlock(inode);
 	ocfs2_dio_free_write_ctx(inode, dwc);
 
 	return ret;
--- a/fs/ocfs2/file.c~ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write
+++ a/fs/ocfs2/file.c
@@ -1245,22 +1245,24 @@ int ocfs2_setattr(struct user_namespace
 				goto bail_unlock;
 			}
 		}
+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS +
 					   2 * ocfs2_quota_trans_credits(sb));
 		if (IS_ERR(handle)) {
 			status = PTR_ERR(handle);
 			mlog_errno(status);
-			goto bail_unlock;
+			goto bail_unlock_alloc;
 		}
 		status = __dquot_transfer(inode, transfer_to);
 		if (status < 0)
 			goto bail_commit;
 	} else {
+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 		if (IS_ERR(handle)) {
 			status = PTR_ERR(handle);
 			mlog_errno(status);
-			goto bail_unlock;
+			goto bail_unlock_alloc;
 		}
 	}
 
@@ -1273,6 +1275,8 @@ int ocfs2_setattr(struct user_namespace
 
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
+bail_unlock_alloc:
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 bail_unlock:
 	if (status && inode_locked) {
 		ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
_
