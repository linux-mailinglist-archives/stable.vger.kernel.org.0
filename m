Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65D049AC57
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 07:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344892AbiAYGZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 01:25:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55712 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244197AbiAYGVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 01:21:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33149B816AD;
        Tue, 25 Jan 2022 06:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7548C340E0;
        Tue, 25 Jan 2022 06:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643091667;
        bh=2HOs6xvsnbV6rQJN0Z/pS+EcTDpK5H0c37b6pAFFqP4=;
        h=Date:From:To:Subject:From;
        b=ELcVHpSK1Q87rjetnD0JvUZ2w5oKUH3D4nGmFuc4JnqIIc9X0UvfrcDknAnlqe9ON
         Z4AThmQx9ZIpIu4143S8fJm7/WzJ2/+ux5zX4iewVPJ3JUeiQ0pGEK5JUrQhuknT9v
         54sWzeSjc2A52fCTIMo2+tVp591CFoVLKpeP5TPY=
Date:   Mon, 24 Jan 2022 22:21:07 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, mm-commits@vger.kernel.org, pcc@google.com,
        peterz@infradead.org, stable@vger.kernel.org
Subject:  +
 mm-use-compare-exchange-operation-to-set-kasan-page-tag.patch added to -mm
 tree
Message-ID: <20220125062107.dCNn0sHGk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, kasan: use compare-exchange operation to set KASAN page tag
has been added to the -mm tree.  Its filename is
     mm-use-compare-exchange-operation-to-set-kasan-page-tag.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-compare-exchange-operation-to-set-kasan-page-tag.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-compare-exchange-operation-to-set-kasan-page-tag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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

Patches currently in -mm which might be from pcc@google.com are

mm-use-compare-exchange-operation-to-set-kasan-page-tag.patch

