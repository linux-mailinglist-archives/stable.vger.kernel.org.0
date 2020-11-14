Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD5E2B2BCF
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 07:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgKNGv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 01:51:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgKNGv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Nov 2020 01:51:57 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3B9522275;
        Sat, 14 Nov 2020 06:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605336717;
        bh=IKGkE35C8diQpCAa1C0h/UjOKNZzft/KbGWnVTvBcq0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xkYOb8eF3q2KZnhzrDiAq8jmM4Ei6UJ/YaOK0w+9vVYK7F/p54c9kU2IsPDxIM294
         +b8PYmtxZQbIm7k3nL3FdPJtr4CbG9StsW5FcSF82DQIBaqedydTCfXmkXYscu/uZ/
         lu6cz3gDGxjdob+4FmqPCBaF4PROuSGtG2O7lZz0=
Date:   Fri, 13 Nov 2020 22:51:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com, jgg@nvidia.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 06/14] mm/gup: use unpin_user_pages() in
 __gup_longterm_locked()
Message-ID: <20201114065156.AkB0cZWK4%akpm@linux-foundation.org>
In-Reply-To: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
