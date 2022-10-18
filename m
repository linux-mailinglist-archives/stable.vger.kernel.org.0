Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D1E601ECB
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiJRANW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiJRAMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:12:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE3989900;
        Mon, 17 Oct 2022 17:09:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F6D6B81BDD;
        Tue, 18 Oct 2022 00:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED06CC433D6;
        Tue, 18 Oct 2022 00:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051768;
        bh=LnC7oAMF2uU7hieFmbfSfjWbCaLHnw8ddFME8BBk0Cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0gGmgH4aPHSnLTbq4CYaWBEli5LgL9H+nxi5BjwCu8NLEHy0O+v1BsFzkRgK1w7S
         wG8qJCtnkrfNdehUB//YbJl2xwWLHYzoXjYd7Pu8rD5lbhIKXvEx/JMs5h5D4/B1Gt
         CC4VLhrUYkdzQi7q6FEHrRgJsTaNHippWGuuDhW/E/D4Y51xg1hS6p4oE9eF4N2nH6
         gxRXWznNMNeawbmdbNEXPUKoH6LIxE0NJx+HQocq0evlYM7PKl/Wcse9YcB5gu0aAx
         O14YkfaG/HscMV3nmg/SIq8fUHwLRg4ggFLXKI5lMq7IqAKoFiDZ8X9WjMGDKkKN/I
         +ormXyOZDP7dA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuqi Zhang <zhangshuqi3@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, chao@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.19 22/29] f2fs: fix wrong dirty page count when race between mmap and fallocate.
Date:   Mon, 17 Oct 2022 20:08:31 -0400
Message-Id: <20221018000839.2730954-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000839.2730954-1-sashal@kernel.org>
References: <20221018000839.2730954-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuqi Zhang <zhangshuqi3@huawei.com>

[ Upstream commit 9b7eadd9bd3a0cc24533a23d83c46430a0ea60ff ]

This is a BUG_ON issue as follows when running xfstest-generic-503:
WARNING: CPU: 21 PID: 1385 at fs/f2fs/inode.c:762 f2fs_evict_inode+0x847/0xaa0
Modules linked in:
CPU: 21 PID: 1385 Comm: umount Not tainted 5.19.0-rc5+ #73
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/01/2014

Call Trace:
evict+0x129/0x2d0
dispose_list+0x4f/0xb0
evict_inodes+0x204/0x230
generic_shutdown_super+0x5b/0x1e0
kill_block_super+0x29/0x80
kill_f2fs_super+0xe6/0x140
deactivate_locked_super+0x44/0xc0
deactivate_super+0x79/0x90
cleanup_mnt+0x114/0x1a0
__cleanup_mnt+0x16/0x20
task_work_run+0x98/0x100
exit_to_user_mode_prepare+0x3d0/0x3e0
syscall_exit_to_user_mode+0x12/0x30
do_syscall_64+0x42/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

Function flow analysis when BUG occurs:
f2fs_fallocate                    mmap
                                  do_page_fault
                                    pte_spinlock  // ---lock_pte
                                    do_wp_page
                                      wp_page_shared
                                        pte_unmap_unlock   // unlock_pte
                                          do_page_mkwrite
                                          f2fs_vm_page_mkwrite
                                            down_read(invalidate_lock)
                                            lock_page
                                            if (PageMappedToDisk(page))
                                              goto out;
                                            // set_page_dirty  --NOT RUN
                                            out: up_read(invalidate_lock);
                                        finish_mkwrite_fault // unlock_pte
f2fs_collapse_range
  down_write(i_mmap_sem)
  truncate_pagecache
    unmap_mapping_pages
      i_mmap_lock_write // down_write(i_mmap_rwsem)
        ......
        zap_pte_range
          pte_offset_map_lock // ---lock_pte
           set_page_dirty
            f2fs_dirty_data_folio
              if (!folio_test_dirty(folio)) {
                                        fault_dirty_shared_page
                                          set_page_dirty
                                            f2fs_dirty_data_folio
                                              if (!folio_test_dirty(folio)) {
                                                filemap_dirty_folio
                                                f2fs_update_dirty_folio // ++
                                              }
                                            unlock_page
                filemap_dirty_folio
                f2fs_update_dirty_folio // page count++
              }
          pte_unmap_unlock  // --unlock_pte
      i_mmap_unlock_write  // up_write(i_mmap_rwsem)
  truncate_inode_pages
  up_write(i_mmap_sem)

When race happens between mmap-do_page_fault-wp_page_shared and
fallocate-truncate_pagecache-zap_pte_range, the zap_pte_range calls
function set_page_dirty without page lock. Besides, though
truncate_pagecache has immap and pte lock, wp_page_shared calls
fault_dirty_shared_page without any. In this case, two threads race
in f2fs_dirty_data_folio function. Page is set to dirty only ONCE,
but the count is added TWICE by calling filemap_dirty_folio.
Thus the count of dirty page cannot accord with the real dirty pages.

Following is the solution to in case of race happens without any lock.
Since folio_test_set_dirty in filemap_dirty_folio is atomic, judge return
value will not be at risk of race.

Signed-off-by: Shuqi Zhang <zhangshuqi3@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 3 +--
 fs/f2fs/data.c       | 3 +--
 fs/f2fs/node.c       | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 6d8b2bf14de0..01d3eede0b29 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -448,8 +448,7 @@ static bool f2fs_dirty_meta_folio(struct address_space *mapping,
 
 	if (!folio_test_uptodate(folio))
 		folio_mark_uptodate(folio);
-	if (!folio_test_dirty(folio)) {
-		filemap_dirty_folio(mapping, folio);
+	if (filemap_dirty_folio(mapping, folio)) {
 		inc_page_count(F2FS_M_SB(mapping), F2FS_DIRTY_META);
 		set_page_private_reference(&folio->page);
 		return true;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index f2a272613477..9157d09dde6d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3681,8 +3681,7 @@ static bool f2fs_dirty_data_folio(struct address_space *mapping,
 		folio_mark_uptodate(folio);
 	BUG_ON(folio_test_swapcache(folio));
 
-	if (!folio_test_dirty(folio)) {
-		filemap_dirty_folio(mapping, folio);
+	if (filemap_dirty_folio(mapping, folio)) {
 		f2fs_update_dirty_folio(inode, folio);
 		return true;
 	}
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 02e92a72511b..3f508b13cb61 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2151,8 +2151,7 @@ static bool f2fs_dirty_node_folio(struct address_space *mapping,
 	if (IS_INODE(&folio->page))
 		f2fs_inode_chksum_set(F2FS_M_SB(mapping), &folio->page);
 #endif
-	if (!folio_test_dirty(folio)) {
-		filemap_dirty_folio(mapping, folio);
+	if (filemap_dirty_folio(mapping, folio)) {
 		inc_page_count(F2FS_M_SB(mapping), F2FS_DIRTY_NODES);
 		set_page_private_reference(&folio->page);
 		return true;
-- 
2.35.1

