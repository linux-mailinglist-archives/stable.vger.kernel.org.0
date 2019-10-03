Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F9CCA7B8
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406018AbfJCQvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406015AbfJCQvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:51:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DE042086A;
        Thu,  3 Oct 2019 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121475;
        bh=wKnXlJdji13ZYMln4+23UJUzA+MR6YZ4RwdHhmPcMz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IH+iJHyYB/ukFbuql/pSJ6CRvv7m1yf3ZpAG4b5UtW7ghq8c+pu/uPslySCy/9/hI
         bHzR1s8dsMwPqX0hsgD2/dzkCZ13OtNmytoqjY8pN0RPB3lu4GO4ZaHm/tfNeFfaxz
         hs8lonJW6IqED4mz7thxv1BVkxxTZqLpKkIB2C2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
        Markus Linnala <markus.linnala@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Henry Burns <henrywolfeburns@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 291/344] z3fold: fix memory leak in kmem cache
Date:   Thu,  3 Oct 2019 17:54:16 +0200
Message-Id: <20191003154608.442529120@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Wool <vitalywool@gmail.com>

commit 63398413c00c7836ea87a1fa205c91d2199b25cf upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/z3fold.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/z3fold.c
+++ b/mm/z3fold.c
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


