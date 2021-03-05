Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32CA32EAB2
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCEMjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:39:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233228AbhCEMje (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:39:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1D6E64FF0;
        Fri,  5 Mar 2021 12:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947973;
        bh=jccTq6OER1P9/5YWt8iNhRDRhuycPyuRO0gMATMCP3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Onc2tRp3OQ1P5iAFAtRSsb1Z0ZlyHziF2UywFo84zVoYPb1WPQl7cgYTigf2AAyRf
         NeCiBM0A8vpOv5gpUqqS8SPGw6rIfXqckE/haHne+MhH8g+wfrgJA3786ztg/Nb3Uk
         5Dy1Ne6gU+aU0U6eqL0Cd+YdqBOgBSIDi2OorR1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 04/39] hugetlb: fix update_and_free_page contig page struct assumption
Date:   Fri,  5 Mar 2021 13:22:03 +0100
Message-Id: <20210305120851.973504079@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
References: <20210305120851.751937389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit dbfee5aee7e54f83d96ceb8e3e80717fac62ad63 upstream.

page structs are not guaranteed to be contiguous for gigantic pages.  The
routine update_and_free_page can encounter a gigantic page, yet it assumes
page structs are contiguous when setting page flags in subpages.

If update_and_free_page encounters non-contiguous page structs, we can see
“BUG: Bad page state in process …” errors.

Non-contiguous page structs are generally not an issue.  However, they can
exist with a specific kernel configuration and hotplug operations.  For
example: Configure the kernel with CONFIG_SPARSEMEM and
!CONFIG_SPARSEMEM_VMEMMAP.  Then, hotplug add memory for the area where
the gigantic page will be allocated.  Zi Yan outlined steps to reproduce
here [1].

[1] https://lore.kernel.org/linux-mm/16F7C58B-4D79-41C5-9B64-A1A1628F4AF2@nvidia.com/

Link: https://lkml.kernel.org/r/20210217184926.33567-1-mike.kravetz@oracle.com
Fixes: 944d9fec8d7a ("hugetlb: add support for gigantic page allocation at runtime")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1208,14 +1208,16 @@ static inline int alloc_fresh_gigantic_p
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
+	struct page *subpage = page;
 
 	if (hstate_is_gigantic(h) && !gigantic_page_supported())
 		return;
 
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[page_to_nid(page)]--;
-	for (i = 0; i < pages_per_huge_page(h); i++) {
-		page[i].flags &= ~(1 << PG_locked | 1 << PG_error |
+	for (i = 0; i < pages_per_huge_page(h);
+	     i++, subpage = mem_map_next(subpage, page, i)) {
+		subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
 				1 << PG_referenced | 1 << PG_dirty |
 				1 << PG_active | 1 << PG_private |
 				1 << PG_writeback);


