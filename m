Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23B34945AE
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 03:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358150AbiATCCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 21:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244434AbiATCCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 21:02:03 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A57C06161C
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 18:02:02 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id s7-20020a5b0447000000b005fb83901511so8680218ybp.11
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 18:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xdUwiaSDktWd6qoicdCm7OxjVqH7uixhadYKrHDPc0M=;
        b=CB2aleUsk+i4qlNsdDxRBtAYQXwwyLAJicGUOKZQrShQKriQmd9u6zCneI/B61xl27
         weBPN7jWK8BTv/dFYfOLwAwzLCkg5DG3IpzAFv8BuI0AidPDiuNWkUvI9KG3wTi9b2Ol
         Sfsv6tu3VH82Apjf/9g46UshMZxDq741k/fJABlhN/OXvjoHvl4YKg0fyUIotqCfxPbc
         qJGkz9sN6NaYWitGwy7DWtrqR7oPuWpi2ga9UW8NsJG+tDMsWNLaKDUgcSz6v4PZcNOL
         DeDA0OYcHAOkSN3SX6zvJSXoUlU1Vn34WyT/9l8oHrKE2QfE+7zI/6ERzuVVa+kJMytY
         YKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xdUwiaSDktWd6qoicdCm7OxjVqH7uixhadYKrHDPc0M=;
        b=OYdEg6IO9bKHc/7YQKQ6qmH5HFv+cy+Izzgs5IE3I6dmjst1F/7JlFC4fB4aX0CkuC
         TzA5wRXaHQK9a8/OvyVOiUTrFqnIbRlJEbkhUYLAe+vE9vNX5YtGyGzVg2C/ADufrutP
         QmcCSbVEqtYgb6UvZOKoeTqJ/B9S+vPzas1kUyPl5X0yl3pw8RaXKJFFX9aAkDJxPCDF
         kEv8OTseNtNpPAIDSIoXnfVRGZm2080BdGVAV1D+24wGwc7KfUYMeKd2vJvvX08ASas8
         3Unw8f+xkaXHLarpU866oJAFDNc42jPd+nemSjPFZSF6KWOCKUnpBCwHaVy6sOtJ6LoE
         bs3Q==
X-Gm-Message-State: AOAM532JlPaLiO5op69sgjz+7EGrAiHQpp1TycIkjbavxrv3pG8fKVcJ
        ZALl+XcxolkjT2eeLQumw4rWRuw=
X-Google-Smtp-Source: ABdhPJxUfHuY7ew10sneL3xC7xWml/X6PZfGnYwPRFCi5To3Uz7ontNS6MTD6r4fKgz9R2UXXwpK6ng=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:7641:d112:dd90:7ea1])
 (user=pcc job=sendgmr) by 2002:a05:6902:154f:: with SMTP id
 r15mr15749472ybu.242.1642644121821; Wed, 19 Jan 2022 18:02:01 -0800 (PST)
Date:   Wed, 19 Jan 2022 18:01:48 -0800
Message-Id: <20220120020148.1632253-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v3] mm: use compare-exchange operation to set KASAN page tag
From:   Peter Collingbourne <pcc@google.com>
To:     Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Peter Collingbourne <pcc@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It has been reported that the tag setting operation on newly-allocated
pages can cause the page flags to be corrupted when performed
concurrently with other flag updates as a result of the use of
non-atomic operations. Fix the problem by using a compare-exchange
loop to update the tag.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/I456b24a2b9067d93968d43b4bb3351c0cec63101
Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
Cc: stable@vger.kernel.org
---
v3:
- use try_cmpxchg() as suggested by Peter Zijlstra on another
  patch

v2:
- use READ_ONCE()

 include/linux/mm.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c768a7c81b0b..87473fe52c3f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1531,11 +1531,18 @@ static inline u8 page_kasan_tag(const struct page *page)
 
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
-- 
2.34.1.703.g22d0c6ccf7-goog

