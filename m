Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE68BA69B
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406301AbfIVSvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406260AbfIVSvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:51:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D59192190F;
        Sun, 22 Sep 2019 18:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178306;
        bh=Ykb93oMr+3gztSj7HV5KYl0vXoN7XcXRQ9o4/s8Ik+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AETwH0Wm5ZQImUP5VLQ0CbyiwUabmn1rFX9zF6tokobeb1Dksla/Tir1cwCdLF7gG
         GmK6XsycZuVVSB6/nVwAMFPQuabw2+3UJsgxZ5n+ID+S9wbsYysp6eWHhGFf+F3Mgw
         2UHiiQLTNqvarsH9qR0SCv2VEtoTU5DXEukhrBJo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kasan-dev@googlegroups.com, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 077/185] kasan/arm64: fix CONFIG_KASAN_SW_TAGS && KASAN_INLINE
Date:   Sun, 22 Sep 2019 14:47:35 -0400
Message-Id: <20190922184924.32534-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 34b5560db40d2941cfbe82eca1641353d5aed1a9 ]

The generic Makefile.kasan propagates CONFIG_KASAN_SHADOW_OFFSET into
KASAN_SHADOW_OFFSET, but only does so for CONFIG_KASAN_GENERIC.

Since commit:

  6bd1d0be0e97936d ("arm64: kasan: Switch to using KASAN_SHADOW_OFFSET")

... arm64 defines CONFIG_KASAN_SHADOW_OFFSET in Kconfig rather than
defining KASAN_SHADOW_OFFSET in a Makefile. Thus, if
CONFIG_KASAN_SW_TAGS && KASAN_INLINE are selected, we get build time
splats due to KASAN_SHADOW_OFFSET not being set:

| [mark@lakrids:~/src/linux]% usellvm 8.0.1 usekorg 8.1.0  make ARCH=arm64 CROSS_COMPILE=aarch64-linux- CC=clang
| scripts/kconfig/conf  --syncconfig Kconfig
|   CC      scripts/mod/empty.o
| clang (LLVM option parsing): for the -hwasan-mapping-offset option: '' value invalid for uint argument!
| scripts/Makefile.build:273: recipe for target 'scripts/mod/empty.o' failed
| make[1]: *** [scripts/mod/empty.o] Error 1
| Makefile:1123: recipe for target 'prepare0' failed
| make: *** [prepare0] Error 2

Let's fix this by always propagating CONFIG_KASAN_SHADOW_OFFSET into
KASAN_SHADOW_OFFSET if CONFIG_KASAN is selected, moving the existing
common definition of +CFLAGS_KASAN_NOSANITIZE to the top of
Makefile.kasan.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Tested-by Steve Capper <steve.capper@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.kasan | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/scripts/Makefile.kasan b/scripts/Makefile.kasan
index 6410bd22fe387..03757cc60e06c 100644
--- a/scripts/Makefile.kasan
+++ b/scripts/Makefile.kasan
@@ -1,4 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
+ifdef CONFIG_KASAN
+CFLAGS_KASAN_NOSANITIZE := -fno-builtin
+KASAN_SHADOW_OFFSET ?= $(CONFIG_KASAN_SHADOW_OFFSET)
+endif
+
 ifdef CONFIG_KASAN_GENERIC
 
 ifdef CONFIG_KASAN_INLINE
@@ -7,8 +12,6 @@ else
 	call_threshold := 0
 endif
 
-KASAN_SHADOW_OFFSET ?= $(CONFIG_KASAN_SHADOW_OFFSET)
-
 CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address
 
 cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
@@ -45,7 +48,3 @@ CFLAGS_KASAN := -fsanitize=kernel-hwaddress \
 		$(instrumentation_flags)
 
 endif # CONFIG_KASAN_SW_TAGS
-
-ifdef CONFIG_KASAN
-CFLAGS_KASAN_NOSANITIZE := -fno-builtin
-endif
-- 
2.20.1

