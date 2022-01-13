Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94ABF48DE6A
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 20:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiAMT41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 14:56:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44348 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiAMT4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 14:56:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC85761DBC;
        Thu, 13 Jan 2022 19:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA04DC36AE9;
        Thu, 13 Jan 2022 19:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642103784;
        bh=s4BZYYbYIg0vY4O1U1F/ONt+MlZ31qGaWEyLiAfFT/I=;
        h=Date:From:To:Subject:From;
        b=ErCOunhE+P+ogpH/IrMbu8yJ8ro2W1u8HDK6iKXfcKlwpT4EafNwRwZQLt9wR5kLF
         XZN6cmniKHGfHBQdHcXQGUc3Qc4vX1ASQ3uG35IwdvYQnbQYXICxFWfbDB9MBuPMLF
         GyU4HpQgNTH4le5BF3XE8Cl2VGJVsHFZQqrtcfRw=
Date:   Thu, 13 Jan 2022 11:56:23 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, glider@google.com,
        mm-commits@vger.kernel.org, pcc@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, willy@infradead.org
Subject:  +
 mm-use-compare-exchange-operation-to-set-kasan-page-tag.patch added to -mm
 tree
Message-ID: <20220113195623.vITTcNluQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: use compare-exchange operation to set KASAN page tag
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
Subject: mm: use compare-exchange operation to set KASAN page tag

It has been reported that the tag setting operation on newly-allocated
pages can cause the page flags to be corrupted when performed concurrently
with other flag updates as a result of the use of non-atomic operations. 
Fix the problem by using a compare-exchange loop to update the tag.

Link: https://lkml.kernel.org/r/20220113031434.464992-1-pcc@google.com
Link: https://linux-review.googlesource.com/id/I456b24a2b9067d93968d43b4bb3351c0cec63101
Signed-off-by: Peter Collingbourne <pcc@google.com>
Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-use-compare-exchange-operation-to-set-kasan-page-tag
+++ a/include/linux/mm.h
@@ -1524,11 +1524,17 @@ static inline u8 page_kasan_tag(const st
 
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
+	do {
+		old_flags = flags = page->flags;
+		flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
+		flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
+	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
 }
 
 static inline void page_kasan_tag_reset(struct page *page)
_

Patches currently in -mm which might be from pcc@google.com are

mm-use-compare-exchange-operation-to-set-kasan-page-tag.patch

