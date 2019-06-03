Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5FF533945
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 21:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFCTuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 15:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfFCTuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 15:50:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A670C268EC;
        Mon,  3 Jun 2019 19:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559591402;
        bh=rDPP2Ylc1IXZWSeaVcGF5xZXUEPAcWuPRxDdHYqQK5w=;
        h=Date:From:To:Subject:From;
        b=1wfiBE6XETgkhOGHksRd53tfcAdajVRsfAFJMAtG7KW5YykduyFEzDHewBggxaZNS
         5vzxVXETuorJlThbmwskaoYqEOQ49pyCuIJSzwpFe/z7vFHcciDMmAgcMkac/j7yYx
         vahgCh+W6DJ9yq/k019ooefko2AVGdvHsG9J/JcA=
Date:   Mon, 03 Jun 2019 12:50:02 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        glider@google.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        stable@vger.kernel.org
Subject:  [merged]
 kasan-initialize-tag-to-0xff-in-__kasan_kmalloc.patch removed from -mm tree
Message-ID: <20190603195002.CCZs9bjgb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kasan: initialize tag to 0xff in __kasan_kmalloc
has been removed from the -mm tree.  Its filename was
     kasan-initialize-tag-to-0xff-in-__kasan_kmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


