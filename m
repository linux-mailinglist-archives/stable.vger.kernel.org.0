Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D535481A01
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 07:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbhL3Gk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 01:40:59 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34861 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236546AbhL3Gk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 01:40:57 -0500
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JPdtx1JKGzcbpM;
        Thu, 30 Dec 2021 14:40:25 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Thu, 30 Dec
 2021 14:40:53 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <richard@nod.at>, <dwmw2@infradead.org>, <lizhe67@huawei.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC:     <libaokun1@huawei.com>, <yukuai3@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH -next 2/2] jffs2: fix memory leak in jffs2_scan_medium
Date:   Thu, 30 Dec 2021 14:52:15 +0800
Message-ID: <20211230065215.3747576-3-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211230065215.3747576-1-libaokun1@huawei.com>
References: <20211230065215.3747576-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If an error is returned in jffs2_scan_eraseblock() and some memory
has been added to the jffs2_summary *s, we can observe the following
kmemleak report:

--------------------------------------------
unreferenced object 0xffff88812b889c40 (size 64):
  comm "mount", pid 692, jiffies 4294838325 (age 34.288s)
  hex dump (first 32 bytes):
    40 48 b5 14 81 88 ff ff 01 e0 31 00 00 00 50 00  @H........1...P.
    00 00 01 00 00 00 01 00 00 00 02 00 00 00 09 08  ................
  backtrace:
    [<ffffffffae93a3a3>] __kmalloc+0x613/0x910
    [<ffffffffaf423b9c>] jffs2_sum_add_dirent_mem+0x5c/0xa0
    [<ffffffffb0f3afa8>] jffs2_scan_medium.cold+0x36e5/0x4794
    [<ffffffffb0f3dbe1>] jffs2_do_mount_fs.cold+0xa7/0x2267
    [<ffffffffaf40acf3>] jffs2_do_fill_super+0x383/0xc30
    [<ffffffffaf40c00a>] jffs2_fill_super+0x2ea/0x4c0
    [<ffffffffb0315d64>] mtd_get_sb+0x254/0x400
    [<ffffffffb0315f5f>] mtd_get_sb_by_nr+0x4f/0xd0
    [<ffffffffb0316478>] get_tree_mtd+0x498/0x840
    [<ffffffffaf40bd15>] jffs2_get_tree+0x25/0x30
    [<ffffffffae9f358d>] vfs_get_tree+0x8d/0x2e0
    [<ffffffffaea7a98f>] path_mount+0x50f/0x1e50
    [<ffffffffaea7c3d7>] do_mount+0x107/0x130
    [<ffffffffaea7c5c5>] __se_sys_mount+0x1c5/0x2f0
    [<ffffffffaea7c917>] __x64_sys_mount+0xc7/0x160
    [<ffffffffb10142f5>] do_syscall_64+0x45/0x70
unreferenced object 0xffff888114b54840 (size 32):
  comm "mount", pid 692, jiffies 4294838325 (age 34.288s)
  hex dump (first 32 bytes):
    c0 75 b5 14 81 88 ff ff 02 e0 02 00 00 00 02 00  .u..............
    00 00 84 00 00 00 44 00 00 00 6b 6b 6b 6b 6b a5  ......D...kkkkk.
  backtrace:
    [<ffffffffae93be24>] kmem_cache_alloc_trace+0x584/0x880
    [<ffffffffaf423b04>] jffs2_sum_add_inode_mem+0x54/0x90
    [<ffffffffb0f3bd44>] jffs2_scan_medium.cold+0x4481/0x4794
    [...]
unreferenced object 0xffff888114b57280 (size 32):
  comm "mount", pid 692, jiffies 4294838393 (age 34.357s)
  hex dump (first 32 bytes):
    10 d5 6c 11 81 88 ff ff 08 e0 05 00 00 00 01 00  ..l.............
    00 00 38 02 00 00 28 00 00 00 6b 6b 6b 6b 6b a5  ..8...(...kkkkk.
  backtrace:
    [<ffffffffae93be24>] kmem_cache_alloc_trace+0x584/0x880
    [<ffffffffaf423c34>] jffs2_sum_add_xattr_mem+0x54/0x90
    [<ffffffffb0f3a24f>] jffs2_scan_medium.cold+0x298c/0x4794
    [...]
unreferenced object 0xffff8881116cd510 (size 16):
  comm "mount", pid 692, jiffies 4294838395 (age 34.355s)
  hex dump (first 16 bytes):
    00 00 00 00 00 00 00 00 09 e0 60 02 00 00 6b a5  ..........`...k.
  backtrace:
    [<ffffffffae93be24>] kmem_cache_alloc_trace+0x584/0x880
    [<ffffffffaf423cc4>] jffs2_sum_add_xref_mem+0x54/0x90
    [<ffffffffb0f3b2e3>] jffs2_scan_medium.cold+0x3a20/0x4794
    [...]
--------------------------------------------

Therefore, when processing errors, it is necessary to determine whether
s->sum_list_head is NULL. If not, call jffs2_sum_reset_collected(s) to
release the memory added in s.

Fixes: e631ddba5887 ("[JFFS2] Add erase block summary support (mount time improvement)")
Cc: stable@vger.kernel.org
Co-developed-with: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/jffs2/scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jffs2/scan.c b/fs/jffs2/scan.c
index b676056826be..49b0637fb36e 100644
--- a/fs/jffs2/scan.c
+++ b/fs/jffs2/scan.c
@@ -281,6 +281,8 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 	else
 		mtd_unpoint(c->mtd, 0, c->mtd->size);
 #endif
+	if (s->sum_list_head)
+		jffs2_sum_reset_collected(s);
 	kfree(s);
 	return ret;
 }
-- 
2.31.1

