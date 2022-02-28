Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286164C6260
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 06:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiB1FOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 00:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiB1FOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 00:14:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36C61A3BC;
        Sun, 27 Feb 2022 21:13:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DD6660F81;
        Mon, 28 Feb 2022 05:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7F1C340E7;
        Mon, 28 Feb 2022 05:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646025217;
        bh=8JBukGUnbi+19Lt5v7H8/Ov6ZrQ1Lh87gM/rAzX6+Yk=;
        h=Date:To:From:Subject:From;
        b=Bp61TDsYxPN6Y44PbZzsrn2YPETlqmDKXpyGAp3wAsrh7P1886JCrYwP8H+RXKxk6
         SM8Z3I5Rals2Hui3w45SiRShtcaqXiml7rITfcpJXkF4fmU9+fkFKtmAn+qIwCy8b7
         ZLFaB1VJCHeeE5UHmIafMK1BPDUod+Otjaz+FeAI=
Date:   Sun, 27 Feb 2022 21:13:37 -0800
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        yang.yang29@zte.com.cn, willy@infradead.org,
        wang.yong12@zte.com.cn, stable@vger.kernel.org,
        songliubraving@fb.com, mike.kravetz@oracle.com,
        kirill@shutemov.name, cgel.zte@gmail.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch added to -mm tree
Message-Id: <20220228051337.AF7F1C340E7@smtp.kernel.org>
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
     Subject: memfd: fix F_SEAL_WRITE after shmem huge page allocated
has been added to the -mm tree.  Its filename is
     memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memfd: fix F_SEAL_WRITE after shmem huge page allocated

Wangyong reports: after enabling tmpfs filesystem to support transparent
hugepage with the following command:

 echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled

the docker program tries to add F_SEAL_WRITE through the following
command, but it fails unexpectedly with errno EBUSY:

 fcntl(5, F_ADD_SEALS, F_SEAL_WRITE) = -1.

That is because memfd_tag_pins() and memfd_wait_for_pins() were never
updated for shmem huge pages: checking page_mapcount() against
page_count() is hopeless on THP subpages - they need to check
total_mapcount() against page_count() on THP heads only.

Make memfd_tag_pins() (compared > 1) as strict as memfd_wait_for_pins()
(compared != 1): either can be justified, but given the non-atomic
total_mapcount() calculation, it is better now to be strict.  Bear in mind
that total_mapcount() itself scans all of the THP subpages, when choosing
to take an XA_CHECK_SCHED latency break.

Also fix the unlikely xa_is_value() case in memfd_wait_for_pins(): if a
page has been swapped out since memfd_tag_pins(), then its refcount must
have fallen, and so it can safely be untagged.

Link: https://lkml.kernel.org/r/a4f79248-df75-2c8c-3df-ba3317ccb5da@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Reported-by: wangyong <wang.yong12@zte.com.cn>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: CGEL ZTE <cgel.zte@gmail.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |   40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

--- a/mm/memfd.c~memfd-fix-f_seal_write-after-shmem-huge-page-allocated
+++ a/mm/memfd.c
@@ -31,20 +31,28 @@
 static void memfd_tag_pins(struct xa_state *xas)
 {
 	struct page *page;
-	unsigned int tagged = 0;
+	int latency = 0;
+	int cache_count;
 
 	lru_add_drain();
 
 	xas_lock_irq(xas);
 	xas_for_each(xas, page, ULONG_MAX) {
-		if (xa_is_value(page))
-			continue;
-		page = find_subpage(page, xas->xa_index);
-		if (page_count(page) - page_mapcount(page) > 1)
+		cache_count = 1;
+		if (!xa_is_value(page) &&
+		    PageTransHuge(page) && !PageHuge(page))
+			cache_count = HPAGE_PMD_NR;
+
+		if (!xa_is_value(page) &&
+		    page_count(page) - total_mapcount(page) != cache_count)
 			xas_set_mark(xas, MEMFD_TAG_PINNED);
+		if (cache_count != 1)
+			xas_set(xas, page->index + cache_count);
 
-		if (++tagged % XA_CHECK_SCHED)
+		latency += cache_count;
+		if (latency < XA_CHECK_SCHED)
 			continue;
+		latency = 0;
 
 		xas_pause(xas);
 		xas_unlock_irq(xas);
@@ -73,7 +81,8 @@ static int memfd_wait_for_pins(struct ad
 
 	error = 0;
 	for (scan = 0; scan <= LAST_SCAN; scan++) {
-		unsigned int tagged = 0;
+		int latency = 0;
+		int cache_count;
 
 		if (!xas_marked(&xas, MEMFD_TAG_PINNED))
 			break;
@@ -87,10 +96,14 @@ static int memfd_wait_for_pins(struct ad
 		xas_lock_irq(&xas);
 		xas_for_each_marked(&xas, page, ULONG_MAX, MEMFD_TAG_PINNED) {
 			bool clear = true;
-			if (xa_is_value(page))
-				continue;
-			page = find_subpage(page, xas.xa_index);
-			if (page_count(page) - page_mapcount(page) != 1) {
+
+			cache_count = 1;
+			if (!xa_is_value(page) &&
+			    PageTransHuge(page) && !PageHuge(page))
+				cache_count = HPAGE_PMD_NR;
+
+			if (!xa_is_value(page) && cache_count !=
+			    page_count(page) - total_mapcount(page)) {
 				/*
 				 * On the last scan, we clean up all those tags
 				 * we inserted; but make a note that we still
@@ -103,8 +116,11 @@ static int memfd_wait_for_pins(struct ad
 			}
 			if (clear)
 				xas_clear_mark(&xas, MEMFD_TAG_PINNED);
-			if (++tagged % XA_CHECK_SCHED)
+
+			latency += cache_count;
+			if (latency < XA_CHECK_SCHED)
 				continue;
+			latency = 0;
 
 			xas_pause(&xas);
 			xas_unlock_irq(&xas);
_

Patches currently in -mm which might be from hughd@google.com are

memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch
tmpfs-support-for-file-creation-time-fix.patch

