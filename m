Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0CB26A168A
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 07:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjBXGQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 01:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBXGQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 01:16:01 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE0C298D9
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 22:16:00 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5376fa4106eso125482467b3.7
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 22:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DwUBlkJdKPYrehLUGi744iL0IslrZEMB0ydUaeQ3WSw=;
        b=JlyeV/p0QjEx8SYggR2ieckT3UiY7lDmRK7MzmToATKYoSEkz9Lg+ltSn3alAt+UXu
         lttz3DIybKvFENCXmSOHi9WbKtrubK/C6WkI7AajUD5Al5Hsw0Nla1iwtk4kXcfeMZIx
         IiBtEN5nIWIai1s1CS7xSFyFxPLF3+kUjERmbMv6Iclc3b2RlJVVt9tVXokz0/Dpkani
         RpzEXbuCDo3Z+5hfRoZyrVsEius1sV5JGAXj6mm+jGONUKj8Siwr91app6J/fINIMjZz
         F2ND/AtvQkvVsdzZEfIT4+iyKMnOXkOmG2Ux/V9JdPltPf4650II1Hd1pcW/NsDlVKYV
         aVXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DwUBlkJdKPYrehLUGi744iL0IslrZEMB0ydUaeQ3WSw=;
        b=UFo9bIKUQN37CdvCCSvt0zUJS/iJM4fmQqZZKJOv1FYRwUPDjlq1Y/WIwcwWcilhe6
         KAQxjnvXagZcjl/bW8qrr9gtt9rccObJqwS9zEGntzXA0dayVNwoHqJ73Z8wNHB3nxl/
         mM08vbvfgTjlDhmnzVzBzzzDD8753ZnOk/LwhA4CRyHJyK7QefID5hkst8FCjgWDif5P
         rHLORO435fEhxydTPI1mltjiWFCyJWGlPSTRrjH2V1QImLYhyGgGaCjn5Ad2VWHJ1gJI
         1PMtLONGeV/dQa9HGyqo1zVSwXTJoibeKyuEIiyvyXx/o2lqpybTw3vbeztCf0+jHBfQ
         AiHw==
X-Gm-Message-State: AO0yUKUzBatHV5pF+woMn6jFEQrAY5FMLcJ16Iy7Lq1m1+Kri5LFABsn
        s51bKSwtgGO9/ATomonJ8xaLzGA=
X-Google-Smtp-Source: AK7set980H5+lupKiI0rohV3ZTtUpPk7o29Hq6Ej0eY1Cz9l9P/5Lh8CyHaeEoW2BHDaXSVs1SjuKy8=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2d3:205:d302:b63f:24c7:8a65])
 (user=pcc job=sendgmr) by 2002:a05:6902:154b:b0:9f5:af6b:6f69 with SMTP id
 r11-20020a056902154b00b009f5af6b6f69mr4862249ybu.5.1677219359839; Thu, 23 Feb
 2023 22:15:59 -0800 (PST)
Date:   Thu, 23 Feb 2023 22:15:50 -0800
Message-Id: <20230224061550.177541-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH] Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"
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
2.39.2.637.g21b0678d19-goog

