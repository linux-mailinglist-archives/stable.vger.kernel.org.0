Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 755D19D861
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 23:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfHZVb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 17:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbfHZVb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 17:31:58 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8FBE21881;
        Mon, 26 Aug 2019 21:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566855118;
        bh=dR/4EmKX1nMvFaGiwsF7XCzuACUxlvQDDE7B2JG0+l0=;
        h=Date:From:To:Subject:From;
        b=jNepNvnB9Du3dYxuwloV+trzcGB/+GnWA+ocTY7N+UwTbggbc/uKuJ32/oGSrpRj2
         yaWwQFE3Xg5aTd4yICeRAogIMkm4iPFHK6SErPHg2q8cbrZykjHFwKOGq41UuMvCLE
         gLoaM5fXGZPFKgsP3FcTlJNxM971PFa2eimzglVE=
Date:   Mon, 26 Aug 2019 14:31:57 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, glider@google.com,
        mark.rutland@arm.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, walter-zh.wu@mediatek.com,
        will.deacon@arm.com
Subject:  [merged]
 =?US-ASCII?Q?mm-kasan-fix-false-positive-invalid-free-reports-with-conf?=
 =?US-ASCII?Q?ig=5Fkasan=5Fsw=5Ftags=3Dy.patch?= removed from -mm tree
Message-ID: <20190826213157.K59PuXBOl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/kasan: fix false positive invalid-free reports with CONFIG_KASAN_SW_TAGS=y
has been removed from the -mm tree.  Its filename was
     mm-kasan-fix-false-positive-invalid-free-reports-with-config_kasan_sw_tags=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-vmscan-remove-unused-lru_pages-argument.patch

