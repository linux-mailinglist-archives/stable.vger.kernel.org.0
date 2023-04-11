Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED126DD8AA
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 13:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjDKLCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 07:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjDKLCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 07:02:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D76423F
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 04:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FF65623EF
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 11:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BE4C433EF;
        Tue, 11 Apr 2023 11:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681210904;
        bh=gZ97PkOxr4ekf5WXnbMpc3AEiE28BfkwAMgz3Q6rlXg=;
        h=Subject:To:Cc:From:Date:From;
        b=cmigJJv91bZYw+sv/mbFw/VthlYZ2YTt3P8lQIzveHpg9AV+I+q7L3uAfbQMObwog
         AH8cEbiWaUc91ps41QFK1RhUVQbnPYM3ONkCnLuzUTWfgHmgISyEjv0NFh77TUsaYX
         pEvSUOhgY9uYn48Kwex8j2ABWSYqgZSsCoICNVoQ=
Subject: FAILED: patch "[PATCH] mm: kfence: fix PG_slab and memcg_data clearing" failed to apply to 5.15-stable tree
To:     muchun.song@linux.dev, akpm@linux-foundation.org,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, roman.gushchin@linux.dev, sjpark@amazon.de,
        songmuchun@bytedance.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 13:01:41 +0200
Message-ID: <2023041141-negligent-sappy-dd84@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 3ee2d7471fa4963a2ced0a84f0653ce88b43c5b2
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041141-negligent-sappy-dd84@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

3ee2d7471fa4 ("mm: kfence: fix PG_slab and memcg_data clearing")
8f0b36497303 ("mm: kfence: fix objcgs vector allocation")
b33f778bba5e ("kfence: alloc kfence_pool after system startup")
698361bca2d5 ("kfence: allow re-enabling KFENCE after system startup")
07e8481d3c38 ("kfence: always use static branches to guard kfence_alloc()")
08f6b10630f2 ("kfence: limit currently covered allocations when pool nearly full")
a9ab52bbcb52 ("kfence: move saving stack trace of allocations into __kfence_alloc()")
9a19aeb56650 ("kfence: count unexpectedly skipped allocations")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3ee2d7471fa4963a2ced0a84f0653ce88b43c5b2 Mon Sep 17 00:00:00 2001
From: Muchun Song <muchun.song@linux.dev>
Date: Mon, 20 Mar 2023 11:00:59 +0800
Subject: [PATCH] mm: kfence: fix PG_slab and memcg_data clearing

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

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 79c94ee55f97..d66092dd187c 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -561,10 +561,6 @@ static unsigned long kfence_init_pool(void)
 		if (!i || (i % 2))
 			continue;
 
-		/* Verify we do not have a compound head page. */
-		if (WARN_ON(compound_head(&pages[i]) != &pages[i]))
-			return addr;
-
 		__folio_set_slab(slab_folio(slab));
 #ifdef CONFIG_MEMCG
 		slab->memcg_data = (unsigned long)&kfence_metadata[i / 2 - 1].objcg |
@@ -597,12 +593,26 @@ static unsigned long kfence_init_pool(void)
 
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
@@ -632,16 +642,6 @@ static bool __init kfence_init_pool_early(void)
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

