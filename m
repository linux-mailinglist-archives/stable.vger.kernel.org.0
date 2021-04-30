Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD8A36F587
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 08:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhD3GDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 02:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhD3GDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 02:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55926613AD;
        Fri, 30 Apr 2021 06:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762531;
        bh=/zhml40MSgqcO95kEwJDoLdufgultqBegVTlGYgtcPE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0ykcbTwqOamNieNO8rjdBPO8kSFBfkDdrdsqsS1LP+6o0QMFI4d1vp6kI5BbsWGGj
         5JwZCYpgJ0TzGpMbX+KiukP6KuShk7+8GOydg0hLVfTr+kGSc4wNYr0M8O2EwCm1gF
         GKoPUlSbN7dISQR2lnVTQ3Ephaw0DX4xoBlQa1IY=
Date:   Thu, 29 Apr 2021 23:02:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com, david@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, slyfox@gentoo.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 175/178] mm: page_alloc: ignore init_on_free=1 for
 debug_pagealloc=1
Message-ID: <20210430060211.frs1WAzi_%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
