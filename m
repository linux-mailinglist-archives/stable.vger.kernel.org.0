Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9626B359E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 05:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjCJEaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 23:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjCJEaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 23:30:01 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11796FA09E
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 20:30:00 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id l24-20020a25b318000000b007eba3f8e3baso4571906ybj.4
        for <stable@vger.kernel.org>; Thu, 09 Mar 2023 20:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678422599;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QkRgpCrNH+soo+fiEkY3prqCJENxuAn2pQWgX5GFHYo=;
        b=IUwzYC9QwdzKEGQekhpa3YY0njrREkSmoVgmtl99u7nOXC6fV8I6Qj8xuVm2JdNjLn
         ubRsEea2cY/79WDUcqLNBHNxYbZC0yowAuL8uRs9dKMJlfl6FryHgcWIuU1DGLMuyXBt
         PEjg/9aOEgNcJYJvM7lq/BUNAYKdWmpfQbreuO0+RIIH2FkduGalkt7xW4w8KqiPD21w
         548hOgBBPCkxL0InIdqn8serccLJf2BAmAuuJF5wGZH6yih+2Uf1yosBEuzcLLl+tdHt
         jMdq1pIgADFODU1v+bGWjfsUjbguZJAQaVh0EbM8oOlgQP5bG02Ujj2O//AQw742BkZw
         avyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678422599;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QkRgpCrNH+soo+fiEkY3prqCJENxuAn2pQWgX5GFHYo=;
        b=6JCLmdaMYa1ptJYztJ4yupV1cKbwOnQs5vi5LiPo31Yf0dlxJz0aOpe6GpUd9OIFvS
         Ja0a17AevsKTIfoDPj8ILAS3FsuR4TnuRtArJW6mSwLn9mBUIqVt03Qi9flDjFaItDuv
         CwL/dJsXaCcobAUArjMVKjJsCs54LBGUop+eBj2gd5VhS7/pejJ2nalF37F5O3KCtSLf
         p2wCC6S7ZCLNnAOLGpuNv0dhWuWC9rL1cW/VV3MAKcgWOkhTZpjMRGMUOdhgILwJXyzI
         ROgtY44I7oXfhBSdGJXAkGGfVD9g21p/Alnf8NGE9z03AZhCszygFuDdkugCUc4FOiQU
         1Tcw==
X-Gm-Message-State: AO0yUKX/M4UQcW+tqOzrqmHcZWrn5vVd5cNXSm37qUUgjiKi01HwfCGr
        chiHUHIOAO9PGAOqftJVR1QcIFU=
X-Google-Smtp-Source: AK7set/EOxMMKghq1Vn5wpYfyDCvnNJSf9PCauOlQqG2n14zxfpAuyizvUnSCrDxjZGqveuY2rprJzc=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2d3:205:4760:7b08:a3d0:bc10])
 (user=pcc job=sendgmr) by 2002:a81:b289:0:b0:53c:7095:595a with SMTP id
 q131-20020a81b289000000b0053c7095595amr15950888ywh.7.1678422599352; Thu, 09
 Mar 2023 20:29:59 -0800 (PST)
Date:   Thu,  9 Mar 2023 20:29:13 -0800
In-Reply-To: <20230310042914.3805818-1-pcc@google.com>
Message-Id: <20230310042914.3805818-2-pcc@google.com>
Mime-Version: 1.0
References: <20230310042914.3805818-1-pcc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Subject: [PATCH v4 1/2] Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"
From:   Peter Collingbourne <pcc@google.com>
To:     catalin.marinas@arm.com, andreyknvl@gmail.com
Cc:     Peter Collingbourne <pcc@google.com>, linux-mm@kvack.org,
        kasan-dev@googlegroups.com, ryabinin.a.a@gmail.com,
        linux-arm-kernel@lists.infradead.org, vincenzo.frascino@arm.com,
        will@kernel.org, eugenis@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
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

This fixes a measurable performance regression introduced in the
reverted commit, where munmap() takes longer than intended if HW
tags KASAN is supported and enabled at runtime. Without this patch,
we see a single-digit percentage performance regression in a particular
mmap()-heavy benchmark when enabling HW tags KASAN, and with the patch,
there is no statistically significant performance impact when enabling
HW tags KASAN.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Fixes: 487a32ec24be ("kasan: drop skip_kasan_poison variable in free_pages_prepare")
Cc: <stable@vger.kernel.org> # 6.1
Link: https://linux-review.googlesource.com/id/Ic4f13affeebd20548758438bb9ed9ca40e312b79
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1c54790c2d17..c58ebf21ce63 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1413,6 +1413,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
 			unsigned int order, fpi_t fpi_flags)
 {
 	int bad = 0;
+	bool skip_kasan_poison = should_skip_kasan_poison(page, fpi_flags);
 	bool init = want_init_on_free();
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
@@ -1489,7 +1490,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
 	 * With hardware tag-based KASAN, memory tags must be set before the
 	 * page becomes unavailable via debug_pagealloc or arch_free_page.
 	 */
-	if (!should_skip_kasan_poison(page, fpi_flags)) {
+	if (!skip_kasan_poison) {
 		kasan_poison_pages(page, order, init);
 
 		/* Memory is already initialized if KASAN did it internally. */
-- 
2.40.0.rc1.284.g88254d51c5-goog

