Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDBB80471
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 06:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfHCEtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 00:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfHCEtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 00:49:11 -0400
Received: from X1 (unknown [76.191.170.112])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BF862166E;
        Sat,  3 Aug 2019 04:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564807750;
        bh=6kmr6LilcL11hGVeo2VRnM4WKfHmmAPFwTQtcC7b9J8=;
        h=Date:From:To:Subject:From;
        b=b/RbFiifxDTqqpHu6zwJl6/FyXucUr9Df+LaviBd7plCXt8fEIW0eEgsEeitfWnLF
         pRsYTP+kHB/W3HzDwz5GF8G0EYly1Ae9/ZAtx+0cteIfM9oVsQakPoGqHUebeTrJGJ
         XM8BQbxx3yGwakIEmXidnCYuAMXchvmbyt0JqAwA=
Date:   Fri, 02 Aug 2019 21:49:08 -0700
From:   akpm@linux-foundation.org
To:     stable@vger.kernel.org, mgorman@techsingularity.net,
        jhubbard@nvidia.com, jglisse@redhat.com, rcampbell@nvidia.com,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 11/17] mm/migrate.c: initialize pud_entry in
 migrate_vma()
Message-ID: <20190803044908.DlYVL%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate.c: initialize pud_entry in migrate_vma()

When CONFIG_MIGRATE_VMA_HELPER is enabled, migrate_vma() calls
migrate_vma_collect() which initializes a struct mm_walk but didn't
initialize mm_walk.pud_entry.  (Found by code inspection) Use a C
structure initialization to make sure it is set to NULL.

Link: http://lkml.kernel.org/r/20190719233225.12243-1-rcampbell@nvidia.com
Fixes: 8763cb45ab967 ("mm/migrate: new memory migration helper for use with
device memory")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/migrate.c~mm-migrate-initialize-pud_entry-in-migrate_vma
+++ a/mm/migrate.c
@@ -2340,16 +2340,13 @@ next:
 static void migrate_vma_collect(struct migrate_vma *migrate)
 {
 	struct mmu_notifier_range range;
-	struct mm_walk mm_walk;
-
-	mm_walk.pmd_entry =3D migrate_vma_collect_pmd;
-	mm_walk.pte_entry =3D NULL;
-	mm_walk.pte_hole =3D migrate_vma_collect_hole;
-	mm_walk.hugetlb_entry =3D NULL;
-	mm_walk.test_walk =3D NULL;
-	mm_walk.vma =3D migrate->vma;
-	mm_walk.mm =3D migrate->vma->vm_mm;
-	mm_walk.private =3D migrate;
+	struct mm_walk mm_walk =3D {
+		.pmd_entry =3D migrate_vma_collect_pmd,
+		.pte_hole =3D migrate_vma_collect_hole,
+		.vma =3D migrate->vma,
+		.mm =3D migrate->vma->vm_mm,
+		.private =3D migrate,
+	};
=20
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm_walk.mm,
 				migrate->start,
_
