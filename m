Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CE76157BC
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiKBCh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiKBChy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:37:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812911B1EF
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:37:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C947617AD
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59979C433D7;
        Wed,  2 Nov 2022 02:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356665;
        bh=i2d4y0pdHZmPNA5T+qYwUJyWrEbYTBbJDexJ9TWUkO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+GEgYlO5TMtqS36QzuTSvwSEZ8fwHCyNSYOubLa5JG2Yn3r/YG4uW+6UJD7HMT09
         dtJuj/kAwwR4mrG3u6abMEqGZ7N0d4zmNSo38WGtvWu9R3Y3INzOTOvkVIv+PUUYCe
         z7bfQwMDm9APs+tYjyd4WZrcfFwgJ4KL0YQ1Ali0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Phillip Lougher <phillip@squashfs.org.uk>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Slade Watkins <srw@sladewatkins.net>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Marc Miltenberger <marcmiltenberger@gmail.com>,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 039/240] squashfs: fix read regression introduced in readahead code
Date:   Wed,  2 Nov 2022 03:30:14 +0100
Message-Id: <20221102022112.286973742@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Lougher <phillip@squashfs.org.uk>

commit 9ef8eb6104527bfe9ed31f7a4ffa721390adf9a8 upstream.

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
Reported-by: Marc Miltenberger <marcmiltenberger@gmail.com>
Cc: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/file.c       |    7 ++++---
 fs/squashfs/page_actor.c |    3 +++
 fs/squashfs/page_actor.h |    6 +++++-
 3 files changed, 12 insertions(+), 4 deletions(-)

--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
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
--- a/fs/squashfs/page_actor.c
+++ b/fs/squashfs/page_actor.c
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
--- a/fs/squashfs/page_actor.h
+++ b/fs/squashfs/page_actor.h
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


