Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762154A3641
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 13:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbiA3May (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 07:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347152AbiA3May (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 07:30:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAACC061714
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 04:30:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA7FCB827B2
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 12:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178B0C340E4;
        Sun, 30 Jan 2022 12:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643545851;
        bh=v/UPBRM3osN5Mk3Vw/gaNSLKmWQu2Vtf+A+NczsZzg8=;
        h=Subject:To:Cc:From:Date:From;
        b=GEIMMXPiaXgRLYR025pCz2SROB1+WfKoP7y6R/aiJo6Bh1vR22AbECzcj0JJSsxK3
         luk9YcWzApQKtWssMRjJhglO1xtzJAsB3sJxUfSyt1wg7B59CcKC3D4pTixiSQsTAe
         qiA+A91/61ZYSMQbhn33aI3kABMZsDpDS199WaFI=
Subject: FAILED: patch "[PATCH] mm, kasan: use compare-exchange operation to set KASAN page" failed to apply to 5.4-stable tree
To:     pcc@google.com, akpm@linux-foundation.org, andreyknvl@gmail.com,
        peterz@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 Jan 2022 13:30:48 +0100
Message-ID: <1643545848231159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 27fe73394a1c6d0b07fa4d95f1bca116d1cc66e9 Mon Sep 17 00:00:00 2001
From: Peter Collingbourne <pcc@google.com>
Date: Sat, 29 Jan 2022 13:41:14 -0800
Subject: [PATCH] mm, kasan: use compare-exchange operation to set KASAN page
 tag

It has been reported that the tag setting operation on newly-allocated
pages can cause the page flags to be corrupted when performed
concurrently with other flag updates as a result of the use of
non-atomic operations.

Fix the problem by using a compare-exchange loop to update the tag.

Link: https://lkml.kernel.org/r/20220120020148.1632253-1-pcc@google.com
Link: https://linux-review.googlesource.com/id/I456b24a2b9067d93968d43b4bb3351c0cec63101
Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e1a84b1e6787..213cc569b192 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1506,11 +1506,18 @@ static inline u8 page_kasan_tag(const struct page *page)
 
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

