Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252A942BBD3
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 11:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239199AbhJMJoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 05:44:54 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14344 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239196AbhJMJow (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 05:44:52 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HTnWh65JWz9007;
        Wed, 13 Oct 2021 17:37:52 +0800 (CST)
Received: from kwepemm600015.china.huawei.com (7.193.23.52) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 13 Oct 2021 17:42:38 +0800
Received: from huawei.com (10.175.101.6) by kwepemm600015.china.huawei.com
 (7.193.23.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 13 Oct
 2021 17:42:37 +0800
From:   ChenXiaoSong <chenxiaosong2@huawei.com>
To:     <viro@zeniv.linux.org.uk>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dhowells@redhat.com>, <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <chenxiaosong2@huawei.com>, <zhangxiaoxu5@huawei.com>
Subject: [PATCH 4.19,v2] VFS: Fix fuseblk memory leak caused by mount concurrency
Date:   Wed, 13 Oct 2021 17:51:01 +0800
Message-ID: <20211013095101.641329-1-chenxiaosong2@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

Fix this by adding a write lock while calling fs_set_subtype.

Linus's tree already have refactoring patchset [1], one of them can fix this bug:
        c30da2e981a7 (fuse: convert to use the new mount API)

Since we did not merge the refactoring patchset in this branch, I create this patch.

[1] https://patchwork.kernel.org/project/linux-fsdevel/patch/20190903113640.7984-3-mszeredi@redhat.com/

Fixes: 79c0b2df79eb (add filesystem subtype support)
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
---
v1: Can not mount sshfs ([PATCH linux-4.19.y] VFS: Fix fuseblk memory leak caused by mount concurrency)
v2: Use write lock while writing superblock

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
2.25.4

