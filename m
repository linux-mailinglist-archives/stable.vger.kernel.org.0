Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056645209D4
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 02:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiEJAMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 20:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiEJAL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 20:11:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C393CA6A;
        Mon,  9 May 2022 17:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CDDBB819C9;
        Tue, 10 May 2022 00:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D61C385C5;
        Tue, 10 May 2022 00:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652141280;
        bh=gphMBiZlLY2X8A9Q36DamKqX2gT3+o7fl9XoohDAY0M=;
        h=Date:To:From:Subject:From;
        b=F/wPE0gTYSixxjvG1/XX1klD911vQSTqw21/eEL7t4ySwu2/Zi72B4R/AySagnpqD
         bcpBD/MFyNzfOF5uCyRs5kKdPMFfM4rrGr25GnMKgjlBe/ZKoWqXxiFWeXpWB2VVjD
         QPupQLQejO+3voy5DxHBz/GlmAMwoioVxkwn9Gqg=
Date:   Mon, 09 May 2022 17:07:59 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        senozhatsky@chromium.org, ngupta@vflare.org, minchan@kernel.org,
        sultan@kerneltoast.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-fix-races-between-asynchronous-zspage-free-and-page-migration.patch added to mm-unstable branch
Message-Id: <20220510000800.A9D61C385C5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: zsmalloc: fix races between asynchronous zspage free and page migration
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-fix-races-between-asynchronous-zspage-free-and-page-migration.patch

This patch should soon appear in the mm-unstable branch at
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
From: Sultan Alsawaf <sultan@kerneltoast.com>
Subject: zsmalloc: fix races between asynchronous zspage free and page migration

The asynchronous zspage free worker tries to lock a zspage's entire page
list without defending against page migration.  Since pages which haven't
yet been locked can concurrently migrate off the zspage page list while
lock_zspage() churns away, lock_zspage() can suffer from a few different
lethal races.

It can lock a page which no longer belongs to the zspage and unsafely
dereference page_private(), it can unsafely dereference a torn pointer to
the next page (since there's a data race), and it can observe a spurious
NULL pointer to the next page and thus not lock all of the zspage's pages
(since a single page migration will reconstruct the entire page list, and
create_page_chain() unconditionally zeroes out each list pointer in the
process).

Fix the races by using migrate_read_lock() in lock_zspage() to synchronize
with page migration.

Link: https://lkml.kernel.org/r/20220509024703.243847-1-sultan@kerneltoast.com
Fixes: 48b4800a1c6a ("zsmalloc: page migration support")
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-fix-races-between-asynchronous-zspage-free-and-page-migration
+++ a/mm/zsmalloc.c
@@ -1718,11 +1718,40 @@ static enum fullness_group putback_zspag
  */
 static void lock_zspage(struct zspage *zspage)
 {
-	struct page *page = get_first_page(zspage);
+	struct page *curr_page, *page;
 
-	do {
-		lock_page(page);
-	} while ((page = get_next_page(page)) != NULL);
+	/*
+	 * Pages we haven't locked yet can be migrated off the list while we're
+	 * trying to lock them, so we need to be careful and only attempt to
+	 * lock each page under migrate_read_lock(). Otherwise, the page we lock
+	 * may no longer belong to the zspage. This means that we may wait for
+	 * the wrong page to unlock, so we must take a reference to the page
+	 * prior to waiting for it to unlock outside migrate_read_lock().
+	 */
+	while (1) {
+		migrate_read_lock(zspage);
+		page = get_first_page(zspage);
+		if (trylock_page(page))
+			break;
+		get_page(page);
+		migrate_read_unlock(zspage);
+		wait_on_page_locked(page);
+		put_page(page);
+	}
+
+	curr_page = page;
+	while ((page = get_next_page(curr_page))) {
+		if (trylock_page(page)) {
+			curr_page = page;
+		} else {
+			get_page(page);
+			migrate_read_unlock(zspage);
+			wait_on_page_locked(page);
+			put_page(page);
+			migrate_read_lock(zspage);
+		}
+	}
+	migrate_read_unlock(zspage);
 }
 
 static int zs_init_fs_context(struct fs_context *fc)
_

Patches currently in -mm which might be from sultan@kerneltoast.com are

zsmalloc-fix-races-between-asynchronous-zspage-free-and-page-migration.patch

