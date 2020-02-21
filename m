Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381A7166C50
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 02:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgBUB3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 20:29:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbgBUB3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 20:29:52 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A5D208E4;
        Fri, 21 Feb 2020 01:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582248591;
        bh=XIBkrke8MUOZit6pdFf1WvsV0JjsCFSJTnPbiIVIFPY=;
        h=Date:From:To:Subject:From;
        b=hxJ7mQW5CBmNv8Do1J1RYU/P9M78ojaGWXlXUScjBS64uPR5/NasnPhGsFuL57uz9
         djs0jX1I5oBWSDZ83GwtrgzoTfhxDLfS6trWdD0NPaacN9vBSh1FzAlqNUW7KzkbdW
         g0DZRA9j57+n7/SgEG6NXRJND82D40MTk6pvljQU=
Date:   Thu, 20 Feb 2020 17:29:51 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        william.kucharski@oracle.com, vbabka@suse.cz,
        stable@vger.kernel.org, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        ying.huang@intel.com
Subject:  +
 mm-fix-possible-pmd-dirty-bit-lost-in-set_pmd_migration_entry.patch added to
 -mm tree
Message-ID: <20200221012951.BOGb-%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix possible PMD dirty bit lost in set_pmd_migration_entry()
has been added to the -mm tree.  Its filename is
     mm-fix-possible-pmd-dirty-bit-lost-in-set_pmd_migration_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-possible-pmd-dirty-bit-lost-in-set_pmd_migration_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-possible-pmd-dirty-bit-lost-in-set_pmd_migration_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-possible-pmd-dirty-bit-lost-in-set_pmd_migration_entry.patch

