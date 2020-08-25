Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE59251237
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 08:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgHYGnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 02:43:18 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43199 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbgHYGnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 02:43:17 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BbKFG6w2bz9sTg;
        Tue, 25 Aug 2020 16:43:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=popple.id.au;
        s=202006; t=1598337795;
        bh=Sj46gycTZgpbO+qnDzJk+GkyULtzfVTSJY3XqVv4wBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sl6HnPeF9b+3VaBws8Pbzu+/2SveSr2RUMDdlLJ1rp/tIB7/NhESW8q7xHu4UnG3+
         dyBpdqE1G/KFNbtz3N7yDL/74VJgTzbGUBGDxlK2pHVhSJyrJZn0xN+veKqQpYuNGb
         atJHD8hrDQosK6//AgWADTybAiuKcX3MwbBL/ohsUQx3eHz1KTc5IIEG4Js35Ay0a6
         VZGpV5IWKFnDiyZHLyt/6Wr62R1tui2nEcCA5xXHDAm8Xn0I2AD4oLS2kyBsfxSCli
         ocCYp6UZ/wL9cLX1Cl0ZqswYRnXofhgj3VP9K5VbgbBPo7YUQGLDkffOfzx6HWo7hW
         CX0eTU9yaV6XQ==
From:   Alistair Popple <alistair@popple.id.au>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Alistair Popple <alistair@popple.id.au>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] mm/rmap: Fixup copying of soft dirty and uffd ptes
Date:   Tue, 25 Aug 2020 16:42:32 +1000
Message-Id: <20200825064232.10023-2-alistair@popple.id.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200825064232.10023-1-alistair@popple.id.au>
References: <20200825064232.10023-1-alistair@popple.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During memory migration a pte is temporarily replaced with a migration
swap pte. Some pte bits from the existing mapping such as the soft-dirty
and uffd write-protect bits are preserved by copying these to the
temporary migration swap pte.

However these bits are not stored at the same location for swap and
non-swap ptes. Therefore testing these bits requires using the
appropriate helper function for the given pte type.

Unfortunately several code locations were found where the wrong helper
function is being used to test soft_dirty and uffd_wp bits which leads
to them getting incorrectly set or cleared during page-migration.

Fix these by using the correct tests based on pte type.

Fixes: a5430dda8a3a ("mm/migrate: support un-addressable ZONE_DEVICE page in migration")
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
Signed-off-by: Alistair Popple <alistair@popple.id.au>
Cc: stable@vger.kernel.org
---
 mm/migrate.c | 15 +++++++++++----
 mm/rmap.c    |  9 +++++++--
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ddb64253fe3e..12f63806d0ac 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2427,10 +2427,17 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
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
diff --git a/mm/rmap.c b/mm/rmap.c
index 83cc459edc40..9425260774a1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1511,9 +1511,14 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
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
-- 
2.20.1

