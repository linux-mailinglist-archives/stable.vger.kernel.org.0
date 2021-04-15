Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9214E360C88
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhDOOvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234034AbhDOOu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A2BE613C7;
        Thu, 15 Apr 2021 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498235;
        bh=QCwKT2m+EHnoIAbXPb8UxtblpvP5x/JRzYwOQydAP4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9tjIyD/eSlSmkpO3XK/nNw6mQFlQiQqBXW9t4B7OhlSubRANUxbsWqDNsGy2E4Ra
         1aTBhpv4RLUADJ+s6F7o2isZBo90n08EZhQoWutC5NnEWcCzubNFR7QZQ7fPhjUAGS
         V5n2AvwHQGhhLZHgJ6lCUtjgZYFUetQCd8plszMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wengang Wang <wen.gang.wang@oracle.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 12/47] ocfs2: fix deadlock between setattr and dio_end_io_write
Date:   Thu, 15 Apr 2021 16:47:04 +0200
Message-Id: <20210415144413.867099958@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wengang Wang <wen.gang.wang@oracle.com>

commit 90bd070aae6c4fb5d302f9c4b9c88be60c8197ec upstream.

The following deadlock is detected:

  truncate -> setattr path is waiting for pending direct IO to be done (inode->i_dio_count become zero) with inode->i_rwsem held (down_write).

  PID: 14827  TASK: ffff881686a9af80  CPU: 20  COMMAND: "ora_p005_hrltd9"
   #0  __schedule at ffffffff818667cc
   #1  schedule at ffffffff81866de6
   #2  inode_dio_wait at ffffffff812a2d04
   #3  ocfs2_setattr at ffffffffc05f322e [ocfs2]
   #4  notify_change at ffffffff812a5a09
   #5  do_truncate at ffffffff812808f5
   #6  do_sys_ftruncate.constprop.18 at ffffffff81280cf2
   #7  sys_ftruncate at ffffffff81280d8e
   #8  do_syscall_64 at ffffffff81003949
   #9  entry_SYSCALL_64_after_hwframe at ffffffff81a001ad

dio completion path is going to complete one direct IO (decrement
inode->i_dio_count), but before that it hung at locking inode->i_rwsem:

   #0  __schedule+700 at ffffffff818667cc
   #1  schedule+54 at ffffffff81866de6
   #2  rwsem_down_write_failed+536 at ffffffff8186aa28
   #3  call_rwsem_down_write_failed+23 at ffffffff8185a1b7
   #4  down_write+45 at ffffffff81869c9d
   #5  ocfs2_dio_end_io_write+180 at ffffffffc05d5444 [ocfs2]
   #6  ocfs2_dio_end_io+85 at ffffffffc05d5a85 [ocfs2]
   #7  dio_complete+140 at ffffffff812c873c
   #8  dio_aio_complete_work+25 at ffffffff812c89f9
   #9  process_one_work+361 at ffffffff810b1889
  #10  worker_thread+77 at ffffffff810b233d
  #11  kthread+261 at ffffffff810b7fd5
  #12  ret_from_fork+62 at ffffffff81a0035e

Thus above forms ABBA deadlock.  The same deadlock was mentioned in
upstream commit 28f5a8a7c033 ("ocfs2: should wait dio before inode lock
in ocfs2_setattr()").  It seems that that commit only removed the
cluster lock (the victim of above dead lock) from the ABBA deadlock
party.

End-user visible effects: Process hang in truncate -> ocfs2_setattr path
and other processes hang at ocfs2_dio_end_io_write path.

This is to fix the deadlock itself.  It removes inode_lock() call from
dio completion path to remove the deadlock and add ip_alloc_sem lock in
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/aops.c |   11 +----------
 fs/ocfs2/file.c |    8 ++++++--
 2 files changed, 7 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2301,7 +2301,7 @@ static void ocfs2_dio_end_io_write(struc
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	handle_t *handle = NULL;
 	loff_t end = offset + bytes;
-	int ret = 0, credits = 0, locked = 0;
+	int ret = 0, credits = 0;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
@@ -2312,13 +2312,6 @@ static void ocfs2_dio_end_io_write(struc
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
 }
 
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1236,22 +1236,24 @@ int ocfs2_setattr(struct dentry *dentry,
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
 
@@ -1264,6 +1266,8 @@ int ocfs2_setattr(struct dentry *dentry,
 
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
+bail_unlock_alloc:
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 bail_unlock:
 	if (status) {
 		ocfs2_inode_unlock(inode, 1);


