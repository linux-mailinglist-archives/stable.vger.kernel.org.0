Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98326CCD33
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 00:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjC1WZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 18:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjC1WZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 18:25:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810DA18C;
        Tue, 28 Mar 2023 15:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B055619AF;
        Tue, 28 Mar 2023 22:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFC7C4339C;
        Tue, 28 Mar 2023 22:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680042314;
        bh=yPiR0x0kKt8CNfgnRexZ6h1PwxCNCh4HsefSzB6CNuk=;
        h=Date:To:From:Subject:From;
        b=CdeFUnvST2zzedWbvYVbO5mofEtcNX/1+yvwljhcssTi5TKD79UZ6i9OUEcxYzwfs
         0i8uFiHxnH9xYXibibhdkqlYro1KdVDs9uOiRgR7cUgPhSFw/pxEJvTtTgsSP2RgQg
         SOuT8R4noHrFPRk1Ih5KI8GKUbv8at5TCtRKkOMU=
Date:   Tue, 28 Mar 2023 15:25:13 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        sjpark@amazon.de, roman.gushchin@linux.dev, jannh@google.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kfence-fix-pg_slab-and-memcg_data-clearing.patch removed from -mm tree
Message-Id: <20230328222514.6DFC7C4339C@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: kfence: fix PG_slab and memcg_data clearing
has been removed from the -mm tree.  Its filename was
     mm-kfence-fix-pg_slab-and-memcg_data-clearing.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: kfence: fix PG_slab and memcg_data clearing
Date: Mon, 20 Mar 2023 11:00:59 +0800

It does not reset PG_slab and memcg_data when KFENCE fails to initialize
kfence pool at runtime.  It is reporting a "Bad page state" message when
kfence pool is freed to buddy.  The checking of whether it is a compound
head page seems unnecessary since we already guarantee this when
allocating kfence pool.   Remove the check to simplify the code.

Link: https://lkml.kernel.org/r/20230320030059.20189-1-songmuchun@bytedance.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-fix-pg_slab-and-memcg_data-clearing
+++ a/mm/kfence/core.c
@@ -561,10 +561,6 @@ static unsigned long kfence_init_pool(vo
 		if (!i || (i % 2))
 			continue;
 
-		/* Verify we do not have a compound head page. */
-		if (WARN_ON(compound_head(&pages[i]) != &pages[i]))
-			return addr;
-
 		__folio_set_slab(slab_folio(slab));
 #ifdef CONFIG_MEMCG
 		slab->memcg_data = (unsigned long)&kfence_metadata[i / 2 - 1].objcg |
@@ -597,12 +593,26 @@ static unsigned long kfence_init_pool(vo
 
 		/* Protect the right redzone. */
 		if (unlikely(!kfence_protect(addr + PAGE_SIZE)))
-			return addr;
+			goto reset_slab;
 
 		addr += 2 * PAGE_SIZE;
 	}
 
 	return 0;
+
+reset_slab:
+	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
+		struct slab *slab = page_slab(&pages[i]);
+
+		if (!i || (i % 2))
+			continue;
+#ifdef CONFIG_MEMCG
+		slab->memcg_data = 0;
+#endif
+		__folio_clear_slab(slab_folio(slab));
+	}
+
+	return addr;
 }
 
 static bool __init kfence_init_pool_early(void)
@@ -632,16 +642,6 @@ static bool __init kfence_init_pool_earl
 	 * fails for the first page, and therefore expect addr==__kfence_pool in
 	 * most failure cases.
 	 */
-	for (char *p = (char *)addr; p < __kfence_pool + KFENCE_POOL_SIZE; p += PAGE_SIZE) {
-		struct slab *slab = virt_to_slab(p);
-
-		if (!slab)
-			continue;
-#ifdef CONFIG_MEMCG
-		slab->memcg_data = 0;
-#endif
-		__folio_clear_slab(slab_folio(slab));
-	}
 	memblock_free_late(__pa(addr), KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool));
 	__kfence_pool = NULL;
 	return false;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-simplify-hugetlb_vmemmap_init-a-bit.patch

