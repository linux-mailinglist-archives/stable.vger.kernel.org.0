Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F1283A08
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 22:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfHFUHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 16:07:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfHFUHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 16:07:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9356520717;
        Tue,  6 Aug 2019 20:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565122057;
        bh=hghdK29MzWKYpKmobEsOGyi4C9TgVe3LksvTfBSZFe8=;
        h=Date:From:To:Subject:From;
        b=Nh1CMKh2cHAx0jqIkI6kQoNfmSb4bpmmxB7T4xaZ7lIu1jVa562TeeaCUvwa+DnfP
         SSsheQxmufgpZBm4Blcwdsk+gorzRp30Za4vDmn4Ix127S1ttq8wkZEHxM2jBu5JLQ
         ZlQLH7j29M8SiWhCXctTUuAHuoocs6Z+QX9ZLw5w=
Date:   Tue, 06 Aug 2019 13:07:37 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, jglisse@redhat.com, jhubbard@nvidia.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, stable@vger.kernel.org
Subject:  [merged]
 mm-migrate-initialize-pud_entry-in-migrate_vma.patch removed from -mm tree
Message-ID: <20190806200737.8sMeKiAFC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: initialize pud_entry in migrate_vma()
has been removed from the -mm tree.  Its filename was
     mm-migrate-initialize-pud_entry-in-migrate_vma.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Ralph Campbell <rcampbell@nvidia.com>
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

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-document-zone-device-struct-page-field-usage.patch
mm-hmm-fix-zone_device-anon-page-mapping-reuse.patch
mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch
mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one-v3.patch

