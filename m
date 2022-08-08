Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9269158BECB
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242031AbiHHBcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242036AbiHHBcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:32:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E865A1A2;
        Sun,  7 Aug 2022 18:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE0BCB80E0A;
        Mon,  8 Aug 2022 01:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92420C433D6;
        Mon,  8 Aug 2022 01:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922324;
        bh=zR12wUi8RY0WfdWWtyBQpmxoI/kb8IcDNKjQXmqjbSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhMalInAR0Oewih73p7i3b/pMR06z+3JDRxC5qewGmpsoLIAzFdg1XRDs4l3yIGXW
         E9uMx3BrVLAHVRe5Rg+t8bMxWKnJTRQ72ExYL8oQivF64MWU+bp/iJVacUrmylUrSG
         PyA9kqJRYzpdt5+D7Yw79jM+sOWou/lgdoU1pFTVIrENfezOLTjzKdHu8+sZ1xNZT5
         MA44gevD41Ca231aY9Lc7lq2tlKhwew3W4xja4mXDfyU2t+XfwAvb5jyq4jQsJiFMb
         JU2x5RGl2/Ww7ZQY/yqhSUH0/1XS8KMo/uf1C6OAPmpBLc01O8d82mDy0NDgkYP+XC
         DxJLCXlHsF78Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Peter Collingbourne <pcc@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        mark.rutland@arm.com, broonie@kernel.org, ebiederm@xmission.com,
        zhengqi.arch@bytedance.com, alexandru.elisei@arm.com,
        peterx@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.19 11/58] mm: kasan: Skip unpoisoning of user pages
Date:   Sun,  7 Aug 2022 21:30:29 -0400
Message-Id: <20220808013118.313965-11-sashal@kernel.org>
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

[ Upstream commit 70c248aca9e7efa85a6664d5ab56c17c326c958f ]

Commit c275c5c6d50a ("kasan: disable freed user page poisoning with HW
tags") added __GFP_SKIP_KASAN_POISON to GFP_HIGHUSER_MOVABLE. A similar
argument can be made about unpoisoning, so also add
__GFP_SKIP_KASAN_UNPOISON to user pages. To ensure the user page is
still accessible via page_address() without a kasan fault, reset the
page->flags tag.

With the above changes, there is no need for the arm64
tag_clear_highpage() to reset the page->flags tag.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lore.kernel.org/r/20220610152141.2148929-3-catalin.marinas@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/fault.c | 1 -
 include/linux/gfp.h   | 2 +-
 mm/page_alloc.c       | 7 +++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index c5e11768e5c1..cdf3ffa0c223 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -927,6 +927,5 @@ struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
 void tag_clear_highpage(struct page *page)
 {
 	mte_zero_clear_page_tags(page_address(page));
-	page_kasan_tag_reset(page);
 	set_bit(PG_mte_tagged, &page->flags);
 }
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 2d2ccae933c2..0ace7759acd2 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -348,7 +348,7 @@ struct vm_area_struct;
 #define GFP_DMA32	__GFP_DMA32
 #define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
 #define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | \
-			 __GFP_SKIP_KASAN_POISON)
+			 __GFP_SKIP_KASAN_POISON | __GFP_SKIP_KASAN_UNPOISON)
 #define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
 #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b5b14b78c4fd..4d5c30dc757f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2397,6 +2397,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
 	bool init_tags = init && (gfp_flags & __GFP_ZEROTAGS);
+	int i;
 
 	set_page_private(page, 0);
 	set_page_refcounted(page);
@@ -2422,8 +2423,6 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	 * should be initialized as well).
 	 */
 	if (init_tags) {
-		int i;
-
 		/* Initialize both memory and tags. */
 		for (i = 0; i != 1 << order; ++i)
 			tag_clear_highpage(page + i);
@@ -2438,6 +2437,10 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		/* Note that memory is already initialized by KASAN. */
 		if (kasan_has_integrated_init())
 			init = false;
+	} else {
+		/* Ensure page_address() dereferencing does not fault. */
+		for (i = 0; i != 1 << order; ++i)
+			page_kasan_tag_reset(page + i);
 	}
 	/* If memory is still not initialized, do it now. */
 	if (init)
-- 
2.35.1

