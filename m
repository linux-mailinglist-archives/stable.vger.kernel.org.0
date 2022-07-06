Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CB5567F90
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 09:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiGFHJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 03:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiGFHJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 03:09:09 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4076220C1;
        Wed,  6 Jul 2022 00:09:08 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Ld9ZT3lBrz19G1p;
        Wed,  6 Jul 2022 15:06:41 +0800 (CST)
Received: from dggpemm100009.china.huawei.com (7.185.36.113) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 6 Jul 2022 15:08:52 +0800
Received: from huawei.com (10.175.113.32) by dggpemm100009.china.huawei.com
 (7.185.36.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 6 Jul
 2022 15:08:51 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        William Kucharski <william.kucharski@oracle.com>,
        "Christoph Hellwig" <hch@lst.de>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH 5.15 v3] mm/filemap: fix UAF in find_lock_entries
Date:   Wed, 6 Jul 2022 15:45:27 +0800
Message-ID: <20220706074527.1406924-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm100009.china.huawei.com (7.185.36.113)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Release refcount after xas_set to fix UAF which may cause panic like this:

 page:ffffea000491fa40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x1247e9
 head:ffffea000491fa00 order:3 compound_mapcount:0 compound_pincount:0
 memcg:ffff888104f91091
 flags: 0x2fffff80010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
...
page dumped because: VM_BUG_ON_PAGE(PageTail(page))
 ------------[ cut here ]------------
 kernel BUG at include/linux/page-flags.h:632!
 invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN
 CPU: 1 PID: 7642 Comm: sh Not tainted 5.15.51-dirty #26
...
 Call Trace:
  <TASK>
  __invalidate_mapping_pages+0xe7/0x540
  drop_pagecache_sb+0x159/0x320
  iterate_supers+0x120/0x240
  drop_caches_sysctl_handler+0xaa/0xe0
  proc_sys_call_handler+0x2b4/0x480
  new_sync_write+0x3d6/0x5c0
  vfs_write+0x446/0x7a0
  ksys_write+0x105/0x210
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f52b5733130
...

This problem has been fixed on mainline by patch 6b24ca4a1a8d ("mm: Use
multi-index entries in the page cache") since it deletes the related code.

Fixes: 5c211ba29deb ("mm: add and use find_lock_entries")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 mm/filemap.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 00e391e75880..c3e1fc0520dc 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2090,7 +2090,11 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
 
 	rcu_read_lock();
 	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
+		unsigned long next_idx = xas.xa_index;
+
 		if (!xa_is_value(page)) {
+			if (PageTransHuge(page))
+				next_idx = page->index + thp_nr_pages(page);
 			if (page->index < start)
 				goto put;
 			if (page->index + thp_nr_pages(page) - 1 > end)
@@ -2111,13 +2115,11 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
 put:
 		put_page(page);
 next:
-		if (!xa_is_value(page) && PageTransHuge(page)) {
-			unsigned int nr_pages = thp_nr_pages(page);
-
+		if (next_idx != xas.xa_index) {
 			/* Final THP may cross MAX_LFS_FILESIZE on 32-bit */
-			xas_set(&xas, page->index + nr_pages);
-			if (xas.xa_index < nr_pages)
+			if (next_idx < xas.xa_index)
 				break;
+			xas_set(&xas, next_idx);
 		}
 	}
 	rcu_read_unlock();
-- 
2.25.1

