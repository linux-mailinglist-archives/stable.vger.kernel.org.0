Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608AA6A644E
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 01:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjCAAf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 19:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCAAf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 19:35:57 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF0B24CAD
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 16:35:56 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536bf649e70so246197477b3.0
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 16:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677630956;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eey2bWIXShb0HJ2rZd6676jnb6hRL1sBGHfdZHZ/mnM=;
        b=N/rvOCTsechIvNmIOTnBhNoi5KZG22HeDohVgUqyzh51PuL1ed75xihZpysMdEVal2
         wARbnZTqVLVUT+MMa3aUDPY8CUUtsciF2YtXI8mkQJo1j345YwGk2XVrdfDAeh9ROK6I
         dW93rejBHlQb9vozFjw+sZUkqGUcFWgkyukVF/jdROyet4Aln11AfIjPFQzQfkpNw5KB
         /O7No6saJ5dbQS/1E3L3sj7E357ESb11gEZmhJCkcQO/SUK59W1cL7oZha7+GE5qZeln
         AMYmyJIVmkWpUfAuGf2PT5aaBSj2iqDJNDL0NEqPy9OouRx/udkBAU7pQ7IA5WKbEXgT
         KjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677630956;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eey2bWIXShb0HJ2rZd6676jnb6hRL1sBGHfdZHZ/mnM=;
        b=PakRQg+h1VbL8Mbbyx1EJTY9m5aYrwGA6uExdWXp4g1fchyBbiYXxCP5lL3O19I4oU
         acyfrrNZJwlPBUDxSnAuJusZkUo6HZ+X5v/6X10i+uw9ZwpEVU2KuX72jo+7OCFT7LJR
         qPseZCV//ityxe/I6ZGhsOANJCJbE3JXuKR4GUqHSC2RhuxUza2aXCxaBEs6/MvxVyb1
         QLtUubQma9tThVKKbHXsBsQXCixBTouktJAAgHvqgRApLkX4GzC5GEuPZDssnSh0mvAi
         ycq8vPtjI4Qf5Ghg89jUUi4QeeXuAigOvRwnq96S31rhgkK/4x7BXeb5l/g8CMOIHBj0
         5uSg==
X-Gm-Message-State: AO0yUKVTja3EO/f5dD0tkT2qPr0rNzEduhl54q7gMXvjxGIha3DBU0dv
        ZLvRYz7zVQ/PZAvJF2Mm4d8ZyZI=
X-Google-Smtp-Source: AK7set+WnI/8zx0zNX6UuAbKa7eTpm1PBQ2QsJBRGQ8Ke+NGGxZmEk1/EvIgBz5VBsB310OKC9gx0Ws=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2d3:205:cb8e:e6d0:b612:8d4c])
 (user=pcc job=sendgmr) by 2002:a25:ec09:0:b0:aa3:f90f:369b with SMTP id
 j9-20020a25ec09000000b00aa3f90f369bmr193406ybh.6.1677630956042; Tue, 28 Feb
 2023 16:35:56 -0800 (PST)
Date:   Tue, 28 Feb 2023 16:35:44 -0800
In-Reply-To: <20230301003545.282859-1-pcc@google.com>
Message-Id: <20230301003545.282859-2-pcc@google.com>
Mime-Version: 1.0
References: <20230301003545.282859-1-pcc@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Subject: [PATCH v3 1/2] Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"
From:   Peter Collingbourne <pcc@google.com>
To:     catalin.marinas@arm.com, andreyknvl@gmail.com
Cc:     Peter Collingbourne <pcc@google.com>, linux-mm@kvack.org,
        kasan-dev@googlegroups.com, ryabinin.a.a@gmail.com,
        linux-arm-kernel@lists.infradead.org, vincenzo.frascino@arm.com,
        will@kernel.org, eugenis@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 487a32ec24be819e747af8c2ab0d5c515508086a.

The should_skip_kasan_poison() function reads the PG_skip_kasan_poison
flag from page->flags. However, this line of code in free_pages_prepare():

page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;

clears most of page->flags, including PG_skip_kasan_poison, before calling
should_skip_kasan_poison(), which meant that it would never return true
as a result of the page flag being set. Therefore, fix the code to call
should_skip_kasan_poison() before clearing the flags, as we were doing
before the reverted patch.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Fixes: 487a32ec24be ("kasan: drop skip_kasan_poison variable in free_pages_prepare")
Cc: <stable@vger.kernel.org> # 6.1
Link: https://linux-review.googlesource.com/id/Ic4f13affeebd20548758438bb9ed9ca40e312b79
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ac1fc986af44..7136c36c5d01 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1398,6 +1398,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
 			unsigned int order, bool check_free, fpi_t fpi_flags)
 {
 	int bad = 0;
+	bool skip_kasan_poison = should_skip_kasan_poison(page, fpi_flags);
 	bool init = want_init_on_free();
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
@@ -1470,7 +1471,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
 	 * With hardware tag-based KASAN, memory tags must be set before the
 	 * page becomes unavailable via debug_pagealloc or arch_free_page.
 	 */
-	if (!should_skip_kasan_poison(page, fpi_flags)) {
+	if (!skip_kasan_poison) {
 		kasan_poison_pages(page, order, init);
 
 		/* Memory is already initialized if KASAN did it internally. */
-- 
2.39.2.722.g9855ee24e9-goog

