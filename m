Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA0D58BF77
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242626AbiHHBkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242449AbiHHBjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:39:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463A3DEA4;
        Sun,  7 Aug 2022 18:34:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E65F6B80881;
        Mon,  8 Aug 2022 01:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB5AC4347C;
        Mon,  8 Aug 2022 01:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922465;
        bh=JtrVEr5W6o4PTfK4Bmq8esY7T57/MzFocy7PfA1w1aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYyIycURzuMnap5flovGBRkJKnfzeZSdCHMxZJs6sOKBsFabdMoXRM7drqwKv5Xqn
         eDgTB5GNNP1vu9f+2S0uB4Q0OB3rkNiLW629t9OZ1iqRgo2sgGIuhuggIxTEPW4g7x
         B3Bd7KADlZAvn26fKGu/6X2CY6T63NrvecFgCu3oGHRn5Z+XCXsVAe7KG6S6nN0/zW
         mk8DUw5TB/cdrYSuV+wksW3WTv/csCrPP/QPYoKneqVHaAeDDG37RfZHTMVM3on33s
         HmeImyWGlNSmL/zRx2AFr9cuZ+5vu5d77y6sePuITrA2f/De/GY1f5cpaukDUeiFfV
         bwUIeyToj1r3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Peter Collingbourne <pcc@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.18 10/53] mm: kasan: Skip page unpoisoning only if __GFP_SKIP_KASAN_UNPOISON
Date:   Sun,  7 Aug 2022 21:33:05 -0400
Message-Id: <20220808013350.314757-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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
index edef84efba76..2a894ba742e4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2346,7 +2346,7 @@ static inline bool check_new_pcp(struct page *page, unsigned int order)
 }
 #endif /* CONFIG_DEBUG_VM */
 
-static inline bool should_skip_kasan_unpoison(gfp_t flags, bool init_tags)
+static inline bool should_skip_kasan_unpoison(gfp_t flags)
 {
 	/* Don't skip if a software KASAN mode is enabled. */
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC) ||
@@ -2358,12 +2358,10 @@ static inline bool should_skip_kasan_unpoison(gfp_t flags, bool init_tags)
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
@@ -2415,7 +2413,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		/* Note that memory is already initialized by the loop above. */
 		init = false;
 	}
-	if (!should_skip_kasan_unpoison(gfp_flags, init_tags)) {
+	if (!should_skip_kasan_unpoison(gfp_flags)) {
 		/* Unpoison shadow memory or set memory tags. */
 		kasan_unpoison_pages(page, order, init);
 
-- 
2.35.1

