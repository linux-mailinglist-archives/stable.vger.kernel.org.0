Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E858D9E9A
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438648AbfJPV7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438642AbfJPV7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:49 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA90A21D80;
        Wed, 16 Oct 2019 21:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263188;
        bh=QBtzNwCVrJp4cN4CQJnMzOVGUpLADOg3yzZ8Zb1kjw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGZwQXdSVg0OaYgWMAt4W6+yLRyyQz++JlM4tA0aLuIFZYwJI48qkBK1ibw/td2lS
         ANvdodFWQxFAl8uGYPRbOv9UHPzkE0p1fN1HRpBo7jPuTnZjjabrdpFyGvoq6CVZuE
         YI7TDrsDNkn7ryvp57dBy3NNvqXaMUy0LvdXTD8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
        Markus Linnala <markus.linnala@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Henry Burns <henrywolfeburns@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 076/112] mm/z3fold.c: claim page in the beginning of free
Date:   Wed, 16 Oct 2019 14:51:08 -0700
Message-Id: <20191016214904.150037983@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Wool <vitalywool@gmail.com>

commit 5b6807de11445c05b537df8324f5d7ab1c2782f9 upstream.

There's a really hard to reproduce race in z3fold between z3fold_free()
and z3fold_reclaim_page().  z3fold_reclaim_page() can claim the page
after z3fold_free() has checked if the page was claimed and
z3fold_free() will then schedule this page for compaction which may in
turn lead to random page faults (since that page would have been
reclaimed by then).

Fix that by claiming page in the beginning of z3fold_free() and not
forgetting to clear the claim in the end.

[vitalywool@gmail.com: v2]
  Link: http://lkml.kernel.org/r/20190928113456.152742cf@bigdell
Link: http://lkml.kernel.org/r/20190926104844.4f0c6efa1366b8f5741eaba9@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Reported-by: Markus Linnala <markus.linnala@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Markus Linnala <markus.linnala@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/z3fold.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -998,9 +998,11 @@ static void z3fold_free(struct z3fold_po
 	struct z3fold_header *zhdr;
 	struct page *page;
 	enum buddy bud;
+	bool page_claimed;
 
 	zhdr = handle_to_z3fold_header(handle);
 	page = virt_to_page(zhdr);
+	page_claimed = test_and_set_bit(PAGE_CLAIMED, &page->private);
 
 	if (test_bit(PAGE_HEADLESS, &page->private)) {
 		/* if a headless page is under reclaim, just leave.
@@ -1008,7 +1010,7 @@ static void z3fold_free(struct z3fold_po
 		 * has not been set before, we release this page
 		 * immediately so we don't care about its value any more.
 		 */
-		if (!test_and_set_bit(PAGE_CLAIMED, &page->private)) {
+		if (!page_claimed) {
 			spin_lock(&pool->lock);
 			list_del(&page->lru);
 			spin_unlock(&pool->lock);
@@ -1044,13 +1046,15 @@ static void z3fold_free(struct z3fold_po
 		atomic64_dec(&pool->pages_nr);
 		return;
 	}
-	if (test_bit(PAGE_CLAIMED, &page->private)) {
+	if (page_claimed) {
+		/* the page has not been claimed by us */
 		z3fold_page_unlock(zhdr);
 		return;
 	}
 	if (unlikely(PageIsolated(page)) ||
 	    test_and_set_bit(NEEDS_COMPACTING, &page->private)) {
 		z3fold_page_unlock(zhdr);
+		clear_bit(PAGE_CLAIMED, &page->private);
 		return;
 	}
 	if (zhdr->cpu < 0 || !cpu_online(zhdr->cpu)) {
@@ -1060,10 +1064,12 @@ static void z3fold_free(struct z3fold_po
 		zhdr->cpu = -1;
 		kref_get(&zhdr->refcount);
 		do_compact_page(zhdr, true);
+		clear_bit(PAGE_CLAIMED, &page->private);
 		return;
 	}
 	kref_get(&zhdr->refcount);
 	queue_work_on(zhdr->cpu, pool->compact_wq, &zhdr->work);
+	clear_bit(PAGE_CLAIMED, &page->private);
 	z3fold_page_unlock(zhdr);
 }
 


