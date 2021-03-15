Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF7733C4E0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhCOR4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236550AbhCORsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4C5C64F58;
        Mon, 15 Mar 2021 17:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830517;
        bh=p3GeSzMUy9sipGaHkGayXlliieXen41G/6ysFvV0sfQ=;
        h=Date:From:To:Subject:From;
        b=xcqWv5RJbeL8uYn7mccP1muwG3rZE+8rAyWeataBNXp6YQYxh919qv/kKvkGIGMxM
         cR9VkZ6wlzArggfeZmv1cM4wshMqp8thLpNdupkuXA0+ehsov9219Ay3fszAsay0w5
         gyeDcGk9RUua9DG/gJd7J2t1psKHny07gieHpshU=
Date:   Mon, 15 Mar 2021 10:48:36 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com, stable@vger.kernel.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-fix-kasan_stack-dependency-for-hw_tags.patch removed from -mm tree
Message-ID: <20210315174836.crh9O6pxI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kasan: fix KASAN_STACK dependency for HW_TAGS
has been removed from the -mm tree.  Its filename was
     kasan-fix-kasan_stack-dependency-for-hw_tags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kasan-fix-per-page-tags-for-non-page_alloc-pages.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
arm64-kasan-allow-to-init-memory-when-setting-tags.patch
kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_free-with-hw_tags.patch
kasan-docs-clean-up-sections.patch
kasan-docs-update-overview-section.patch
kasan-docs-update-usage-section.patch
kasan-docs-update-error-reports-section.patch
kasan-docs-update-boot-parameters-section.patch
kasan-docs-update-generic-implementation-details-section.patch
kasan-docs-update-sw_tags-implementation-details-section.patch
kasan-docs-update-hw_tags-implementation-details-section.patch
kasan-docs-update-shadow-memory-section.patch
kasan-docs-update-ignoring-accesses-section.patch
kasan-docs-update-tests-section.patch

