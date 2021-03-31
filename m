Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E7E350AE3
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 01:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhCaXi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 19:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbhCaXiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Mar 2021 19:38:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0410260C3E;
        Wed, 31 Mar 2021 23:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617233895;
        bh=MNKBZ/IkS01MKFSEFVSJIKjB4Jago1D5ZpJm4NWgXaU=;
        h=Date:From:To:Subject:From;
        b=APHpXDSCqrDVDWsDns8y3bVDadRHrGdyu+wZMSehflD3KJt6qAoYo1/nVdWkO1KqW
         0kqK6nCmgsDtxwX13+f35pJ9g4+1Xtbqn/p/5jSrzYa4BWIRktQYe5XCzQYrvHksN7
         47oeOZMve3d8ABuk0B5Kxh31q+K+IW4o1uL6rsu4=
Date:   Wed, 31 Mar 2021 16:38:14 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com,
        jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org, wen.gang.wang@oracle.com
Subject:  +
 ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write.patch added to -mm
 tree
Message-ID: <20210331233814.VDNpynvhr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: fix deadlock between setattr and dio_end_io_write
has been added to the -mm tree.  Its filename is
     ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Thus above forms ABBA deadlock. The same deadlock was mentioned in
upstream commit 28f5a8a7c033cbf3e32277f4cc9c6afd74f05300. well, it seems
that that commit just removed cluster lock (the victim of above dead
lock) from the ABBA deadlock party.

End-user visible effects:
Process hang in truncate -> ocfs2_setattr path and other processes hang at
ocfs2_dio_end_io_write path.

This is to fix the deadlock its self. It removes inode_lock() call from dio
completion path to remove the deadlock and add ip_alloc_sem lock in setattr
path to synchronize the inode modifications.

Link: https://lkml.kernel.org/r/20210331203654.3911-1-wen.gang.wang@oracle.com
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   11 +----------
 fs/ocfs2/file.c |   11 ++++++++++-
 2 files changed, 11 insertions(+), 11 deletions(-)

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
@@ -1124,7 +1124,7 @@ int ocfs2_setattr(struct user_namespace
 	handle_t *handle = NULL;
 	struct dquot *transfer_to[MAXQUOTAS] = { };
 	int qtype;
-	int had_lock;
+	int had_lock, had_alloc_lock = 0;
 	struct ocfs2_lock_holder oh;
 
 	trace_ocfs2_setattr(inode, dentry,
@@ -1245,6 +1245,9 @@ int ocfs2_setattr(struct user_namespace
 				goto bail_unlock;
 			}
 		}
+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
+		had_alloc_lock = 1;
+
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS +
 					   2 * ocfs2_quota_trans_credits(sb));
 		if (IS_ERR(handle)) {
@@ -1256,6 +1259,9 @@ int ocfs2_setattr(struct user_namespace
 		if (status < 0)
 			goto bail_commit;
 	} else {
+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
+		had_alloc_lock = 1;
+
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 		if (IS_ERR(handle)) {
 			status = PTR_ERR(handle);
@@ -1274,6 +1280,9 @@ int ocfs2_setattr(struct user_namespace
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
 bail_unlock:
+	if (had_alloc_lock)
+		up_write(&OCFS2_I(inode)->ip_alloc_sem);
+
 	if (status && inode_locked) {
 		ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
 		inode_locked = 0;
_

Patches currently in -mm which might be from wen.gang.wang@oracle.com are

ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write.patch

