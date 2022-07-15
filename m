Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC6957598F
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 04:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241090AbiGOC1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 22:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiGOC1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 22:27:11 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E90122B39;
        Thu, 14 Jul 2022 19:27:08 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LkZvt2q8FzlVxh;
        Fri, 15 Jul 2022 10:25:30 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 15 Jul
 2022 10:27:06 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <stable@vger.kernel.org>, <linux-ext4@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <ritesh.list@gmail.com>, <lczerner@redhat.com>,
        <enwlinux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <yi.zhang@huawei.com>, <yebin10@huawei.com>, <yukuai3@huawei.com>,
        <libaokun1@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 4.19] ext4: fix race condition between ext4_ioctl_setflags and ext4_fiemap
Date:   Fri, 15 Jul 2022 10:39:28 +0800
Message-ID: <20220715023928.2701166-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch and problem analysis is based on v4.19 LTS.
The d3b6f23f7167("ext4: move ext4_fiemap to use iomap framework") patch
is incorporated in v5.7-rc1. This patch avoids this problem by switching
to iomap in ext4_fiemap.

Hulk Robot reported a BUG on stable 4.19.252:
==================================================================
kernel BUG at fs/ext4/extents_status.c:762!
invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 7 PID: 2845 Comm: syz-executor Not tainted 4.19.252 #46
RIP: 0010:ext4_es_cache_extent+0x30e/0x370
[...]
Call Trace:
 ext4_cache_extents+0x238/0x2f0
 ext4_find_extent+0x785/0xa40
 ext4_fiemap+0x36d/0xe90
 do_vfs_ioctl+0x6af/0x1200
[...]
==================================================================

Above issue may happen as follows:
-------------------------------------
           cpu1		    cpu2
_____________________|_____________________
do_vfs_ioctl
 ext4_ioctl
  ext4_ioctl_setflags
   ext4_ind_migrate
                        do_vfs_ioctl
                         ioctl_fiemap
                          ext4_fiemap
                           ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)
                           ext4_fill_fiemap_extents
    down_write(&EXT4_I(inode)->i_data_sem);
    ext4_ext_check_inode
    ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS)
    memset(ei->i_data, 0, sizeof(ei->i_data))
    up_write(&EXT4_I(inode)->i_data_sem);
                            down_read(&EXT4_I(inode)->i_data_sem);
                            ext4_find_extent
                             ext4_cache_extents
                              ext4_es_cache_extent
                               BUG_ON(end < lblk)

We can easily reproduce this problem with the syzkaller testcase:
```
02:37:07 executing program 3:
r0 = openat(0xffffffffffffff9c, &(0x7f0000000040)='./file0\x00', 0x26e1, 0x0)
ioctl$FS_IOC_FSSETXATTR(r0, 0x40086602, &(0x7f0000000080)={0x17e})
mkdirat(0xffffffffffffff9c, &(0x7f00000000c0)='./file1\x00', 0x1ff)
r1 = openat(0xffffffffffffff9c, &(0x7f0000000100)='./file1\x00', 0x0, 0x0)
ioctl$FS_IOC_FIEMAP(r1, 0xc020660b, &(0x7f0000000180)={0x0, 0x1, 0x0, 0xef3, 0x6, []}) (async, rerun: 32)
ioctl$FS_IOC_FSSETXATTR(r1, 0x40086602, &(0x7f0000000140)={0x17e}) (rerun: 32)
```

To solve this issue, we use __generic_block_fiemap() instead of
generic_block_fiemap() and add inode_lock_shared to avoid race condition.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/ext4/extents.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6c492fca60c4..38aaf48e94cb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5198,13 +5198,18 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			return error;
 	}
 
+	inode_lock_shared(inode);
 	/* fallback to generic here if not in extents fmt */
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-		return generic_block_fiemap(inode, fieinfo, start, len,
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
+		error = __generic_block_fiemap(inode, fieinfo, start, len,
 			ext4_get_block);
+		goto out_unlock;
+	}
 
-	if (fiemap_check_flags(fieinfo, EXT4_FIEMAP_FLAGS))
-		return -EBADR;
+	if (fiemap_check_flags(fieinfo, EXT4_FIEMAP_FLAGS)) {
+		error = -EBADR;
+		goto out_unlock;
+	}
 
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
 		error = ext4_xattr_fiemap(inode, fieinfo);
@@ -5225,6 +5230,8 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		error = ext4_fill_fiemap_extents(inode, start_blk,
 						 len_blks, fieinfo);
 	}
+out_unlock:
+	inode_unlock_shared(inode);
 	return error;
 }
 
-- 
2.31.1

