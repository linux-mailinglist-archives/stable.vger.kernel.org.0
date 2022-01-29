Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBD34A3212
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 22:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353216AbiA2VlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 16:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353214AbiA2VlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 16:41:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7927BC061714;
        Sat, 29 Jan 2022 13:41:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41B67B82812;
        Sat, 29 Jan 2022 21:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C2EC340E8;
        Sat, 29 Jan 2022 21:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643492475;
        bh=HcQaM4uHbzU5KF8uZ0eERG7hSGsc2MgWgOfJIJw+SN8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=p7TRmllIX3WRnElWKRKuTIoPXLu5lvVYgP26VDXNSzQSP1hsRr1x19MUuMQyizY/2
         Rtryo8NfWkNqi7WjMeJPeRgHsaiqzz8YF7vxd8xNxbFH47KgpAYyLn4HbuuKjNeMdk
         48pGOxOpWEBIgomD7+rj56pwo0a9ml6jNEXHNIBI=
Date:   Sat, 29 Jan 2022 13:41:14 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        peterz@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 08/12] mm, kasan: use compare-exchange operation
 to set KASAN page tag
Message-ID: <20220129214114.kH5sHZ6C3%akpm@linux-foundation.org>
In-Reply-To: <20220129134026.8ccf701012f26eb2c2c269c9@linux-foundation.org>
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
