Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60AFF15757F
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgBJMlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:43518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729978AbgBJMlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:24 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F303020733;
        Mon, 10 Feb 2020 12:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338483;
        bh=7sMWQDAzRleLr9dEoJVWItMajMIRfGXWNDV+dhEDopE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmtRNo+FjdQqLEq7Dq7P2TvTq2ZcC/8yATHI8NCWXjTGGY5zWAfncPyISXyyu7orj
         RjevnIarwCtrp+M17NHVYxPOk0LJSAwjowtqxFOTSExZnkLuNZ3E30NMrpZBAdVWRq
         0RoN7U4nFlqH9dsrhqUaCgE156AysZmLNYCeiGoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gang He <ghe@suse.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 261/367] ocfs2: fix oops when writing cloned file
Date:   Mon, 10 Feb 2020 04:32:54 -0800
Message-Id: <20200210122448.661972896@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gang He <GHe@suse.com>

commit 2d797e9ff95ecbcf0a83d657928ed20579444857 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/file.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
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


