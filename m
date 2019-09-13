Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A56B1F70
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbfIMNTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730276AbfIMNTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:19:33 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85EFF20CC7;
        Fri, 13 Sep 2019 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380773;
        bh=k4lrNev99SCZd1gywLiIvSW5LSq1aWXIApH9Ct40LUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8K1Wos0uKOP76zgLTXDUQE4e//m90Dbs4RBF6xID1XVv3EYhz3xOE/WTfHncsQ5A
         TzK6NJ3cPJF1La0WESwKFP9n+CywH5o3O8JumDd2xDluIh94frH2z53vGHOcShboKK
         GZWIownF0Gx5lKQKWK+aLOPFbxg38RLuhpc54P9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 174/190] mm/migrate.c: initialize pud_entry in migrate_vma()
Date:   Fri, 13 Sep 2019 14:07:09 +0100
Message-Id: <20190913130613.639793420@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -2328,16 +2328,13 @@ next:
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



