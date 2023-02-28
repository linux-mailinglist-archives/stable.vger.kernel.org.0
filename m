Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3D26A530D
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 07:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjB1GdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 01:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjB1GdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 01:33:21 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1E6BB
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 22:32:53 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536a545bfbaso192370807b3.20
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 22:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677565971;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eey2bWIXShb0HJ2rZd6676jnb6hRL1sBGHfdZHZ/mnM=;
        b=exeEIY5fWGlcZGVP7LYpH20VWXe5Zd74N5MibMoNaGhfte0/m04wncsgkZ42c81G9u
         xjwSkbxN7lhKJw3/ZFJ330YJlKsDgfyX/pKH51okzeWO026l5lbQ+rBHN+YqTVoP8rHl
         Wk7FGb5O2F4gadUDHuF7XtjdA7lEYjFJOyhol0bSWbjAuVG6LwYUtM6TVxhR4UWI2vvE
         ygXcb6MhUbYAD0IPZ9mgdxdOC0NWpPGNq+N6hidb1kFjVoRDXSpvbF8s7I9f73F9DW/T
         HeIP7KXQ+Ci/dbBH8Y3O4rh6lswmAGQ71d2MsJoj8ViqLp7nuN3tp2j/0oBV85TCiKG8
         xFzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677565971;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eey2bWIXShb0HJ2rZd6676jnb6hRL1sBGHfdZHZ/mnM=;
        b=dPh5DIRpG2VLo1djk8dnz29QbXIHYroMFm1PzmevtpmhPjR74a1exmpWt7vL3kBIii
         34zFuMYfZMxA8Fj+F69eYMKDqeLQ4Dq7eZcBN2QuHNEaZEutlLBI3wqDKKaAYLMdntEY
         wfEAcoZawfiZ1QvPjGkAPePHhIknXY6XRSmqk4EUqRJ3UTyJ6Myy4uyWbV9IqKDZNkl+
         lM/Ldkdae+Ti1/N8+oYTnoeatY9YREtCSLtQnpZVVEGkv1jGCsoOkLNGkGcbpRaIVavV
         LURgU0Gp/X9da24kM6LmpImMHdPpkppeh5UixlYCVzldHq7XQB3RgoSK66ddDlSh3ml+
         7eSA==
X-Gm-Message-State: AO0yUKUFzhVGVktwUcv0DHxdjZ/WwPFmelMAylwUN6b3qZ0/tLw2TbpC
        BhH/a7lD9HsrymyGnUoNu3gYDm0=
X-Google-Smtp-Source: AK7set+57JSpmmONJa+F5jArhG3H6DN81OBajRlOxhpKK//us3HrP9vQLt/cDaarFzuIYJrI34YHm6Q=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2d3:205:cb8e:e6d0:b612:8d4c])
 (user=pcc job=sendgmr) by 2002:a05:6902:1388:b0:855:fdcb:4467 with SMTP id
 x8-20020a056902138800b00855fdcb4467mr1957716ybu.0.1677565970984; Mon, 27 Feb
 2023 22:32:50 -0800 (PST)
Date:   Mon, 27 Feb 2023 22:32:39 -0800
In-Reply-To: <20230228063240.3613139-1-pcc@google.com>
Message-Id: <20230228063240.3613139-2-pcc@google.com>
Mime-Version: 1.0
References: <20230228063240.3613139-1-pcc@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Subject: [PATCH v2 1/2] Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"
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

