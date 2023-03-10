Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D995B6B42BD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjCJOG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjCJOGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:06:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327FB10FB9D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:05:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C80460F11
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4765C433EF;
        Fri, 10 Mar 2023 14:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457155;
        bh=Y/F9FQehCBtrVJAaGZyYyQ8NBoZzhC7l6nfbBagWduk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWTTkivVnCYAWWU2/ACSVPxtisei5m8fw6sNG6KHiaOG4enJdTsod2o4dUhUwBYeM
         BzZQn+5TAZtmdmotCfo/56h8Z6WqddgGv0OrG5TFO7CIyvAdvWKO+zugKFUhzDmqzV
         T6d3CdLKHya6FE++pQx3PBsEZ4qJ7n8vkAuW1YDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/200] ubifs: ubifs_releasepage: Remove ubifs_assert(0) to valid this process
Date:   Fri, 10 Mar 2023 14:37:26 +0100
Message-Id: <20230310133718.258011499@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 66f4742e93523ab2f062d9d9828b3e590bc61536 ]

There are two states for ubifs writing pages:
1. Dirty, Private
2. Not Dirty, Not Private

The normal process cannot go to ubifs_releasepage() which means there
exists pages being private but not dirty. Reproducer[1] shows that it
could occur (which maybe related to [2]) with following process:

     PA                     PB                    PC
lock(page)[PA]
ubifs_write_end
  attach_page_private         // set Private
  __set_page_dirty_nobuffers  // set Dirty
unlock(page)

write_cache_pages[PA]
  lock(page)
  clear_page_dirty_for_io(page)	// clear Dirty
  ubifs_writepage

                        do_truncation[PB]
			  truncate_setsize
			    i_size_write(inode, newsize) // newsize = 0

    i_size = i_size_read(inode)	// i_size = 0
    end_index = i_size >> PAGE_SHIFT
    if (page->index > end_index)
      goto out // jump
out:
unlock(page)   // Private, Not Dirty

						generic_fadvise[PC]
						  lock(page)
						  invalidate_inode_page
						    try_to_release_page
						      ubifs_releasepage
						        ubifs_assert(c, 0)
		                                        // bad assertion!
						  unlock(page)
			  truncate_pagecache[PB]

Then we may get following assertion failed:
  UBIFS error (ubi0:0 pid 1683): ubifs_assert_failed [ubifs]:
  UBIFS assert failed: 0, in fs/ubifs/file.c:1513
  UBIFS warning (ubi0:0 pid 1683): ubifs_ro_mode [ubifs]:
  switched to read-only mode, error -22
  CPU: 2 PID: 1683 Comm: aa Not tainted 5.16.0-rc5-00184-g0bca5994cacc-dirty #308
  Call Trace:
    dump_stack+0x13/0x1b
    ubifs_ro_mode+0x54/0x60 [ubifs]
    ubifs_assert_failed+0x4b/0x80 [ubifs]
    ubifs_releasepage+0x67/0x1d0 [ubifs]
    try_to_release_page+0x57/0xe0
    invalidate_inode_page+0xfb/0x130
    __invalidate_mapping_pages+0xb9/0x280
    invalidate_mapping_pagevec+0x12/0x20
    generic_fadvise+0x303/0x3c0
    ksys_fadvise64_64+0x4c/0xb0

[1] https://bugzilla.kernel.org/show_bug.cgi?id=215373
[2] https://linux-mtd.infradead.narkive.com/NQoBeT1u/patch-rfc-ubifs-fix-assert-failed-in-ubifs-set-page-dirty

Fixes: 1e51764a3c2ac0 ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/file.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 1f429260a85fc..10c1779af9c51 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1472,14 +1472,23 @@ static bool ubifs_release_folio(struct folio *folio, gfp_t unused_gfp_flags)
 	struct inode *inode = folio->mapping->host;
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 
-	/*
-	 * An attempt to release a dirty page without budgeting for it - should
-	 * not happen.
-	 */
 	if (folio_test_writeback(folio))
 		return false;
+
+	/*
+	 * Page is private but not dirty, weird? There is one condition
+	 * making it happened. ubifs_writepage skipped the page because
+	 * page index beyonds isize (for example. truncated by other
+	 * process named A), then the page is invalidated by fadvise64
+	 * syscall before being truncated by process A.
+	 */
 	ubifs_assert(c, folio_test_private(folio));
-	ubifs_assert(c, 0);
+	if (folio_test_checked(folio))
+		release_new_page_budget(c);
+	else
+		release_existing_page_budget(c);
+
+	atomic_long_dec(&c->dirty_pg_cnt);
 	folio_detach_private(folio);
 	folio_clear_checked(folio);
 	return true;
-- 
2.39.2



