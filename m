Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC311CAA89
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392581AbfJCRH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391316AbfJCQfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:35:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CA2320830;
        Thu,  3 Oct 2019 16:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120554;
        bh=a2JF6c9MZwJJTWBKErrc3IokanYEbZZ3ei7ZxHE1edg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAhSEnY/YBY+xs6xzViO4TYd4Vr4seDsLM5DeBqZABAzLRQwvhcmUT6Cf2XFvD7xn
         xEMfzWoGaxpobJZEx1c9w5VixU/BWLBgKIeoSpjCVXFNY/rrofVk5krgF6S0XQJrqP
         m/60Dfl/WK4XK4WOjOTQRyo0wGFv1dfbVMYpK+jo=
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
Subject: [PATCH 5.2 265/313] z3fold: fix memory leak in kmem cache
Date:   Thu,  3 Oct 2019 17:54:03 +0200
Message-Id: <20191003154559.153678471@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
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
@@ -297,14 +297,11 @@ static void z3fold_unregister_migration(
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
@@ -312,6 +309,12 @@ static struct z3fold_header *init_z3fold
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
@@ -932,7 +935,7 @@ retry:
 	if (!page)
 		return -ENOMEM;
 
-	zhdr = init_z3fold_page(page, pool, gfp);
+	zhdr = init_z3fold_page(page, bud == HEADLESS, pool, gfp);
 	if (!zhdr) {
 		__free_page(page);
 		return -ENOMEM;


