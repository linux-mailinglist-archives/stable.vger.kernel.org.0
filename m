Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD1D9C12D
	for <lists+stable@lfdr.de>; Sun, 25 Aug 2019 02:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfHYAzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 20:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfHYAzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 20:55:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 628DA22CF7;
        Sun, 25 Aug 2019 00:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566694500;
        bh=5HYpnWuJ3nYcHULbN9ZEAdHlX5aKAAA5am09MKUmBjA=;
        h=Date:From:To:Subject:From;
        b=aLhNaLvVpRCMyKWPS+iYJ4gyE6kwGv3jDwTeIz1IrsW1/fP0VN9CV49gFl3CmXlzY
         j5/s+PCUithPry/y3C3Db1zr3Q5e7MVIC7L+J8dQb+bPuJnTpofO5KmeVYujBmYO1g
         Ic3xuUsTnOQYyvi5KyV4HbMubgwDXDCZnriKnWaQ=
Date:   Sat, 24 Aug 2019 17:54:59 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, kirill@shutemov.name,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 08/11] mm, page_owner: handle THP splits correctly
Message-ID: <20190825005459.Ik4Bi2G1I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
