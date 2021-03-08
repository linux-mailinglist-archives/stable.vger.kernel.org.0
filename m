Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31443317F5
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 20:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhCHT6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 14:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231542AbhCHT6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 14:58:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC66864F11;
        Mon,  8 Mar 2021 19:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615233514;
        bh=ygA/sL0vufWIpiGjBK0LvT8Z2IDSfslRvQdh6WJuHgg=;
        h=Date:From:To:Subject:From;
        b=QCJRBcCyvlLaGCnDk3Axp6bzj06zpzPLecvQfxehCqISHI22RSfge58qeQQbdXzqO
         FotA0gqLYRce3YX9NmcWhmo06wjRq2rW9dIOBWkmDjNBI/uJ903Yk1EH3vchPL2lm5
         EOt6Cd75/yXI7BBiuXTRFBb6Mb4IpV3GTkjPgg4c=
Date:   Mon, 08 Mar 2021 11:58:33 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com, stable@vger.kernel.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  + kasan-fix-kasan_stack-dependency-for-hw_tags.patch
 added to -mm tree
Message-ID: <20210308195833.fH2D8VroK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kasan: fix KASAN_STACK dependency for HW_TAGS
has been added to the -mm tree.  Its filename is
     kasan-fix-kasan_stack-dependency-for-hw_tags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-kasan_stack-dependency-for-hw_tags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-kasan_stack-dependency-for-hw_tags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix KASAN_STACK dependency for HW_TAGS

There's a runtime failure when running HW_TAGS-enabled kernel built with
GCC on hardware that doesn't support MTE.  GCC-built kernels always have
CONFIG_KASAN_STACK enabled, even though stack instrumentation isn't
supported by HW_TAGS.  Having that config enabled causes KASAN to issue
MTE-only instructions to unpoison kernel stacks, which causes the failure.

Fix the issue by disallowing CONFIG_KASAN_STACK when HW_TAGS is used.

(The commit that introduced CONFIG_KASAN_HW_TAGS specified proper
 dependency for CONFIG_KASAN_STACK_ENABLE but not for CONFIG_KASAN_STACK.)

Link: https://lkml.kernel.org/r/59e75426241dbb5611277758c8d4d6f5f9298dac.1615215441.git.andreyknvl@google.com
Fixes: 6a63a63ff1ac ("kasan: introduce CONFIG_KASAN_HW_TAGS")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.kasan~kasan-fix-kasan_stack-dependency-for-hw_tags
+++ a/lib/Kconfig.kasan
@@ -156,6 +156,7 @@ config KASAN_STACK_ENABLE
 
 config KASAN_STACK
 	int
+	depends on KASAN_GENERIC || KASAN_SW_TAGS
 	default 1 if KASAN_STACK_ENABLE || CC_IS_GCC
 	default 0
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch
kasan-fix-kasan_stack-dependency-for-hw_tags.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch

