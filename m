Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A963A9DD
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733217AbfFIQ5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733209AbfFIQ5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:57:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CAE7205ED;
        Sun,  9 Jun 2019 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099458;
        bh=3HFavAxzaHRyQLrKs26tbBek5N9yfGiVCtDxUG+IQts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTH4mQqzWlVCIF+T5XiFwZjCiv0mkjOwESB8iHDGOy1UKmwgjiJyPveWbCknxQaEN
         yYpm5xtFtkXmWTXlykjkMOitTOjDXL0mg1bIUPm5VxlLKjrWzgkH0oV2DY9lOGlfsQ
         Jp20Vy14ahjWUtO9EN6u9W+Yi+1Xhv+qN7grMcrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuning Zhang <sunny.s.zhang@oracle.com>,
        Joseph Qi <jiangqi903@gmail.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, piaojun <piaojun@huawei.com>,
        "Gang He" <ghe@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 013/241] ocfs2: fix ocfs2 read inode data panic in ocfs2_iget
Date:   Sun,  9 Jun 2019 18:39:15 +0200
Message-Id: <20190609164148.168490433@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuning Zhang <sunny.s.zhang@oracle.com>

commit e091eab028f9253eac5c04f9141bbc9d170acab3 upstream.

In some cases, ocfs2_iget() reads the data of inode, which has been
deleted for some reason.  That will make the system panic.  So We should
judge whether this inode has been deleted, and tell the caller that the
inode is a bad inode.

For example, the ocfs2 is used as the backed of nfs, and the client is
nfsv3.  This issue can be reproduced by the following steps.

on the nfs server side,
..../patha/pathb

Step 1: The process A was scheduled before calling the function fh_verify.

Step 2: The process B is removing the 'pathb', and just completed the call
to function dput.  Then the dentry of 'pathb' has been deleted from the
dcache, and all ancestors have been deleted also.  The relationship of
dentry and inode was deleted through the function hlist_del_init.  The
following is the call stack.
dentry_iput->hlist_del_init(&dentry->d_u.d_alias)

At this time, the inode is still in the dcache.

Step 3: The process A call the function ocfs2_get_dentry, which get the
inode from dcache.  Then the refcount of inode is 1.  The following is the
call stack.
nfsd3_proc_getacl->fh_verify->exportfs_decode_fh->fh_to_dentry(ocfs2_get_dentry)

Step 4: Dirty pages are flushed by bdi threads.  So the inode of 'patha'
is evicted, and this directory was deleted.  But the inode of 'pathb'
can't be evicted, because the refcount of the inode was 1.

Step 5: The process A keep running, and call the function
reconnect_path(in exportfs_decode_fh), which call function
ocfs2_get_parent of ocfs2.  Get the block number of parent
directory(patha) by the name of ...  Then read the data from disk by the
block number.  But this inode has been deleted, so the system panic.

Process A                                             Process B
1. in nfsd3_proc_getacl                   |
2.                                        |        dput
3. fh_to_dentry(ocfs2_get_dentry)         |
4. bdi flush dirty cache                  |
5. ocfs2_iget                             |

[283465.542049] OCFS2: ERROR (device sdp): ocfs2_validate_inode_block:
Invalid dinode #580640: OCFS2_VALID_FL not set

[283465.545490] Kernel panic - not syncing: OCFS2: (device sdp): panic forced
after error

[283465.546889] CPU: 5 PID: 12416 Comm: nfsd Tainted: G        W
4.1.12-124.18.6.el6uek.bug28762940v3.x86_64 #2
[283465.548382] Hardware name: VMware, Inc. VMware Virtual Platform/440BX
Desktop Reference Platform, BIOS 6.00 09/21/2015
[283465.549657]  0000000000000000 ffff8800a56fb7b8 ffffffff816e839c
ffffffffa0514758
[283465.550392]  000000000008dc20 ffff8800a56fb838 ffffffff816e62d3
0000000000000008
[283465.551056]  ffff880000000010 ffff8800a56fb848 ffff8800a56fb7e8
ffff88005df9f000
[283465.551710] Call Trace:
[283465.552516]  [<ffffffff816e839c>] dump_stack+0x63/0x81
[283465.553291]  [<ffffffff816e62d3>] panic+0xcb/0x21b
[283465.554037]  [<ffffffffa04e66b0>] ocfs2_handle_error+0xf0/0xf0 [ocfs2]
[283465.554882]  [<ffffffffa04e7737>] __ocfs2_error+0x67/0x70 [ocfs2]
[283465.555768]  [<ffffffffa049c0f9>] ocfs2_validate_inode_block+0x229/0x230
[ocfs2]
[283465.556683]  [<ffffffffa047bcbc>] ocfs2_read_blocks+0x46c/0x7b0 [ocfs2]
[283465.557408]  [<ffffffffa049bed0>] ? ocfs2_inode_cache_io_unlock+0x20/0x20
[ocfs2]
[283465.557973]  [<ffffffffa049f0eb>] ocfs2_read_inode_block_full+0x3b/0x60
[ocfs2]
[283465.558525]  [<ffffffffa049f5ba>] ocfs2_iget+0x4aa/0x880 [ocfs2]
[283465.559082]  [<ffffffffa049146e>] ocfs2_get_parent+0x9e/0x220 [ocfs2]
[283465.559622]  [<ffffffff81297c05>] reconnect_path+0xb5/0x300
[283465.560156]  [<ffffffff81297f46>] exportfs_decode_fh+0xf6/0x2b0
[283465.560708]  [<ffffffffa062faf0>] ? nfsd_proc_getattr+0xa0/0xa0 [nfsd]
[283465.561262]  [<ffffffff810a8196>] ? prepare_creds+0x26/0x110
[283465.561932]  [<ffffffffa0630860>] fh_verify+0x350/0x660 [nfsd]
[283465.562862]  [<ffffffffa0637804>] ? nfsd_cache_lookup+0x44/0x630 [nfsd]
[283465.563697]  [<ffffffffa063a8b9>] nfsd3_proc_getattr+0x69/0xf0 [nfsd]
[283465.564510]  [<ffffffffa062cf60>] nfsd_dispatch+0xe0/0x290 [nfsd]
[283465.565358]  [<ffffffffa05eb892>] ? svc_tcp_adjust_wspace+0x12/0x30
[sunrpc]
[283465.566272]  [<ffffffffa05ea652>] svc_process_common+0x412/0x6a0 [sunrpc]
[283465.567155]  [<ffffffffa05eaa03>] svc_process+0x123/0x210 [sunrpc]
[283465.568020]  [<ffffffffa062c90f>] nfsd+0xff/0x170 [nfsd]
[283465.568962]  [<ffffffffa062c810>] ? nfsd_destroy+0x80/0x80 [nfsd]
[283465.570112]  [<ffffffff810a622b>] kthread+0xcb/0xf0
[283465.571099]  [<ffffffff810a6160>] ? kthread_create_on_node+0x180/0x180
[283465.572114]  [<ffffffff816f11b8>] ret_from_fork+0x58/0x90
[283465.573156]  [<ffffffff810a6160>] ? kthread_create_on_node+0x180/0x180

Link: http://lkml.kernel.org/r/1554185919-3010-1-git-send-email-sunny.s.zhang@oracle.com
Signed-off-by: Shuning Zhang <sunny.s.zhang@oracle.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: piaojun <piaojun@huawei.com>
Cc: "Gang He" <ghe@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/export.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -148,16 +148,24 @@ static struct dentry *ocfs2_get_parent(s
 	u64 blkno;
 	struct dentry *parent;
 	struct inode *dir = d_inode(child);
+	int set;
 
 	trace_ocfs2_get_parent(child, child->d_name.len, child->d_name.name,
 			       (unsigned long long)OCFS2_I(dir)->ip_blkno);
 
+	status = ocfs2_nfs_sync_lock(OCFS2_SB(dir->i_sb), 1);
+	if (status < 0) {
+		mlog(ML_ERROR, "getting nfs sync lock(EX) failed %d\n", status);
+		parent = ERR_PTR(status);
+		goto bail;
+	}
+
 	status = ocfs2_inode_lock(dir, NULL, 0);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
 		parent = ERR_PTR(status);
-		goto bail;
+		goto unlock_nfs_sync;
 	}
 
 	status = ocfs2_lookup_ino_from_name(dir, "..", 2, &blkno);
@@ -166,11 +174,31 @@ static struct dentry *ocfs2_get_parent(s
 		goto bail_unlock;
 	}
 
+	status = ocfs2_test_inode_bit(OCFS2_SB(dir->i_sb), blkno, &set);
+	if (status < 0) {
+		if (status == -EINVAL) {
+			status = -ESTALE;
+		} else
+			mlog(ML_ERROR, "test inode bit failed %d\n", status);
+		parent = ERR_PTR(status);
+		goto bail_unlock;
+	}
+
+	trace_ocfs2_get_dentry_test_bit(status, set);
+	if (!set) {
+		status = -ESTALE;
+		parent = ERR_PTR(status);
+		goto bail_unlock;
+	}
+
 	parent = d_obtain_alias(ocfs2_iget(OCFS2_SB(dir->i_sb), blkno, 0, 0));
 
 bail_unlock:
 	ocfs2_inode_unlock(dir, 0);
 
+unlock_nfs_sync:
+	ocfs2_nfs_sync_unlock(OCFS2_SB(dir->i_sb), 1);
+
 bail:
 	trace_ocfs2_get_parent_end(parent);
 


