Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64BBC48D0B2
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 04:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiAMDOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 22:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiAMDOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 22:14:44 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D93EC061748
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 19:14:44 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a84-20020a251a57000000b0061171f19f8dso8679894yba.13
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 19:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Vn5oKbnGZSK29/TeD2jdsTWSsU6BDg6nOy220ST8fyE=;
        b=ZAVJQmK76ka/sB9vdoEgbpDzHHvQ9eaRaksI3ggjA9gVsDwXmYzobW1WITyq+eXbJ7
         d0EPMyljiyJTxGq4RZ4LdlWDk5U/f27wU+O+CI+bpJrKu6DWTwONrF4XF/dI+5spLRJJ
         FMJOwro7nKdAhO0EPrCEagaEgRODbulo/AfI8Ip2y+/40eZyHd3uS8EaKOxk8dtDUxAT
         EdYGdxK08jPgIaXE8gb2qJwaJnY8ZcAPgbA8nqk43dlGBVnXfgXaKu/nuTKvwyqMv0+e
         r72JnMbrVNDCxFAdcNs+NJGc4m0I5192QGjfFQAX4xji6GWCU1dSEzfNXjyE5IsgG45s
         KBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Vn5oKbnGZSK29/TeD2jdsTWSsU6BDg6nOy220ST8fyE=;
        b=Jq6Dw1xzc6c5jgGIUaHQc7sr6E+QS0LSWSEqWz8ntcm0uPzwBoTSa15xZIUghsf2Ci
         z9b1F+1/3GH8IZDg5nvzizvCodb0pMtztBhVHmlN+C+83fgbpZ5YMz8E7+LG4ZF0wBFx
         KN4p3vErnWTOYImTt9fQCSutSuOch6NYfU0MvqlWLaMSV2VClG3ai39Cl4dfxReObxhE
         xicZFenqlvEoJvmVa/t9RLOGs9CzoZBfcLneEMpSU4LOXxjL2Me7AikZWSx8VWM1yI2T
         iKlrjkasfgDB+HnRoEz5JYSHCRBZMcKzJkleND9hnH/XKGiZEdpVo2Cc6FrBGBNB6+r1
         o97g==
X-Gm-Message-State: AOAM531GvAsm6yRWNyBVGOn3KydhuswQ6Rb2nn8KdXjtTW0z5tj/Gczo
        5z2Auqlxdb0i+h+aIpdmdq5IMKg=
X-Google-Smtp-Source: ABdhPJwo+5zEuBBP9DSC2b29Tuo0F0jw0Ox/T3uvpDRiQLRasor571HDpoxgJoDoibMecszhSTXgi4E=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:55e2:d4be:752f:9807])
 (user=pcc job=sendgmr) by 2002:a05:6902:725:: with SMTP id
 l5mr3323683ybt.575.1642043683429; Wed, 12 Jan 2022 19:14:43 -0800 (PST)
Date:   Wed, 12 Jan 2022 19:14:34 -0800
Message-Id: <20220113031434.464992-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH] mm: use compare-exchange operation to set KASAN page tag
From:   Peter Collingbourne <pcc@google.com>
To:     Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Peter Collingbourne <pcc@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
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
 include/linux/mm.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c768a7c81b0b..b544b0a9f537 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1531,11 +1531,17 @@ static inline u8 page_kasan_tag(const struct page *page)
 
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
-- 
2.34.1.575.g55b058a8bb-goog

