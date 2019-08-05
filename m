Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9FF281C8B
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731126AbfHENZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731121AbfHENZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CC6B20880;
        Mon,  5 Aug 2019 13:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011499;
        bh=t3JAQbHCLtKUt/umNrekrtOnvNMzgyKVDWx4eUOBK/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqK95qHQPVA5gwggIh5e66doghDt/2eQGS83ySGky1OR4jRqf6s+0o+Q/neqRUV1y
         i3fBhRdYD7yOJmEebc493n49s9kqYvM8BLLMFrCMTIG6AKKdgAB8xWfQC359PoOaap
         8qveIR+5Ka1WRkQuJMIQTdWsArbblpTLkJsJJ9WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 104/131] mm/migrate.c: initialize pud_entry in migrate_vma()
Date:   Mon,  5 Aug 2019 15:03:11 +0200
Message-Id: <20190805124958.936782467@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>

commit 7b358c6f12dc82364f6d317f8c8f1d794adbc3f5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/migrate.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2347,16 +2347,13 @@ next:
 static void migrate_vma_collect(struct migrate_vma *migrate)
 {
 	struct mmu_notifier_range range;
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
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm_walk.mm,
 				migrate->start,


