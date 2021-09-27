Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326B8419BB5
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbhI0RV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236847AbhI0RTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:19:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3D73611EF;
        Mon, 27 Sep 2021 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762771;
        bh=2xoO9EbBO3BATnGBf8H6ObRb99Rb93yV4/QlF5JSOhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C19xmNlyzyhYGtLQ/2n20RDqJJvQfLiK1qIkv4jhmPoZRbEh0ldi7SWcBWS1fPs6T
         n8UhOspduLrfJwcijM9tvRaRi9za+5ddrnZ+tnDEFRF1rbM+PJb4JizoTHBmft1kNh
         vWay7OXl7cT4IKXpowb6Vcd2eloxVu8iaxgBBMGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Branislav Rankov <branislav.rankov@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.14 045/162] arm64: Mitigate MTE issues with str{n}cmp()
Date:   Mon, 27 Sep 2021 19:01:31 +0200
Message-Id: <20210927170235.061650896@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 59a68d4138086c015ab8241c3267eec5550fbd44 upstream.

As with strlen(), the patches importing the updated str{n}cmp()
implementations were originally developed and tested before the
advent of CONFIG_KASAN_HW_TAGS, and have subsequently revealed
not to be MTE-safe. Since in-kernel MTE is still a rather niche
case, let it temporarily fall back to the generic C versions for
correctness until we can figure out the best fix.

Fixes: 758602c04409 ("arm64: Import latest version of Cortex Strings' strcmp")
Fixes: 020b199bc70d ("arm64: Import latest version of Cortex Strings' strncmp")
Cc: <stable@vger.kernel.org> # 5.14.x
Reported-by: Branislav Rankov <branislav.rankov@arm.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/34dc4d12eec0adae49b0ac927df642ed10089d40.1631890770.git.robin.murphy@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/assembler.h |    5 +++++
 arch/arm64/include/asm/string.h    |    2 ++
 arch/arm64/lib/strcmp.S            |    2 +-
 arch/arm64/lib/strncmp.S           |    2 +-
 4 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -525,6 +525,11 @@ alternative_endif
 #define EXPORT_SYMBOL_NOKASAN(name)	EXPORT_SYMBOL(name)
 #endif
 
+#ifdef CONFIG_KASAN_HW_TAGS
+#define EXPORT_SYMBOL_NOHWKASAN(name)
+#else
+#define EXPORT_SYMBOL_NOHWKASAN(name)	EXPORT_SYMBOL_NOKASAN(name)
+#endif
 	/*
 	 * Emit a 64-bit absolute little endian symbol reference in a way that
 	 * ensures that it will be resolved at build time, even when building a
--- a/arch/arm64/include/asm/string.h
+++ b/arch/arm64/include/asm/string.h
@@ -12,11 +12,13 @@ extern char *strrchr(const char *, int c
 #define __HAVE_ARCH_STRCHR
 extern char *strchr(const char *, int c);
 
+#ifndef CONFIG_KASAN_HW_TAGS
 #define __HAVE_ARCH_STRCMP
 extern int strcmp(const char *, const char *);
 
 #define __HAVE_ARCH_STRNCMP
 extern int strncmp(const char *, const char *, __kernel_size_t);
+#endif
 
 #define __HAVE_ARCH_STRLEN
 extern __kernel_size_t strlen(const char *);
--- a/arch/arm64/lib/strcmp.S
+++ b/arch/arm64/lib/strcmp.S
@@ -173,4 +173,4 @@ L(done):
 	ret
 
 SYM_FUNC_END_PI(strcmp)
-EXPORT_SYMBOL_NOKASAN(strcmp)
+EXPORT_SYMBOL_NOHWKASAN(strcmp)
--- a/arch/arm64/lib/strncmp.S
+++ b/arch/arm64/lib/strncmp.S
@@ -258,4 +258,4 @@ L(ret0):
 	ret
 
 SYM_FUNC_END_PI(strncmp)
-EXPORT_SYMBOL_NOKASAN(strncmp)
+EXPORT_SYMBOL_NOHWKASAN(strncmp)


