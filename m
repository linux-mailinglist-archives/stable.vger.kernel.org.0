Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E1A2A5CC1
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 03:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgKDCk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 21:40:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728499AbgKDCk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 21:40:26 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7710322264;
        Wed,  4 Nov 2020 02:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604457625;
        bh=+5JihvcCg0P3ilXIAybIvcgupWJ9hpnO2uSgfz13AAg=;
        h=Date:From:To:Subject:From;
        b=hz2+wkBEY34xj6NtUEGloDVViWgIMsYF6nkE7D5hJlzWckNMz7uY6fFBKxgS25wbu
         1kbDXRDzML8lh3m4knQUOjZfE3lsqiXXWKrzaEgTwhgBdA+b0msv5K/lM+0GCnc/dX
         Gr6SYRNsp2cEF8+yQ68Kcid0PK/WjLY9+H6sK44w=
Date:   Tue, 03 Nov 2020 18:40:24 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        jhubbard@nvidia.com, jack@suse.cz, ira.weiny@intel.com,
        imbrenda@linux.ibm.com, aneesh.kumar@linux.ibm.com, jgg@nvidia.com
Subject:  [alternative-merged]
 mm-gup-use-unpin_user_pages-in-check_and_migrate_cma_pages.patch removed from
 -mm tree
Message-ID: <20201104024024.gT0sT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/gup: use unpin_user_pages() in check_and_migrate_cma_pages()
has been removed from the -mm tree.  Its filename was
     mm-gup-use-unpin_user_pages-in-check_and_migrate_cma_pages.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: use unpin_user_pages() in check_and_migrate_cma_pages()

When FOLL_PIN is passed to __get_user_pages() the page list must be put
back using unpin_user_pages() otherwise the page pin reference persists in
a corrupted state.

Link: https://lkml.kernel.org/r/0-v1-976effcd4468+d4-gup_cma_fix_jgg@nvidia.com
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-use-unpin_user_pages-in-check_and_migrate_cma_pages
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
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-gup-use-unpin_user_pages-in-__gup_longterm_locked.patch

