Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A79C33BAA9
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhCOOKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234622AbhCOOEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 445A864E83;
        Mon, 15 Mar 2021 14:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817071;
        bh=aD9FFcm63Hj9Nhu8p+dI7qWaGC5qGSu94P5UNIjpjdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrOTBncntcbe9KS6IgcgH9gu7o1K6opLAn6h1KKV2q/RY12mo90Zx/UeOORvhBhaC
         jh4u04x1lFVc+XHwpOSOylou5h2T8xShZc7q3VtHrwelR7++niylwPOZPXx3qZR3qQ
         Ov3yZaKuKmr32gR4cPsihV1jiqbEnqG559+zdzms=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 285/306] kasan: fix KASAN_STACK dependency for HW_TAGS
Date:   Mon, 15 Mar 2021 14:55:48 +0100
Message-Id: <20210315135517.316445703@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Andrey Konovalov <andreyknvl@google.com>

commit d9b571c885a8974fbb7d4ee639dbc643fd000f9e upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.kasan |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -156,6 +156,7 @@ config KASAN_STACK_ENABLE
 
 config KASAN_STACK
 	int
+	depends on KASAN_GENERIC || KASAN_SW_TAGS
 	default 1 if KASAN_STACK_ENABLE || CC_IS_GCC
 	default 0
 


