Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B74A6F90
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730808AbfICQdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731380AbfICQcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:32:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E833E2343A;
        Tue,  3 Sep 2019 16:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528321;
        bh=RnF9yfW2THGGX/asy4zb05YAO7hpaGDMbNjZA2wFmEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slfWfLXHZZVAmSNcnTPW8w/eTMbUaneu1iVM1F1tTR02J4ghbItk4vuuyIffcsi2Y
         bup8wZR8FY3tnOpFNVAc9KnlGLt63ZEL1gM7j8gz+ZeVT8jdKm0Uoh6zjRGCLccwNO
         dEaISpfIPpFMMtlDnFj8D8n5g6650UQE0qIJj6+U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 154/167] mm/migrate.c: initialize pud_entry in migrate_vma()
Date:   Tue,  3 Sep 2019 12:25:06 -0400
Message-Id: <20190903162519.7136-154-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>

[ Upstream commit 7b358c6f12dc82364f6d317f8c8f1d794adbc3f5 ]

When CONFIG_MIGRATE_VMA_HELPER is enabled, migrate_vma() calls
migrate_vma_collect() which initializes a struct mm_walk but didn't
initialize mm_walk.pud_entry.  (Found by code inspection) Use a C
structure initialization to make sure it is set to NULL.

Link: http://lkml.kernel.org/r/20190719233225.12243-1-rcampbell@nvidia.com
Fixes: 8763cb45ab967 ("mm/migrate: new memory migration helper for use with device memory")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index b2ea7d1e6f248..0c48191a90368 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2328,16 +2328,13 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
  */
 static void migrate_vma_collect(struct migrate_vma *migrate)
 {
-	struct mm_walk mm_walk;
-
-	mm_walk.pmd_entry = migrate_vma_collect_pmd;
-	mm_walk.pte_entry = NULL;
-	mm_walk.pte_hole = migrate_vma_collect_hole;
-	mm_walk.hugetlb_entry = NULL;
-	mm_walk.test_walk = NULL;
-	mm_walk.vma = migrate->vma;
-	mm_walk.mm = migrate->vma->vm_mm;
-	mm_walk.private = migrate;
+	struct mm_walk mm_walk = {
+		.pmd_entry = migrate_vma_collect_pmd,
+		.pte_hole = migrate_vma_collect_hole,
+		.vma = migrate->vma,
+		.mm = migrate->vma->vm_mm,
+		.private = migrate,
+	};
 
 	mmu_notifier_invalidate_range_start(mm_walk.mm,
 					    migrate->start,
-- 
2.20.1

