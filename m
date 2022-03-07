Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC114CF861
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238675AbiCGJxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbiCGJvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:51:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0E566C8B;
        Mon,  7 Mar 2022 01:45:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2CB8B810B9;
        Mon,  7 Mar 2022 09:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10237C340E9;
        Mon,  7 Mar 2022 09:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646305;
        bh=jZhJUgnC00Oi4NxwevCHNXIQrXbw0XYFCaL4YrnILQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pb7aLgPGeFJDwWRN9GUpIpRH4Ca8ECVsfgyTC11ihhfmK+mgCdbZZQBpJhlm19i/m
         FMQMBOuBP9EXpOAjjA5veOeeu+Tj05VzyA7TYzKjttjMzRuKgvczXt0sBrGHWCOMXN
         wvq4XFdFFd/HPqgqFHJCNg08MaNA53gmZhuRJ68c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Zeal Robot <zealci@zte.com.cn>,
        wangyong <wang.yong12@zte.com.cn>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        CGEL ZTE <cgel.zte@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Song Liu <songliubraving@fb.com>,
        Yang Yang <yang.yang29@zte.com.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 200/262] memfd: fix F_SEAL_WRITE after shmem huge page allocated
Date:   Mon,  7 Mar 2022 10:19:04 +0100
Message-Id: <20220307091708.322068557@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit f2b277c4d1c63a85127e8aa2588e9cc3bd21cb99 upstream.

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
total_mapcount() calculation, it is better now to be strict.  Bear in
mind that total_mapcount() itself scans all of the THP subpages, when
choosing to take an XA_CHECK_SCHED latency break.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memfd.c |   40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

--- a/mm/memfd.c
+++ b/mm/memfd.c
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


