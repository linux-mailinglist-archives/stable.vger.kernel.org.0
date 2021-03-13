Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF75F339BEB
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 06:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhCMFIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 00:08:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231938AbhCMFIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Mar 2021 00:08:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36B6164FA7;
        Sat, 13 Mar 2021 05:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612094;
        bh=zK+h7VijOFJSPX1xiKzXdTpB0F2ONaCHKR8zs3+pwpI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rfgrpHBbGtvQhmyBGO6jJv+u3sy9urBSspIgLK54eWMs9OcHDA8jhqJHiTaq6KUgm
         EM5Wac31xfUM9PwWMNxvjVwEKkFod+16PdYSqwjBEQsZGcCNo0ftzqwoT0dbNo8GU9
         OKg6wL2cNxSAFBTzypSAuIGFsPHEzOEHL99jVaNA=
Date:   Fri, 12 Mar 2021 21:08:13 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 21/29] kasan: fix KASAN_STACK dependency for
 HW_TAGS
Message-ID: <20210313050813.Gybpfo-3O%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
