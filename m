Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20D957DB23
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 09:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbiGVHV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 03:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbiGVHV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 03:21:27 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E272018E;
        Fri, 22 Jul 2022 00:21:24 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Lq14q2Tw2zjX5P;
        Fri, 22 Jul 2022 15:18:35 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 22 Jul
 2022 15:21:21 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <stable@vger.kernel.org>, <linux-ext4@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <ritesh.list@gmail.com>, <lczerner@redhat.com>,
        <enwlinux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <yi.zhang@huawei.com>, <yebin10@huawei.com>, <yukuai3@huawei.com>,
        <libaokun1@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 5.4] ext4: fix race condition between ext4_ioctl_setflags and ext4_fiemap
Date:   Fri, 22 Jul 2022 15:33:34 +0800
Message-ID: <20220722073334.1893924-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index f1bbce4350c4..50f956bda34c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5175,16 +5175,21 @@ static int _ext4_fiemap(struct inode *inode,
 		fieinfo->fi_flags &= ~FIEMAP_FLAG_CACHE;
 	}
 
+	inode_lock_shared(inode);
 	/* fallback to generic here if not in extents fmt */
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) &&
-	    fill == ext4_fill_fiemap_extents)
-		return generic_block_fiemap(inode, fieinfo, start, len,
+	    fill == ext4_fill_fiemap_extents) {
+		error = __generic_block_fiemap(inode, fieinfo, start, len,
 			ext4_get_block);
+		goto out_unlock;
+	}
 
 	if (fill == ext4_fill_es_cache_info)
 		ext4_fiemap_flags &= FIEMAP_FLAG_XATTR;
-	if (fiemap_check_flags(fieinfo, ext4_fiemap_flags))
-		return -EBADR;
+	if (fiemap_check_flags(fieinfo, ext4_fiemap_flags)) {
+		error = -EBADR;
+		goto out_unlock;
+	}
 
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
 		error = ext4_xattr_fiemap(inode, fieinfo);
@@ -5204,6 +5209,8 @@ static int _ext4_fiemap(struct inode *inode,
 		 */
 		error = fill(inode, start_blk, len_blks, fieinfo);
 	}
+out_unlock:
+	inode_unlock_shared(inode);
 	return error;
 }
 
-- 
2.31.1

