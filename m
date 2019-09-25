Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F69BD714
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 06:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411655AbfIYESp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 00:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392964AbfIYESp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Sep 2019 00:18:45 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B32821920;
        Wed, 25 Sep 2019 04:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569385124;
        bh=ekZBp+V5LMpYCtW+DaGXtggjL8uJwp5CaS2I/M5lm/o=;
        h=Date:From:To:Subject:From;
        b=QHPMcluCfCGKNcx126TVR9/xrzc+GXXgpOkkSv88HjFcmSTkh5fWsikgAbApODvMH
         uOuV8B6oITBmEx8Z8uVWivf/i5XB9akwaJtIs346aAMvjPsqUV1R7ajJkFYFyyPc6N
         iY+i8740/AwxkqmBVJtkWWbeUfGLv+J9Ovc74ypg=
Date:   Tue, 24 Sep 2019 21:18:44 -0700
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, henrywolfeburns@gmail.com,
        markus.linnala@gmail.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, stable@vger.kernel.org, vbabka@suse.cz,
        vitalywool@gmail.com
Subject:  [merged] z3fold-fix-memory-leak-in-kmem-cache.patch
 removed from -mm tree
Message-ID: <20190925041844.WOC597Z9n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: z3fold: fix memory leak in kmem cache
has been removed from the -mm tree.  Its filename was
     z3fold-fix-memory-leak-in-kmem-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold: fix memory leak in kmem cache

Currently there is a leak in init_z3fold_page() -- it allocates handles
from kmem cache even for headless pages, but then they are never used and
never freed, so eventually kmem cache may get exhausted.  This patch
provides a fix for that.

Link: http://lkml.kernel.org/r/20190917185352.44cf285d3ebd9e64548de5de@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Reported-by: Markus Linnala <markus.linnala@gmail.com>
Tested-by: Markus Linnala <markus.linnala@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/z3fold.c~z3fold-fix-memory-leak-in-kmem-cache
+++ a/mm/z3fold.c
@@ -295,14 +295,11 @@ static void z3fold_unregister_migration(
  }
 
 /* Initializes the z3fold header of a newly allocated z3fold page */
-static struct z3fold_header *init_z3fold_page(struct page *page,
+static struct z3fold_header *init_z3fold_page(struct page *page, bool headless,
 					struct z3fold_pool *pool, gfp_t gfp)
 {
 	struct z3fold_header *zhdr = page_address(page);
-	struct z3fold_buddy_slots *slots = alloc_slots(pool, gfp);
-
-	if (!slots)
-		return NULL;
+	struct z3fold_buddy_slots *slots;
 
 	INIT_LIST_HEAD(&page->lru);
 	clear_bit(PAGE_HEADLESS, &page->private);
@@ -310,6 +307,12 @@ static struct z3fold_header *init_z3fold
 	clear_bit(NEEDS_COMPACTING, &page->private);
 	clear_bit(PAGE_STALE, &page->private);
 	clear_bit(PAGE_CLAIMED, &page->private);
+	if (headless)
+		return zhdr;
+
+	slots = alloc_slots(pool, gfp);
+	if (!slots)
+		return NULL;
 
 	spin_lock_init(&zhdr->page_lock);
 	kref_init(&zhdr->refcount);
@@ -930,7 +933,7 @@ retry:
 	if (!page)
 		return -ENOMEM;
 
-	zhdr = init_z3fold_page(page, pool, gfp);
+	zhdr = init_z3fold_page(page, bud == HEADLESS, pool, gfp);
 	if (!zhdr) {
 		__free_page(page);
 		return -ENOMEM;
_

Patches currently in -mm which might be from vitalywool@gmail.com are


