Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6541D261945
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731471AbgIHSIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731475AbgIHQLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3609624766;
        Tue,  8 Sep 2020 15:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579707;
        bh=JHBaui2oYNsB+cpUjU0rdcQDgVUS16DZ10SJ3jdO2qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/3iqFO9Hrk+VKpDTW/J9/Bjv+wvYOLGK1iP5EX3pq6p2dcHJHapoWv4rgESraA7p
         BZlVRJjbg40YJMBkciRVvCpq65U7pJfYfhMwfwzDtl1tG5/5ovgn9UfjY3uBk9m1AL
         Qn8NB8SJS1gbLl6BiCnDwKfw7lfcroJpbfNB8m5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Popple <alistair@popple.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 175/186] mm/rmap: fixup copying of soft dirty and uffd ptes
Date:   Tue,  8 Sep 2020 17:25:17 +0200
Message-Id: <20200908152250.151339235@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Popple <alistair@popple.id.au>

commit ad7df764b7e1c7dc64e016da7ada2e3e1bb90700 upstream.

During memory migration a pte is temporarily replaced with a migration
swap pte.  Some pte bits from the existing mapping such as the soft-dirty
and uffd write-protect bits are preserved by copying these to the
temporary migration swap pte.

However these bits are not stored at the same location for swap and
non-swap ptes.  Therefore testing these bits requires using the
appropriate helper function for the given pte type.

Unfortunately several code locations were found where the wrong helper
function is being used to test soft_dirty and uffd_wp bits which leads to
them getting incorrectly set or cleared during page-migration.

Fix these by using the correct tests based on pte type.

Fixes: a5430dda8a3a ("mm/migrate: support un-addressable ZONE_DEVICE page in migration")
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
Signed-off-by: Alistair Popple <alistair@popple.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Alistair Popple <alistair@popple.id.au>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200825064232.10023-2-alistair@popple.id.au
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/migrate.c |   15 +++++++++++----
 mm/rmap.c    |    9 +++++++--
 2 files changed, 18 insertions(+), 6 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2330,10 +2330,17 @@ again:
 			entry = make_migration_entry(page, mpfn &
 						     MIGRATE_PFN_WRITE);
 			swp_pte = swp_entry_to_pte(entry);
-			if (pte_soft_dirty(pte))
-				swp_pte = pte_swp_mksoft_dirty(swp_pte);
-			if (pte_uffd_wp(pte))
-				swp_pte = pte_swp_mkuffd_wp(swp_pte);
+			if (pte_present(pte)) {
+				if (pte_soft_dirty(pte))
+					swp_pte = pte_swp_mksoft_dirty(swp_pte);
+				if (pte_uffd_wp(pte))
+					swp_pte = pte_swp_mkuffd_wp(swp_pte);
+			} else {
+				if (pte_swp_soft_dirty(pte))
+					swp_pte = pte_swp_mksoft_dirty(swp_pte);
+				if (pte_swp_uffd_wp(pte))
+					swp_pte = pte_swp_mkuffd_wp(swp_pte);
+			}
 			set_pte_at(mm, addr, ptep, swp_pte);
 
 			/*
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1511,9 +1511,14 @@ static bool try_to_unmap_one(struct page
 			 */
 			entry = make_migration_entry(page, 0);
 			swp_pte = swp_entry_to_pte(entry);
-			if (pte_soft_dirty(pteval))
+
+			/*
+			 * pteval maps a zone device page and is therefore
+			 * a swap pte.
+			 */
+			if (pte_swp_soft_dirty(pteval))
 				swp_pte = pte_swp_mksoft_dirty(swp_pte);
-			if (pte_uffd_wp(pteval))
+			if (pte_swp_uffd_wp(pteval))
 				swp_pte = pte_swp_mkuffd_wp(swp_pte);
 			set_pte_at(mm, pvmw.address, pvmw.pte, swp_pte);
 			/*


