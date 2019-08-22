Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F939A3DA
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 01:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfHVXd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 19:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbfHVXd3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 19:33:29 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8C0620578;
        Thu, 22 Aug 2019 23:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566516808;
        bh=0NwQlsSziZJaMCck4H2ZDnpQ9eTyWEWyigid55n9zcg=;
        h=Date:From:To:Subject:From;
        b=EilHSMAzyulLGdMxQl+0Aozr8iSP9rr0OAvZnJzV+GRXIfFNh/lLZcxHibS7+rUab
         ekxlhuwHAv+A3RY2gSU71XwJ6yuyrImYHx4pLYPAM+BloanCy19PKtx5wk2RtudM8y
         LzNd7cHvfJEJy08DL7DVAuc3dhByw8yoknlxh8JI=
Date:   Thu, 22 Aug 2019 16:33:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will.deacon@arm.com,
        walter-zh.wu@mediatek.com, stable@vger.kernel.org,
        mark.rutland@arm.com, glider@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        aryabinin@virtuozzo.com
Subject:  +
 =?us-ascii?Q?mm-kasan-fix-false-positive-invalid-free-reports-with-conf?=
 =?us-ascii?Q?ig=5Fkasan=5Fsw=5Ftags=3Dy.patch?= added to -mm tree
Message-ID: <20190822233327.IzyVh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/kasan: fix false positive invalid-free reports with CONFIG_KASAN_SW_TAGS=y
has been added to the -mm tree.  Its filename is
     mm-kasan-fix-false-positive-invalid-free-reports-with-config_kasan_sw_tags=y.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-fix-false-positive-invalid-free-reports-with-config_kasan_sw_tags%3Dy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-fix-false-positive-invalid-free-reports-with-config_kasan_sw_tags%3Dy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-kasan-fix-false-positive-invalid-free-reports-with-config_kasan_sw_tags=y.patch
mm-vmscan-remove-unused-lru_pages-argument.patch

