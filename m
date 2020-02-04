Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8805152079
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 19:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgBDSjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 13:39:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgBDSjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Feb 2020 13:39:53 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CD832084E;
        Tue,  4 Feb 2020 18:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580841592;
        bh=m6GNmlM4+nSM8IqLxtWl5braycPiLqJxSBjp7JOtzbU=;
        h=Date:From:To:Subject:From;
        b=dBnnuKQDvKLetvLBhvO9EZPErj+M8VXsShK6YWxB6q5H9eIQBZkgrOrzTD/5/j7Re
         9p0OUhXPgSLY8fNfLpSDRLYhlxy8UiDUGL+8IoQrPq7jP3WdhmtRt+YhZpnLxi17n1
         Ot2niQfk7PPd6H4+5FapWTHgYm2N9RIUchL7NivM=
Date:   Tue, 04 Feb 2020 10:39:51 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org
Subject:  [merged]
 ocfs2-fix-the-oops-problem-when-write-cloned-file.patch removed from -mm
 tree
Message-ID: <20200204183951.qhiw3kyAn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: fix oops when writing cloned file
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-the-oops-problem-when-write-cloned-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gang He <GHe@suse.com>
Subject: ocfs2: fix oops when writing cloned file

Writing a cloned file triggers a kernel oops and the user-space command
process is also killed by the system.  The bug can be reproduced stably
via:

1) create a file under ocfs2 file system directory.

  journalctl -b > aa.txt

2) create a cloned file for this file.

  reflink aa.txt bb.txt

3) write the cloned file with dd command.

  dd if=/dev/zero of=bb.txt bs=512 count=1 conv=notrunc

The dd command is killed by the kernel, then you can see the oops message
via dmesg command.

[  463.875404] BUG: kernel NULL pointer dereference, address: 0000000000000028
[  463.875413] #PF: supervisor read access in kernel mode
[  463.875416] #PF: error_code(0x0000) - not-present page
[  463.875418] PGD 0 P4D 0
[  463.875425] Oops: 0000 [#1] SMP PTI
[  463.875431] CPU: 1 PID: 2291 Comm: dd Tainted: G           OE     5.3.16-2-default
[  463.875433] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[  463.875500] RIP: 0010:ocfs2_refcount_cow+0xa4/0x5d0 [ocfs2]
[  463.875505] Code: 06 89 6c 24 38 89 eb f6 44 24 3c 02 74 be 49 8b 47 28
[  463.875508] RSP: 0018:ffffa2cb409dfce8 EFLAGS: 00010202
[  463.875512] RAX: ffff8b1ebdca8000 RBX: 0000000000000001 RCX: ffff8b1eb73a9df0
[  463.875515] RDX: 0000000000056a01 RSI: 0000000000000000 RDI: 0000000000000000
[  463.875517] RBP: 0000000000000001 R08: ffff8b1eb73a9de0 R09: 0000000000000000
[  463.875520] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[  463.875522] R13: ffff8b1eb922f048 R14: 0000000000000000 R15: ffff8b1eb922f048
[  463.875526] FS:  00007f8f44d15540(0000) GS:ffff8b1ebeb00000(0000) knlGS:0000000000000000
[  463.875529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  463.875532] CR2: 0000000000000028 CR3: 000000003c17a000 CR4: 00000000000006e0
[  463.875546] Call Trace:
[  463.875596]  ? ocfs2_inode_lock_full_nested+0x18b/0x960 [ocfs2]
[  463.875648]  ocfs2_file_write_iter+0xaf8/0xc70 [ocfs2]
[  463.875672]  new_sync_write+0x12d/0x1d0
[  463.875688]  vfs_write+0xad/0x1a0
[  463.875697]  ksys_write+0xa1/0xe0
[  463.875710]  do_syscall_64+0x60/0x1f0
[  463.875743]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  463.875758] RIP: 0033:0x7f8f4482ed44
[  463.875762] Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 80 00 00 00
[  463.875765] RSP: 002b:00007fff300a79d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  463.875769] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8f4482ed44
[  463.875771] RDX: 0000000000000200 RSI: 000055f771b5c000 RDI: 0000000000000001
[  463.875774] RBP: 0000000000000200 R08: 00007f8f44af9c78 R09: 0000000000000003
[  463.875776] R10: 000000000000089f R11: 0000000000000246 R12: 000055f771b5c000
[  463.875779] R13: 0000000000000200 R14: 0000000000000000 R15: 000055f771b5c000

This regression problem was introduced by commit e74540b28556 ("ocfs2:
protect extent tree in ocfs2_prepare_inode_for_write()").

Link: http://lkml.kernel.org/r/20200121050153.13290-1-ghe@suse.com
Fixes: e74540b28556 ("ocfs2: protect extent tree in ocfs2_prepare_inode_for_write()").
Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-fix-the-oops-problem-when-write-cloned-file
+++ a/fs/ocfs2/file.c
@@ -2101,17 +2101,15 @@ static int ocfs2_is_io_unaligned(struct
 static int ocfs2_inode_lock_for_extent_tree(struct inode *inode,
 					    struct buffer_head **di_bh,
 					    int meta_level,
-					    int overwrite_io,
 					    int write_sem,
 					    int wait)
 {
 	int ret = 0;
 
 	if (wait)
-		ret = ocfs2_inode_lock(inode, NULL, meta_level);
+		ret = ocfs2_inode_lock(inode, di_bh, meta_level);
 	else
-		ret = ocfs2_try_inode_lock(inode,
-			overwrite_io ? NULL : di_bh, meta_level);
+		ret = ocfs2_try_inode_lock(inode, di_bh, meta_level);
 	if (ret < 0)
 		goto out;
 
@@ -2136,6 +2134,7 @@ static int ocfs2_inode_lock_for_extent_t
 
 out_unlock:
 	brelse(*di_bh);
+	*di_bh = NULL;
 	ocfs2_inode_unlock(inode, meta_level);
 out:
 	return ret;
@@ -2177,7 +2176,6 @@ static int ocfs2_prepare_inode_for_write
 		ret = ocfs2_inode_lock_for_extent_tree(inode,
 						       &di_bh,
 						       meta_level,
-						       overwrite_io,
 						       write_sem,
 						       wait);
 		if (ret < 0) {
@@ -2233,13 +2231,13 @@ static int ocfs2_prepare_inode_for_write
 							   &di_bh,
 							   meta_level,
 							   write_sem);
+			meta_level = 1;
+			write_sem = 1;
 			ret = ocfs2_inode_lock_for_extent_tree(inode,
 							       &di_bh,
 							       meta_level,
-							       overwrite_io,
-							       1,
+							       write_sem,
 							       wait);
-			write_sem = 1;
 			if (ret < 0) {
 				if (ret != -EAGAIN)
 					mlog_errno(ret);
_

Patches currently in -mm which might be from GHe@suse.com are


