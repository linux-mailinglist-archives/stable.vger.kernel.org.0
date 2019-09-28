Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D682C1070
	for <lists+stable@lfdr.de>; Sat, 28 Sep 2019 11:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbfI1JfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Sep 2019 05:35:01 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39538 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfI1JfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Sep 2019 05:35:01 -0400
Received: by mail-lf1-f65.google.com with SMTP id 72so3642086lfh.6;
        Sat, 28 Sep 2019 02:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=sqzpIJTUSyMjvNLNtMpXjO9U+cAbapAxKF1UKLPlejs=;
        b=TW7KPlSqAa6wsClwUUOFxv1pU8gsHgaqMzCgLKlROwfWVCIOZI/H1Hd+e5H9ihsl2S
         213aT5DDG6Dx+LzKxT83l3BQyPRmpPOEk0r9PTLDz1pxWx010Zkp3FWEydjxO0M60emn
         uXzE1ZIGNwm84dmDSwyvYl9tckI0DDrh7nqI6KrmJguW3EVMB6B2gHdY25J2Ym9A7Vt8
         4hsfZ7s+jYwC2dwpDvxAX5kvPKuQGPzVSQtFWU7fH5jG/zkKomUd+kILFUsSyTWiBWue
         6yA5hOEQ9e07M2IN5Req/JsvKAsjG/AKWxNg6F/hr/+OWUQ4nWXgbeDrT9dt69hayOnq
         S3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=sqzpIJTUSyMjvNLNtMpXjO9U+cAbapAxKF1UKLPlejs=;
        b=NI6gFtC0rRdZfOG26e8Us7EzRwfHthfpw5J4KnE38Zj2m2Br+p23tMXoF/nLvY/NRD
         mPp0UZEH0Bi6BI7PUGWBqKLf826A2oU8fb1g5ZT8jgnj3c3/aDA3TH/Ip/qNOFByf2tO
         PZu22GS9LFfQ6eE7o3Y9r7ekre26O1i9s7Exr/mqKPXfmuVwC2d5vkBcVvWINMDkpR5n
         T4+thq0yBbEEuJ2k3AWyV+7GwCJECZgQOsOtZ+aHEhEj5L9y3hQSIKmmsgkpK93IR1yA
         GFwEEPLG2vrQi1cyI+BrzpXvhoYYDfYOBlN8WBAwjfn1qNowL4p5zBsigRBvTYyB49vr
         imGg==
X-Gm-Message-State: APjAAAWktKoENRY2P4LdK6NxRnGA30BuyR+x40h6qRq/SMWU6cR+vucV
        C99yWwMuyvXQHP6ukkNog+I=
X-Google-Smtp-Source: APXvYqwwuh1GjfIdsBSxb/r0rjF6N074kvqQ1/3Wn9VOkGtT9HtjiGXMAQChZMByZxxHrjibevm+Cg==
X-Received: by 2002:a19:641e:: with SMTP id y30mr5789536lfb.148.1569663299262;
        Sat, 28 Sep 2019 02:34:59 -0700 (PDT)
Received: from bigdell (2.69.152.136.mobile.tre.se. [2.69.152.136])
        by smtp.gmail.com with ESMTPSA id m15sm1247655ljg.97.2019.09.28.02.34.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Sep 2019 02:34:59 -0700 (PDT)
Date:   Sat, 28 Sep 2019 11:34:56 +0200
From:   Vitaly Wool <vitalywool@gmail.com>
To:     Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Markus Linnala <markus.linnala@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH v2] z3fold: claim page in the beginning of free
Message-ID: <20190928113456.152742cf@bigdell>
X-Mailer: Claws Mail 3.17.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There's a really hard to reproduce race in z3fold between
z3fold_free() and z3fold_reclaim_page(). z3fold_reclaim_page()
can claim the page after z3fold_free() has checked if the page
was claimed and z3fold_free() will then schedule this page for
compaction which may in turn lead to random page faults (since
that page would have been reclaimed by then). Fix that by
claiming page in the beginning of z3fold_free() and not
forgetting to clear the claim in the end.

Reported-by: Markus Linnala <markus.linnala@gmail.com>
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: <stable@vger.kernel.org>
---
 mm/z3fold.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/z3fold.c b/mm/z3fold.c
index 05bdf90646e7..6d3d3f698ebb 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -998,9 +998,11 @@ static void z3fold_free(struct z3fold_pool *pool,
unsigned long handle) struct z3fold_header *zhdr;
 	struct page *page;
 	enum buddy bud;
+	bool page_claimed;
 
 	zhdr = handle_to_z3fold_header(handle);
 	page = virt_to_page(zhdr);
+	page_claimed = test_and_set_bit(PAGE_CLAIMED, &page->private);
 
 	if (test_bit(PAGE_HEADLESS, &page->private)) {
 		/* if a headless page is under reclaim, just leave.
@@ -1008,7 +1010,7 @@ static void z3fold_free(struct z3fold_pool *pool,
unsigned long handle)
 		 * has not been set before, we release this page
 		 * immediately so we don't care about its value any
more. */
-		if (!test_and_set_bit(PAGE_CLAIMED, &page->private)) {
+		if (!page_claimed) {
 			spin_lock(&pool->lock);
 			list_del(&page->lru);
 			spin_unlock(&pool->lock);
@@ -1044,13 +1046,15 @@ static void z3fold_free(struct z3fold_pool
*pool, unsigned long handle) atomic64_dec(&pool->pages_nr);
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
@@ -1060,10 +1064,12 @@ static void z3fold_free(struct z3fold_pool
*pool, unsigned long handle) zhdr->cpu = -1;
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
 
-- 
2.17.1
