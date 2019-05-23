Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3883628C47
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 23:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbfEWVVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 17:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729797AbfEWVVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 17:21:42 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD9E72175B;
        Thu, 23 May 2019 21:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558646501;
        bh=uyavDHmqTevQwrr+GcExVnWNt9UpoGzQLLv7s2VynSI=;
        h=Date:From:To:Subject:From;
        b=roFkfVptw9Y3Rq53Dl8nIt1HN9XzA0mwTQgw+U2WW7XC41o09cVjAih0kHpfsElTh
         lGt7XSVCqNJjOmLuE8433sH8Ou012XuqCGlkNtUkEfC7OjGzw2vlVPp6BstKxTV2D0
         4GYoNtXGJjh/ZgY10IoqOanPlplJ+SdEwedzX17Q=
Date:   Thu, 23 May 2019 14:21:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        ndesaulniers@google.com, glider@google.com, dvyukov@google.com,
        aryabinin@virtuozzo.com, andreyknvl@google.com,
        natechancellor@gmail.com
Subject:  + kasan-initialize-tag-to-0xff-in-__kasan_kmalloc.patch
 added to -mm tree
Message-ID: <20190523212140.PQKKT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kasan: initialize tag to 0xff in __kasan_kmalloc
has been added to the -mm tree.  Its filename is
     kasan-initialize-tag-to-0xff-in-__kasan_kmalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-initialize-tag-to-0xff-in-__kasan_kmalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-initialize-tag-to-0xff-in-__kasan_kmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: kasan: initialize tag to 0xff in __kasan_kmalloc

When building with -Wuninitialized and CONFIG_KASAN_SW_TAGS unset, Clang
warns:

mm/kasan/common.c:484:40: warning: variable 'tag' is uninitialized when
used here [-Wuninitialized]
        kasan_unpoison_shadow(set_tag(object, tag), size);
                                              ^~~

set_tag ignores tag in this configuration but clang doesn't realize it at
this point in its pipeline, as it points to arch_kasan_set_tag as being
the point where it is used, which will later be expanded to (void
*)(object) without a use of tag.  Initialize tag to 0xff, as it removes
this warning and doesn't change the meaning of the code.

Link: https://github.com/ClangBuiltLinux/linux/issues/465
Link: http://lkml.kernel.org/r/20190502163057.6603-1-natechancellor@gmail.com
Fixes: 7f94ffbc4c6a ("kasan: add hooks implementation for tag-based mode")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/common.c~kasan-initialize-tag-to-0xff-in-__kasan_kmalloc
+++ a/mm/kasan/common.c
@@ -464,7 +464,7 @@ static void *__kasan_kmalloc(struct kmem
 {
 	unsigned long redzone_start;
 	unsigned long redzone_end;
-	u8 tag;
+	u8 tag = 0xff;
 
 	if (gfpflags_allow_blocking(flags))
 		quarantine_reduce();
_

Patches currently in -mm which might be from natechancellor@gmail.com are

kasan-initialize-tag-to-0xff-in-__kasan_kmalloc.patch

