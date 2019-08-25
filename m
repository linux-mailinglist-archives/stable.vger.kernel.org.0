Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A349C130
	for <lists+stable@lfdr.de>; Sun, 25 Aug 2019 02:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfHYAzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 20:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfHYAzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 20:55:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A08A22CE3;
        Sun, 25 Aug 2019 00:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566694510;
        bh=S/u5w9NhTrxsivl7K1Z35nRC16DrJe8DW84Y81s14Ew=;
        h=Date:From:To:Subject:From;
        b=0NeMK/2CHmHw3+DMaZZFpHW8Mf6T5HpVKVEEKfxxXpW/b96pn1PoLhJXX3cPT/xSR
         5oWlU7eMMuZWy+ASalzhjDt9s6bdjcz1NVaO+R3FzAlIpXI4mTvBQeeZAOd2r8MB/G
         DmSO8pOg2NaZdUHYs6KO1V7mwrzGk0sY4w++Vq/M=
Date:   Sat, 24 Aug 2019 17:55:09 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, catalin.marinas@arm.com,
        dvyukov@google.com, glider@google.com, linux-mm@kvack.org,
        mark.rutland@arm.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        walter-zh.wu@mediatek.com, will.deacon@arm.com
Subject:  [patch 11/11] mm/kasan: fix false positive invalid-free
 reports with CONFIG_KASAN_SW_TAGS=y
Message-ID: <20190825005509.BW17vfLCd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/kasan: fix false positive invalid-free reports with CONFIG_KASAN_SW_TAGS=y

The code like this:

	ptr = kmalloc(size, GFP_KERNEL);
	page = virt_to_page(ptr);
	offset = offset_in_page(ptr);
	kfree(page_address(page) + offset);

may produce false-positive invalid-free reports on the kernel with
CONFIG_KASAN_SW_TAGS=y.

In the example above we lose the original tag assigned to 'ptr', so
kfree() gets the pointer with 0xFF tag.  In kfree() we check that 0xFF tag
is different from the tag in shadow hence print false report.

Instead of just comparing tags, do the following:

1) Check that shadow doesn't contain KASAN_TAG_INVALID.  Otherwise it's
   double-free and it doesn't matter what tag the pointer have.

2) If pointer tag is different from 0xFF, make sure that tag in the
   shadow is the same as in the pointer.

Link: http://lkml.kernel.org/r/20190819172540.19581-1-aryabinin@virtuozzo.com
Fixes: 7f94ffbc4c6a ("kasan: add hooks implementation for tag-based mode")
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Walter Wu <walter-zh.wu@mediatek.com>
Reported-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/kasan/common.c~mm-kasan-fix-false-positive-invalid-free-reports-with-config_kasan_sw_tags=y
+++ a/mm/kasan/common.c
@@ -407,8 +407,14 @@ static inline bool shadow_invalid(u8 tag
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
 		return shadow_byte < 0 ||
 			shadow_byte >= KASAN_SHADOW_SCALE_SIZE;
-	else
-		return tag != (u8)shadow_byte;
+
+	/* else CONFIG_KASAN_SW_TAGS: */
+	if ((u8)shadow_byte == KASAN_TAG_INVALID)
+		return true;
+	if ((tag != KASAN_TAG_KERNEL) && (tag != (u8)shadow_byte))
+		return true;
+
+	return false;
 }
 
 static bool __kasan_slab_free(struct kmem_cache *cache, void *object,
_
