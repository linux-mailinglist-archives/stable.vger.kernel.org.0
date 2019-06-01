Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63EE4319C0
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 07:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfFAFao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 01:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbfFAFao (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 01:30:44 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 117A427137;
        Sat,  1 Jun 2019 05:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559367043;
        bh=VieaouXc7Pn5c2+CPS9IUBFlGP9RpOuZqiPmE48gaCU=;
        h=Date:From:To:Subject:From;
        b=MLupGBqfZFj/NWpkW5bRxGgcg16uhb+yFGZEzj6y2Ss2He2xqHBocWaqLLkJhbVCg
         AkSVSJ6PjCHwQrHmVbIhAiROlBYRCtSzZyQfhMftXhxAFwXVdxEdvgmRJ3t5UHXfrm
         RyId9bjVtH21PRU2xjImMqMZ0UECBw2Z6WAu/UIk=
Date:   Fri, 31 May 2019 22:30:42 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 15/21] kasan: initialize tag to 0xff in
 __kasan_kmalloc
Message-ID: <20190601053042.mWX2CrxA0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
