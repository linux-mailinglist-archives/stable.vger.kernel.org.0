Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4A0364BC8
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242876AbhDSUq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242726AbhDSUpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:45:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C78D613D3;
        Mon, 19 Apr 2021 20:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865085;
        bh=jqlxbD4jWz55BNOzhYL6VinJOSoZoV0z2NCOXkKdtbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1HwRS1GPpL/a9qeNNUvFtUZfCBYxw3M/RIFYtGmsiE1FqQvleBVaxHlONqZ3JYER
         m0zh7bD4LbFxRc4KN0M0JaU2bzbKxdF2GILg6Jrw39qrTwPclWXCsjJH7hVV1Bgfxe
         VGKDM1I+7HE3QyPLISzt+bkIaAVXKevDcO7D9N60Lb+FswHQfr4ALxJ1FJsUfSIOOE
         fGdThnEVsKqFon8CF8kZSTCw51huEomIi3HvROSHr/VLWAnqXgHFOFT1zHqOaEKn3V
         Bq7F+rK2bYOtlCC+CNkCRMqSjeJB1wXtSw7dAT0zXcN5LmMX4l0qdD1WyB+XvH6SPF
         S/iH2c210kT/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Marco Elver <elver@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, kasan-dev@googlegroups.com,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 16/21] kasan: fix hwasan build for gcc
Date:   Mon, 19 Apr 2021 16:44:14 -0400
Message-Id: <20210419204420.6375-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204420.6375-1-sashal@kernel.org>
References: <20210419204420.6375-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5c595ac4c776c44b5c59de22ab43b3fe256d9fbb ]

gcc-11 adds support for -fsanitize=kernel-hwaddress, so it becomes
possible to enable CONFIG_KASAN_SW_TAGS.

Unfortunately this fails to build at the moment, because the
corresponding command line arguments use llvm specific syntax.

Change it to use the cc-param macro instead, which works on both clang
and gcc.

[elver@google.com: fixup for "kasan: fix hwasan build for gcc"]
  Link: https://lkml.kernel.org/r/YHQZVfVVLE/LDK2v@elver.google.com

Link: https://lkml.kernel.org/r/20210323124112.1229772-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.kasan | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/Makefile.kasan b/scripts/Makefile.kasan
index 1e000cc2e7b4..127012f45166 100644
--- a/scripts/Makefile.kasan
+++ b/scripts/Makefile.kasan
@@ -2,6 +2,8 @@
 CFLAGS_KASAN_NOSANITIZE := -fno-builtin
 KASAN_SHADOW_OFFSET ?= $(CONFIG_KASAN_SHADOW_OFFSET)
 
+cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
+
 ifdef CONFIG_KASAN_GENERIC
 
 ifdef CONFIG_KASAN_INLINE
@@ -12,8 +14,6 @@ endif
 
 CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address
 
-cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
-
 # -fasan-shadow-offset fails without -fsanitize
 CFLAGS_KASAN_SHADOW := $(call cc-option, -fsanitize=kernel-address \
 			-fasan-shadow-offset=$(KASAN_SHADOW_OFFSET), \
@@ -36,14 +36,14 @@ endif # CONFIG_KASAN_GENERIC
 ifdef CONFIG_KASAN_SW_TAGS
 
 ifdef CONFIG_KASAN_INLINE
-    instrumentation_flags := -mllvm -hwasan-mapping-offset=$(KASAN_SHADOW_OFFSET)
+    instrumentation_flags := $(call cc-param,hwasan-mapping-offset=$(KASAN_SHADOW_OFFSET))
 else
-    instrumentation_flags := -mllvm -hwasan-instrument-with-calls=1
+    instrumentation_flags := $(call cc-param,hwasan-instrument-with-calls=1)
 endif
 
 CFLAGS_KASAN := -fsanitize=kernel-hwaddress \
-		-mllvm -hwasan-instrument-stack=$(CONFIG_KASAN_STACK) \
-		-mllvm -hwasan-use-short-granules=0 \
+		$(call cc-param,hwasan-instrument-stack=$(CONFIG_KASAN_STACK)) \
+		$(call cc-param,hwasan-use-short-granules=0) \
 		$(instrumentation_flags)
 
 endif # CONFIG_KASAN_SW_TAGS
-- 
2.30.2

