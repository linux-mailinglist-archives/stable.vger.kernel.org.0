Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AD7377468
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 00:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhEHWqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 18:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 May 2021 18:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 993DB613C5;
        Sat,  8 May 2021 22:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513950;
        bh=YGUjy9mJpvI5u/waify9gCoujIrd+MYbPBIEKTSHggY=;
        h=Date:From:To:Subject:From;
        b=DV86O6TYJBXRYhKQtFmEBfnqzC0NDNyTU/K1xTZVDYy5VoIW+XfcPnZe80vWDrctH
         JHoIdJ90WcLi+dm6paCykTjf6UH2qm1fcFDsZvhoB4gpIPewRzcbE2KY+glq+pPrc0
         6xBgwkuTiWU1OFlyC+tHDbuet3qWlZnVEoGg70E4=
Date:   Sat, 08 May 2021 15:45:50 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, david@redhat.com, mm-commits@vger.kernel.org,
        slyfox@gentoo.org, stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-ignore-init_on_free=1-for-debug_pagealloc=1.patch removed
 from -mm tree
Message-ID: <20210508224550.8IA6LEG6j%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: ignore init_on_free=1 for debug_pagealloc=1
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-ignore-init_on_free=1-for-debug_pagealloc=1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: mm: page_alloc: ignore init_on_free=1 for debug_pagealloc=1

On !ARCH_SUPPORTS_DEBUG_PAGEALLOC (like ia64) debug_pagealloc=1 implies
page_poison=on:

    if (page_poisoning_enabled() ||
         (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
          debug_pagealloc_enabled()))
            static_branch_enable(&_page_poisoning_enabled);

page_poison=on needs to override init_on_free=1.

Before the change it did not work as expected for the following case:
- have PAGE_POISONING=y
- have page_poison unset
- have !ARCH_SUPPORTS_DEBUG_PAGEALLOC arch (like ia64)
- have init_on_free=1
- have debug_pagealloc=1

That way we get both keys enabled:
- static_branch_enable(&init_on_free);
- static_branch_enable(&_page_poisoning_enabled);

which leads to poisoned pages returned for __GFP_ZERO pages.

After the change we execute only:
- static_branch_enable(&_page_poisoning_enabled);
  and ignore init_on_free=1.

Link: https://lkml.kernel.org/r/20210329222555.3077928-1-slyfox@gentoo.org
Link: https://lkml.org/lkml/2021/3/26/443
Fixes: 8db26a3d4735 ("mm, page_poison: use static key more efficiently")
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-ignore-init_on_free=1-for-debug_pagealloc=1
+++ a/mm/page_alloc.c
@@ -786,32 +786,36 @@ static inline void clear_page_guard(stru
  */
 void init_mem_debugging_and_hardening(void)
 {
+	bool page_poisoning_requested = false;
+
+#ifdef CONFIG_PAGE_POISONING
+	/*
+	 * Page poisoning is debug page alloc for some arches. If
+	 * either of those options are enabled, enable poisoning.
+	 */
+	if (page_poisoning_enabled() ||
+	     (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
+	      debug_pagealloc_enabled())) {
+		static_branch_enable(&_page_poisoning_enabled);
+		page_poisoning_requested = true;
+	}
+#endif
+
 	if (_init_on_alloc_enabled_early) {
-		if (page_poisoning_enabled())
+		if (page_poisoning_requested)
 			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
 				"will take precedence over init_on_alloc\n");
 		else
 			static_branch_enable(&init_on_alloc);
 	}
 	if (_init_on_free_enabled_early) {
-		if (page_poisoning_enabled())
+		if (page_poisoning_requested)
 			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
 				"will take precedence over init_on_free\n");
 		else
 			static_branch_enable(&init_on_free);
 	}
 
-#ifdef CONFIG_PAGE_POISONING
-	/*
-	 * Page poisoning is debug page alloc for some arches. If
-	 * either of those options are enabled, enable poisoning.
-	 */
-	if (page_poisoning_enabled() ||
-	     (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
-	      debug_pagealloc_enabled()))
-		static_branch_enable(&_page_poisoning_enabled);
-#endif
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	if (!debug_pagealloc_enabled())
 		return;
_

Patches currently in -mm which might be from slyfox@gentoo.org are


