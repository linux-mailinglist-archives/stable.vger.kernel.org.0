Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1CB442FE0
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 15:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhKBOMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 10:12:09 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:25345 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbhKBOMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 10:12:08 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HkBVJ2k4mzbhWs;
        Tue,  2 Nov 2021 22:04:40 +0800 (CST)
Received: from kwepemm600015.china.huawei.com (7.193.23.52) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 22:09:24 +0800
Received: from huawei.com (10.175.127.227) by kwepemm600015.china.huawei.com
 (7.193.23.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Tue, 2 Nov
 2021 22:09:23 +0800
From:   ChenXiaoSong <chenxiaosong2@huawei.com>
To:     <viro@zeniv.linux.org.uk>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dhowells@redhat.com>, <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <zhangxiaoxu5@huawei.com>, <chenxiaosong2@huawei.com>
Subject: [PATCH 4.19,v3] VFS: Fix memory leak caused by concurrently mounting fs with subtype
Date:   Tue, 2 Nov 2021 22:22:06 +0800
Message-ID: <20211102142206.3972465-1-chenxiaosong2@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600015.china.huawei.com (7.193.23.52)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If two processes mount same superblock, memory leak occurs:

CPU0               |  CPU1
do_new_mount       |  do_new_mount
  fs_set_subtype   |    fs_set_subtype
    kstrdup        |
                   |      kstrdup
    memrory leak   |

The following reproducer triggers the problem:

1. shell command: mount -t ntfs /dev/sda1 /mnt &
2. c program: mount("/dev/sda1", "/mnt", "fuseblk", 0, "...")

with kmemleak report being along the lines of

unreferenced object 0xffff888235f1a5c0 (size 8):
  comm "mount.ntfs", pid 2860, jiffies 4295757824 (age 43.423s)
  hex dump (first 8 bytes):
    00 a5 f1 35 82 88 ff ff                          ...5....
  backtrace:
    [<00000000656e30cc>] __kmalloc_track_caller+0x16e/0x430
    [<000000008e591727>] kstrdup+0x3e/0x90
    [<000000008430d12b>] do_mount.cold+0x7b/0xd9
    [<0000000078d639cd>] ksys_mount+0xb2/0x150
    [<000000006015988d>] __x64_sys_mount+0x29/0x40
    [<00000000e0a7c118>] do_syscall_64+0xc1/0x1d0
    [<00000000bcea7df5>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<00000000803a4067>] 0xffffffffffffffff

Linus's tree already have refactoring patchset [1], one of them can fix this bug:
        c30da2e981a7 ("fuse: convert to use the new mount API")
After refactoring, init super_block->s_subtype in fuse_fill_super.

Since we did not merge the refactoring patchset in this branch, I create this patch.
This patch fix this by adding a write lock while calling fs_set_subtype.

[1] https://patchwork.kernel.org/project/linux-fsdevel/patch/20190903113640.7984-3-mszeredi@redhat.com/

Fixes: 79c0b2df79eb ("add filesystem subtype support")
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
---
v1: Can not mount sshfs ([PATCH linux-4.19.y] VFS: Fix fuseblk memory leak caused by mount concurrency)
v2: Use write lock while writing superblock ([PATCH 4.19,v2] VFS: Fix fuseblk memory leak caused by mount concurrency)
v3: Update commit message

 fs/namespace.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2f3c6a0350a8..396ff1bcfdad 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2490,9 +2490,12 @@ static int do_new_mount(struct path *path, const char *fstype, int sb_flags,
 		return -ENODEV;
 
 	mnt = vfs_kern_mount(type, sb_flags, name, data);
-	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE) &&
-	    !mnt->mnt_sb->s_subtype)
-		mnt = fs_set_subtype(mnt, fstype);
+	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE)) {
+		down_write(&mnt->mnt_sb->s_umount);
+		if (!mnt->mnt_sb->s_subtype)
+			mnt = fs_set_subtype(mnt, fstype);
+		up_write(&mnt->mnt_sb->s_umount);
+	}
 
 	put_filesystem(type);
 	if (IS_ERR(mnt))
-- 
2.31.1

