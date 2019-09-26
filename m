Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD32EBFB70
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 00:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbfIZWsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 18:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbfIZWsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Sep 2019 18:48:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AF3F207FF;
        Thu, 26 Sep 2019 22:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569538128;
        bh=x50GAVdc7ldQdMsGScZeYWuAg493CJPym/c250YFDc0=;
        h=Date:From:To:Subject:From;
        b=WjCRIsSU6HyWFDSmzgKSZos9cXGmpYhztu9e0IgEH/+SdHwqDg/yqlQ4Y8nAv+Uyt
         VJSw4nVzeABdl31Tqc0H4tEaYUJtdrkz+/8PwCLgjXmABAiHJVshdeHOn7CcCg8g//
         QV7RlkDB07+Y0hQR+ayf1h5qzzpiK8fh6CkNz+ac=
Date:   Thu, 26 Sep 2019 15:48:48 -0700
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, henrywolfeburns@gmail.com,
        markus.linnala@gmail.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, stable@vger.kernel.org, vbabka@suse.cz,
        vitalywool@gmail.com
Subject:  + z3fold-claim-page-in-the-beginning-of-free.patch added
 to -mm tree
Message-ID: <20190926224848.9lQbCvEmR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: claim page in the beginning of free
has been added to the -mm tree.  Its filename is
     z3fold-claim-page-in-the-beginning-of-free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/z3fold-claim-page-in-the-beginning-of-free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/z3fold-claim-page-in-the-beginning-of-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: mm/z3fold.c: claim page in the beginning of free

There's a really hard to reproduce race in z3fold between z3fold_free()
and z3fold_reclaim_page().  z3fold_reclaim_page() can claim the page after
z3fold_free() has checked if the page was claimed and z3fold_free() will
then schedule this page for compaction which may in turn lead to random
page faults (since that page would have been reclaimed by then).  Fix that
by claiming page in the beginning of z3fold_free().

Link: http://lkml.kernel.org/r/20190926104844.4f0c6efa1366b8f5741eaba9@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Reported-by: Markus Linnala <markus.linnala@gmail.com>
Cc: Markus Linnala <markus.linnala@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/z3fold.c~z3fold-claim-page-in-the-beginning-of-free
+++ a/mm/z3fold.c
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
@@ -1044,7 +1046,7 @@ static void z3fold_free(struct z3fold_po
 		atomic64_dec(&pool->pages_nr);
 		return;
 	}
-	if (test_bit(PAGE_CLAIMED, &page->private)) {
+	if (page_claimed) {
 		z3fold_page_unlock(zhdr);
 		return;
 	}
_

Patches currently in -mm which might be from vitalywool@gmail.com are

z3fold-claim-page-in-the-beginning-of-free.patch

