Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3735480928
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 13:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhL1MnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 07:43:06 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34855 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbhL1MnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 07:43:05 -0500
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JNZ1m1fKVzccG2;
        Tue, 28 Dec 2021 20:42:36 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 28 Dec
 2021 20:43:03 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <richard@nod.at>, <dwmw2@infradead.org>,
        <christian.brauner@ubuntu.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <libaokun1@huawei.com>, <yukuai3@huawei.com>,
        <stable@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] jffs2: fix use-after-free in jffs2_clear_xattr_subsystem
Date:   Tue, 28 Dec 2021 20:54:30 +0800
Message-ID: <20211228125430.1880252-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we mount a jffs2 image, assume that the first few blocks of
the image are normal and contain at least one xattr-related inode,
but the next block is abnormal. As a result, an error is returned
in jffs2_scan_eraseblock(). jffs2_clear_xattr_subsystem() is then
called in jffs2_build_filesystem() and then again in
jffs2_do_fill_super().

Finally we can observe the following report:
 ==================================================================
 BUG: KASAN: use-after-free in jffs2_clear_xattr_subsystem+0x95/0x6ac
 Read of size 8 at addr ffff8881243384e0 by task mount/719

 Call Trace:
  dump_stack+0x115/0x16b
  jffs2_clear_xattr_subsystem+0x95/0x6ac
  jffs2_do_fill_super+0x84f/0xc30
  jffs2_fill_super+0x2ea/0x4c0
  mtd_get_sb+0x254/0x400
  mtd_get_sb_by_nr+0x4f/0xd0
  get_tree_mtd+0x498/0x840
  jffs2_get_tree+0x25/0x30
  vfs_get_tree+0x8d/0x2e0
  path_mount+0x50f/0x1e50
  do_mount+0x107/0x130
  __se_sys_mount+0x1c5/0x2f0
  __x64_sys_mount+0xc7/0x160
  do_syscall_64+0x45/0x70
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

 Allocated by task 719:
  kasan_save_stack+0x23/0x60
  __kasan_kmalloc.constprop.0+0x10b/0x120
  kasan_slab_alloc+0x12/0x20
  kmem_cache_alloc+0x1c0/0x870
  jffs2_alloc_xattr_ref+0x2f/0xa0
  jffs2_scan_medium.cold+0x3713/0x4794
  jffs2_do_mount_fs.cold+0xa7/0x2253
  jffs2_do_fill_super+0x383/0xc30
  jffs2_fill_super+0x2ea/0x4c0
 [...]

 Freed by task 719:
  kmem_cache_free+0xcc/0x7b0
  jffs2_free_xattr_ref+0x78/0x98
  jffs2_clear_xattr_subsystem+0xa1/0x6ac
  jffs2_do_mount_fs.cold+0x5e6/0x2253
  jffs2_do_fill_super+0x383/0xc30
  jffs2_fill_super+0x2ea/0x4c0
 [...]

 The buggy address belongs to the object at ffff8881243384b8
  which belongs to the cache jffs2_xattr_ref of size 48
 The buggy address is located 40 bytes inside of
  48-byte region [ffff8881243384b8, ffff8881243384e8)
 [...]
 ==================================================================

The triggering of the BUG is shown in the following stack:
-----------------------------------------------------------
jffs2_fill_super
  jffs2_do_fill_super
    jffs2_do_mount_fs
      jffs2_build_filesystem
        jffs2_scan_medium
          jffs2_scan_eraseblock        <--- ERROR
        jffs2_clear_xattr_subsystem    <--- free
    jffs2_clear_xattr_subsystem        <--- free again
-----------------------------------------------------------

An error is returned in jffs2_do_mount_fs(). If the error is returned
by jffs2_sum_init(), the jffs2_clear_xattr_subsystem() does not need to
be executed. If the error is returned by jffs2_build_filesystem(), the
jffs2_clear_xattr_subsystem() also does not need to be executed again.
So move jffs2_clear_xattr_subsystem() from 'out_inohash' to 'out_root'
to fix this UAF problem.

Fixes: aa98d7cf59b5 ("[JFFS2][XATTR] XATTR support on JFFS2 (version. 5)")
Cc: stable@vger.kernel.org
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/jffs2/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 2ac410477c4f..71f03a5d36ed 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -603,8 +603,8 @@ int jffs2_do_fill_super(struct super_block *sb, struct fs_context *fc)
 	jffs2_free_ino_caches(c);
 	jffs2_free_raw_node_refs(c);
 	kvfree(c->blocks);
- out_inohash:
 	jffs2_clear_xattr_subsystem(c);
+ out_inohash:
 	kfree(c->inocache_list);
  out_wbuf:
 	jffs2_flash_cleanup(c);
-- 
2.31.1

