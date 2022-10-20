Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B33606B58
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 00:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJTWjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 18:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJTWjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 18:39:22 -0400
X-Greylist: delayed 165 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Oct 2022 15:39:21 PDT
Received: from p3plwbeout15-02.prod.phx3.secureserver.net (p3plsmtp15-02-2.prod.phx3.secureserver.net [173.201.193.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6270DC42
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 15:39:20 -0700 (PDT)
Received: from mailex.mailcore.me ([94.136.40.142])
        by :WBEOUT: with ESMTP
        id le9SozUdUgJnvle9ToDIXy; Thu, 20 Oct 2022 15:36:35 -0700
X-CMAE-Analysis: v=2.4 cv=WcXJ12tX c=1 sm=1 tr=0 ts=6351cd73
 a=s1hRAmXuQnGNrIj+3lWWVA==:117 a=84ok6UeoqCVsigPHarzEiQ==:17
 a=ggZhUymU-5wA:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=gQ9z1Vi_AAAA:8
 a=pGLkceISAAAA:8 a=FXvPX3liAAAA:8 a=LyTzotujRfjnjsB5pxYA:9
 a=AjGcO6oz07-iQ99wixmX:22 a=TvPxYD56syJNzSX8U-5E:22 a=UObqyxdv-6Yh2QiB9mM_:22
X-SECURESERVER-ACCT: phillip@squashfs.org.uk  
X-SID:  le9SozUdUgJnv
Received: from 82-69-79-175.dsl.in-addr.zen.co.uk ([82.69.79.175] helo=phoenix.fritz.box)
        by smtp12.mailcore.me with esmtpa (Exim 4.94.2)
        (envelope-from <phillip@squashfs.org.uk>)
        id 1ole9R-0006zQ-Bl; Thu, 20 Oct 2022 23:36:33 +0100
From:   Phillip Lougher <phillip@squashfs.org.uk>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc:     hsinyi@chromium.org, regressions@leemhuis.info,
        regressions@lists.linux.dev, dimitri.ledkov@canonical.com,
        michael.vogt@canonical.com, phillip.lougher@gmail.com,
        ogra@ubuntu.com, olivier.tilloy@canonical.com,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Slade Watkins <srw@sladewatkins.net>,
        Bagas Sanjaya <bagasdotme@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] squashfs: fix read regression introduced in readahead code
Date:   Thu, 20 Oct 2022 23:36:14 +0100
Message-Id: <20221020223616.7571-2-phillip@squashfs.org.uk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221020223616.7571-1-phillip@squashfs.org.uk>
References: <20221020223616.7571-1-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mailcore-Auth: 439999529
X-Mailcore-Domain: 1394945
X-123-reg-Authenticated:  phillip@squashfs.org.uk  
X-Originating-IP: 82.69.79.175
X-CMAE-Envelope: MS4xfKZBdbxZBAoNqPHqI9NuRzl+GOzyCWZQCO6ZXbv/hiCUtlX8MY+jpDmRVuRF27M6mavTBLBRTrH+BRFIglHVQP7WN7LJlzpoyXcZIOBD9KtAFfC9O1Se
 60IbC4/w87Exglg/XTwxVyjasd7T58HLQyS8laZDUAq7aFYbjD+soa5fZvmY7Gd2o8qn8uA8FKkB1DfyfWQKvZC+Hv2kAKCxWA+pt/hkBRVJyMLBaNUreDYX
 LgQzZT0lUu7qy43yvhMDVQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a file isn't a whole multiple of the page size, the last page will
have trailing bytes unfilled.

There was a mistake in the readahead code which did this.  In
particular it incorrectly assumed that the last page in the
readahead page array (page[nr_pages - 1]) will always contain the
last page in the block, which if we're at file end, will be the page
that needs to be zero filled.

But the readahead code may not return the last page in the block, which
means it is unmapped and will be skipped by the decompressors (a
temporary buffer used).

In this case the zero filling code will zero out the wrong page, leading
to data corruption.

Fix this by by extending the "page actor" to return the last page if
present, or NULL if a temporary buffer was used.

Fixes: 8fc78b6fe24c ("squashfs: implement readahead")
Link: https://lore.kernel.org/lkml/b0c258c3-6dcf-aade-efc4-d62a8b3a1ce2@alu.unizg.hr/
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Tested-by: Slade Watkins <srw@sladewatkins.net>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/file.c       | 7 ++++---
 fs/squashfs/page_actor.c | 3 +++
 fs/squashfs/page_actor.h | 6 +++++-
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index e56510964b22..e526eb7a1658 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -557,6 +557,7 @@ static void squashfs_readahead(struct readahead_control *ractl)
 		int res, bsize;
 		u64 block = 0;
 		unsigned int expected;
+		struct page *last_page;
 
 		nr_pages = __readahead_batch(ractl, pages, max_pages);
 		if (!nr_pages)
@@ -593,15 +594,15 @@ static void squashfs_readahead(struct readahead_control *ractl)
 
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
diff --git a/fs/squashfs/page_actor.c b/fs/squashfs/page_actor.c
index 54b93bf4a25c..81af6c4ca115 100644
--- a/fs/squashfs/page_actor.c
+++ b/fs/squashfs/page_actor.c
@@ -71,11 +71,13 @@ static void *handle_next_page(struct squashfs_page_actor *actor)
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
 
@@ -125,6 +127,7 @@ struct squashfs_page_actor *squashfs_page_actor_init_special(struct squashfs_sb_
 	actor->returned_pages = 0;
 	actor->next_index = page[0]->index & ~((1 << (msblk->block_log - PAGE_SHIFT)) - 1);
 	actor->pageaddr = NULL;
+	actor->last_page = NULL;
 	actor->alloc_buffer = msblk->decompressor->alloc_buffer;
 	actor->squashfs_first_page = direct_first_page;
 	actor->squashfs_next_page = direct_next_page;
diff --git a/fs/squashfs/page_actor.h b/fs/squashfs/page_actor.h
index 95ffbb543d91..97d4983559b1 100644
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
@@ -29,10 +30,13 @@ extern struct squashfs_page_actor *squashfs_page_actor_init(void **buffer,
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
-- 
2.35.1

