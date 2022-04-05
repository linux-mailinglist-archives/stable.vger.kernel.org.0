Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D764F3340
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245297AbiDEIyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240957AbiDEIcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396808FE7A;
        Tue,  5 Apr 2022 01:25:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B80560FFC;
        Tue,  5 Apr 2022 08:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3B8C385A1;
        Tue,  5 Apr 2022 08:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147127;
        bh=bymNXs9RSnkFw+C4LkYHYp5fkQlBVZApsmk8h49t/k0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDQ7In1aEyagAmhskaibY/4gmFYYBg1U9X7jG0dcYpstG9h4j1b37ufNZR+TNb8ED
         YYlfsY7WwlBRdhwIJDMXeOV5SFiWy/MIXidp6s1YsO+sAECbZeB2RImog8K+4Ib+Nh
         1ipA3OwCe/Sd3Lk5lIbSYGp0C+eS8gUZAsbwyHAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.17 1012/1126] ubifs: Fix to add refcount once page is set private
Date:   Tue,  5 Apr 2022 09:29:19 +0200
Message-Id: <20220405070437.193663780@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 3b67db8a6ca83e6ff90b756d3da0c966f61cd37b upstream.

MM defined the rule [1] very clearly that once page was set with PG_private
flag, we should increment the refcount in that page, also main flows like
pageout(), migrate_page() will assume there is one additional page
reference count if page_has_private() returns true. Otherwise, we may
get a BUG in page migration:

  page:0000000080d05b9d refcount:-1 mapcount:0 mapping:000000005f4d82a8
  index:0xe2 pfn:0x14c12
  aops:ubifs_file_address_operations [ubifs] ino:8f1 dentry name:"f30e"
  flags: 0x1fffff80002405(locked|uptodate|owner_priv_1|private|node=0|
  zone=1|lastcpupid=0x1fffff)
  page dumped because: VM_BUG_ON_PAGE(page_count(page) != 0)
  ------------[ cut here ]------------
  kernel BUG at include/linux/page_ref.h:184!
  invalid opcode: 0000 [#1] SMP
  CPU: 3 PID: 38 Comm: kcompactd0 Not tainted 5.15.0-rc5
  RIP: 0010:migrate_page_move_mapping+0xac3/0xe70
  Call Trace:
    ubifs_migrate_page+0x22/0xc0 [ubifs]
    move_to_new_page+0xb4/0x600
    migrate_pages+0x1523/0x1cc0
    compact_zone+0x8c5/0x14b0
    kcompactd+0x2bc/0x560
    kthread+0x18c/0x1e0
    ret_from_fork+0x1f/0x30

Before the time, we should make clean a concept, what does refcount means
in page gotten from grab_cache_page_write_begin(). There are 2 situations:
Situation 1: refcount is 3, page is created by __page_cache_alloc.
  TYPE_A - the write process is using this page
  TYPE_B - page is assigned to one certain mapping by calling
	   __add_to_page_cache_locked()
  TYPE_C - page is added into pagevec list corresponding current cpu by
	   calling lru_cache_add()
Situation 2: refcount is 2, page is gotten from the mapping's tree
  TYPE_B - page has been assigned to one certain mapping
  TYPE_A - the write process is using this page (by calling
	   page_cache_get_speculative())
Filesystem releases one refcount by calling put_page() in xxx_write_end(),
the released refcount corresponds to TYPE_A (write task is using it). If
there are any processes using a page, page migration process will skip the
page by judging whether expected_page_refs() equals to page refcount.

The BUG is caused by following process:
    PA(cpu 0)                           kcompactd(cpu 1)
				compact_zone
ubifs_write_begin
  page_a = grab_cache_page_write_begin
    add_to_page_cache_lru
      lru_cache_add
        pagevec_add // put page into cpu 0's pagevec
  (refcnf = 3, for page creation process)
ubifs_write_end
  SetPagePrivate(page_a) // doesn't increase page count !
  unlock_page(page_a)
  put_page(page_a)  // refcnt = 2
				[...]

    PB(cpu 0)
filemap_read
  filemap_get_pages
    add_to_page_cache_lru
      lru_cache_add
        __pagevec_lru_add // traverse all pages in cpu 0's pagevec
	  __pagevec_lru_add_fn
	    SetPageLRU(page_a)
				isolate_migratepages
                                  isolate_migratepages_block
				    get_page_unless_zero(page_a)
				    // refcnt = 3
                                      list_add(page_a, from_list)
				migrate_pages(from_list)
				  __unmap_and_move
				    move_to_new_page
				      ubifs_migrate_page(page_a)
				        migrate_page_move_mapping
					  expected_page_refs get 3
                                  (migration[1] + mapping[1] + private[1])
	 release_pages
	   put_page_testzero(page_a) // refcnt = 3
                                          page_ref_freeze  // refcnt = 0
	     page_ref_dec_and_test(0 - 1 = -1)
                                          page_ref_unfreeze
                                            VM_BUG_ON_PAGE(-1 != 0, page)

UBIFS doesn't increase the page refcount after setting private flag, which
leads to page migration task believes the page is not used by any other
processes, so the page is migrated. This causes concurrent accessing on
page refcount between put_page() called by other process(eg. read process
calls lru_cache_add) and page_ref_unfreeze() called by migration task.

Actually zhangjun has tried to fix this problem [2] by recalculating page
refcnt in ubifs_migrate_page(). It's better to follow MM rules [1], because
just like Kirill suggested in [2], we need to check all users of
page_has_private() helper. Like f2fs does in [3], fix it by adding/deleting
refcount when setting/clearing private for a page. BTW, according to [4],
we set 'page->private' as 1 because ubifs just simply SetPagePrivate().
And, [5] provided a common helper to set/clear page private, ubifs can
use this helper following the example of iomap, afs, btrfs, etc.

Jump [6] to find a reproducer.

[1] https://lore.kernel.org/lkml/2b19b3c4-2bc4-15fa-15cc-27a13e5c7af1@aol.com
[2] https://www.spinics.net/lists/linux-mtd/msg04018.html
[3] http://lkml.iu.edu/hypermail/linux/kernel/1903.0/03313.html
[4] https://lore.kernel.org/linux-f2fs-devel/20210422154705.GO3596236@casper.infradead.org
[5] https://lore.kernel.org/all/20200517214718.468-1-guoqing.jiang@cloud.ionos.com
[6] https://bugzilla.kernel.org/show_bug.cgi?id=214961

Fixes: 1e51764a3c2ac0 ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/file.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -570,7 +570,7 @@ static int ubifs_write_end(struct file *
 	}
 
 	if (!PagePrivate(page)) {
-		SetPagePrivate(page);
+		attach_page_private(page, (void *)1);
 		atomic_long_inc(&c->dirty_pg_cnt);
 		__set_page_dirty_nobuffers(page);
 	}
@@ -947,7 +947,7 @@ static int do_writepage(struct page *pag
 		release_existing_page_budget(c);
 
 	atomic_long_dec(&c->dirty_pg_cnt);
-	ClearPagePrivate(page);
+	detach_page_private(page);
 	ClearPageChecked(page);
 
 	kunmap(page);
@@ -1304,7 +1304,7 @@ static void ubifs_invalidatepage(struct
 		release_existing_page_budget(c);
 
 	atomic_long_dec(&c->dirty_pg_cnt);
-	ClearPagePrivate(page);
+	detach_page_private(page);
 	ClearPageChecked(page);
 }
 
@@ -1471,8 +1471,8 @@ static int ubifs_migrate_page(struct add
 		return rc;
 
 	if (PagePrivate(page)) {
-		ClearPagePrivate(page);
-		SetPagePrivate(newpage);
+		detach_page_private(page);
+		attach_page_private(newpage, (void *)1);
 	}
 
 	if (mode != MIGRATE_SYNC_NO_COPY)
@@ -1496,7 +1496,7 @@ static int ubifs_releasepage(struct page
 		return 0;
 	ubifs_assert(c, PagePrivate(page));
 	ubifs_assert(c, 0);
-	ClearPagePrivate(page);
+	detach_page_private(page);
 	ClearPageChecked(page);
 	return 1;
 }
@@ -1567,7 +1567,7 @@ static vm_fault_t ubifs_vm_page_mkwrite(
 	else {
 		if (!PageChecked(page))
 			ubifs_convert_page_budget(c);
-		SetPagePrivate(page);
+		attach_page_private(page, (void *)1);
 		atomic_long_inc(&c->dirty_pg_cnt);
 		__set_page_dirty_nobuffers(page);
 	}


