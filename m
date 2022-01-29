Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C844A2B3E
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 03:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352174AbiA2COa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 21:14:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34142 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbiA2CO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 21:14:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9848AB826A5;
        Sat, 29 Jan 2022 02:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B91C340E7;
        Sat, 29 Jan 2022 02:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643422467;
        bh=HcQaM4uHbzU5KF8uZ0eERG7hSGsc2MgWgOfJIJw+SN8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zqDzdM8OISLXNKghZjUgtHrG1DJKpCz0zqMSB5ld+PWiVQ4mqkv42zVNen2oIQT+p
         YJU8qghy5eGvtZuY+f7GxEt66Klem1Nqcl27kTNEAWtVeVAxIGTTuc7fdpGSuCeuXE
         rxl2K7BZhOXeKlkxVKxQ+AwneotmsK5debUhkuCg=
Date:   Fri, 28 Jan 2022 18:14:26 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        peterz@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 5/7] mm, kasan: use compare-exchange operation to
 set KASAN page tag
Message-ID: <20220129021426.fXzRllwUv%akpm@linux-foundation.org>
In-Reply-To: <20220128181341.2103de95948608a65958ae40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>
Subject: mm, kasan: use compare-exchange operation to set KASAN page tag

It has been reported that the tag setting operation on newly-allocated
pages can cause the page flags to be corrupted when performed concurrently
with other flag updates as a result of the use of non-atomic operations. 
Fix the problem by using a compare-exchange loop to update the tag.

Link: https://lkml.kernel.org/r/20220120020148.1632253-1-pcc@google.com
Link: https://linux-review.googlesource.com/id/I456b24a2b9067d93968d43b4bb3351c0cec63101
Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-use-compare-exchange-operation-to-set-kasan-page-tag
+++ a/include/linux/mm.h
@@ -1506,11 +1506,18 @@ static inline u8 page_kasan_tag(const st
 
 static inline void page_kasan_tag_set(struct page *page, u8 tag)
 {
-	if (kasan_enabled()) {
-		tag ^= 0xff;
-		page->flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
-		page->flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
-	}
+	unsigned long old_flags, flags;
+
+	if (!kasan_enabled())
+		return;
+
+	tag ^= 0xff;
+	old_flags = READ_ONCE(page->flags);
+	do {
+		flags = old_flags;
+		flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
+		flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
+	} while (unlikely(!try_cmpxchg(&page->flags, &old_flags, flags)));
 }
 
 static inline void page_kasan_tag_reset(struct page *page)
_
