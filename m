Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA64A59CB64
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 00:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiHVWYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 18:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiHVWYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 18:24:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3832A402EA;
        Mon, 22 Aug 2022 15:24:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C42BF6133D;
        Mon, 22 Aug 2022 22:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262EAC433D6;
        Mon, 22 Aug 2022 22:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661207072;
        bh=vLkPEvonAr06kBYz979KinBd/sipgibCBPcIxw4Pozw=;
        h=Date:To:From:Subject:From;
        b=hVKQ2x+VbNCJZYSWJSdw4vXyND3vsPyI6n+o6j+GCQbgErkJaovfU/MUY3vHppAft
         ZRQWhN8CH35AuI8v2vR8HP5SGkpRXQqUMxA5+X8MSdpm6e7/ZEvVqJMSnLT23zhvVN
         hrx7N/CdVOrBBCvjI+2MYu+Rdd+wzhrlHsRGvPco=
Date:   Mon, 22 Aug 2022 15:24:31 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        lists@colorremedies.com, phillip@squashfs.org.uk,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-dont-call-kmalloc-in-decompressors.patch added to mm-hotfixes-unstable branch
Message-Id: <20220822222432.262EAC433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: squashfs: don't call kmalloc in decompressors
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-dont-call-kmalloc-in-decompressors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-dont-call-kmalloc-in-decompressors.patch

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
Subject: squashfs: don't call kmalloc in decompressors
Date: Mon, 22 Aug 2022 22:54:30 +0100

The decompressors may be called while in an atomic section.  So move the
kmalloc() out of this path, and into the "page actor" init function.

This fixes a regression introduced by commit
f268eedddf35 ("squashfs: extend "page actor" to handle missing pages")

Link: https://lkml.kernel.org/r/20220822215430.15933-1-phillip@squashfs.org.uk
Fixes: f268eedddf35 ("squashfs: extend "page actor" to handle missing pages")
Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c        |    2 +-
 fs/squashfs/file_direct.c |    2 +-
 fs/squashfs/page_actor.c  |   34 +++++++++++++++-------------------
 fs/squashfs/page_actor.h  |    5 +++++
 4 files changed, 22 insertions(+), 21 deletions(-)

--- a/fs/squashfs/file.c~squashfs-dont-call-kmalloc-in-decompressors
+++ a/fs/squashfs/file.c
@@ -593,7 +593,7 @@ static void squashfs_readahead(struct re
 
 		res = squashfs_read_data(inode->i_sb, block, bsize, NULL, actor);
 
-		kfree(actor);
+		squashfs_page_actor_free(actor);
 
 		if (res == expected) {
 			int bytes;
--- a/fs/squashfs/file_direct.c~squashfs-dont-call-kmalloc-in-decompressors
+++ a/fs/squashfs/file_direct.c
@@ -74,7 +74,7 @@ int squashfs_readpage_block(struct page
 	/* Decompress directly into the page cache buffers */
 	res = squashfs_read_data(inode->i_sb, block, bsize, NULL, actor);
 
-	kfree(actor);
+	squashfs_page_actor_free(actor);
 
 	if (res < 0)
 		goto mark_errored;
--- a/fs/squashfs/page_actor.c~squashfs-dont-call-kmalloc-in-decompressors
+++ a/fs/squashfs/page_actor.c
@@ -52,6 +52,7 @@ struct squashfs_page_actor *squashfs_pag
 	actor->buffer = buffer;
 	actor->pages = pages;
 	actor->next_page = 0;
+	actor->tmp_buffer = NULL;
 	actor->squashfs_first_page = cache_first_page;
 	actor->squashfs_next_page = cache_next_page;
 	actor->squashfs_finish_page = cache_finish_page;
@@ -68,20 +69,9 @@ static void *handle_next_page(struct squ
 
 	if ((actor->next_page == actor->pages) ||
 			(actor->next_index != actor->page[actor->next_page]->index)) {
-		if (actor->alloc_buffer) {
-			void *tmp_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
-
-			if (tmp_buffer) {
-				actor->tmp_buffer = tmp_buffer;
-				actor->next_index++;
-				actor->returned_pages++;
-				return tmp_buffer;
-			}
-		}
-
 		actor->next_index++;
 		actor->returned_pages++;
-		return ERR_PTR(-ENOMEM);
+		return actor->alloc_buffer ? actor->tmp_buffer : ERR_PTR(-ENOMEM);
 	}
 
 	actor->next_index++;
@@ -96,11 +86,10 @@ static void *direct_first_page(struct sq
 
 static void *direct_next_page(struct squashfs_page_actor *actor)
 {
-	if (actor->pageaddr)
+	if (actor->pageaddr) {
 		kunmap_local(actor->pageaddr);
-
-	kfree(actor->tmp_buffer);
-	actor->pageaddr = actor->tmp_buffer = NULL;
+		actor->pageaddr = NULL;
+	}
 
 	return handle_next_page(actor);
 }
@@ -109,8 +98,6 @@ static void direct_finish_page(struct sq
 {
 	if (actor->pageaddr)
 		kunmap_local(actor->pageaddr);
-
-	kfree(actor->tmp_buffer);
 }
 
 struct squashfs_page_actor *squashfs_page_actor_init_special(struct squashfs_sb_info *msblk,
@@ -121,6 +108,16 @@ struct squashfs_page_actor *squashfs_pag
 	if (actor == NULL)
 		return NULL;
 
+	if (msblk->decompressor->alloc_buffer) {
+		actor->tmp_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
+
+		if (actor->tmp_buffer == NULL) {
+			kfree(actor);
+			return NULL;
+		}
+	} else
+		actor->tmp_buffer = NULL;
+
 	actor->length = length ? : pages * PAGE_SIZE;
 	actor->page = page;
 	actor->pages = pages;
@@ -128,7 +125,6 @@ struct squashfs_page_actor *squashfs_pag
 	actor->returned_pages = 0;
 	actor->next_index = page[0]->index & ~((1 << (msblk->block_log - PAGE_SHIFT)) - 1);
 	actor->pageaddr = NULL;
-	actor->tmp_buffer = NULL;
 	actor->alloc_buffer = msblk->decompressor->alloc_buffer;
 	actor->squashfs_first_page = direct_first_page;
 	actor->squashfs_next_page = direct_next_page;
--- a/fs/squashfs/page_actor.h~squashfs-dont-call-kmalloc-in-decompressors
+++ a/fs/squashfs/page_actor.h
@@ -29,6 +29,11 @@ extern struct squashfs_page_actor *squas
 extern struct squashfs_page_actor *squashfs_page_actor_init_special(
 				struct squashfs_sb_info *msblk,
 				struct page **page, int pages, int length);
+static inline void squashfs_page_actor_free(struct squashfs_page_actor *actor)
+{
+	kfree(actor->tmp_buffer);
+	kfree(actor);
+}
 static inline void *squashfs_first_page(struct squashfs_page_actor *actor)
 {
 	return actor->squashfs_first_page(actor);
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-dont-call-kmalloc-in-decompressors.patch

