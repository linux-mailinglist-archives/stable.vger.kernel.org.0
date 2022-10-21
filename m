Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CC1606C8E
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 02:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiJUAlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 20:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJUAlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 20:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847DD836F0;
        Thu, 20 Oct 2022 17:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A820616D9;
        Fri, 21 Oct 2022 00:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78900C433C1;
        Fri, 21 Oct 2022 00:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666312838;
        bh=QsehJkgZTofB3HQMWEJjTmeqRHZd2lLcMWCZwwd+JqA=;
        h=Date:To:From:Subject:From;
        b=zPHfurVuxkPGWK5FOtEqDzUGGgIgh3bOJ9kNn8oHjOXKldXn0uYOtSjYIwLkFzKs1
         c0hH3GlMarc339Rjtui4CqMmOVec55EblHee9TWpT0/ABH97pG3RCbxC5LqpnwGJXi
         ra+wuLJ8YJHR6XUbWYCL/sVrfQhYdgM1BIeXEt9s=
Date:   Thu, 20 Oct 2022 17:40:37 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        srw@sladewatkins.net, regressions@leemhuis.info,
        mirsad.todorovac@alu.unizg.hr, hsinyi@chromium.org,
        dimitri.ledkov@canonical.com, bagasdotme@gmail.com,
        phillip@squashfs.org.uk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-read-regression-introduced-in-readahead-code.patch added to mm-hotfixes-unstable branch
Message-Id: <20221021004038.78900C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: squashfs: fix read regression introduced in readahead code
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-fix-read-regression-introduced-in-readahead-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-read-regression-introduced-in-readahead-code.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: fix read regression introduced in readahead code
Date: Thu, 20 Oct 2022 23:36:14 +0100

Patch series "squashfs: fix some regressions introduced in the readahead
code".

This patchset fixes 3 regressions introduced by the recent readahead code
changes.  The first regression is causing "snaps" to randomly fail after a
couple of hours or days, which how the regression came to light.


This patch (of 3):

If a file isn't a whole multiple of the page size, the last page will have
trailing bytes unfilled.

There was a mistake in the readahead code which did this.  In particular
it incorrectly assumed that the last page in the readahead page array
(page[nr_pages - 1]) will always contain the last page in the block, which
if we're at file end, will be the page that needs to be zero filled.

But the readahead code may not return the last page in the block, which
means it is unmapped and will be skipped by the decompressors (a temporary
buffer used).

In this case the zero filling code will zero out the wrong page, leading
to data corruption.

Fix this by by extending the "page actor" to return the last page if
present, or NULL if a temporary buffer was used.

Link: https://lkml.kernel.org/r/20221020223616.7571-1-phillip@squashfs.org.uk
Link: https://lkml.kernel.org/r/20221020223616.7571-2-phillip@squashfs.org.uk
Fixes: 8fc78b6fe24c ("squashfs: implement readahead")
Link: https://lore.kernel.org/lkml/b0c258c3-6dcf-aade-efc4-d62a8b3a1ce2@alu.unizg.hr/
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Tested-by: Slade Watkins <srw@sladewatkins.net>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: <stable@vger.kernel.org>
Cc: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c       |    7 ++++---
 fs/squashfs/page_actor.c |    3 +++
 fs/squashfs/page_actor.h |    6 +++++-
 3 files changed, 12 insertions(+), 4 deletions(-)

--- a/fs/squashfs/file.c~squashfs-fix-read-regression-introduced-in-readahead-code
+++ a/fs/squashfs/file.c
@@ -557,6 +557,7 @@ static void squashfs_readahead(struct re
 		int res, bsize;
 		u64 block = 0;
 		unsigned int expected;
+		struct page *last_page;
 
 		nr_pages = __readahead_batch(ractl, pages, max_pages);
 		if (!nr_pages)
@@ -593,15 +594,15 @@ static void squashfs_readahead(struct re
 
 		res = squashfs_read_data(inode->i_sb, block, bsize, NULL, actor);
 
-		squashfs_page_actor_free(actor);
+		last_page = squashfs_page_actor_free(actor);
 
 		if (res == expected) {
 			int bytes;
 
 			/* Last page (if present) may have trailing bytes not filled */
 			bytes = res % PAGE_SIZE;
-			if (pages[nr_pages - 1]->index == file_end && bytes)
-				memzero_page(pages[nr_pages - 1], bytes,
+			if (index == file_end && bytes && last_page)
+				memzero_page(last_page, bytes,
 					     PAGE_SIZE - bytes);
 
 			for (i = 0; i < nr_pages; i++) {
--- a/fs/squashfs/page_actor.c~squashfs-fix-read-regression-introduced-in-readahead-code
+++ a/fs/squashfs/page_actor.c
@@ -71,11 +71,13 @@ static void *handle_next_page(struct squ
 			(actor->next_index != actor->page[actor->next_page]->index)) {
 		actor->next_index++;
 		actor->returned_pages++;
+		actor->last_page = NULL;
 		return actor->alloc_buffer ? actor->tmp_buffer : ERR_PTR(-ENOMEM);
 	}
 
 	actor->next_index++;
 	actor->returned_pages++;
+	actor->last_page = actor->page[actor->next_page];
 	return actor->pageaddr = kmap_local_page(actor->page[actor->next_page++]);
 }
 
@@ -125,6 +127,7 @@ struct squashfs_page_actor *squashfs_pag
 	actor->returned_pages = 0;
 	actor->next_index = page[0]->index & ~((1 << (msblk->block_log - PAGE_SHIFT)) - 1);
 	actor->pageaddr = NULL;
+	actor->last_page = NULL;
 	actor->alloc_buffer = msblk->decompressor->alloc_buffer;
 	actor->squashfs_first_page = direct_first_page;
 	actor->squashfs_next_page = direct_next_page;
--- a/fs/squashfs/page_actor.h~squashfs-fix-read-regression-introduced-in-readahead-code
+++ a/fs/squashfs/page_actor.h
@@ -16,6 +16,7 @@ struct squashfs_page_actor {
 	void    *(*squashfs_first_page)(struct squashfs_page_actor *);
 	void    *(*squashfs_next_page)(struct squashfs_page_actor *);
 	void    (*squashfs_finish_page)(struct squashfs_page_actor *);
+	struct page *last_page;
 	int	pages;
 	int	length;
 	int	next_page;
@@ -29,10 +30,13 @@ extern struct squashfs_page_actor *squas
 extern struct squashfs_page_actor *squashfs_page_actor_init_special(
 				struct squashfs_sb_info *msblk,
 				struct page **page, int pages, int length);
-static inline void squashfs_page_actor_free(struct squashfs_page_actor *actor)
+static inline struct page *squashfs_page_actor_free(struct squashfs_page_actor *actor)
 {
+	struct page *last_page = actor->last_page;
+
 	kfree(actor->tmp_buffer);
 	kfree(actor);
+	return last_page;
 }
 static inline void *squashfs_first_page(struct squashfs_page_actor *actor)
 {
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-read-regression-introduced-in-readahead-code.patch
squashfs-fix-extending-readahead-beyond-end-of-file.patch
squashfs-fix-buffer-release-race-condition-in-readahead-code.patch

