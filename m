Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F586ECC0
	for <lists+stable@lfdr.de>; Sat, 20 Jul 2019 01:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbfGSXcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 19:32:36 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15731 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbfGSXcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 19:32:36 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3253190000>; Fri, 19 Jul 2019 16:32:41 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 19 Jul 2019 16:32:35 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 19 Jul 2019 16:32:35 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 19 Jul
 2019 23:32:34 +0000
Received: from HQMAIL104.nvidia.com (172.18.146.11) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 19 Jul
 2019 23:32:34 +0000
Received: from hqnvemgw02.nvidia.com (172.16.227.111) by HQMAIL104.nvidia.com
 (172.18.146.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 19 Jul 2019 23:32:34 +0000
Received: from rcampbell-dev.nvidia.com (Not Verified[10.110.48.66]) by hqnvemgw02.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5d3253120000>; Fri, 19 Jul 2019 16:32:34 -0700
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-mm@kvack.org>
CC:     <linux-kernel@vger.kernel.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        <stable@vger.kernel.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm/migrate: initialize pud_entry in migrate_vma()
Date:   Fri, 19 Jul 2019 16:32:25 -0700
Message-ID: <20190719233225.12243-1-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563579161; bh=cBV6E3QUPkSFHVwkOFQ0NgttBSDLgksbh5PnUNNrN0w=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Type:
         Content-Transfer-Encoding;
        b=kSM15fI5BAWSOEp5MwrwxhHFCEKX/TAHdTgJ7Umkm6B4XXIZWumZsK8I6vNXvxlBf
         mFrioVqQhDUY9lYgLXSEnboJcf1bL/ZoAKjGMjxauf+fSi4rSqbEMXL47cK9CyGGTF
         g6UlqhfdPh1zpX6I83oWpf4TQZ5ThZp39QFmpxmGe0zDXrvtiRevb+VXkN4GGzgnTj
         j2UwuGP1+O33GpEIbinCf9pcrWajXQUHszoY1LGP8X93xswc/goUG/PiV0lKQP61j0
         yyhegnK0/aA1cHamqHHjTT59Bc4wWgAHlHX8HarC1Pa3Ate7T5z0I+3qd3KlqLYSpG
         ucjUxT5cNsAQw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When CONFIG_MIGRATE_VMA_HELPER is enabled, migrate_vma() calls
migrate_vma_collect() which initializes a struct mm_walk but
didn't initialize mm_walk.pud_entry. (Found by code inspection)
Use a C structure initialization to make sure it is set to NULL.

Fixes: 8763cb45ab967 ("mm/migrate: new memory migration helper for use with
device memory")
Cc: stable@vger.kernel.org
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/migrate.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 515718392b24..a42858d8e00b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2340,16 +2340,13 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
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
--=20
2.20.1

