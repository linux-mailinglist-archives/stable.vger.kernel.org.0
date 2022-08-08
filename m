Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213AC58BECC
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242125AbiHHBcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242043AbiHHBcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:32:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E9CBC3C;
        Sun,  7 Aug 2022 18:32:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8152EB80E07;
        Mon,  8 Aug 2022 01:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B1FC433C1;
        Mon,  8 Aug 2022 01:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922326;
        bh=C0/FhI6A70p6eEbFTQN5lW3PuelL2uWqCL1sY+gWr34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUhrUkEq0djna6IlENyy1IfX9AAeV+w6EZ+G07V+oZYL2I3njOLShI097N9Psgg4e
         VX9biirTOqKl/Inbc8CJMkMmX4kuFreaFfLuuzV7Ec0nKGeRsrqTJSzkG39nhVfZhO
         aGDH2vjcHbyv1UBvOOg1QmXpqkbKOIi1bpyVov6SHXQg5uKA1HZUc7IyUOcX9c/sQq
         o3LN36a8iYFxHBhBXkdcUERwxYO2XOKuxbWLAfTQBcPDkTKQlXhJsTsEK+d7zupIGj
         wx6Nz9p3rrS0+QyHOv9l8ai2gS7P/yFDltibnqRbc7w5IaXYOxD+qi10u/6Y3AbXch
         cNfw4mNjhhN0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Peter Collingbourne <pcc@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.19 12/58] mm: kasan: Skip page unpoisoning only if __GFP_SKIP_KASAN_UNPOISON
Date:   Sun,  7 Aug 2022 21:30:30 -0400
Message-Id: <20220808013118.313965-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit 6d05141a393071e104bf5be5ad4d0c79c6dff343 ]

Currently post_alloc_hook() skips the kasan unpoisoning if the tags will
be zeroed (__GFP_ZEROTAGS) or __GFP_SKIP_KASAN_UNPOISON is passed. Since
__GFP_ZEROTAGS is now accompanied by __GFP_SKIP_KASAN_UNPOISON, remove
the extra check.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lore.kernel.org/r/20220610152141.2148929-4-catalin.marinas@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4d5c30dc757f..b0bcab50f0a3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2361,7 +2361,7 @@ static inline bool check_new_pcp(struct page *page, unsigned int order)
 }
 #endif /* CONFIG_DEBUG_VM */
 
-static inline bool should_skip_kasan_unpoison(gfp_t flags, bool init_tags)
+static inline bool should_skip_kasan_unpoison(gfp_t flags)
 {
 	/* Don't skip if a software KASAN mode is enabled. */
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC) ||
@@ -2373,12 +2373,10 @@ static inline bool should_skip_kasan_unpoison(gfp_t flags, bool init_tags)
 		return true;
 
 	/*
-	 * With hardware tag-based KASAN enabled, skip if either:
-	 *
-	 * 1. Memory tags have already been cleared via tag_clear_highpage().
-	 * 2. Skipping has been requested via __GFP_SKIP_KASAN_UNPOISON.
+	 * With hardware tag-based KASAN enabled, skip if this has been
+	 * requested via __GFP_SKIP_KASAN_UNPOISON.
 	 */
-	return init_tags || (flags & __GFP_SKIP_KASAN_UNPOISON);
+	return flags & __GFP_SKIP_KASAN_UNPOISON;
 }
 
 static inline bool should_skip_init(gfp_t flags)
@@ -2430,7 +2428,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		/* Note that memory is already initialized by the loop above. */
 		init = false;
 	}
-	if (!should_skip_kasan_unpoison(gfp_flags, init_tags)) {
+	if (!should_skip_kasan_unpoison(gfp_flags)) {
 		/* Unpoison shadow memory or set memory tags. */
 		kasan_unpoison_pages(page, order, init);
 
-- 
2.35.1

