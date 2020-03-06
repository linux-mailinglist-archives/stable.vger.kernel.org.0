Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDAF17B6B6
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 07:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgCFG2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 01:28:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgCFG2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 01:28:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D58F120866;
        Fri,  6 Mar 2020 06:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583476110;
        bh=uyfzSbFv5luzHl1YAVE2dYWKKdeQ2J6g8VwGs5QOymA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BDeqZLS3itKiCC/fOOY7a3MJqQW7AUddIs/NHz56lvImWgJ2CwzJAabqyuUGHz/ai
         n2S6gST3MsaayX5bRhWSesyQLDK+RxvXQSqLlVIjtj7kltYyxB0cQAwfeBZ4n8iR63
         TBMkaYI50ATi9FYgDSckrtGt1DztLst5J3O6opnQ=
Date:   Thu, 05 Mar 2020 22:28:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, william.kucharski@oracle.com, ying.huang@intel.com,
        ziy@nvidia.com
Subject:  [patch 2/7] mm: fix possible PMD dirty bit lost in
 set_pmd_migration_entry()
Message-ID: <20200306062829.35P2DyOg_%akpm@linux-foundation.org>
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>
Subject: mm: fix possible PMD dirty bit lost in set_pmd_migration_entry()

In set_pmd_migration_entry(), pmdp_invalidate() is used to change PMD
atomically.  But the PMD is read before that with an ordinary memory
reading.  If the THP (transparent huge page) is written between the PMD
reading and pmdp_invalidate(), the PMD dirty bit may be lost, and cause
data corruption.  The race window is quite small, but still possible in
theory, so need to be fixed.

The race is fixed via using the return value of pmdp_invalidate() to get
the original content of PMD, which is a read/modify/write atomic
operation.  So no THP writing can occur in between.

The race has been introduced when the THP migration support is added in
the commit 616b8371539a ("mm: thp: enable thp migration in generic path").
But this fix depends on the commit d52605d7cb30 ("mm: do not lose dirty
and accessed bits in pmdp_invalidate()").  So it's easy to be backported
after v4.16.  But the race window is really small, so it may be fine not
to backport the fix at all.

Link: http://lkml.kernel.org/r/20200220075220.2327056-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-fix-possible-pmd-dirty-bit-lost-in-set_pmd_migration_entry
+++ a/mm/huge_memory.c
@@ -3043,8 +3043,7 @@ void set_pmd_migration_entry(struct page
 		return;
 
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
-	pmdval = *pvmw->pmd;
-	pmdp_invalidate(vma, address, pvmw->pmd);
+	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 	if (pmd_dirty(pmdval))
 		set_page_dirty(page);
 	entry = make_migration_entry(page, pmd_write(pmdval));
_
