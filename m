Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CE46C23B5
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 22:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjCTVbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 17:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjCTVbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 17:31:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B28301BE;
        Mon, 20 Mar 2023 14:30:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16CA8616B5;
        Mon, 20 Mar 2023 21:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C89BC433D2;
        Mon, 20 Mar 2023 21:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679347800;
        bh=v7CVZRNVtMzr2jazIMDrPdjA2KcXkTYMUdCdiyE0D9E=;
        h=Date:To:From:Subject:From;
        b=VFmdfJVZUBuwu+shdTc7Jwoe2USXN8c7pxddwRuuTEaDVDaNEbcBJI89r4bH72Qqo
         zpJg+5HnSWxNvwZuZO+0HKVBahTzRfZNOQm5+GsNkmACSn7XRgR4rMBF/1vYxh39Wl
         Q19v68rWlnxDU+0JhJlpSRGoVq8m2Hgt9WoYgtMQ=
Date:   Mon, 20 Mar 2023 14:29:59 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        sjpark@amazon.de, roman.gushchin@linux.dev, jannh@google.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-fix-pg_slab-and-memcg_data-clearing.patch added to mm-hotfixes-unstable branch
Message-Id: <20230320213000.6C89BC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: kfence: fix PG_slab and memcg_data clearing
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kfence-fix-pg_slab-and-memcg_data-clearing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-fix-pg_slab-and-memcg_data-clearing.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: kfence: fix PG_slab and memcg_data clearing
Date: Mon, 20 Mar 2023 11:00:59 +0800

It does not reset PG_slab and memcg_data when KFENCE fails to initialize
kfence pool at runtime.  It is reporting a "Bad page state" message when
kfence pool is freed to buddy.  The checking of whether it is a compound
head page seems unnecessary sicne we already guarantee this when
allocating kfence pool, removing the check to simplify the code.

Link: https://lkml.kernel.org/r/20230320030059.20189-1-songmuchun@bytedance.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Fixes: 8f0b36497303 ("mm: kfence: fix objcgs vector allocation")
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

mm-kfence-fix-using-kfence_metadata-without-initialization-in-show_object.patch
mm-kfence-fix-pg_slab-and-memcg_data-clearing.patch
mm-hugetlb_vmemmap-simplify-hugetlb_vmemmap_init-a-bit.patch

