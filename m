Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428379A374
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 01:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405518AbfHVXDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 19:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405506AbfHVXDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 19:03:02 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10E5F21848;
        Thu, 22 Aug 2019 23:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566514981;
        bh=zfyA5TXZsaSLnlXFKMrMe2E4hu4PyR5crDUlL/3rKJs=;
        h=Date:From:To:Subject:From;
        b=G5tbDPpwpZE/G5NRz74BEgB81OEBJkI2XtcSYc30ZGXj/w7UNIdLn7QoR7PYogljh
         DOJoKT6CCASStdwuyaisjbguEUl5ob/EfE7CkjCXKna60jCx4djTA0b8taAX9l67SQ
         d4i8vXBV+QPPnudLgUx7qKSeD3thnTa8dvg02UPw=
Date:   Thu, 22 Aug 2019 16:03:00 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, mhocko@kernel.org,
        mgorman@techsingularity.net, kirill@shutemov.name, vbabka@suse.cz
Subject:  + mm-page_owner-handle-thp-splits-correctly.patch added to
 -mm tree
Message-ID: <20190822230300.FRWOS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, page_owner: handle THP splits correctly
has been added to the -mm tree.  Its filename is
     mm-page_owner-handle-thp-splits-correctly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-handle-thp-splits-correctly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-handle-thp-splits-correctly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: handle THP splits correctly

THP splitting path is missing the split_page_owner() call that
split_page() has.  As a result, split THP pages are wrongly reported in
the page_owner file as order-9 pages.  Furthermore when the former head
page is freed, the remaining former tail pages are not listed in the
page_owner file at all.  This patch fixes that by adding the
split_page_owner() call into __split_huge_page().

Link: http://lkml.kernel.org/r/20190820131828.22684-2-vbabka@suse.cz
Fixes: a9627bc5e34e ("mm/page_owner: introduce split_page_owner and replace manual handling")
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c~mm-page_owner-handle-thp-splits-correctly
+++ a/mm/huge_memory.c
@@ -32,6 +32,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/oom.h>
 #include <linux/numa.h>
+#include <linux/page_owner.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -2516,6 +2517,9 @@ static void __split_huge_page(struct pag
 	}
 
 	ClearPageCompound(head);
+
+	split_page_owner(head, HPAGE_PMD_ORDER);
+
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
 		/* Additional pin to swap cache */
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_owner-handle-thp-splits-correctly.patch
mm-page_owner-record-page-owner-for-each-subpage.patch
mm-page_owner-keep-owner-info-when-freeing-the-page.patch
mm-page_owner-debug_pagealloc-save-and-dump-freeing-stack-trace.patch
mm-compaction-clear-total_migratefree_scanned-before-scanning-a-new-zone-fix-2.patch
mm-reclaim-cleanup-should_continue_reclaim.patch
mm-compaction-raise-compaction-priority-after-it-withdrawns.patch

