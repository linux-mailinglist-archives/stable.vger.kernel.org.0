Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C102B5003
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgKPSlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:41:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgKPSlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 13:41:21 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D68420867;
        Mon, 16 Nov 2020 18:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605552080;
        bh=xIU8KFCgxD/CPhat5cPEQLa6oofXQgk8tS8dXV2+pAI=;
        h=Date:From:To:Subject:From;
        b=vcuPHgFZw3ulu3UPKkPfpVqJQ46vR/3i7fN5qdQE1u4JxCSPA5JvE5+PpYLZZW8uM
         AELEeJBP+NMcgcP1tmCLd2rnvP4ff9GiqcCxgPNXDEHHWvcUgWDhYNomDv2/NsVnDc
         hSle0/8sjxdIZe/fnwJD5zj9l7USKAhwws8CGHBg=
Date:   Mon, 16 Nov 2020 10:41:20 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com,
        ira.weiny@intel.com, jgg@nvidia.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 mm-gup-use-unpin_user_pages-in-__gup_longterm_locked.patch removed from -mm
 tree
Message-ID: <20201116184120.Yl7fF-luC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/gup: use unpin_user_pages() in __gup_longterm_locked()
has been removed from the -mm tree.  Its filename was
     mm-gup-use-unpin_user_pages-in-__gup_longterm_locked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: use unpin_user_pages() in __gup_longterm_locked()

When FOLL_PIN is passed to __get_user_pages() the page list must be put
back using unpin_user_pages() otherwise the page pin reference persists in
a corrupted state.

There are two places in the unwind of __gup_longterm_locked() that put the
pages back without checking.  Normally on error this function would return
the partial page list making this the caller's responsibility, but in
these two cases the caller is not allowed to see these pages at all.

Link: https://lkml.kernel.org/r/0-v2-3ae7d9d162e2+2a7-gup_cma_fix_jgg@nvidia.com
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reported-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-use-unpin_user_pages-in-__gup_longterm_locked
+++ a/mm/gup.c
@@ -1647,8 +1647,11 @@ check_again:
 		/*
 		 * drop the above get_user_pages reference.
 		 */
-		for (i = 0; i < nr_pages; i++)
-			put_page(pages[i]);
+		if (gup_flags & FOLL_PIN)
+			unpin_user_pages(pages, nr_pages);
+		else
+			for (i = 0; i < nr_pages; i++)
+				put_page(pages[i]);
 
 		if (migrate_pages(&cma_page_list, alloc_migration_target, NULL,
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_CONTIG_RANGE)) {
@@ -1728,8 +1731,11 @@ static long __gup_longterm_locked(struct
 			goto out;
 
 		if (check_dax_vmas(vmas_tmp, rc)) {
-			for (i = 0; i < rc; i++)
-				put_page(pages[i]);
+			if (gup_flags & FOLL_PIN)
+				unpin_user_pages(pages, rc);
+			else
+				for (i = 0; i < rc; i++)
+					put_page(pages[i]);
 			rc = -EOPNOTSUPP;
 			goto out;
 		}
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-reorganize-internal_get_user_pages_fast.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork.patch

