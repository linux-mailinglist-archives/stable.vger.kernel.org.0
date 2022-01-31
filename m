Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89094A4371
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359610AbiAaLVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38400 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378132AbiAaLTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:19:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE704B82A4C;
        Mon, 31 Jan 2022 11:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB4FC340E8;
        Mon, 31 Jan 2022 11:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627983;
        bh=pz05IZcGWACADVBvxdAq92ZPbMNlGCY/ENYXnBkp9pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JaYGlTs6icTqL4du7ZZUwBNXoiHNffpxLtG2FyC3WLp2bFts/AnzfMgtYQm60BHgp
         AxQdhWFBJ12Xpwzy64sTvfL6FRQ3u70a5T9wosQKugGZfGz5aORjMr+NYus2AteCUU
         p8hbprcY5qChsu2f476P4bHIERvdY98WqBz7SZtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 086/200] mm, kasan: use compare-exchange operation to set KASAN page tag
Date:   Mon, 31 Jan 2022 11:55:49 +0100
Message-Id: <20220131105236.503859012@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

commit 27fe73394a1c6d0b07fa4d95f1bca116d1cc66e9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1524,11 +1524,18 @@ static inline u8 page_kasan_tag(const st
 
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


