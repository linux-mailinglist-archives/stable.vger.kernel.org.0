Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0349F20DE4B
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731844AbgF2UYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732546AbgF2TZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E76825336;
        Mon, 29 Jun 2020 15:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445175;
        bh=WmKZJ3jZ4rr2AEEx8132hJJVHy1T919jQDDban6+uwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnwpMRvarehT72RXrDK+cL/WSlfPl6xaNDxt75pupFqs0ThGXTeTDjVIUA8+XJQ9F
         nbbznSV2dWEke6F0seR//e3mYPbmi2fLqF7d/z2e86o/l3Z/axqQFLwRRSzC+8GaZx
         x9NAzphJwUwpdJGMPpmtYdohyTVo4JJcztElw2yk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Joel Becker <jlbec@evilplan.org>,
        Jun Piao <piaojun@huawei.com>, Mark Fasheh <mark@fasheh.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 67/78] ocfs2: fix panic on nfs server over ocfs2
Date:   Mon, 29 Jun 2020 11:37:55 -0400
Message-Id: <20200629153806.2494953-68-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxiao Bi <junxiao.bi@oracle.com>

commit e5a15e17a78d58f933d17cafedfcf7486a29f5b4 upstream.

The following kernel panic was captured when running nfs server over
ocfs2, at that time ocfs2_test_inode_bit() was checking whether one
inode locating at "blkno" 5 was valid, that is ocfs2 root inode, its
"suballoc_slot" was OCFS2_INVALID_SLOT(65535) and it was allocted from
//global_inode_alloc, but here it wrongly assumed that it was got from per
slot inode alloctor which would cause array overflow and trigger kernel
panic.

  BUG: unable to handle kernel paging request at 0000000000001088
  IP: [<ffffffff816f6898>] _raw_spin_lock+0x18/0xf0
  PGD 1e06ba067 PUD 1e9e7d067 PMD 0
  Oops: 0002 [#1] SMP
  CPU: 6 PID: 24873 Comm: nfsd Not tainted 4.1.12-124.36.1.el6uek.x86_64 #2
  Hardware name: Huawei CH121 V3/IT11SGCA1, BIOS 3.87 02/02/2018
  RIP: _raw_spin_lock+0x18/0xf0
  RSP: e02b:ffff88005ae97908  EFLAGS: 00010206
  RAX: ffff88005ae98000 RBX: 0000000000001088 RCX: 0000000000000000
  RDX: 0000000000020000 RSI: 0000000000000009 RDI: 0000000000001088
  RBP: ffff88005ae97928 R08: 0000000000000000 R09: ffff880212878e00
  R10: 0000000000007ff0 R11: 0000000000000000 R12: 0000000000001088
  R13: ffff8800063c0aa8 R14: ffff8800650c27d0 R15: 000000000000ffff
  FS:  0000000000000000(0000) GS:ffff880218180000(0000) knlGS:ffff880218180000
  CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000001088 CR3: 00000002033d0000 CR4: 0000000000042660
  Call Trace:
    igrab+0x1e/0x60
    ocfs2_get_system_file_inode+0x63/0x3a0 [ocfs2]
    ocfs2_test_inode_bit+0x328/0xa00 [ocfs2]
    ocfs2_get_parent+0xba/0x3e0 [ocfs2]
    reconnect_path+0xb5/0x300
    exportfs_decode_fh+0xf6/0x2b0
    fh_verify+0x350/0x660 [nfsd]
    nfsd4_putfh+0x4d/0x60 [nfsd]
    nfsd4_proc_compound+0x3d3/0x6f0 [nfsd]
    nfsd_dispatch+0xe0/0x290 [nfsd]
    svc_process_common+0x412/0x6a0 [sunrpc]
    svc_process+0x123/0x210 [sunrpc]
    nfsd+0xff/0x170 [nfsd]
    kthread+0xcb/0xf0
    ret_from_fork+0x61/0x90
  Code: 83 c2 02 0f b7 f2 e8 18 dc 91 ff 66 90 eb bf 0f 1f 40 00 55 48 89 e5 41 56 41 55 41 54 53 0f 1f 44 00 00 48 89 fb ba 00 00 02 00 <f0> 0f c1 17 89 d0 45 31 e4 45 31 ed c1 e8 10 66 39 d0 41 89 c6
  RIP   _raw_spin_lock+0x18/0xf0
  CR2: 0000000000001088
  ---[ end trace 7264463cd1aac8f9 ]---
  Kernel panic - not syncing: Fatal exception

Link: http://lkml.kernel.org/r/20200616183829.87211-4-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/suballoc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 71f22c8fbffd4..4ca2f71565f9a 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2891,9 +2891,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 		goto bail;
 	}
 
-	inode_alloc_inode =
-		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
-					    suballoc_slot);
+	if (suballoc_slot == (u16)OCFS2_INVALID_SLOT)
+		inode_alloc_inode = ocfs2_get_system_file_inode(osb,
+			GLOBAL_INODE_ALLOC_SYSTEM_INODE, suballoc_slot);
+	else
+		inode_alloc_inode = ocfs2_get_system_file_inode(osb,
+			INODE_ALLOC_SYSTEM_INODE, suballoc_slot);
 	if (!inode_alloc_inode) {
 		/* the error code could be inaccurate, but we are not able to
 		 * get the correct one. */
-- 
2.25.1

