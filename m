Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9EF337697
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 16:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbhCKPMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 10:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbhCKPLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 10:11:45 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F20C061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 07:11:45 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id t5so15772117qti.5
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 07:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AApTWOpa7ui0/YyXhD3tUhfEI1bu0UZzTT8+Disz7/w=;
        b=RHJUA4xfDCj19gTdtnLY8BzgPsWIGu8LEWnYDr9Cy8aPAwzNTdDYRRyoUzwo4cMqf2
         cD+acaWmz4tmGDVlM/dpk6biRUtSAz1iamX8bvSb9rgtMOT0xgC9ncWfL+3gIKfUyw5B
         25QGtk8QUVqrC/5dYGGc+fEWyIF4a1xA3wyatNUUfdmHKyZq/i7PQjBYQ/CvKw5ktLPV
         JHtnJdjr89mu/LZViYGBGXneDSr16+n4cqPZokACKXYN8aK5tVBxsCwEgTPZ7aU3UiA2
         U8fJXmmFRZxkhqprV5YAMsysgeEgVNbcfMG8UoH6C31MW27OuBHQ6VgJFgHlgSljozH2
         DMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=AApTWOpa7ui0/YyXhD3tUhfEI1bu0UZzTT8+Disz7/w=;
        b=Zv0VYvvrQllC8BzWrdaDn7nAlB6pNfV7qlQijSDzejOIAW6U9BMFg1rv++8BAthfjs
         ifZq2PJLPpqmfSEVJOq3JxJfTDvNORQ0N09jp9zNa6aa8bgF2bm6gEGcD6HaKkxuGaC3
         4uO4K3AdmSyYXL2pTVsIeGcyqiVrvZ38AHN+3Xb7Um5dVBvq645HWHRWK0Dk2HKMe602
         pIhavQtgm3lcZt/5HRNpGb2eqsDAgWvONz/J+Z3wzpJDwtK1fD2g4o6YaWyUkKRDG6tC
         SQGCGzLqySTsCnEPnF1FPbSYcPpVV2HYOtJXWDXeD95AHF0WrcJJ+kzjLkNsEsIqDl0r
         ehYw==
X-Gm-Message-State: AOAM531SdiuY8weBnikkGqQtTEeh2peRfqKCaqJC4TxuaxaIudMdxrAT
        BKHhU3xbKWPL03MVSMxdZElnYLO76i4SlZyy
X-Google-Smtp-Source: ABdhPJw/9WyeAXPJh+ppicdtiNcPiRyV/8swmShG4RkM2/ZfaIcVwbL+Oyqk4hDD0utK59rhqPheAfu7VAe8mIQc
X-Received: from andreyknvl3.muc.corp.google.com ([2a00:79e0:15:13:95a:d8a8:4925:42be])
 (user=andreyknvl job=sendgmr) by 2002:a0c:ea4b:: with SMTP id
 u11mr7819047qvp.43.1615475504801; Thu, 11 Mar 2021 07:11:44 -0800 (PST)
Date:   Thu, 11 Mar 2021 16:11:41 +0100
Message-Id: <1a41abb11c51b264511d9e71c303bb16d5cb367b.1615475452.git.andreyknvl@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH] kasan: fix per-page tags for non-page_alloc pages
From:   Andrey Konovalov <andreyknvl@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrey Konovalov <andreyknvl@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To allow performing tag checks on page_alloc addresses obtained via
page_address(), tag-based KASAN modes store tags for page_alloc
allocations in page->flags.

Currently, the default tag value stored in page->flags is 0x00.
Therefore, page_address() returns a 0x00ffff... address for pages
that were not allocated via page_alloc.

This might cause problems. A particular case we encountered is a conflict
with KFENCE. If a KFENCE-allocated slab object is being freed via
kfree(page_address(page) + offset), the address passed to kfree() will
get tagged with 0x00 (as slab pages keep the default per-page tags).
This leads to is_kfence_address() check failing, and a KFENCE object
ending up in normal slab freelist, which causes memory corruptions.

This patch changes the way KASAN stores tag in page-flags: they are now
stored xor'ed with 0xff. This way, KASAN doesn't need to initialize
per-page flags for every created page, which might be slow.

With this change, page_address() returns natively-tagged (with 0xff)
pointers for pages that didn't have tags set explicitly.

This patch fixes the encountered conflict with KFENCE and prevents more
similar issues that can occur in the future.

Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 include/linux/mm.h | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77e64e3eac80..c45c28f094a7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1440,16 +1440,28 @@ static inline bool cpupid_match_pid(struct task_struct *task, int cpupid)
 
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 
+/*
+ * KASAN per-page tags are stored xor'ed with 0xff. This allows to avoid
+ * setting tags for all pages to native kernel tag value 0xff, as the default
+ * value 0x00 maps to 0xff.
+ */
+
 static inline u8 page_kasan_tag(const struct page *page)
 {
-	if (kasan_enabled())
-		return (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
-	return 0xff;
+	u8 tag = 0xff;
+
+	if (kasan_enabled()) {
+		tag = (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
+		tag ^= 0xff;
+	}
+
+	return tag;
 }
 
 static inline void page_kasan_tag_set(struct page *page, u8 tag)
 {
 	if (kasan_enabled()) {
+		tag ^= 0xff;
 		page->flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
 		page->flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
 	}
-- 
2.31.0.rc2.261.g7f71774620-goog

